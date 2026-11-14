# Lua-Driven Hyprland Configuration Plan

> The configuration uses exactly four workspaces: 1, 2, 3, and 4.

> Repository source location: All Hyprland config files live in `./hypr/` within this repository.
> Target directory installation/linking is managed separately and excluded from this plan.
> Follow the directory and loading model used by
> `/home/ratul/CodeBase/dots.rhr/tmp/end-4-hyprland-dots/dots/.config/hypr`: Lua is the source of truth,
> `hyprland.lua` is the root entry point in `./hypr/`, modules live under `hyprland/`, user overrides live under `custom/`, Quickshell overrides live under `hyprland/shell-overrides/`, and the runtime library emits Hyprland
> configuration through `hl` helpers.

## Directory Structure

All files reside in `./hypr/` in this repository, structured exactly like `/home/ratul/CodeBase/dots.rhr/tmp/end-4-hyprland-dots/dots/.config/hypr`:

```
hypr/                           # Repository directory: ./hypr/
 ├── hyprland.lua               # Root entry point & load orchestrator
 ├── hypridle.conf              # Idle-management configuration
 ├── hyprlock.conf              # Lock-screen entry point
 ├── custom/                    # User overrides and local customization
 │   ├── env.lua                # Custom environment overrides
 │   ├── execs.lua              # Custom startup commands overrides
 │   ├── general.lua            # Custom general/appearance overrides
 │   ├── keybinds.lua           # Custom keybinding overrides
 │   ├── rules.lua              # Custom window rules overrides
 │   ├── variables.lua          # Custom variables
 │   └── scripts/               # Custom user scripts
 │       └── __restore_video_wallpaper.sh
 ├── hyprland/                  # Core modular configuration
 │   ├── colors.lua             # Theme colors & border palette
 │   ├── env.lua                # Core environment variables
 │   ├── execs.lua              # Core startup applications
 │   ├── general.lua            # Core general layout, appearance, animations & input
 │   ├── keybinds.lua           # Core keybindings
 │   ├── rules.lua              # Core window and workspace rules
 │   ├── variables.lua          # Global variables and constants
 │   ├── lib/                   # Shared Lua library & Hyprland config builder (hl)
 │   │   └── init.lua
 │   ├── services/              # Runtime service configuration & initialization
 │   │   ├── create_custom_config.lua # Ensures template files in custom/ exist
 │   │   └── init.lua
 │   ├── shell-overrides/       # Shell-specific Hyprland overrides (e.g. Quickshell)
 │   │   └── main.lua
 │   └── scripts/               # Helper scripts executed by keybinds/services
 │       ├── fuzzel-emoji.sh
 │       ├── launch_first_available.sh
 │       ├── snip_to_search.sh
 │       ├── start_geoclue_agent.sh
 │       └── ai/
 ├── hyprlock/                  # Hyprlock auxiliary scripts and styling
 │   ├── check-capslock.sh
 │   ├── colors.conf
 │   └── status.sh
 ├── monitors.lua               # Optional display/monitor config (e.g. nwg-displays)
 └── workspaces.lua             # Optional workspace assignment config
```

---

## Lua Configuration Architecture

- [ ] Repository source directory is `./hypr/`.
- [ ] Use the system `lua` interpreter without third-party frameworks.
- [ ] Root entry point is `hypr/hyprland.lua`, matching the reference end-4 structure.
- [ ] Core configuration resides in `hypr/hyprland/`, while optional user customizations reside in `hypr/custom/`.
- [ ] Automatically initialize missing custom template files via `hypr/hyprland/services/create_custom_config.lua`.
- [ ] Represent repeated settings, keybinds, rules, and commands as Lua tables.
- [ ] Use the shared helpers in `hypr/hyprland/lib/init.lua` for emitting and validating Hyprland settings via the `hl` DSL.
- [ ] Fail loudly if Lua loading or configuration generation fails.
- [ ] Load `hyprland.shell-overrides.main` last for shell-specific behavior (e.g., Quickshell layer rules and bar suppression).

### Lua Loading Workflow (`hypr/hyprland.lua`)

