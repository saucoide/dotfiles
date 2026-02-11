#!/usr/bin/env fish
# Run the micronix microvm with a project directory mounted
#
# Usage: micronix.fish [options] [/path/to/project]
#        micronix.fish                     (uses current directory)
#        micronix.fish --env VAR=value     (pass env var to guest)
#        micronix.fish --env VAR           (pass current value of VAR)

set --local FLAKE_DIR (set --query FLAKE_DIR; and echo $FLAKE_DIR; or echo $HOME/dotfiles)
set --local WORKSPACE_LINK /tmp/microvm-workspace
set --local ENV_DIR /tmp/microvm-env
set --local ENV_FILE $ENV_DIR/env.fish

# parse arguments
set --local env_vars
set --local PROJECT_PATH ""

set --local i 1
while test $i -le (count $argv)
    set --local arg $argv[$i]
    if test "$arg" = "--env"
        set i (math $i + 1)
        if test $i -le (count $argv)
            set --append env_vars $argv[$i]
        end
    else if test -z "$PROJECT_PATH"
        set PROJECT_PATH "$arg"
    end
    set i (math $i + 1)
end

if test -z "$PROJECT_PATH"
    set PROJECT_PATH (pwd)
end

# get absolute path
set PROJECT_PATH (realpath "$PROJECT_PATH")

if not test -d "$PROJECT_PATH"
    echo "Error: '$PROJECT_PATH' is not a directory"
    exit 1
end

echo "Mounting project: $PROJECT_PATH"

# symlink the workspace
rm --force $WORKSPACE_LINK
ln --symbolic $PROJECT_PATH $WORKSPACE_LINK

echo "Workspace linked: $WORKSPACE_LINK -> $PROJECT_PATH"

# write environment variables to temp file (fish format)
mkdir --parents $ENV_DIR
rm --force $ENV_FILE
if test (count $env_vars) -gt 0
    for var in $env_vars
        if string match --quiet "*=*" "$var"
            set --local name (string split --max 1 = "$var")[1]
            set --local val (string split --max 1 = "$var")[2]
            echo "set --global --export $name '$val'" >> $ENV_FILE
        else
            set --local val $$var
            if test -n "$val"
                echo "set --global --export $var '$val'" >> $ENV_FILE
            end
        end
    end
    echo "Environment variables written to: $ENV_FILE"
end

# rebuild if needed
set --local RUNNER $FLAKE_DIR/.result/bin/microvm-run
if not test -x $RUNNER
    echo "Building micronix VM..."
    nix build $FLAKE_DIR#nixosConfigurations.micronix.config.microvm.runner.vfkit --out-link $FLAKE_DIR/.result
end

echo "Starting VM..."
echo "  - Project mounted at: /workspace"
echo "  - Exit VM: shutdown now (inside) or Ctrl+C"
echo ""

exec $RUNNER
