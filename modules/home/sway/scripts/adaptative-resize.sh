#!/usr/bin/env bash
set -euo pipefail

# Get the layout of the parent container
LAYOUT=$(swaymsg -t get_tree | jq -r '.. | select(.nodes? // [] | any(.focused)) | .layout')

ACTION=$1   # grow or shrink
AMOUNT=$2   # e.g., 10px

case "$LAYOUT" in
    "splith"|"stacked")
        # Horizontal context: resize width
        swaymsg resize "$ACTION" width "$AMOUNT"
        ;;
    "splitv"|"tabbed")
        # Vertical context: resize height
        swaymsg resize "$ACTION" height "$AMOUNT"
        ;;
    *)
        # Floating windows or edge cases: resize both
        swaymsg resize "$ACTION" width "$AMOUNT"
        swaymsg resize "$ACTION" height "$AMOUNT"
        ;;
esac
