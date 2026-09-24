#!/usr/bin/env bash
# /* ---- 💫 https://github.com/JaKooLit 💫 ---- */  ##

# For Hyprlock
#pidof hyprlock || hyprlock -q

# Ensure weather cache is up-to-date before locking (Waybar/lockscreen readers)
bash "$HOME/.config/hypr/UserScripts/WeatherWrap.sh" >/dev/null 2>&1

# hypridle turns `loginctl lock-session` into hyprlock (lock_cmd); without it, lock directly
if pgrep -x hypridle >/dev/null; then
    loginctl lock-session
else
    pidof hyprlock >/dev/null || { hyprlock & disown; }
fi

