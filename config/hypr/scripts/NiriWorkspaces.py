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

def get_niri_data():
    try:
        ws_out = subprocess.check_output(["niri", "msg", "--json", "workspaces"], stderr=subprocess.DEVNULL).decode()
        win_out = subprocess.check_output(["niri", "msg", "--json", "windows"], stderr=subprocess.DEVNULL).decode()
        return json.loads(ws_out), json.loads(win_out)
    except Exception:
        return [], []

def generate_output():
    workspaces, windows = get_niri_data()
    if not workspaces:
        return {"text": "", "tooltip": ""}

    ws_windows = {}
    for w in windows:
        ws_id = w.get("workspace_id")
        if ws_id:
            ws_windows.setdefault(ws_id, []).append(w)

    workspaces.sort(key=lambda x: x.get("idx", 0))

    items = []
    tooltip_items = []
    active_idx = 1

    for ws in workspaces:
        idx = ws["idx"]
        is_active = ws.get("is_active", False)
        is_focused = ws.get("is_focused", False)
        if is_focused or is_active:
            active_idx = idx

        ws_wins = ws_windows.get(ws["id"], [])
        win_icons = " ".join(get_window_icon(w.get("app_id"), w.get("title")) for w in ws_wins)

        label = f"{idx} {win_icons}".strip() if win_icons else f"{idx}"

        if is_focused or is_active:
            items.append(f"<span background='#ffffff' foreground='#11111b'> <b>{label}</b> </span>")
        elif not ws_wins:
            items.append(f"<span background='#313244' foreground='#a6adc8'> {label} </span>")
        else:
            items.append(f"<span background='#45475a' foreground='#cdd6f4'> {label} </span>")

        titles = [w.get("title") or w.get("app_id") or "Window" for w in ws_wins]
        win_list_str = ", ".join(titles) if titles else "Empty"
        tooltip_items.append(f"Workspace {idx}: {win_list_str}")

    text_output = " ".join(items)
    tooltip_output = "\n".join(tooltip_items)

    cls = "active" if active_idx else "normal"
    return {
        "text": text_output,
        "tooltip": tooltip_output,
        "class": cls
    }

def main():
    if not os.environ.get("NIRI_SOCKET"):
        print(json.dumps({"text": "", "tooltip": ""}), flush=True)
        return

    print(json.dumps(generate_output()), flush=True)

    try:
        proc = subprocess.Popen(["niri", "msg", "--json", "event-stream"], stdout=subprocess.PIPE, stderr=subprocess.DEVNULL, text=True)
    except Exception:
        sys.exit(0)

    while True:
        line = proc.stdout.readline()
        if not line:
            break
        output = generate_output()
        print(json.dumps(output), flush=True)

if __name__ == "__main__":
    main()
