---@module 'hl'

-- /* ---- 💫 https://github.com/JaKooLit 💫 ---- */  #
-- Commands and Apps to be executed at launch (vendor defaults)
-- Add your own in UserConfigs/Startup_Apps.lua

local defaults    = require("UserConfigs.01-UserDefaults")
local home        = os.getenv("HOME")
local scriptsDir  = home .. "/.config/hypr/scripts"
local UserScripts = home .. "/.config/hypr/UserScripts"

-- Video wallpaper chosen in WallpaperSelect.sh (SUPER W), if any
local function live_wallpaper()
    local f = io.open(home .. "/.config/hypr/.live_wallpaper", "r")
    if not f then return nil end
    local path = f:read("l")
    f:close()
    if path and path ~= "" then return path end
end

hl.on("hyprland.start", function()
    -- Environment sync
    hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
    hl.exec_cmd("systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")

    -- Wallpaper: mpvpaper for a video wallpaper, otherwise the awww daemon (renamed swww)
    local video = live_wallpaper()
    if video then
        hl.exec_cmd("mpvpaper '*' -o 'load-scripts=no no-audio --loop' '" .. video .. "'")
    else
        hl.exec_cmd("awww-daemon --format xrgb")
    end

    -- Dropdown terminal (SUPER SHIFT Return)
    hl.exec_cmd(scriptsDir .. "/Dropterminal.sh " .. defaults.term)

    -- Core services
    hl.exec_cmd(scriptsDir .. "/Polkit.sh")
    hl.exec_cmd("nm-applet")
    hl.exec_cmd("swaync")
    hl.exec_cmd("waybar")
    hl.exec_cmd("qs -c overview")  -- Quickshell Overview
    hl.exec_cmd("hypridle")
    hl.exec_cmd(scriptsDir .. "/Hyprsunset.sh init")
    hl.exec_cmd("blueman-applet")

    -- Clipboard manager
    hl.exec_cmd("wl-paste --type text --watch cliphist store")
    hl.exec_cmd("wl-paste --type image --watch cliphist store")

    -- Rainbow borders (toggle it from the quick settings menu, SUPER SHIFT E)
    local f = io.open(UserScripts .. "/RainbowBorders.sh", "r")
    if f then
        f:close()
        hl.exec_cmd(UserScripts .. "/RainbowBorders.sh")
    end
end)

-- Optional features (put them in UserConfigs/Startup_Apps.lua inside hl.on("hyprland.start", ...)):
-- Random wallpaper every 30 min:
--   hl.exec_cmd(UserScripts .. "/WallpaperAutoChange.sh " .. home .. "/Pictures/wallpapers")
-- Gnome polkit for NixOS:
--   hl.exec_cmd(scriptsDir .. "/Polkit-NixOS.sh")
-- xdg-desktop-portal-hyprland:
--   hl.exec_cmd(scriptsDir .. "/PortalHyprland.sh")
