#!/usr/bin/env python3
# Niri: resize the focused window's height by moving the border the arrow points at, like
# Hyprland. On the bottom window of a column the shared border is its top edge, so "up" grows it
# and "down" shrinks it; on every other window the border is the bottom edge.
# Usage: NiriResizeHeight.py up|down [pixels]
import json
import subprocess
import sys

direction = sys.argv[1]
step = int(sys.argv[2]) if len(sys.argv) > 2 else 50


def niri_json(*args):
    return json.loads(subprocess.check_output(["niri", "msg", "--json", *args]))


focused = niri_json("focused-window")
if not focused:
    sys.exit(0)

delta = step if direction == "down" else -step

pos = focused["layout"].get("pos_in_scrolling_layout")
if pos:
    col, row = pos
    rows = sum(1 for w in niri_json("windows")
               if w["workspace_id"] == focused["workspace_id"]
               and (w["layout"].get("pos_in_scrolling_layout") or [None])[0] == col)
    if rows > 1 and row == rows:
        delta = -delta

subprocess.run(["niri", "msg", "action", "set-window-height", f"{delta:+d}"])