1. Load `hyprland.lib` (initializes `hl` builder, helpers, globals like `HOME`, `is_file_exists`).
2. Load `hyprland.services` (ensures `custom/` files exist via `create_custom_config`).
3. Load core environment `hyprland.env`, followed by `custom.env` if present.
4. Load core modules:
   - `hyprland.execs`
   - `hyprland.general`
   - `hyprland.rules`
   - `hyprland.colors`
   - `hyprland.keybinds`
5. Load custom overrides if present:
   - `custom.execs`
   - `custom.general`
   - `custom.rules`
   - `custom.keybinds`
6. Load display & workspace configurations if present (`workspaces.lua`, `monitors.lua`).
7. Load shell overrides (`hyprland.shell-overrides.main`).

---

## Configuration Requirements

### 1. Core Settings (`hyprland/hyprland.lua`, `hyprland/general.lua`)

- [ ] Set `MODKEY = SUPER`
- [ ] Load all Lua modules in the correct order
- [ ] Enable tiling state persistence
- [ ] Set default window behavior to non-tiled (floating)
- [ ] Emit a valid Hyprland entry point

### 2. Keybindings (`hyprland/keybinds.lua`)

#### Required Keybinds

NOTE: Key binding names like SUPER, RETURN, PRINTSCREEN are for reference only. These are not the absolute names that hyprland expects. Read docs before proceeding.

| Key                       | Action                              | Notes                                 |
| ------------------------- | ----------------------------------- | ------------------------------------- |
| `SUPER + RETURN`          | Open kitty terminal                 | Primary terminal                      |
| `SUPER + T`               | Toggle tiling mode                  | Persists state across reboots         |
| `SUPER + TAB`             | Cycle applications (all workspaces) | GNOME-like app switching              |
| `ALT + TAB`               | Cycle windows (all workspaces)      | GNOME-like window switching           |
| `SUPER + E`               | Open file manager                   | thunar                                |
| `SUPER + 1-4`             | Switch to workspace 1-4             | Basic workspace navigation            |
| `SUPER + SHIFT + 1-4`     | Move window to workspace 1-4        | Window management                     |
| `SUPER + L` / `SUPER + H` | Focus workspace right/left          | Workspace navigation                  |
| `PRINTSCREEN`             | Screenshot selection area           | Interactive region select → clipboard |
| `SHIFT + PRINTSCREEN`     | Screenshot full screen              | Entire display → clipboard            |
| `ALT + PRINTSCREEN`       | Screenshot active window            | Focused window only → clipboard       |

#### Suggested Additional Keybinds

| Key                 | Action              | Notes                       |
| ------------------- | ------------------- | --------------------------- |
| `SUPER + Q`         | Kill focused window | Quick close                 |
| `SUPER + F`         | Fullscreen toggle   | Window fullscreen           |
| `SUPER + SPACE`     | Toggle floating     | Quick float/tile            |
| `SUPER + SHIFT + Q` | Force kill window   | Emergency close             |
| `SUPER + V`         | Clipboard history   | cliphist with image support |

> **Note**: Application launcher (`SUPER+D`), Exit menu (`SUPER+ESC`), Notifications, System tray (network, bluetooth, polkit) — all handled by **QuickShell** (to be implemented later).

### 3. Visual Theme (`hyprland/general.lua`, `hyprland/colors.lua`)

- [ ] **Gaps**: 2-4px (only in tiling mode)
- [ ] **Border width**: 1-2px
- [ ] **Border colors**: Active/inactive distinction
- [ ] **Rounding**: 8-12px radius
- [ ] **Shadows**: Disabled (none)
- [ ] **Blur**: Optional for panels/backgrounds

### 4. Window Rules (`hyprland/rules.lua`)

- [ ] Default: all windows floating (non-tiled)
- [ ] Tiling toggle: `SUPER + T` enables tiling for current/future windows
- [ ] Persist tiling state across restarts (requires `hyprctl` state saving)
- [ ] Specific app rules as needed (dialogs always float, etc.)

### 5. Animations (`hyprland/general.lua`)

- [ ] **Currently**: Empty/disabled (user preference)
- [ ] **Future**: Can add bezier curves for open/close/move/resize

### 6. Environment (`hyprland/env.lua`)

