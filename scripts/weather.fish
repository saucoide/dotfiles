#!/usr/bin/env fish

function main

    # default to wroclaw
    set -l pick $argv[1]
    if test -z "$pick"
        set pick "Wroclaw"
    end

    # a bunch of aliases
    switch "$pick"
        case "wro"
            set _location "Wroclaw"
        case "Las Palmas" "las palmas" "lpa"
            set _location "Las+Palmas"
        case moon
            set _location "Moon"
        case '*'
            set _location "$pick"
    end

    echo "Fetching weather for: $_location..."
    curl -s "https://v2d.wttr.in/$_location"
end

main $argv
