require("hyprland.lib")
require("hyprland.variables")

if is_file_exists(HOME .. "/.config/hypr/custom/variables.lua") then
    require("custom.variables")
end

local scriptsDir = "$HOME/.config/hypr/hyprland/scripts"

-- Terminal (SUPER + RETURN)
hl.bind("SUPER + RETURN", hl.dsp.exec_cmd(terminal), { description = "Launch terminal (kitty)" })

-- File Manager (SUPER + E)
hl.bind("SUPER + E", hl.dsp.exec_cmd(fileManager), { description = "Launch file manager (thunar)" })

-- Window actions
hl.bind("SUPER + Q", hl.dsp.window.close(), { description = "Kill focused window" })
hl.bind("SUPER + SHIFT + Q", hl.dsp.window.kill(), { description = "Force kill focused window" })
hl.bind("SUPER + F", hl.dsp.window.fullscreen({ action = "toggle" }), { description = "Toggle fullscreen" })
hl.bind("SUPER + SPACE", hl.dsp.window.float({ action = "toggle" }), { description = "Toggle floating" })

-- Tiling toggle (SUPER + T) - persists state
hl.bind("SUPER + T", hl.dsp.exec_cmd(scriptsDir .. "/toggle_tiling.sh"), { description = "Toggle tiling mode and persist state" })

-- App / Window cycling across all workspaces
hl.bind("SUPER + Tab", hl.dsp.window.cycle_next(), { description = "Cycle applications across all workspaces" })
hl.bind("ALT + Tab", hl.dsp.window.cycle_next(), { description = "Cycle windows across all workspaces" })
hl.bind("ALT + SHIFT + Tab", hl.dsp.window.cycle_next({ next = false }), { description = "Cycle windows backward" })

-- Workspace navigation (Workspaces 1 to 4)
for i = 1, 4 do
    -- SUPER + 1-4: Switch to workspace
    hl.bind("SUPER + " .. i, hl.dsp.focus({ workspace = i }), { description = "Switch to workspace " .. i })
    -- SUPER + SHIFT + 1-4: Move window to workspace
    hl.bind("SUPER + SHIFT + " .. i, hl.dsp.window.move({ workspace = i }), { description = "Move window to workspace " .. i })
end

-- Focus workspace right/left (SUPER + L / SUPER + H)
hl.bind("SUPER + L", hl.dsp.focus({ workspace = "m+1" }), { description = "Focus workspace right" })
hl.bind("SUPER + H", hl.dsp.focus({ workspace = "m-1" }), { description = "Focus workspace left" })

-- Screenshots via hyprshot (auto-copy to clipboard)
hl.bind("Print", hl.dsp.exec_cmd("hyprshot -m region --clipboard-only"), { description = "Screenshot selection area -> clipboard" })
hl.bind("SHIFT + Print", hl.dsp.exec_cmd("hyprshot -m output --clipboard-only"), { description = "Screenshot full screen -> clipboard" })
hl.bind("ALT + Print", hl.dsp.exec_cmd("hyprshot -m window -m active --clipboard-only"), { description = "Screenshot active window -> clipboard" })

-- Clipboard history with image support via cliphist & fuzzel
hl.bind("SUPER + V", hl.dsp.exec_cmd("cliphist list | fuzzel --dmenu | cliphist decode | wl-copy"), { description = "Clipboard history" })

-- Mouse window manipulations
hl.bind("SUPER + mouse:272", hl.dsp.window.drag(), { mouse = true, description = "Move window with mouse" })
hl.bind("SUPER + mouse:273", hl.dsp.window.resize(), { mouse = true, description = "Resize window with mouse" })
