#!/usr/bin/env python3
# Niri: maximize-column only grows the focused window's column to full width; it
# leaves the window's height alone, which matters when the column is a vertical
# stack (the window keeps whatever height share it had). This also fills the
# window's height so it truly takes up the whole page, and toggles back to an
# automatic height when un-maximizing instead of leaving it stuck.
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

tile_width = focused["layout"]["tile_size"][0]
workspace = next(w for w in niri_json("workspaces") if w["id"] == focused["workspace_id"])
output_width = niri_json("outputs")[workspace["output"]]["logical"]["width"]

if tile_width < output_width * 0.9:
    niri_action("maximize-column")
    niri_action("set-window-height", "100%")
else:
    niri_action("maximize-column")
    niri_action("reset-window-height")
