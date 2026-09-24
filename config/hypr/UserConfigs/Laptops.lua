---@module 'hl'

-- /* ---- 💫 https://github.com/JaKooLit 💫 ---- */  #

-- User laptop settings. Addendum to configs/Laptops.lua (brightness keys, touchpad device, etc.)
-- Switch binds: https://wiki.hypr.land/Configuring/Basics/Binds/ (Switches); list them with `hyprctl devices`.

-- Disable the laptop panel while the lid is closed (useful with an external monitor).
-- CAVEATS: sometimes the laptop panel does not come back and you must re-plug the external
-- monitor; make sure the lid is OPEN before shutting down. systemd-logind's HandleLidSwitch
-- may also conflict (see the wiki).
--
-- hl.bind("switch:on:Lid Switch", function()
--     hl.monitor({ output = "eDP-1", disabled = true })
-- end, { locked = true })
--
-- hl.bind("switch:off:Lid Switch", function()
--     hl.monitor({ output = "eDP-1", mode = "preferred", position = "auto", scale = 1 })
-- end, { locked = true })
