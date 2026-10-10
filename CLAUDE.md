# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this repo is

Personal fork of [JaKooLit/Hyprland-Dots](https://github.com/JaKooLit/Hyprland-Dots): dotfiles for Hyprland, extended with a **niri** setup that reuses the Hyprland scripts and theming. Everything under `config/` mirrors `~/.config/`. There is no build step.

## Applying changes

The installed configs in `~/.config/` are plain copies, not symlinks. After editing a file under `config/`, copy it to the matching path in `~/.config/` for it to take effect, e.g.:

```bash
cp config/hypr/UserScripts/WallpaperSelect.sh ~/.config/hypr/UserScripts/
cp config/niri/config.kdl ~/.config/niri/
```

- `copy.sh` is the full interactive installer (backs up and replaces whole directories). Don't run it to deploy a single change. Note that it doesn't include `niri`.
- `niri validate` checks `~/.config/niri/config.kdl`. niri reloads its config automatically on save.
- Hyprland reloads its Lua config on save. `hyprctl reload` forces a reload.

## Architecture

- **Hyprland** (`config/hypr/`): the entry point is `hyprland.lua`, using the Lua config format for Hyprland 0.55+. Legacy `.conf` files were removed. It `require`s defaults from `configs/` followed by user overrides from `UserConfigs/` with the same names. Edit `UserConfigs/` for personal changes and `configs/` only to change defaults.
- **niri** (`config/niri/config.kdl`): one KDL file. Its keybinds `spawn-sh` the shared scripts in `~/.config/hypr/scripts/` and `~/.config/hypr/UserScripts/`. niri-specific helpers are `scripts/Niri*.py`.
- **Shared scripts**: many of them came from upstream and assume Hyprland (`hyprctl`). When a script is used from niri, branch on `$NIRI_SOCKET` and use `niri msg -j ...` instead. For examples, see `Logout.sh` and `UserScripts/WallpaperSelect.sh`.
- **Theming via wallust**: `config/wallust/wallust.toml` generates color files from the current wallpaper for hypr, niri, rofi, waybar, kitty, ghostty and quickshell. Templates live in `config/wallust/templates/`. niri pulls in `~/.config/niri/wallust-colors.kdl` through `include optional=true`. The flow is: wallpaper set with `awww` → `scripts/WallustSwww.sh` → `scripts/Refresh.sh`.
- **Waybar**: configs and styles are under `config/waybar/configs/` and `config/waybar/style/`. Per-monitor niri workspaces come from `scripts/NiriWorkspaces.py`.
- `hyprconf2lua/` is a vendored Python tool that converts hyprlang `.conf` to Lua. Run its tests with `cd hyprconf2lua && python -m pytest tests/`, or a single test with `python -m pytest tests/test_converter.py -k <name>`.

## Commits

Use the conventional-style prefixes from `COMMIT_MESSAGE_GUIDELINES.md`, with a scope when it helps, e.g. `feat(niri): ...`, `fix(waybar): ...`. Use the imperative mood and keep lines to 72 characters or fewer.
