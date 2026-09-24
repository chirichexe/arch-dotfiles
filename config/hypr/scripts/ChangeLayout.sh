#!/usr/bin/env bash
# /* ---- 💫 https://github.com/JaKooLit 💫 ---- */  ##
# for changing Hyprland Layouts (Master or Dwindle) on the fly
# SUPER J/K/O are layout-aware Lua binds in configs/Keybinds.lua, so only the layout changes here.

notif="$HOME/.config/swaync/images/ja.png"

# `init` used to re-register the J/K binds at startup; that is handled by the Lua config now.
[ "$1" = "init" ] && exit 0

LAYOUT=$(hyprctl -j getoption general:layout | jq -r '.str')

case $LAYOUT in
"master")
  hyprctl eval 'hl.config({ general = { layout = "dwindle" } })' >/dev/null
  notify-send -e -u low -i "$notif" " Dwindle Layout"
  ;;
*)
  hyprctl eval 'hl.config({ general = { layout = "master" } })' >/dev/null
  notify-send -e -u low -i "$notif" " Master Layout"
  ;;
esac
