#!/usr/bin/env fish
# Run the micronix microvm with a project directory mounted
#
# Usage: micronix.fish /path/to/project
#        micronix.fish  (uses current directory)

set -l FLAKE_DIR (set -q FLAKE_DIR; and echo $FLAKE_DIR; or echo $HOME/dotfiles)
set -l WORKSPACE_LINK /tmp/microvm-workspace

# find workspace path
set -l PROJECT_PATH $argv[1]
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
rm -f $WORKSPACE_LINK
ln -s $PROJECT_PATH $WORKSPACE_LINK

echo "Workspace linked: $WORKSPACE_LINK -> $PROJECT_PATH"

# rebuild if needed
set -l RUNNER $FLAKE_DIR/.result/bin/microvm-run
if not test -x $RUNNER
    echo "Building micronix VM..."
    nix build $FLAKE_DIR#nixosConfigurations.micronix.config.microvm.runner.vfkit --out-link $FLAKE_DIR/.result
end

echo "Starting VM..."
echo "  - Project mounted at: /workspace"
echo "  - Exit VM: shutdown now (inside) or Ctrl+C"
echo ""

exec $RUNNER
