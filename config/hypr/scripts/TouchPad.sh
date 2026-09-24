#!/usr/bin/env bash
# /* ---- 💫 https://github.com/JaKooLit 💫 ---- */  ##
# For disabling touchpad.
# Edit Touchpad_Device in ~/.config/hypr/configs/Laptops.lua according to your system
# use hyprctl devices to get your system touchpad device name
# source https://github.com/hyprwm/Hyprland/discussions/4283?sort=new#discussioncomment-8648109

set -euo pipefail

notif="$HOME/.config/swaync/images/ja.png"
laptops_conf="$HOME/.config/hypr/configs/Laptops.lua"

touchpad_device="${TOUCHPAD_DEVICE:-}"
if [[ -z "$touchpad_device" && -f "$laptops_conf" ]]; then
    touchpad_device="$(
        sed -nE 's/^[[:space:]]*local[[:space:]]+Touchpad_Device[[:space:]]*=[[:space:]]*"([^"]*)".*/\1/p' "$laptops_conf" | head -n1
    )"
fi

if [[ -z "$touchpad_device" ]]; then
    notify-send -u low -i "$notif" " Touchpad" " Device name not set (check configs/Laptops.lua)"
    exit 1
fi


# Hyprland Lua config (0.55+): per-device settings are applied with hl.device()
set_touchpad() {
    hyprctl eval "hl.device({ name = \"${touchpad_device}\", enabled = $1 })" >/dev/null
}
status_file="${XDG_RUNTIME_DIR:-/tmp}/touchpad.status"

enable_touchpad() {
    printf "true" >"$status_file"
    notify-send -u low -i "$notif" " Enabling" " touchpad"
    set_touchpad true
}

disable_touchpad() {
    printf "false" >"$status_file"
    notify-send -u low -i "$notif" " Disabling" " touchpad"
    set_touchpad false
}

current_state="false"
if [[ -f "$status_file" ]]; then
    current_state="$(<"$status_file")"
fi

if [[ "$current_state" == "true" ]]; then
    disable_touchpad
else
    enable_touchpad
fi
