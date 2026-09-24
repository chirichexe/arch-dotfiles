---@module 'hl'

-- Wallust colors for the Lua config.
-- Wallust still writes ~/.config/hypr/wallust/wallust-hyprland.conf (`$colorN = rgb(RRGGBB)`),
-- so read that file and return its values, e.g. `colors.color12 == "rgb(F67C8B)"`.
-- Wallpaper scripts run `hyprctl reload` after wallust, which re-reads this file.

local path = os.getenv("HOME") .. "/.config/hypr/wallust/wallust-hyprland.conf"

-- Fallback palette, used when the wallust file is missing or incomplete
local colors = {
    background = "rgb(181719)",
    foreground = "rgb(B5EAF4)",
}
for i = 0, 15 do colors["color" .. i] = "rgb(8ED9E7)" end
colors.color0  = "rgb(3E3E40)"
colors.color10 = "rgb(525974)"
colors.color12 = "rgb(F67C8B)"

local f = io.open(path, "r")
if f then
    for line in f:lines() do
        local name, value = line:match("^%s*%$([%w_]+)%s*=%s*(%S+)")
        if name and value then colors[name] = value end
    end
    f:close()
end

return colors
