#!/usr/bin/env python3
import json
import os
import re
import sys
import subprocess

def get_window_icon(app_id, title):
    app_id = app_id or ""
    title = title or ""

    # Title checks
    if re.search(r"amazon", title, re.I): return " "
    if re.search(r"reddit", title, re.I): return " "
    if re.search(r"gmail", title, re.I): return "󰊫 "
    if re.search(r"whatsapp|zapzap", title, re.I): return " "
    if re.search(r"messenger", title, re.I): return " "
    if re.search(r"facebook", title, re.I): return " "
    if re.search(r"chatgpt|deepseek|qwen", title, re.I): return "󰚩 "
    if re.search(r"Picture-in-Picture", title, re.I): return " "
    if re.search(r"youtube", title, re.I): return " "
    if re.search(r"cmus", title, re.I): return " "
    if re.search(r"virtualbox", title, re.I): return "💽 "
    if re.search(r"github", title, re.I): return " "
    if re.search(r"nvim ~|nvim|vim", title, re.I): return " "
    if re.search(r"figma", title, re.I): return " "
    if re.search(r"jira", title, re.I): return " "

    # Class / App ID checks
    if re.search(r"firefox|org\.mozilla\.firefox|librewolf|floorp|mercury-browser|[Cc]achy-browser", app_id): return " "
    if re.search(r"zen", app_id, re.I): return "󰰷 "
    if re.search(r"waterfox", app_id, re.I): return " "
    if re.search(r"microsoft-edge", app_id, re.I): return " "
    if re.search(r"Chromium|Thorium|[Cc]hrome", app_id): return " "
    if re.search(r"brave-browser", app_id, re.I): return "🦁 "
    if re.search(r"tor browser", app_id, re.I): return " "
    if re.search(r"firefox-developer-edition", app_id, re.I): return "🦊 "

    if re.search(r"kitty-dropterm", app_id, re.I): return " "
    if re.search(r"kitty|konsole", app_id, re.I): return " "
    if re.search(r"ghostty", app_id, re.I): return " "
    if re.search(r"wezterm", app_id, re.I): return " "

    if re.search(r"[Tt]hunderbird|eu\.betterbird\.Betterbird", app_id): return " "
    if re.search(r"[Tt]elegram|org\.telegram\.desktop|tdesktop", app_id): return " "
    if re.search(r"discord|[Ww]ebcord|Vesktop", app_id): return " "
    if re.search(r"subl", app_id, re.I): return "󰅳 "
    if re.search(r"slack", app_id, re.I): return " "

    if re.search(r"mpv", app_id, re.I): return " "
    if re.search(r"celluloid|Zoom", app_id, re.I): return " "
    if re.search(r"Cider", app_id): return "󰎆 "
    if re.search(r"vlc", app_id, re.I): return "󰕼 "
    if re.search(r"[Ss]potify", app_id): return " "
    if re.search(r"Plex", app_id): return "󰚺 "

    if re.search(r"virt-manager", app_id, re.I): return " "
    if re.search(r"virtualbox", app_id, re.I): return "💽 "
    if re.search(r"remmina", app_id, re.I): return "🖥️ "

    if re.search(r"code|VSCode|code-oss|codium|VSCodium", app_id, re.I): return "󰨞 "
    if re.search(r"zed", app_id, re.I): return "󰵁"
    if re.search(r"codeblocks", app_id, re.I): return "󰅩 "
    if re.search(r"mousepad", app_id, re.I): return " "
    if re.search(r"libreoffice-writer", app_id, re.I): return " "
    if re.search(r"libreoffice-startcenter", app_id, re.I): return "󰏆 "
    if re.search(r"libreoffice-calc", app_id, re.I): return " "
    if re.search(r"jetbrains", app_id, re.I): return " "
    if re.search(r"obsidian", app_id, re.I): return "󰎞 "

    if re.search(r"obs|Studio", app_id, re.I): return " "
    if re.search(r"polkit", app_id, re.I): return "󰒃 "
    if re.search(r"nwg-look", app_id, re.I): return " "
    if re.search(r"[Pp]avucontrol", app_id): return "󱡫 "
    if re.search(r"steam", app_id, re.I): return " "
    if re.search(r"thunar|nemo|nautilus", app_id, re.I): return "󰝰 "
    if re.search(r"gparted", app_id, re.I): return ""
    if re.search(r"gimp", app_id, re.I): return " "
    if re.search(r"emulator", app_id, re.I): return "📱 "
    if re.search(r"android-studio", app_id, re.I): return " "
    if re.search(r"Helvum", app_id, re.I): return "󰓃"
    if re.search(r"localsend", app_id, re.I): return ""
    if re.search(r"PrusaSlicer|Cura|OrcaSlicer", app_id, re.I): return "󰹛"

    return " "

