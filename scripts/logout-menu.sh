#!/usr/bin/env bash

set -euo pipefail

main() {

    declare -a options=(
        " Lock screen"
        "󰏦 Suspend"
        "󰒲 Hibernate"
        " Logout"
        " Reboot"
        " Shutdown"
    )

    lock_screen_cmd="swaylock --daemonize"
    logout_cmd="swaymsg exit"
    suspend_cmd="systemctl suspend"
    reboot_cmd="systemctl reboot"
    shutdown_cmd="systemctl poweroff"
    hibernate_cmd="systemctl hibernate"

    choice=$(printf '%s\n' "${options[@]}" | wofi --dmenu -i  -p "Quit Menu:")

    case $choice in
        " Lock screen")
            ${lock_screen_cmd};;
        "󰏦 Suspend")
            cmd=${suspend_cmd};;
        "󰒲 Hibernate")
            cmd=${hibernate_cmd};;
        " Logout")
            cmd=${logout_cmd};;
        " Reboot")
            cmd=${reboot_cmd};;
        " Shutdown")
            cmd=${shutdown_cmd};;
    esac

    if [[ ${cmd:-} ]]; then
        confirmation=$(printf '%s\n' "Yes" "No" | wofi --dmenu -i -p "${choice}?")
        if [[ ${confirmation} == "Yes" ]]; then
            ${cmd}
        fi
    fi
}

[[ "${BASH_SOURCE[0]}" == "${0}" ]] && main "$@"
