---@module 'hl'

-- /* ---- 💫 https://github.com/JaKooLit 💫 ---- */  #

-- This is a file where you put your own default apps, default search Engine etc.
-- It is `require`d by hyprland.lua (and Keybinds.lua), which read the table it returns.
--
-- NOTE: scripts (WaybarScripts.sh, RofiSearch.sh, Kool_Quick_Settings.sh) also parse the
-- `local name = "value"` lines below, so keep each one on a single line in that exact form.

-- Default editor (exported as $EDITOR for everything Hyprland launches)
local editor = "nvim"

-- Editor for the KooL Quick Settings Menu (SUPER SHIFT E); falls back to nano
local edit = "${EDITOR:-nano}"

-- Terminal (SUPER Return) and file manager (SUPER E); also used by Waybar modules
local term = "kitty"
local files = "thunar"

-- Default Search Engine for ROFI Search (SUPER S)
local Search_Engine = "https://www.google.com/search?q={}"

hl.env("EDITOR", editor)
hl.env("TERMINAL", term)

return {
    editor        = editor,
    edit          = edit,
    term          = term,
    files         = files,
    Search_Engine = Search_Engine,
}
