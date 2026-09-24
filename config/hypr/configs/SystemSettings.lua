---@module 'hl'

-- /* ---- 💫 https://github.com/JaKooLit 💫 ---- */  #
-- Default settings

local scriptsDir = os.getenv("HOME") .. "/.config/hypr/scripts"

hl.config({
    dwindle = {
        preserve_split = true,
        smart_resizing = true,
        use_active_for_splits = true,
        smart_split = false,
        default_split_ratio = 1.0,
        split_bias = 0,
        precise_mouse_move = false,
        special_scale_factor = 0.8,
    },
})

hl.config({
    master = {
        new_status = "slave",   -- fixed: was "master"
        new_on_top = false,
        new_on_active = "none",
        orientation = "left",
        mfact = 0.55,
        slave_count_for_center_master = 2,
        center_master_fallback = "left",
        smart_resizing = true,
        drop_at_cursor = true,
        always_keep_position = false,
    },
})

hl.config({
    scrolling = {
        column_width = 0.80,
        fullscreen_on_one_column = true,
        direction = "right",
        follow_focus = true,
    },
})

hl.config({
    general = {
        resize_on_border = true,
        layout = "dwindle",
    },
})

hl.config({
    input = {
        kb_layout = "it",
        kb_variant = "",
        kb_model = "",
        kb_options = "",
        kb_rules = "",
        repeat_rate = 50,
        repeat_delay = 300,
        sensitivity = 0,
        numlock_by_default = true,
        left_handed = false,
        follow_mouse = 1,
        float_switch_override_focus = false,
        touchpad = {
            disable_while_typing = true,
            natural_scroll = true,
            clickfinger_behavior = false,
            middle_button_emulation = false,
            tap_to_click = true,
            drag_lock = false,
        },
        touchdevice = {
            enabled = true,
        },
        tablet = {
            transform = 0,
            left_handed = 0,
        },
    },
})

hl.config({
    gestures = {
        workspace_swipe_distance = 300,
        workspace_swipe_touch = false,
        workspace_swipe_invert = true,
        workspace_swipe_min_speed_to_force = 30,
        workspace_swipe_cancel_ratio = 0.5,
        workspace_swipe_create_new = true,
        workspace_swipe_direction_lock = true,
        workspace_swipe_forever = false,
        workspace_swipe_use_r = false,
        close_max_timeout = 100,
    },
})

-- Gestures: 3-finger horizontal = workspace switch
hl.gesture({
    fingers   = 3,
    direction = "horizontal",
    action    = "workspace",
})
-- Gestures: 3-finger up/down = zoom in/out (cursor zoom never below 1.0)
local function zoom(mult)
    local factor = math.max(1.0, hl.get_config("cursor.zoom_factor") or 1.0)
    hl.config({ cursor = { zoom_factor = math.max(1.0, factor * mult) } })
end
hl.gesture({
    fingers   = 3,
    direction = "up",
    action    = function() zoom(1.5) end,
})
hl.gesture({
    fingers   = 3,
    direction = "down",
    action    = function() zoom(1 / 1.5) end,
})
-- Gestures: 4-finger up = overview toggle
hl.gesture({
    fingers   = 4,
    direction = "up",
    action    = function()
        hl.exec_cmd(scriptsDir .. "/OverviewToggle.sh")
    end,
})
-- Gestures: 4-finger down = float active window
hl.gesture({
    fingers   = 4,
    direction = "down",
    action    = "float",
})

hl.config({
    misc = {
        disable_hyprland_logo = true,
        disable_splash_rendering = true,
        force_default_wallpaper = false,
        vrr = 0,  -- fixed: was 2 (causes MPV black screen when maximised)
        mouse_move_enables_dpms = true,
        enable_swallow = false,
        swallow_regex = "^(kitty)$",
        focus_on_activate = false,
        initial_workspace_tracking = 0,
        middle_click_paste = false,
        enable_anr_dialog = true,
        anr_missed_pings = 15,
        allow_session_lock_restore = true,
        on_focus_under_fullscreen = 1,
    },
})

hl.config({
    binds = {
        workspace_back_and_forth = true,
        allow_workspace_cycles = true,
        pass_mouse_when_bound = false,
    },
})

-- Could help when scaling and not pixelating
hl.config({
    xwayland = {
        enabled = true,
        force_zero_scaling = true,
    },
})

hl.config({
    render = {
        direct_scanout = 0,
    },
})

hl.config({
    cursor = {
        sync_gsettings_theme = true,
        no_hardware_cursors = 0,  -- fixed: was 1 (disabled hw cursors)
        enable_hyprcursor = true,
        warp_on_change_workspace = 2,
        no_warps = true,
        no_break_fs_vrr = false,
        min_refresh_rate = 24,
        hotspot_padding = 1,
        inactive_timeout = 0,
        default_monitor = "",
        zoom_factor = 1.0,
        zoom_rigid = false,
        zoom_detached_camera = true,
        hide_on_key_press = false,  -- true hides the pointer on every key press (even SUPER) until the mouse moves
        hide_on_touch = false,
        hide_on_tablet = false,
        use_cpu_buffer = false,
    },
})

-- NOTE: debug.vfr was removed in Hyprland >= 0.54.3 — block deleted
