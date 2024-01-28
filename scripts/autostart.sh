#!/usr/bin/env bash
nm-applet --indicator &
swww init &
swww img "$HOME/dotfiles/images/wallpaper.png" & 
waybar &
dunst
