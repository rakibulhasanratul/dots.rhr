#!/usr/bin/env bash

# Dynamic color generator based on current or provided wallpaper
# Uses matugen to extract Material You colors and distribute to:
# - Hyprland: ~/.config/hypr/hyprland/colors.lua
# - Hyprlock: ~/.config/hypr/hyprlock/colors.conf
# - Kitty: ~/.config/kitty/kitty-colors.conf
# - Starship: ~/.config/starship.toml
# - GTK / Fuzzel / Quickshell colors

XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"
MATUGEN_DIR="$XDG_CONFIG_HOME/matugen"

usage() {
    echo "Usage: $(basename "$0") [OPTIONS] [IMAGE_PATH]"
    echo ""
    echo "Options:"
    echo "  -m, --mode [dark|light]       Set theme mode (default: dark)"
    echo "  -t, --type [scheme-type]      Set matugen scheme type (e.g. scheme-tonal-spot, scheme-fidelity, etc.)"
    echo "  -h, --help                    Show this help"
    exit 0
}

MODE="dark"
SCHEME_TYPE="scheme-tonal-spot"
WALLPAPER=""

while [[ $# -gt 0 ]]; do
    case "$1" in
        -m|--mode)
            MODE="$2"
            shift 2
            ;;
        -t|--type)
            SCHEME_TYPE="$2"
            shift 2
            ;;
        -h|--help)
            usage
            ;;
        *)
            WALLPAPER="$1"
            shift
            ;;
    esac
done

# If no wallpaper argument is given, check default ~/.config/background, swww, or state
if [[ -z "$WALLPAPER" ]]; then
    if [[ -f "$XDG_CONFIG_HOME/background" ]]; then
        WALLPAPER="$XDG_CONFIG_HOME/background"
    elif command -v swww &>/dev/null; then
        DETECTED=$(swww query 2>/dev/null | grep -oP 'image: \K.*' | head -n 1)
        if [[ -n "$DETECTED" && -f "$DETECTED" ]]; then
            WALLPAPER="$DETECTED"
        fi
    fi
    if [[ -z "$WALLPAPER" && -f "$XDG_STATE_HOME/quickshell/user/generated/wallpaper/path.txt" ]]; then
        DETECTED=$(cat "$XDG_STATE_HOME/quickshell/user/generated/wallpaper/path.txt")
        if [[ -f "$DETECTED" ]]; then
            WALLPAPER="$DETECTED"
        fi
    fi
fi

if [[ -z "$WALLPAPER" || ! -f "$WALLPAPER" ]]; then
    echo "Error: No valid wallpaper specified or found."
    echo "Please provide an image: $(basename "$0") /path/to/wallpaper.png"
    exit 1
fi

if ! command -v matugen &>/dev/null; then
    echo "Error: matugen is not installed. Please install it with 'paru -Syu --needed matugen-bin'."
    exit 1
fi

echo "Generating color palette for: $WALLPAPER (mode: $MODE, type: $SCHEME_TYPE)"

# Run matugen
matugen image "$WALLPAPER" --mode "$MODE" --type "$SCHEME_TYPE"

# Reload Kitty instances with new colors if running
if pgrep -x kitty >/dev/null 2>&1; then
    kill -SIGUSR1 $(pidof kitty) 2>/dev/null || true
fi

# Reload Hyprland if running
if command -v hyprctl &>/dev/null && pgrep -x Hyprland >/dev/null 2>&1; then
    hyprctl reload >/dev/null 2>&1 || true
fi

echo "Colors successfully generated and applied to Kitty, Starship, and Hyprland!"
