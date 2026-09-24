---@module 'hl'

-- /* ---- 💫 https://github.com/JaKooLit 💫 ---- */  #

-- Default Keybinds
-- visit https://wiki.hypr.land/Configuring/Basics/Binds/ for more info
-- Dispatcher reference: https://wiki.hypr.land/Configuring/Basics/Dispatchers/
--
-- NOTE: in the Lua config, shell variables like "$term" are NOT expanded by Hyprland.
-- Default apps come from UserConfigs/01-UserDefaults.lua instead.
-- Descriptions are shown by SUPER SHIFT K (scripts/KeyBinds.sh reads `hyprctl binds -j`).

local defaults    = require("UserConfigs.01-UserDefaults")

local mainMod     = "SUPER"
local scriptsDir  = os.getenv("HOME") .. "/.config/hypr/scripts"
local UserScripts = os.getenv("HOME") .. "/.config/hypr/UserScripts"

local term        = defaults.term
local files       = defaults.files

-- bind(keys, description, dispatcher, opts?)
local function bind(keys, desc, dispatcher, opts)
    opts = opts or {}
    opts.description = desc
    return hl.bind(keys, dispatcher, opts)
end

local function exec(cmd) return hl.dsp.exec_cmd(cmd) end
local function script(name) return exec(scriptsDir .. "/" .. name) end
local function userscript(name) return exec(UserScripts .. "/" .. name) end

