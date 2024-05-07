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
run udiskie &
run xfce4-power-manager &
run blueman-applet &
run light-locker &

# Using xinput to set input settings
# xinput list # list devices
# xinput list-props {device} # list devices
# xinput set-prop {device} {property} {value}
# Touchpad settings
xinput -set-prop "Elan Touchpad" "libinput Tapping Enabled" 1
xinput set-prop "Elan Touchpad" "libinput Accel Speed" +0.2

# Trackpoint settings
xinput set-prop "Elan TrackPoint" "libinput Accel Speed" -0.3