# Waybar shows one custom module per workspace slot ("custom/niri_ws#1".."#10", defined in
# ~/.config/waybar/ModulesWorkspaces) so each one is a real GTK widget styled by the same CSS as
# Hyprland's workspace buttons. This daemon writes one JSON file per slot and asks waybar to
# re-read them with a single realtime signal.
MAX_SLOTS = 10
SIGNAL = 8  # "signal": 8 in the niri_ws modules -> SIGRTMIN+8
STATE_DIR = os.path.join(os.environ.get("XDG_RUNTIME_DIR", "/tmp"), "waybar-niri-ws")


def niri_json(*args):
    out = subprocess.check_output(["niri", "msg", "--json", *args], stderr=subprocess.DEVNULL)
    return json.loads(out)


def slot_states():
    """Workspaces of the focused output, keyed by their 1-based index on that output."""
    try:
        workspaces, windows = niri_json("workspaces"), niri_json("windows")
    except Exception:
        return {}

    focused = next((w for w in workspaces if w.get("is_focused")), None)
    output = focused.get("output") if focused else None

    per_ws = {}
    for w in windows:
        if w.get("workspace_id") is not None:
            per_ws.setdefault(w["workspace_id"], []).append(w)

    states = {}
    for ws in workspaces:
        if output and ws.get("output") != output:
            continue
        idx = ws.get("idx", 0)
        if not 1 <= idx <= MAX_SLOTS:
            continue
        wins = per_ws.get(ws["id"], [])
        icons = " ".join(get_window_icon(w.get("app_id"), w.get("title")) for w in wins).strip()
        text = f"{idx} {icons}".strip()
        classes = ["niri-ws", "active" if ws.get("is_active") else ("occupied" if wins else "empty")]
        if ws.get("is_urgent"):
            classes.append("urgent")
        titles = [w.get("title") or w.get("app_id") or "Window" for w in wins]
        states[idx] = {
            "text": text,
            "class": classes,
            "tooltip": f"Workspace {idx}: " + (", ".join(titles) if titles else "Empty"),
        }
    return states


def write_states():
    os.makedirs(STATE_DIR, exist_ok=True)
    states = slot_states()
    for idx in range(1, MAX_SLOTS + 1):
        data = states.get(idx, {"text": "", "class": ["niri-ws", "hidden"]})
        tmp = os.path.join(STATE_DIR, f".{idx}.json")
        with open(tmp, "w") as f:
            json.dump(data, f)
        os.replace(tmp, os.path.join(STATE_DIR, f"{idx}.json"))
    subprocess.run(["pkill", f"-RTMIN+{SIGNAL}", "-x", "waybar"], stderr=subprocess.DEVNULL)


def main():
    # This module only launches the daemon; its own output stays empty (hidden)
    print(json.dumps({"text": ""}), flush=True)
    if not os.environ.get("NIRI_SOCKET"):
        return

    try:
        proc = subprocess.Popen(["niri", "msg", "--json", "event-stream"],
                                stdout=subprocess.PIPE, stderr=subprocess.DEVNULL, text=True)
    except Exception:
        sys.exit(0)

    write_states()
    for _ in proc.stdout:
        write_states()


if __name__ == "__main__":
    main()
