# ************************************
# Generated from ~/dotfiles/system.org
# ************************************

# Guix profile
GUIX_PROFILE="$HOME/.guix-profile"
. "$GUIX_PROFILE/etc/profile"

# fish as default non-login shell
export SHELL=/usr/bin/fish

# Add a few places to $PATH
export PATH=$HOME/scripts:$PATH

# Python debugging
export PYTHONBREAKPOINT=ipdb.set_trace
