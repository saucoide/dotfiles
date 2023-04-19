#!/bin/bash

# Generated from ~/dotfiles/system.org

function run {
  if ! pgrep $1 ;
  then
    $@&
  fi
}

# setxkbmap -option "ctrl:nocaps"
run dunst &
run nm-applet &
# run blueberry-tray &
# run volumeicon &
# run xfce4-power-manager &
# run picom --config $HOME/.config/picom/picom.conf &
# run /usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &
# run udiskie &
