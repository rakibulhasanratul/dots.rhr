#!/usr/bin/env bash

# Toggle tiling state persistence script for Hyprland
# When tiling is enabled:
# - Default window rule for class .* is set to tile
# - Active floating windows are tiled (except explicitly floating dialogs)
# When tiling is disabled (default):
# - Default window rule is float
# - Active windows are floated

STATE_FILE="${XDG_STATE_HOME:-$HOME/.local/state}/hyprland_tiling_mode"
mkdir -p "$(dirname "$STATE_FILE")"

get_current_mode() {
    if [[ -f "$STATE_FILE" ]]; then
        cat "$STATE_FILE"
    else
        echo "floating"
    fi
}

apply_mode() {
    local mode="$1"
    if [[ "$mode" == "tiling" ]]; then
        # Enable tiling mode
        hyprctl keyword windowrule "tile,class:.*" >/dev/null 2>&1
        hyprctl keyword general:gaps_in 3 >/dev/null 2>&1
        hyprctl keyword general:gaps_out 4 >/dev/null 2>&1
        echo "tiling" > "$STATE_FILE"
    else
        # Enable floating mode
        hyprctl keyword windowrule "float,class:.*" >/dev/null 2>&1
        hyprctl keyword general:gaps_in 0 >/dev/null 2>&1
        hyprctl keyword general:gaps_out 0 >/dev/null 2>&1
        echo "floating" > "$STATE_FILE"
    fi
}

if [[ "$1" == "--restore" ]]; then
    CURRENT=$(get_current_mode)
    apply_mode "$CURRENT"
elif [[ "$1" == "--status" ]]; then
    get_current_mode
else
    CURRENT=$(get_current_mode)
    if [[ "$CURRENT" == "tiling" ]]; then
        apply_mode "floating"
    else
        apply_mode "tiling"
    fi
fi
