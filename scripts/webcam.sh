#!/usr/bin/env bash

set -euo pipefail

main() {
  # Filter for index 0 devices to avoid metadata nodes
  choice=$(for d in /sys/class/video4linux/video*; do
      if [ "$(cat "$d/index")" = "0" ]; then
          echo "$(basename "$d"): $(cat "$d/name")"
      fi
  done | rofi -dmenu -i -p "Select Webcam" )

  if [ -z "$choice" ]; then
      exit 0
  fi

  device_node=$(echo "$choice" | cut -d: -f1)
  device_name=$(echo "$choice" | cut -d: -f2- | xargs)

  if [[ "$device_name" == *"IR Camera"* ]]; then
      # Specific config for IR camera
      mpv "av://v4l2:/dev/$device_node" \
          --demuxer-lavf-o=video_size=400x480,input_format=mjpeg \
          --vd-lavc-o=err_detect=ignore_err \
          --msg-level=ffmpeg/video=fatal,ffmpeg=fatal \
          --profile=low-latency --untimed
  else
      # Standard config for regular cameras
      mpv "av://v4l2:/dev/$device_node" \
          --profile=low-latency --untimed
  fi
}

[[ "${BASH_SOURCE[0]}" == "${0}" ]] && main "$@"
