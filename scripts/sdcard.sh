#!/usr/bin/env bash

set -euo pipefail

# Check if the driver is enabled
if [[ -d "/sys/bus/usb/devices/2-3/driver" ]]; then
    status="Enabled"
else
    status="Disabled"
fi

 
# Update status
if [[ $# -eq 0 ]]; then
    echo "SD Card reader status: ${status}"
elif [[ "${1}" == "on" ]]; then
    if [[ ${status} == "Disabled" ]]; then
        echo 2-3 >> /sys/bus/usb/drivers/usb/bind
        echo "Enabled SD Card reader."
    else
        echo "SD Card reader already enabled. No action taken."
    fi
elif [[ "${1}" == "off" ]]; then
    if [[ ${status} == "Enabled" ]]; then
        echo 2-3 >> /sys/bus/usb/drivers/usb/unbind
        echo "Disabled SD Card reader."
    else
        echo "SD Card reader already disabled. No action taken."
    fi
else
    echo "SD Card reader status: ${status}"
fi
