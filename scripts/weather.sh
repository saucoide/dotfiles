#!/usr/bin/env bash

set -euo pipefail

main() {

  # Preset locations
  declare -A weather_location
  weather_location[Wroclaw]="Wroclaw"
  weather_location[Las Palmas]="Las+Palmas"
  weather_location[Moon]="Moon"
  
  _pick="$(printf '%s\n' "${!weather_location[@]}" | rofi -dmenu -p "Where do you want to see the weather?")"
  if [[ ${weather_location[${_pick}]+_} ]]; then
    _location="${weather_location[${_pick}]}"
  else
    _location="${_pick}"
  fi

  # Curl wttr.in, a CLI weather app.
  curl -s "https://v2d.wttr.in/${_location}"
}

[[ "${BASH_SOURCE[0]}" == "${0}" ]] && main "$@"
