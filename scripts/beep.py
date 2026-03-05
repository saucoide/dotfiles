#!/usr/bin/env -S uv run --script

import subprocess
import dataclasses
import sys
import shutil
import pathlib
import time


SHORT_BEEP = pathlib.Path(__file__).parent / "soundfiles" / "beep-short.wav"
LONG_BEEP = pathlib.Path(__file__).parent / "soundfiles" / "beep-long.wav"


@dataclasses.dataclass
class Plan:
    intervals: int  # count
    interval_duration: int  # secs


def play(path):
    candidates = [
        # jank af
        ["afplay", path],  # macOS
        ["paplay", path],  # Linux PulseAudio
        ["aplay", path],  # Linux ALSA, wav only usually
        ["ffplay", "-nodisp", "-autoexit", path],  # if installed
        ["mpg123", path],
        ["play", path],  # sox
    ]

    for cmd in candidates:
        if shutil.which(cmd[0]):
            subprocess.Popen(
                cmd,
                stdout=subprocess.DEVNULL,
                stderr=subprocess.DEVNULL,
            )
            return True
    return False


def parse_duration(duration: str) -> int:
    """Parse a duration string like '30s', '30secs', '15min', '15mins' into seconds."""
    import re

    match = re.fullmatch(r"(\d+)(s|secs?|min|mins?)", duration)
    if not match:
        raise ValueError(f"invalid duration: {duration!r}")
    value = int(match.group(1))
    unit = match.group(2)
    if unit.startswith("min"):
        return value * 60
    return value


def parse(args) -> Plan:
    match args:
        case ["in", duration] | ["after", duration]:
            return Plan(intervals=1, interval_duration=parse_duration(duration))
        case ["every", interval, "for", duration]:
            interval_secs = parse_duration(interval)
            total_secs = parse_duration(duration)
            return Plan(
                intervals=total_secs // interval_secs, interval_duration=interval_secs
            )
        case ["every", interval, count, "times"]:
            return Plan(
                intervals=int(count), interval_duration=parse_duration(interval)
            )
        case _:
            print("Usage: beep <in|after> <duration>")
            print("       beep every <interval> for <duration>")
            print("       beep every <interval> <N> times")
            sys.exit(1)


def execute(plan: Plan):
    n = 0
    while n < plan.intervals:
        time.sleep(plan.interval_duration)
        play(LONG_BEEP)
        n += 1


def end():
    time.sleep(1)
    for n in range(3):
        play(SHORT_BEEP)
        time.sleep(0.2)


def main():
    args = sys.argv[1:]
    plan = parse(args)
    # plan = Plan(intervals=3, interval_duration=1)
    execute(plan)
    end()


if __name__ == "__main__":
    main()
