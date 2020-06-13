#! /bin/bash 

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

picom --config $HOME/.config/qtile/picom.conf &
/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &

