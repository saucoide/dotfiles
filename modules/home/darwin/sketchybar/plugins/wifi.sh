#!/usr/bin/env sh

# Get primary network interface from scutil
PRIMARY=$(scutil --nwi 2>/dev/null | awk '/IPv4 network interface information/{found=1} found && /^ +[a-z]+[0-9]+ :/{print $1; exit}')

if [ -z "$PRIMARY" ]; then
  sketchybar --set "$NAME" label="Offline" icon=󰖪
  exit 0
fi

# Determine interface type
TYPE=$(networksetup -listallhardwareports 2>/dev/null | grep -B1 "Device: $PRIMARY" | head -1 | sed 's/Hardware Port: //')

case "$TYPE" in
  Wi-Fi)
    sketchybar --set "$NAME" label="WiFi" icon=󰖩
    ;;
  *Ethernet*|*LAN*|*Thunderbolt*|*USB*|*AX88179*)
    sketchybar --set "$NAME" label="Wired" icon=󰈀
    ;;
  *)
    sketchybar --set "$NAME" label="$TYPE" icon=󰖩
    ;;
esac
