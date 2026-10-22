#!/usr/bin/env python3
# Niri: maximize-column only grows the focused window's column to full width; it
# leaves the window's height alone, which matters when the column is a vertical
# stack (the window keeps whatever height share it had). This also fills the
# window's height so it truly takes up the whole page, and toggles back on a
# second press instead of leaving it stuck.
#
# A stacked column can't give one window 100% height without crushing its
# siblings, so for that case this switches the column to niri's tabbed display
# instead: the focused window gets the full tile, the others are just hidden
# behind it (not squashed to a sliver), and switching back to normal restores
# everyone's shared height exactly as before.
import json
import subprocess
import sys


def niri_json(*args):
    return json.loads(subprocess.check_output(["niri", "msg", "--json", *args]))


def niri_action(*args):
    subprocess.run(["niri", "msg", "action", *args])


focused = niri_json("focused-window")
if not focused:
    sys.exit(0)

col = focused["layout"].get("pos_in_scrolling_layout")
stacked = col is not None and sum(
    1 for w in niri_json("windows")
    if w["workspace_id"] == focused["workspace_id"]
    and (w["layout"].get("pos_in_scrolling_layout") or [None])[0] == col[0]
) > 1

tile_width = focused["layout"]["tile_size"][0]
workspace = next(w for w in niri_json("workspaces") if w["id"] == focused["workspace_id"])
output_width = niri_json("outputs")[workspace["output"]]["logical"]["width"]

niri_action("maximize-column")
if tile_width < output_width * 0.9:
    niri_action("set-column-display", "tabbed" if stacked else "normal")
    if not stacked:
        niri_action("set-window-height", "100%")
else:
    niri_action("set-column-display", "normal")
    if not stacked:
        niri_action("reset-window-height")
