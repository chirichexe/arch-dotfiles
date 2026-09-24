---@module 'hl'

-- /* ---- 💫 https://github.com/JaKooLit 💫 ---- */  #

-- default Monitor config

-- *********************************************************** #

-- 

-- NOTE: This will be overwritten by NWG-Displays 

-- once you use and click apply. You can still find this

-- default at ~/.config/hypr/Monitor_Profiles/default.lua
-- NOTE: nwg-displays writes monitors.conf (hyprlang), which the Lua config does not read.
-- After using it, copy the resulting rules here as hl.monitor({ ... }).

--

-- *********************************************************** #

-- Monitor Configuration

-- See Hyprland wiki for more details

-- https://wiki.hyprland.org/Configuring/Monitors/

-- Configure your Display resolution, offset, scale and Monitors here, use `hyprctl monitors` to get the info.

-- Monitors

-- Catch-all rule for any monitor. (The old .conf had preferred, highrr and highres
-- catch-all rules one after another; only the last one, highres, ever took effect.)
hl.monitor({
    output   = "",
    mode     = "highres",
    position = "auto",
    scale    = 1,
})

-- NOTE: for laptop, kindly check the lid-switch notes in UserConfigs/Laptops.lua

-- Created this inorder for the monitor display to not wake up if not intended.

-- See here: https://github.com/hyprwm/Hyprland/issues/4090

-- Some examples to set your own monitor

--monitor = eDP-1, preferred, auto, 1

--monitor = eDP-1, 2560x1440@165, 0x0, 1 #own screen

--monitor = DP-3, 1920x1080@240, auto, 1 

--monitor = DP-1, preferred, auto, 1

--monitor = HDMI-A-1, preferred,auto,1

-- QEMU-KVM, virtual box or vmware

--monitor = Virtual-1, 1920x1080@60,auto,1

-- to disable a monitor

--monitor=name,disable

-- Mirror samples

--monitor=DP-3,1920x1080@60,0x0,1,mirror,DP-2

--monitor=,preferred,auto,1,mirror,eDP-1

--monitor=HDMI-A-1,2560x1440@144,0x0,1,mirror,eDP-1

-- 10 bit monitor support - See wiki https://wiki.hyprland.org/Configuring/Monitors/#10-bit-support - See NOTES below

-- NOTE: Colors registered in Hyprland (e.g. the border color) do not support 10 bit.

-- NOTE: Some applications do not support screen capture with 10 bit enabled. (Screen captures like OBS may render black screen)

-- monitor=,preferred,auto,1,bitdepth,10

--monitor=eDP-1,transform,0

--monitor=eDP-1,addreserved,10,10,10,49

-- workspaces - Monitor rules

-- https://wiki.hyprland.org/Configuring/Workspace-Rules/

-- SUPER E - Workspace-Rules 

-- Workspace rules go in ~/.config/hypr/workspaces.lua (hl.workspace_rule)
