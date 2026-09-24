---@module 'hl'
-- Default monitor profile (applied by scripts/MonitorProfiles.sh -> copied to ~/.config/hypr/monitors.lua)
-- Catch-all rule for any monitor at its highest resolution.
hl.monitor({
    output   = "",
    mode     = "highres",
    position = "auto",
    scale    = 1,
})
