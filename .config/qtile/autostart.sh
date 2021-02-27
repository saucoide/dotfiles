#!/bin/bash

# Generated from ~/dotfiles/system.org

function run {
  if ! pgrep $1 ;
  then
    $@&
  fi
}

dunst &
numlockx on &
run nm-applet &
blueberry-tray &
run volumeicon &
run xfce4-power-manager &
run spotify
hsetxkbmap -option "ctrl:nocaps" &

picom --config $HOME/.config/picom/picom.conf &
/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &
