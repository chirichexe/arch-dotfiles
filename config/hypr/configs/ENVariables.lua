---@module 'hl'

-- /* ---- 💫 https://github.com/JaKooLit 💫 ---- */  #
-- Environment variables. See https://wiki.hyprland.org/Configuring/Environment-variables/

-- Current Version of JakooLit Dotfiles:
hl.env("DOTS_VERSION", "2.3.20")

-- Toolkit Backend Variables
hl.env("GDK_BACKEND", "wayland,x11,*")
hl.env("QT_QPA_PLATFORM", "wayland;xcb")
hl.env("CLUTTER_BACKEND", "wayland")

-- Run SDL2 applications on Wayland.
-- hl.env("SDL_VIDEODRIVER", "wayland")

-- XDG Specifications
hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
hl.env("XDG_SESSION_DESKTOP", "Hyprland")
hl.env("XDG_SESSION_TYPE", "wayland")

-- QT Variables
hl.env("QT_AUTO_SCREEN_SCALE_FACTOR", 1)
hl.env("QT_WAYLAND_DISABLE_WINDOWDECORATION", 1)
hl.env("QT_QPA_PLATFORMTHEME", "qt6ct")  -- fixed: was duplicate qt5ct + qt6ct
hl.env("QT_STYLE_OVERRIDE", "Fusion")    -- added

-- hyprland-qt-support (safe default; switch to org.hyprland.style if installed)
hl.env("QT_QUICK_CONTROLS_STYLE", "Basic")  -- fixed: was org.hyprland.style (crashes if not installed)

-- xwayland apps scale fix
hl.env("GDK_SCALE", 1)
hl.env("QT_SCALE_FACTOR", 1)

-- Cursor (both hyprcursor and xcursor)
hl.env("HYPRCURSOR_THEME", "Bibata-Modern-Ice")
hl.env("HYPRCURSOR_SIZE", 24)
hl.env("XCURSOR_THEME", "Bibata-Modern-Ice")  -- added: needed for X11 cursor
hl.env("XCURSOR_SIZE", 24)                     -- added

-- Firefox
hl.env("MOZ_ENABLE_WAYLAND", 1)

-- Electron >28 apps
hl.env("ELECTRON_OZONE_PLATFORM_HINT", "auto")

-- NVIDIA (active by default; disable if no NVIDIA GPU)
hl.env("LIBVA_DRIVER_NAME", "nvidia")
hl.env("__GLX_VENDOR_LIBRARY_NAME", "nvidia")
hl.env("NVD_BACKEND", "direct")
hl.env("GSK_RENDERER", "ngl")

-- Additional NVIDIA envs (activate with care):
-- hl.env("GBM_BACKEND", "nvidia-drm")
-- hl.env("__GL_GSYNC_ALLOWED", 1)
-- hl.env("__NV_PRIME_RENDER_OFFLOAD", 1)
-- hl.env("__VK_LAYER_NV_optimus", "NVIDIA_only")
-- hl.env("WLR_DRM_NO_ATOMIC", 1)

-- VM / software rendering
-- hl.env("LIBGL_ALWAYS_SOFTWARE", 1)  -- Warning: may cause Hyprland to crash
-- hl.env("WLR_RENDERER_ALLOW_SOFTWARE", 1)

-- Aquamarine Environment Variables (Hyprland > 0.45)
-- hl.env("AQ_TRACE", 1)
-- hl.env("AQ_DRM_DEVICES", "/dev/dri/card1:/dev/dri/card0")
-- hl.env("AQ_MGPU_NO_EXPLICIT", 1)
-- hl.env("AQ_NO_MODIFIERS", 1)

-- Hyprland Environment Variables
-- hl.env("HYPRLAND_TRACE", 1)
-- hl.env("HYPRLAND_NO_RT", 1)
-- hl.env("HYPRLAND_NO_SD_NOTIFY", 1)
-- hl.env("HYPRLAND_NO_SD_VARS", 1)