- [ ] XDG environment variables
- [ ] Wayland-specific variables
- [ ] Qt/GTK theme integration
- [ ] Cursor theme
- [ ] Electron/Chrome flags for Wayland

### 7. Input Configuration (`hyprland/general.lua`)

- [ ] Touchpad: natural scroll, tap-to-click, disable while typing
- [ ] Mouse: sensitivity, acceleration profile
- [ ] Keyboard: repeat rate, delay

### 8. Monitor & Workspace Configuration (`monitors.lua`, `workspaces.lua`)

- [ ] Auto-detect or manual configuration
- [ ] Resolution, refresh rate, position, scale
- [ ] Workspace-to-monitor assignment

### 9. Startup Applications (`hyprland/execs.lua`)

- [ ] `hypridle` (idle management)
- [ ] `hyprlock` (lock screen)
- [ ] Wallpaper daemon (`swww`)
- [ ] **NO quickshell autostart** (will be added later)
- [ ] **NO nm-applet, blueman-applet, polkit-kde-agent** (QuickShell handles tray)
- [ ] **NO dunst** (QuickShell handles notifications)

### 10. Layer Rules & Shell Overrides (`hyprland/shell-overrides/main.lua`)

- [ ] Configure for Quickshell panels
- [ ] Blur, ignore mouse input settings

### 11. Miscellaneous (`hyprland/general.lua`, `hyprland/variables.lua`)

- [ ] Focus behavior (follow mouse, etc.)
- [ ] Cursor settings
- [ ] New window behavior
- [ ] XWayland compatibility

---

## Implementation Phases

### Phase 1: Lua Entry Point and Core Structure in `./hypr/` (Required)

- [ ] Create the `./hypr/` tree: `hyprland/`, `custom/`, `hyprlock/`, and `hyprland/scripts/` directories
- [ ] Implement `hypr/hyprland/lib/init.lua` helpers and the `hl` configuration API
- [ ] Implement `hypr/hyprland.lua` (root entry point) with end-4 reference loading order
- [ ] Implement `hypr/hyprland/services/create_custom_config.lua` and `hypr/hyprland/services/init.lua`
- [ ] Implement `hypr/hyprland/keybinds.lua` (all required keybinds)
- [ ] Implement `hypr/hyprland/rules.lua` (tiling + floating defaults)
- [ ] Implement `hypr/hyprland/general.lua` and `hypr/hyprland/colors.lua`
- [ ] Implement tiling persistence through `hypr/hyprland/scripts/`
- [ ] Populate dependency package installation in `install.sh`

### Phase 2: Environment & Input (Required)

- [ ] `hypr/hyprland/env.lua`
- [ ] Input settings in `hypr/hyprland/general.lua`
- [ ] `hypr/monitors.lua` and `hypr/workspaces.lua`

### Phase 3: Polish & Extras (Optional)

- [ ] `hypr/hyprland/execs.lua`
- [ ] `hypr/hyprland/shell-overrides/main.lua`
- [ ] `hypr/hyprland/services/`
- [ ] `hypr/hypridle.conf`, `hypr/hyprlock.conf`, and `hypr/hyprlock/` support files

---

## Technical Notes

### Tiling State Persistence

- Hyprland doesn't natively persist tiling state across reboots
- **Solution**: Use Lua scripts to invoke `hyprctl keyword` commands in startup/shutdown hooks
- Save state to state file on exit
- Restore on startup via the generated `exec-once` command

### Lua Runtime and Loading

- **Use the system `lua` interpreter**; do not add a Lua framework or runtime dependency.
- Configuration lives in the repository at `./hypr/`.
- Validate every Lua file with `lua -e "assert(loadfile(...))"` before activation.
- Changes to Lua modules take effect when the entry point is reloaded; no generated
  configuration tree is supported.

### Screenshot Tool

- **Use `hyprshot` only** (replaces `grim + slurp`)
- `hyprshot` provides: region, window, output, active modes
- **Auto-copy to clipboard** after capture (via `wl-copy`)
- Install: `hyprshot` package

### Clipboard History

- **Use `cliphist`** with `wl-clipboard`
- Supports **images** (not just text)
- `SUPER + V` opens cliphist menu with image previews
- Store: `wl-copy < image.png` for screenshots

