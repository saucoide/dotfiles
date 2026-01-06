#!/usr/bin/env bash
set -euo pipefail

declare -a options=(
    " Performance"
    " Balanced"
    " Powersave"
    " Force Full Charge"
    " Auto Mode"
    " Status"
)

choice=$(printf '%s\n' "${options[@]}" | wofi --dmenu -i -p "Power Profile:")
case $choice in
    " Performance")
        cmd="tlp performance";;
    " Balanced")
        cmd="tlp balanced";;
    " Powersave")
        cmd="tlp power-saver";;
    " Force Full Charge")
        cmd="tlp fullcharge";;
    " Auto Mode")
        cmd="tlp start";;
    " Status")
        bat_status=$(cat /sys/class/power_supply/BAT0/status)
        bat_cap=$(cat /sys/class/power_supply/BAT0/capacity)
        if [[ -f /sys/devices/system/cpu/cpu0/cpufreq/energy_performance_preference ]]; then
            gov=$(cat /sys/devices/system/cpu/cpu0/cpufreq/energy_performance_preference)
        elif [[ -f /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor ]]; then
            gov=$(cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor)
        else
            gov="unknown"
        fi
        notify-send "Battery Status" "Level: ${bat_cap}%\nState: ${bat_status}\nProfile: ${gov}"
        exit 0;;
esac

if [[ ${cmd:-} ]]; then
    pkexec $cmd
    notify-send "Power Profile" "Switched to: $choice"
fi
