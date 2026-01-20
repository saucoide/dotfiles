#!/usr/bin/env bash
set -euo pipefail

# Script to toggle the touchscreen on and off
ACTION=${1:-toggle}
INPUT_DEVICE_ID=$(swaymsg -t get_inputs | jq -r '.[] | .identifier | select(contains("Touchscreen"))')
swaymsg input $INPUT_DEVICE_ID events $ACTION
