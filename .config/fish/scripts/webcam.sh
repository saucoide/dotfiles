#!/usr/bin/env bash

set -euo pipefail

main() {
  
  _device=$(v4l2-ctl --list-devices | rofi -dmenu "Choose a video device:" | xargs echo)
  mpv "av://v4l2:${_device}" --profile=low-latency --untimed
}

[[ "${BASH_SOURCE[0]}" == "${0}" ]] && main "$@"
