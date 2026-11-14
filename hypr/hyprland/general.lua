hl.config({
    general = {
        -- Gaps (configured for tiling, toggled via toggle_tiling script)
        gaps_in = 3,
        gaps_out = 4,
        gaps_workspaces = 0,

        border_size = 2,
        col = {
            active_border = "rgba(0db7d4ff)",
            inactive_border = "rgba(313136aa)"
        },
        resize_on_border = true,
        no_focus_fallback = true,
        allow_tearing = false,
        layout = "dwindle"
    },

    decoration = {
        rounding = 10,
        rounding_power = 2.0,

        -- Shadows disabled
        shadow = {
            enabled = false,
        },

        -- Blur
        blur = {
            enabled = true,
            size = 8,
            passes = 2,
            new_optimizations = true,
        },
    },

    -- Animations disabled / instant transitions
    animations = {
        enabled = false
    },

    input = {
        kb_layout = "us",
        numlock_by_default = true,
        repeat_delay = 250,
        repeat_rate = 35,

        follow_mouse = 1,
        sensitivity = 0,

        touchpad = {
            natural_scroll = true,
            disable_while_typing = true,
            tap_to_click = true,
            clickfinger_behavior = true,
            scroll_factor = 1.0
        }
    },

    dwindle = {
        preserve_split = true,
        smart_split = false,
        smart_resizing = false
    },

    misc = {
        disable_hyprland_logo = true,
        disable_splash_rendering = true,
        mouse_move_enables_dpms = true,
        key_press_enables_dpms = true,
        focus_on_activate = true
    },

    cursor = {
        no_warps = false,
        zoom_factor = 1.0,
    },

    xwayland = {
        force_zero_scaling = true
    }
})
