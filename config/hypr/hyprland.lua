---@module 'hl'

-- /* ---- 💫 https://github.com/JaKooLit 💫 ---- */  #
-- Always refer to Hyprland wiki: https://wiki.hyprland.org/

-- Initial boot script: applies wallpapers, theming, new settings on first launch.
-- As long as ~/.config/hypr/.initial_startup_done exists, this will NOT re-execute.
hl.on("hyprland.start", function()
    hl.exec_cmd(os.getenv("HOME") .. "/.config/hypr/initial-boot.sh")
end)

-- ### Loading the config modules (configs/ and UserConfigs/, relative to this file) ###

-- User default apps (term, files, ...) first; Keybinds and Startup_Apps read them
require("UserConfigs.01-UserDefaults") -- Settings for user default apps
require("configs.Keybinds")            -- Pre-configured keybinds

-- Load defaults, then user additions/overrides
require("configs.Startup_Apps")
require("UserConfigs.Startup_Apps")

require("configs.ENVariables")        -- Environment variables (defaults)
require("UserConfigs.ENVariables")    -- Environment variables (user)

-- For laptop related
require("configs.Laptops")
require("UserConfigs.Laptops")

-- Load defaults, then user additions
require("configs.WindowRules")        -- Window Rules (defaults)
require("UserConfigs.WindowRules")    -- Window Rules (user)
require("configs.LayerRules")         -- Layer Rules (defaults)
require("UserConfigs.LayerRules")     -- Layer Rules (user)

require("configs.SystemSettings")     -- Default config for hypr

require("UserConfigs.UserDecorations") -- Decorations config file
require("UserConfigs.UserAnimations")  -- Animation config file
require("UserConfigs.UserKeybinds")    -- Put your own keybinds here
require("UserConfigs.UserSettings")    -- Main Hyprland Settings

-- nwg-displays
require("monitors")
require("workspaces")
