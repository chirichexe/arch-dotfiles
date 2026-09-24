---@module 'hl'

-- /* ---- 💫 https://github.com/JaKooLit 💫 ---- */  #

-- See https://wiki.hyprland.org/Configuring/Keywords/ for more variable settings

-- These configs are mostly for laptops. This is an addendum to Keybinds.lua

local mainMod = "SUPER"

local scriptsDir = os.getenv("HOME") .. "/.config/hypr/scripts"

local UserConfigs = os.getenv("HOME") .. "/.config/hypr/UserConfigs"

-- for disabling Touchpad. hyprctl devices to get device name.
-- scripts/TouchPad.sh reads this line, keep it in the form: local Touchpad_Device = "name"

local Touchpad_Device = "asue1209:00-04f3:319f-touchpad"

hl.bind("xf86KbdBrightnessDown", hl.dsp.exec_cmd(os.getenv("HOME") .. "/.config/hypr/scripts/BrightnessKbd.sh --dec"), { repeating = true })

-- decrease keyboard brightness

hl.bind("xf86KbdBrightnessUp", hl.dsp.exec_cmd(os.getenv("HOME") .. "/.config/hypr/scripts/BrightnessKbd.sh --inc"), { repeating = true })

-- increase keyboard brightness

hl.bind("xf86Launch1", hl.dsp.exec_cmd("rog-control-center"))

-- ASUS Armory crate button

hl.bind("xf86Launch3", hl.dsp.exec_cmd("asusctl led-mode -n"))

-- FN+F4 Switch keyboard RGB profile 

hl.bind("xf86Launch4", hl.dsp.exec_cmd("asusctl profile -n"))

-- FN+F5 change of fan profiles (Quite, Balance, Performance)

hl.bind("xf86MonBrightnessDown", hl.dsp.exec_cmd(os.getenv("HOME") .. "/.config/hypr/scripts/Brightness.sh --dec"), { repeating = true })

-- decrease monitor brightness

hl.bind("xf86MonBrightnessUp", hl.dsp.exec_cmd(os.getenv("HOME") .. "/.config/hypr/scripts/Brightness.sh --inc"), { repeating = true })

-- increase monitor brightness

hl.bind("xf86TouchpadToggle", hl.dsp.exec_cmd(os.getenv("HOME") .. "/.config/hypr/scripts/TouchPad.sh"))

-- disable touchpad

-- Screenshot keybindings using F6 (no PrinSrc button)

hl.bind(mainMod .. " + " .. "F6", hl.dsp.exec_cmd(os.getenv("HOME") .. "/.config/hypr/scripts/ScreenShot.sh --now"))

-- screenshot

hl.bind(mainMod .. " + " .. "SHIFT" .. " + " .. "F6", hl.dsp.exec_cmd(os.getenv("HOME") .. "/.config/hypr/scripts/ScreenShot.sh --area"))

-- screenshot (area)

hl.bind(mainMod .. " + " .. "CTRL" .. " + " .. "F6", hl.dsp.exec_cmd(os.getenv("HOME") .. "/.config/hypr/scripts/ScreenShot.sh --in5"))

-- # screenshot (5 secs delay)

hl.bind(mainMod .. " + " .. "ALT" .. " + " .. "F6", hl.dsp.exec_cmd(os.getenv("HOME") .. "/.config/hypr/scripts/ScreenShot.sh --in10"))

-- screenshot (10 secs delay)

hl.bind("ALT + F6", hl.dsp.exec_cmd(os.getenv("HOME") .. "/.config/hypr/scripts/ScreenShot.sh --active"))

-- screenshot (active window only)

local TOUCHPAD_ENABLED = true

hl.device({
    name = Touchpad_Device,
    enabled = true,
})