### File Manager

- **Use `thunar`** (lightweight, GTK3, minimal deps)
- Single file manager only
- Bind to `SUPER + E`

### Terminal

- **Use `kitty`** (GPU-accelerated, lightweight)
- Single terminal only

### QuickShell (Future UI Layer)

QuickShell will handle:

- **Application launcher**
- **Exit/Session menu**
- **Notifications**
- **System tray** (network, bluetooth, polkit)
- **Status bar / panels**
- **Widgets** (clock, battery, workspace indicator, etc.)

> Keep Hyprland config minimal — delegate UI to QuickShell.

### Lock/Idle

- **Use `hyprlock`** + **`hypridle`** (native Hyprland, minimal)

### Wallpaper

- **Use `swww`** (daemon-based, transitions, lightweight)

### Utils

- `jq` (JSON parsing for scripts)
- `wl-clipboard` (clipboard utilities)

---

## Dependencies to Install (Minimal Set)

NOTE: Do NOT install any dependency. Rather, write install instructions in `install.sh` script following the instructions in the `install.sh` file. Use `paru -Syu --needed` for installation.

```
# Core Hyprland and Lua configuration
hyprland
lua
hyprland-protocols
hyprcursor
hyprgraphics
hyprutils
hyprwayland-scanner
xcb-proto
xcb-util
xcb-util-wm

# Screenshot (single tool)
hyprshot

# Clipboard (images + text)
wl-clipboard
cliphist

# Terminal
kitty

# File Manager (single tool, lightweight)
thunar

# Status Bar / Shell (will implement UI)
quickshell

# Lock/Idle (native)
hyprlock
hypridle

# Wallpaper
swww

# Utils
jq
```

---

## Testing Checklist

After implementation, verify:

- [ ] `SUPER + RETURN` opens kitty
- [ ] `SUPER + T` toggles tiling (visual confirmation)
- [ ] Tiling state persists after `hyprctl reload` and reboot
- [ ] `ALT + TAB` cycles windows across all workspaces
- [ ] `SUPER + TAB` cycles applications across all workspaces
- [ ] `SUPER + 1-4` switches workspaces 1-4
- [ ] `SUPER + SHIFT + 1-4` moves windows to workspaces 1-4
- [ ] `SUPER + L/H` navigates workspaces left/right
- [ ] `PRINTSCREEN` opens region selector → copies to clipboard
- [ ] `SHIFT + PRINTSCREEN` captures full screen → copies to clipboard
- [ ] `ALT + PRINTSCREEN` captures active window → copies to clipboard
- [ ] `SUPER + V` opens cliphist with **image previews**
- [ ] `SUPER + E` opens thunar
- [ ] `SUPER + Q` kills focused window
- [ ] `SUPER + F` toggles fullscreen
- [ ] `SUPER + SPACE` toggles floating
- [ ] `SUPER + SHIFT + Q` force kills window
- [ ] Gaps appear only in tiling mode (2-4px)
- [ ] No shadows on windows
- [ ] No animations (instant transitions)
- [ ] Every Lua module passes `lua -e "assert(loadfile(...))"`
- [ ] `hyprland.lua` loads every required module without errors
- [ ] The loaded configuration passes Hyprland validation/reload
- [ ] `hyprctl` commands work for all keybinds

---

## Notes for Future Customization

1. **User Overrides**: Add customizations to `custom/*.lua` (e.g. `custom/keybinds.lua`, `custom/execs.lua`) so updates to core `hyprland/` remain clean.
2. **Custom Scripts**: Place in `custom/scripts/` or `hyprland/scripts/` directory.
3. **Color Generation**: Use `matugen` templates in `matugen/hyprland/`.
4. **Quickshell Integration**: See `hyprland/shell-overrides/main.lua` for panel-specific configs.
5. **Display & Workspace Configuration**: Keep personal or tool-generated monitor layouts in `monitors.lua` and `workspaces.lua` (compatible with nwg-displays).
6. **Quickshell UI**: Implement panels, bar, launcher, widgets, notifications, system tray, session menu in QuickShell later.

---
