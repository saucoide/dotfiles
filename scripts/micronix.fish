#!/usr/bin/env fish
# Run the micronix microvm with a project directory mounted
#
# Usage: micronix.fish [options] [/path/to/project]
#        micronix.fish                     (uses current directory)
#        micronix.fish --env VAR           (copy env var from host)
#        micronix.fish --env VAR=value     (pass env var to guest)
#        micronix.fish --pi                (launch pi inside the VM)

set --local FLAKE_DIR (set --query FLAKE_DIR; and echo $FLAKE_DIR; or echo $HOME/dotfiles)

# parse arguments
set --local env_vars
set --local PROJECT_PATH ""
set --local launch_pi 0

set --local i 1
while test $i -le (count $argv)
    set --local arg $argv[$i]
    if test "$arg" = "--env"
        set i (math $i + 1)
        if test $i -gt (count $argv)
            echo 'Error: --env requires NAME or NAME=value' >&2
            exit 1
        end

        set --local parts (string split --max 1 -- = "$argv[$i]")
        set --local name "$parts[1]"
        if not string match --quiet --regex '^[A-Za-z_][A-Za-z0-9_]*$' -- "$name"
            echo "Error: '$name' is not a valid environment variable name" >&2
            exit 1
        end

        set --local val
        if test (count $parts) -eq 2
            set val "$parts[2]"
        else
            if not set --query --export "$name"
                echo "Error: host environment variable '$name' is not set" >&2
                exit 1
            end
            set val "$$name"
        end
        set --append env_vars "$name=$val"
    else if test "$arg" = "--pi"
        set launch_pi 1
    else if test -z "$PROJECT_PATH"
        set PROJECT_PATH "$arg"
    end
    set i (math $i + 1)
end

if test -z "$PROJECT_PATH"
    set PROJECT_PATH (pwd)
end

# Use absolute paths so they remain valid after changing directories.
set PROJECT_PATH (realpath "$PROJECT_PATH")
or exit 1

set FLAKE_DIR (realpath "$FLAKE_DIR")
or exit 1

if not test -d "$PROJECT_PATH"
    echo "Error: '$PROJECT_PATH' is not a directory"
    exit 1
end

# Reuse the built runner, build if missing
set --local RUNNER $FLAKE_DIR/.result/bin/microvm-run
if not test -x "$RUNNER"
    echo 'Building micronix VM...'
    nix build "$FLAKE_DIR#nixosConfigurations.micronix.config.microvm.runner.vfkit" --out-link "$FLAKE_DIR/.result"
    or exit 1
end

# create a unique runtime directory
set --local INSTANCE_DIR (mktemp -d /tmp/micronix.XXXXXXXX)
or exit 1

function cleanup_instance --on-event fish_exit --inherit-variable INSTANCE_DIR
    rm -rf "$INSTANCE_DIR"
end

# Let Ctrl+C stop the VM without killing this script, so it can clean up afterward
function interrupt_instance --on-signal INT
end

set --local WORKSPACE_LINK $INSTANCE_DIR/workspace
set --local ENV_DIR $INSTANCE_DIR/env
set --local ENV_FILE $ENV_DIR/env.fish

echo "Mounting project: $PROJECT_PATH"

# point the VM's workspace at the chosen project directory
ln -s "$PROJECT_PATH" "$WORKSPACE_LINK"
or exit 1

echo "Workspace linked: $WORKSPACE_LINK -> $PROJECT_PATH"

# write environment variables to temp file (fish format)
mkdir -p "$ENV_DIR"
or exit 1
if test (count $env_vars) -gt 0
    for var in $env_vars
        set --local parts (string split --max 1 -- = "$var")
        printf 'set --global --export %s %s\n' "$parts[1]" (string escape -- "$parts[2]") >> "$ENV_FILE"
    end
    echo "Environment variables written to: $ENV_FILE"
end

# write pi launch flag
if test $launch_pi -eq 1
    echo "set --global --export MICRONIX_LAUNCH_PI 1" >> $ENV_FILE
    echo "Pi will launch automatically inside the VM"
end

echo 'Starting VM...'
echo "  - Runtime directory: $INSTANCE_DIR"
echo '  - Project mounted at: /home/saucoide/workspace'
echo "  - Exit VM: shutdown now (inside) or Ctrl+C"
echo ""

cd "$INSTANCE_DIR"
or exit 1
# wait for the VM to exit, then remove its temporary directory
$RUNNER
exit $status
