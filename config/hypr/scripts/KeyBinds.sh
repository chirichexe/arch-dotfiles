#!/usr/bin/env bash
# /* ---- 💫 https://github.com/JaKooLit 💫 ---- */  ##
# searchable enabled keybinds using rofi
# Reads the live binds from Hyprland (`hyprctl binds -j`), so it always matches the Lua config,
# including user overrides. Descriptions come from the `description` option of hl.bind().

# kill yad to not interfere with this binds
pkill yad || true

# check if rofi is already running
if pidof rofi > /dev/null; then
  pkill rofi
fi

rofi_theme="$HOME/.config/rofi/config-keybinds.rasi"
msg='☣️ NOTE ☣️: Clicking with Mouse or Pressing ENTER will have NO function'

# modmask bits: SHIFT=1 CAPS=2 CTRL=4 ALT=8 MOD2=16 MOD3=32 SUPER=64 MOD5=128
display_keybinds=$(hyprctl binds -j | jq -r '
  def mods($m):
    [ (if ($m / 64 | floor) % 2 == 1 then "SUPER" else empty end),
      (if ($m / 4  | floor) % 2 == 1 then "CTRL"  else empty end),
      (if ($m / 8  | floor) % 2 == 1 then "ALT"   else empty end),
      (if  $m % 2 == 1                then "SHIFT" else empty end) ];
  def keyname($k):
    ({ "code:10": "1", "code:11": "2", "code:12": "3", "code:13": "4", "code:14": "5",
       "code:15": "6", "code:16": "7", "code:17": "8", "code:18": "9", "code:19": "0",
       "mouse:272": "LMB", "mouse:273": "RMB" })[$k] // $k;
  .[]
  | select(.submap == "" or .submap == null)
  | ((mods(.modmask) + [keyname(.key)]) | join(" + ")) as $combo
  | "\($combo)  →  \(if (.description // "") != "" then .description else .dispatcher + " " + (.arg // "") end)"
')

if [[ -z "$display_keybinds" ]]; then
  notify-send -u low "Keybinds" "Could not read binds from Hyprland (is it running?)"
  exit 1
fi

# use rofi to display the keybinds
printf '%s\n' "$display_keybinds" | rofi -dmenu -i -config "$rofi_theme" -mesg "$msg"
