# ************************************
# Generated from ~/dotfiles/system.org
# ************************************

export XDG_DATA_DIRS="/usr/local/share/:/usr/share/"

# Guix profile
GUIX_PROFILE="$HOME/.guix-profile"
. "$GUIX_PROFILE/etc/profile"

# Fix locales for nix https://nixos.wiki/wiki/Locales
export LOCALE_ARCHIVE=/usr/lib/locale/locale-archive

# QT5 Style
# Manage the style using kvantum
export QT_STYLE_OVERRIDE=kvantum

# fish as default non-login shell
export SHELL=/usr/bin/fish

# Add a few places to $PATH
export PATH=$HOME/.local/bin:$HOME/.cargo/bin:$HOME/scripts:$PATH

# Python debugging
export PYTHONBREAKPOINT=pdb.set_trace
export PYTHONSTARTUP=$HOME/.pythonrc.py
