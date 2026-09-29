#!/usr/bin/env python3
# Niri: open a terminal stacked below the focused window, in the same column, Hyprland-style.
# The new window gets the smaller golden-ratio share of the column height (38.2%).
#
# Niri reports a new window before its first frame is drawn. Moving it into the focused column
# right then (one IPC batch) makes niri play the normal open animation directly in its final
# slot, instead of opening a new column on the right and sliding it over.
import json
import os
import select
import socket
import subprocess
import sys
import time

TERM = sys.argv[1] if len(sys.argv) > 1 else "kitty"
HEIGHT = 38.2  # percent
TIMEOUT = 5.0


def niri_json(*args):
    return json.loads(subprocess.check_output(["niri", "msg", "--json", *args]))


def send_actions(*actions):
    """Send several actions on one IPC connection so niri applies them before the next frame."""
    with socket.socket(socket.AF_UNIX) as sock:
        sock.connect(os.environ["NIRI_SOCKET"])
        f = sock.makefile("rw")
        for act in actions:
            f.write(json.dumps({"Action": act}) + "\n")
        f.flush()
        for _ in actions:
            f.readline()


focused = niri_json("focused-window")

# Nothing tiled to stack under: just open the terminal normally
if not focused or focused.get("is_floating"):
    subprocess.Popen([TERM], start_new_session=True)
    sys.exit(0)

known = {w["id"] for w in niri_json("windows")}

# Listen before spawning so the new window's first event cannot be missed
events = subprocess.Popen(["niri", "msg", "--json", "event-stream"],
                          stdout=subprocess.PIPE, stderr=subprocess.DEVNULL, text=True)
subprocess.Popen([TERM], start_new_session=True)

new_id = None
deadline = time.monotonic() + TIMEOUT
while new_id is None and time.monotonic() < deadline:
    ready, _, _ = select.select([events.stdout], [], [], deadline - time.monotonic())
    if not ready:
        break
    line = events.stdout.readline()
    if not line:
        break
    win = json.loads(line).get("WindowOpenedOrChanged", {}).get("window")
    if win and win["id"] not in known and not win.get("is_floating"):
        new_id = win["id"]
events.terminate()

if new_id is None:
    sys.exit(0)

# The window would open in a new column right of the focused one: consuming it left drops it at
# the bottom of the focused column.
send_actions(
    {"ConsumeOrExpelWindowLeft": {"id": new_id}},
    {"SetWindowHeight": {"id": new_id, "change": {"SetProportion": HEIGHT}}},
)