-- Run a different dispatcher depending on the active workspace's layout
-- (https://wiki.hypr.land/Configuring/Basics/Code-snippets/#per-layout-binds)
local function layout_bind(bind_table)
    return function()
        local workspace = hl.get_active_special_workspace() or hl.get_active_workspace()
        if not workspace then return end
        local dispatcher = bind_table[workspace.tiled_layout] or bind_table.default
        if dispatcher then hl.dispatch(dispatcher) end
    end
end

-- Multiply the cursor zoom factor, never going below 1.0
local function zoom(mult)
    return function()
        local factor = hl.get_config("cursor.zoom_factor") or 1.0
        if factor < 1.0 then factor = 1.0 end
        hl.config({ cursor = { zoom_factor = math.max(1.0, factor * mult) } })
    end
end

--### STANDARD ####

-- Common shortcuts
bind(mainMod .. " + D", "app launcher", exec("pkill rofi || true && rofi -show drun -modi drun"))
bind(mainMod .. " + B", "default browser", exec("xdg-open \"https://\""))
-- toggles quickshell or ags overview (tries QS first, falls back to AGS)
bind(mainMod .. " + A", "desktop overview", script("OverviewToggle.sh"))
bind(mainMod .. " + Return", "open terminal", exec(term))
bind(mainMod .. " + E", "file manager", exec(files))

-- FEATURES / EXTRAS
bind(mainMod .. " + T", "global theme switcher", script("ThemeChanger.sh"))
bind(mainMod .. " + H", "help / cheat sheet", script("KeyHints.sh"))
bind(mainMod .. " + ALT + R", "refresh bar, menus and notifications", script("Refresh.sh"))
bind(mainMod .. " + ALT + E", "rofi emoticons", script("RofiEmoji.sh"))
bind(mainMod .. " + S", "web search", script("RofiSearch.sh"))
bind(mainMod .. " + CTRL + S", "window switcher", exec("rofi -show window"))
bind(mainMod .. " + ALT + O", "toggle blur settings", script("ChangeBlur.sh"))
bind(mainMod .. " + SHIFT + G", "toggle game mode", script("GameMode.sh"))
bind(mainMod .. " + ALT + L", "toggle dwindle / master layout", script("ChangeLayout.sh"))
bind(mainMod .. " + ALT + V", "clipboard manager", script("ClipManager.sh"))
bind(mainMod .. " + CTRL + R", "rofi theme selector", script("RofiThemeSelector.sh"))
bind(mainMod .. " + CTRL + SHIFT + R", "rofi theme selector (modified)",
    exec("pkill rofi || true && " .. scriptsDir .. "/RofiThemeSelector-modified.sh"))

bind(mainMod .. " + SHIFT + F", "fullscreen", hl.dsp.window.fullscreen({ mode = "fullscreen" }))
bind(mainMod .. " + CTRL + F", "maximize window", hl.dsp.window.fullscreen({ mode = "maximized" }))
bind(mainMod .. " + SPACE", "toggle float", hl.dsp.window.float({ action = "toggle" }))

-- Float all windows on the current workspace (replaces the removed `workspaceopt allfloat`):
-- if any tiled window is left, float them all; otherwise tile them all back.
bind(mainMod .. " + ALT + SPACE", "toggle float for all windows on workspace", function()
    local ws = hl.get_active_workspace()
    if not ws then return end
    local windows = hl.get_workspace_windows(ws)
    local anyTiled = false
    for _, w in ipairs(windows) do
        if not w.floating then anyTiled = true break end
    end
    for _, w in ipairs(windows) do
        hl.dispatch(hl.dsp.window.float({ window = w, action = anyTiled and "enable" or "disable" }))
    end
end)

bind(mainMod .. " + SHIFT + Return", "dropdown terminal", exec(scriptsDir .. "/Dropterminal.sh " .. term))

-- Desktop zooming or magnifier
bind(mainMod .. " + ALT + mouse_down", "zoom in", zoom(2.0))
bind(mainMod .. " + ALT + mouse_up", "zoom out", zoom(0.5))

-- Waybar / Bar related
bind(mainMod .. " + CTRL + ALT + B", "toggle waybar", exec("pkill -SIGUSR1 waybar"))
bind(mainMod .. " + CTRL + B", "waybar styles", script("WaybarStyles.sh"))
bind(mainMod .. " + ALT + B", "waybar layout", script("WaybarLayout.sh"))

-- Night light toggle (Hyprsunset)
bind(mainMod .. " + N", "toggle night light", exec(scriptsDir .. "/Hyprsunset.sh toggle"))

-- FEATURES / EXTRAS (UserScripts)
bind(mainMod .. " + SHIFT + M", "online music", userscript("RofiBeats.sh"))
bind(mainMod .. " + W", "select wallpaper", userscript("WallpaperSelect.sh"))
bind(mainMod .. " + SHIFT + W", "wallpaper effects", userscript("WallpaperEffects.sh"))
bind("CTRL + ALT + W", "random wallpaper", userscript("WallpaperRandom.sh"))
bind(mainMod .. " + CTRL + O", "toggle active window opacity", hl.dsp.window.set_prop({ prop = "opaque", value = "toggle" }))
bind(mainMod .. " + SHIFT + K", "search keybinds", script("KeyBinds.sh"))
bind(mainMod .. " + SHIFT + A", "animations menu", script("Animations.sh"))
bind(mainMod .. " + SHIFT + O", "change oh-my-zsh theme", userscript("ZshChangeTheme.sh"))
bind("ALT_L + SHIFT_L", "switch keyboard layout globally",
    exec(scriptsDir .. "/KeyboardLayout.sh switch"), { locked = true, non_consuming = true })
bind("SHIFT_L + ALT_L", "switch keyboard layout per-window",
    script("Tak0-Per-Window-Switch.sh"), { locked = true, non_consuming = true })
bind(mainMod .. " + ALT + C", "calculator", userscript("RofiCalc.sh"))

-- Move current workspace to monitor (left right up or down)
bind(mainMod .. " + CTRL + F9", "move workspace to left monitor", hl.dsp.workspace.move({ monitor = "l" }))
bind(mainMod .. " + CTRL + F10", "move workspace to right monitor", hl.dsp.workspace.move({ monitor = "r" }))
bind(mainMod .. " + CTRL + F11", "move workspace to upper monitor", hl.dsp.workspace.move({ monitor = "u" }))
bind(mainMod .. " + CTRL + F12", "move workspace to lower monitor", hl.dsp.workspace.move({ monitor = "d" }))

--### SYSTEM ####

bind("CTRL + ALT + Delete", "exit Hyprland",
    exec("command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch 'hl.dsp.exit()'"))
bind(mainMod .. " + Q", "close active window", hl.dsp.window.close())
bind(mainMod .. " + SHIFT + Q", "kill active window process", script("KillActiveProcess.sh"))
bind("CTRL + ALT + L", "lock screen", script("LockScreen.sh"))
bind("CTRL + ALT + P", "power menu", script("Wlogout.sh"))
bind(mainMod .. " + SHIFT + N", "notification panel", exec("swaync-client -t -sw"))
bind(mainMod .. " + SHIFT + E", "KooL quick settings", script("Kool_Quick_Settings.sh"))

--### LAYOUTS ####

-- Master Layout
bind(mainMod .. " + CTRL + D", "remove master", hl.dsp.layout("removemaster"))
bind(mainMod .. " + I", "add master", hl.dsp.layout("addmaster"))
bind(mainMod .. " + CTRL + Return", "swap with master", hl.dsp.layout("swapwithmaster"))

-- Dwindle Layout
bind(mainMod .. " + SHIFT + I", "rotate split", hl.dsp.layout("rotatesplit"))
bind(mainMod .. " + O", "toggle split (dwindle)", hl.dsp.layout("togglesplit"))
bind(mainMod .. " + P", "toggle pseudo-tiling", hl.dsp.window.pseudo())
bind(mainMod .. " + M", "set split ratio 0.3", hl.dsp.layout("splitratio 0.3"))

-- Cycle windows: master uses its own ordering, every other layout cycles globally
-- (replaces the runtime `hyprctl keyword bind` done by ChangeLayout.sh / KeybindsLayoutInit.sh)
bind(mainMod .. " + J", "cycle next window", layout_bind({
    master  = hl.dsp.layout("cyclenext"),
    default = hl.dsp.window.cycle_next(),
}))
bind(mainMod .. " + K", "cycle previous window", layout_bind({
    master  = hl.dsp.layout("cycleprev"),
    default = hl.dsp.window.cycle_next({ next = false }),
}))

-- Cycle windows; if floating bring to top
bind("ALT + Tab", "cycle next window and bring to top", function()
    hl.dispatch(hl.dsp.window.cycle_next())
    hl.dispatch(hl.dsp.window.bring_to_top())
end)

--### SPECIAL KEYS / HOT KEYS ####

local volume = scriptsDir .. "/Volume.sh"
bind("XF86AudioRaiseVolume", "volume up", exec(volume .. " --inc"), { repeating = true, locked = true })
bind("XF86AudioLowerVolume", "volume down", exec(volume .. " --dec"), { repeating = true, locked = true })
bind("ALT + XF86AudioRaiseVolume", "volume up (precise)", exec(volume .. " --inc-precise"), { repeating = true, locked = true })
bind("ALT + XF86AudioLowerVolume", "volume down (precise)", exec(volume .. " --dec-precise"), { repeating = true, locked = true })
bind("XF86AudioMicMute", "toggle mic mute", exec(volume .. " --toggle-mic"), { locked = true })
bind("XF86AudioMute", "toggle mute", exec(volume .. " --toggle"), { locked = true })
bind("XF86Sleep", "sleep", exec("systemctl suspend"), { locked = true })
bind("XF86RFKill", "airplane mode", script("AirplaneMode.sh"), { locked = true })

-- media controls using keyboards
local media = scriptsDir .. "/MediaCtrl.sh"
bind("XF86AudioPlay", "play/pause", exec(media .. " --pause"), { locked = true })
bind("XF86AudioPause", "pause", exec(media .. " --pause"), { locked = true })
bind("XF86AudioNext", "next track", exec(media .. " --nxt"), { locked = true })
bind("XF86AudioPrev", "previous track", exec(media .. " --prv"), { locked = true })
bind("XF86AudioStop", "stop", exec(media .. " --stop"), { locked = true })

-- Screenshot keybindings NOTE: You may need to press Fn key as well
local shot = scriptsDir .. "/ScreenShot.sh"
bind(mainMod .. " + Print", "screenshot now", exec(shot .. " --now"))
bind(mainMod .. " + SHIFT + Print", "screenshot area", exec(shot .. " --area"))
bind(mainMod .. " + CTRL + Print", "screenshot in 5s", exec(shot .. " --in5"))
bind(mainMod .. " + CTRL + SHIFT + Print", "screenshot in 10s", exec(shot .. " --in10"))
bind("ALT + Print", "screenshot active window", exec(shot .. " --active"))
-- screenshot with swappy (another screenshot tool)
bind(mainMod .. " + SHIFT + S", "screenshot area (swappy)", exec(shot .. " --swappy"))

--### WINDOWS ####

-- Resize windows
bind(mainMod .. " + SHIFT + left", "resize left", hl.dsp.window.resize({ x = -50, y = 0, relative = true }), { repeating = true })
bind(mainMod .. " + SHIFT + right", "resize right", hl.dsp.window.resize({ x = 50, y = 0, relative = true }), { repeating = true })
bind(mainMod .. " + SHIFT + up", "resize up", hl.dsp.window.resize({ x = 0, y = -50, relative = true }), { repeating = true })
bind(mainMod .. " + SHIFT + down", "resize down", hl.dsp.window.resize({ x = 0, y = 50, relative = true }), { repeating = true })

-- Move windows
bind(mainMod .. " + CTRL + left", "move window left", hl.dsp.window.move({ direction = "left" }))
bind(mainMod .. " + CTRL + right", "move window right", hl.dsp.window.move({ direction = "right" }))
bind(mainMod .. " + CTRL + up", "move window up", hl.dsp.window.move({ direction = "up" }))
bind(mainMod .. " + CTRL + down", "move window down", hl.dsp.window.move({ direction = "down" }))

-- Swap windows
bind(mainMod .. " + ALT + left", "swap window left", hl.dsp.window.swap({ direction = "left" }))
bind(mainMod .. " + ALT + right", "swap window right", hl.dsp.window.swap({ direction = "right" }))
bind(mainMod .. " + ALT + up", "swap window up", hl.dsp.window.swap({ direction = "up" }))
bind(mainMod .. " + ALT + down", "swap window down", hl.dsp.window.swap({ direction = "down" }))

-- Move focus with mainMod + arrow keys
bind(mainMod .. " + left", "focus left", hl.dsp.focus({ direction = "left" }))
bind(mainMod .. " + right", "focus right", hl.dsp.focus({ direction = "right" }))
bind(mainMod .. " + up", "focus up", hl.dsp.focus({ direction = "up" }))
bind(mainMod .. " + down", "focus down", hl.dsp.focus({ direction = "down" }))

-- Groups
bind(mainMod .. " + G", "toggle group", hl.dsp.group.toggle())
bind(mainMod .. " + CTRL + Tab", "previous window in group", hl.dsp.group.prev())
bind(mainMod .. " + CTRL + K", "move window left into group", hl.dsp.window.move({ into_group = "left" }))
bind(mainMod .. " + CTRL + L", "move window right into group", hl.dsp.window.move({ into_group = "right" }))
bind(mainMod .. " + CTRL + H", "move window out of group", hl.dsp.window.move({ out_of_group = true }))

-- SUPER + Tab / SUPER + SHIFT + Tab: cycle inside the active group if there is one,
-- otherwise go to the next/previous workspace on this monitor.
-- (The .conf version bound both actions to the same key, so both fired at once.)
local function group_or_workspace(forward)
    return function()
        local w = hl.get_active_window()
        if w and w.group and w.group.size > 1 then
            hl.dispatch(forward and hl.dsp.group.next() or hl.dsp.group.prev())
        else
            hl.dispatch(hl.dsp.focus({ workspace = forward and "m+1" or "m-1" }))
        end
    end
end
bind(mainMod .. " + Tab", "next window in group / next workspace", group_or_workspace(true))
bind(mainMod .. " + SHIFT + Tab", "previous window in group / previous workspace", group_or_workspace(false))

--### WORKSPACES ####

-- Special workspace
bind(mainMod .. " + SHIFT + U", "move window to special workspace", hl.dsp.window.move({ workspace = "special" }))
bind(mainMod .. " + U", "toggle special workspace", hl.dsp.workspace.toggle_special())

-- Number row: 1..9 and 0 for workspace 10. Keysyms are used because `code:NN` keys are not
-- parsed by the Lua config in Hyprland 0.56 (the bind ends up with keycode 0 and never fires).
for i = 1, 10 do
    local key = tostring(i % 10)
    bind(mainMod .. " + " .. key, "switch to workspace " .. i, hl.dsp.focus({ workspace = i }))
    bind(mainMod .. " + SHIFT + " .. key, "move window to workspace " .. i, hl.dsp.window.move({ workspace = i }))
    bind(mainMod .. " + CTRL + " .. key, "move window silently to workspace " .. i,
        hl.dsp.window.move({ workspace = i, follow = false }))
end

bind(mainMod .. " + SHIFT + bracketleft", "move window to previous workspace", hl.dsp.window.move({ workspace = "-1" }))
bind(mainMod .. " + SHIFT + bracketright", "move window to next workspace", hl.dsp.window.move({ workspace = "+1" }))
bind(mainMod .. " + CTRL + bracketleft", "move window silently to previous workspace",
    hl.dsp.window.move({ workspace = "-1", follow = false }))
bind(mainMod .. " + CTRL + bracketright", "move window silently to next workspace",
    hl.dsp.window.move({ workspace = "+1", follow = false }))

-- Scroll through existing workspaces with mainMod + scroll
bind(mainMod .. " + mouse_down", "next workspace", hl.dsp.focus({ workspace = "e+1" }))
bind(mainMod .. " + mouse_up", "previous workspace", hl.dsp.focus({ workspace = "e-1" }))
bind(mainMod .. " + period", "next workspace", hl.dsp.focus({ workspace = "e+1" }))
bind(mainMod .. " + comma", "previous workspace", hl.dsp.focus({ workspace = "e-1" }))

-- Move/resize windows with mainMod + LMB/RMB and dragging
bind(mainMod .. " + mouse:272", "move window", hl.dsp.window.drag(), { mouse = true })     -- left click
bind(mainMod .. " + mouse:273", "resize window", hl.dsp.window.resize(), { mouse = true }) -- right click
