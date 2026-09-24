#!/usr/bin/env bash
# /* ---- 💫 https://github.com/JaKooLit 💫 ---- */  ##
# Game Mode. Turning off all animations

notif="$HOME/.config/swaync/images/ja.png"
SCRIPTSDIR="$HOME/.config/hypr/scripts"


HYPRGAMEMODE=$(hyprctl -j getoption animations:enabled | jq -r '.bool')
if [ "$HYPRGAMEMODE" = true ] ; then
    hyprctl eval '
        hl.config({
            animations = { enabled = false },
            decoration = { shadow = { enabled = false }, blur = { enabled = false }, rounding = 0 },
            general    = { gaps_in = 0, gaps_out = 0, border_size = 1 },
        })
        hl.window_rule({ name = "gamemode-opaque", match = { class = ".*" }, opaque = true })
    ' >/dev/null
    awww kill 
    notify-send -e -u low -i "$notif" " Gamemode:" " enabled"
    sleep 0.1
    exit
else
	pgrep -x awww-daemon >/dev/null || { awww-daemon --format xrgb & sleep 0.5; }
	awww img "$HOME/.config/rofi/.current_wallpaper" &
	sleep 0.1
	${SCRIPTSDIR}/WallustSwww.sh
	sleep 0.5
  hyprctl reload
	${SCRIPTSDIR}/Refresh.sh	 
    notify-send -e -u normal -i "$notif" " Gamemode:" " disabled"
    exit
fi
hyprctl reload
