-- Root entry point & load orchestrator for Hyprland Lua configuration

-- Internal library and services --
require("hyprland.lib")
require("hyprland.services")

-- Environment variables --
require("hyprland.env")
if is_file_exists(HOME .. "/.config/hypr/custom/env.lua") then
    require("custom.env")
elseif is_file_exists("hypr/custom/env.lua") or is_file_exists("custom/env.lua") then
    pcall(require, "custom.env")
end

-- Core configuration modules --
require("hyprland.execs")
require("hyprland.general")
require("hyprland.rules")
require("hyprland.colors")
require("hyprland.keybinds")

-- Custom configuration overrides --
if is_file_exists(HOME .. "/.config/hypr/custom/execs.lua") then
    require("custom.execs")
elseif is_file_exists("hypr/custom/execs.lua") or is_file_exists("custom/execs.lua") then
    pcall(require, "custom.execs")
end

if is_file_exists(HOME .. "/.config/hypr/custom/general.lua") then
    require("custom.general")
elseif is_file_exists("hypr/custom/general.lua") or is_file_exists("custom/general.lua") then
    pcall(require, "custom.general")
end

if is_file_exists(HOME .. "/.config/hypr/custom/rules.lua") then
    require("custom.rules")
elseif is_file_exists("hypr/custom/rules.lua") or is_file_exists("custom/rules.lua") then
    pcall(require, "custom.rules")
end

if is_file_exists(HOME .. "/.config/hypr/custom/keybinds.lua") then
    require("custom.keybinds")
elseif is_file_exists("hypr/custom/keybinds.lua") or is_file_exists("custom/keybinds.lua") then
    pcall(require, "custom.keybinds")
end

-- Display & Workspace configurations --
if is_file_exists(HOME .. "/.config/hypr/workspaces.lua") then
    require("workspaces")
elseif is_file_exists("hypr/workspaces.lua") or is_file_exists("workspaces.lua") then
    pcall(require, "workspaces")
end

if is_file_exists(HOME .. "/.config/hypr/monitors.lua") then
    require("monitors")
elseif is_file_exists("hypr/monitors.lua") or is_file_exists("monitors.lua") then
    pcall(require, "monitors")
end

-- Shell overrides --
require("hyprland.shell-overrides.main")
