#!/usr/bin/env bash
# /* ---- 💫 https://github.com/JaKooLit 💫 ---- */  ##
# End the current session, whichever compositor is running (used by wlogout, waybar, swaync)

if [ -n "$HYPRLAND_INSTANCE_SIGNATURE" ]; then
    hyprctl dispatch 'hl.dsp.exit()'
elif [ -n "$NIRI_SOCKET" ]; then
    niri msg action quit --skip-confirmation
else
    loginctl terminate-session "${XDG_SESSION_ID:-self}"
fi
