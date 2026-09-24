-- /* ---- 💫 https://github.com/JaKooLit 💫 ---- */  #
-- Vendor defaults for layerrules
-- See https://wiki.hyprland.org/Configuring/Window-Rules/ for more

---@module 'hl'

-- LAYER RULES
hl.layer_rule({
    match = { namespace = "rofi" },
    blur = true,
    ignore_alpha = 0,
    animation = "slide",
})

hl.layer_rule({
    match = { namespace = "notifications" },
    blur = true,
    ignore_alpha = 0,
    animation = "slide",
})

hl.layer_rule({
    match = { namespace = "quickshell:overview" },
    blur = true,
    ignore_alpha = 0.5,
})

hl.layer_rule({
    match = { namespace = "quickshell:expose" },
    dim_around = true,
})

hl.layer_rule({
    match = { namespace = "quickshell:expose" },
    blur = true,
    ignore_alpha = 0,
    xray = true,
})

hl.layer_rule({
    match = { namespace = "wallpaper" },
    blur = true,
    ignore_alpha = 0,
})

-- swaync + helper overlays
-- Disabled: causes huge blur on notifications
-- hl.layer_rule({ match = { namespace = "swaync-control-center" }, blur = true, ignore_alpha = 0 })
hl.layer_rule({
    match = { namespace = "swaync-notification-window" },
    blur = true,
    ignore_alpha = 0,
})

hl.layer_rule({
    match = { namespace = "com.aurora.keybinds_help" },
    blur = true,
    ignore_alpha = 0,
})

hl.layer_rule({
    match = { namespace = "logout_dialog" },
    blur = true,
    ignore_alpha = 0,
})
