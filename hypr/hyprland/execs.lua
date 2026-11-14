-- Startup applications
hl.on("hyprland.start", function()
    -- Idle management
    hl.exec_cmd("hypridle")

    -- Wallpaper daemon & set default background (~/.config/background)
    hl.exec_cmd("swww-daemon && swww img ~/.config/background")

    -- Generate color schemes from background
    hl.exec_cmd("~/.config/hypr/hyprland/scripts/switchwall.sh ~/.config/background")

    -- Clipboard history: store text & images
    hl.exec_cmd("wl-paste --type text --watch cliphist store")
    hl.exec_cmd("wl-paste --type image --watch cliphist store")

    -- Restore tiling state if previously saved
    hl.exec_cmd("~/.config/hypr/hyprland/scripts/toggle_tiling.sh --restore")

    -- Cursor
    hl.exec_cmd("hyprctl setcursor volantes_light_cursors 24")

    -- Dbus environment setup
    hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
end)
