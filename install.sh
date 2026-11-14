#!/bin/sh
set -ex

# Instructions:
## Installing dependencies Dependencies
### Any sort of dependencies should be installed via `paru` with `-Syu --needed` flag.
### Before installing any dependencies, it should echo what packages it is installing.
### Example: `echo Installing core hyprland dependencies`
## Logging
### Enable verbose mode where possible. Exaple: cp -rv, rm -rv, mv -v, etc.

echo "Installing core Hyprland and Lua dependencies"
paru -Syu --needed \
    hyprland \
    lua \
    hyprland-protocols \
    hyprcursor \
    hyprgraphics \
    hyprutils \
    hyprwayland-scanner \
    xcb-proto \
    xcb-util \
    xcb-util-wm

echo "Installing launcher, screenshot, and clipboard utilities"
paru -Syu --needed \
    fuzzel \
    hyprshot \
    wl-clipboard \
    cliphist

echo "Installing terminal, file manager, and fonts"
paru -Syu --needed \
    kitty \
    thunar \
    ttf-jetbrains-mono-nerd

echo "Installing status bar and shell"
paru -Syu --needed \
    quickshell

echo "Installing idle, lockscreen, wallpaper daemon, prompt, and color generator"
paru -Syu --needed \
    hyprlock \
    hypridle \
    swww \
    matugen-bin \
    starship \
    jq

# Setup and Copy Configurations
echo "Setting up dotfiles and copying configurations..."

repo_root="$(cd "$(dirname "$0")" && pwd)"
config_home="${XDG_CONFIG_HOME:-$HOME/.config}"
icons_dir="${XDG_DATA_HOME:-$HOME/.local/share}/icons"

mkdir -pv "$config_home"
mkdir -pv "$icons_dir"

backup_and_copy() {
    src="$1"
    dest="$2"

    if [ -e "$dest" ] || [ -L "$dest" ]; then
        bak_dest="${dest}.bak"
        if [ -e "$bak_dest" ] || [ -L "$bak_dest" ]; then
            idx=1
            while [ -e "${dest}.bak.${idx}" ] || [ -L "${dest}.bak.${idx}" ]; do
                idx=$((idx + 1))
            done
            bak_dest="${dest}.bak.${idx}"
        fi
        echo "Backing up existing $dest to $bak_dest"
        mv -v "$dest" "$bak_dest"
    fi

    echo "Copying $src to $dest"
    cp -rv "$src" "$dest"
}

# Copy configurations with backup
backup_and_copy "$repo_root/hypr" "$config_home/hypr"
backup_and_copy "$repo_root/kitty" "$config_home/kitty"
backup_and_copy "$repo_root/matugen" "$config_home/matugen"
backup_and_copy "$repo_root/fish" "$config_home/fish"
backup_and_copy "$repo_root/herdr" "$config_home/herdr"
backup_and_copy "$repo_root/starship/starship.toml" "$config_home/starship.toml"

# Copy custom cursor themes
if [ -d "$repo_root/icons" ]; then
    echo "Installing cursor themes to $icons_dir"
    for cursor in "$repo_root/icons"/*; do
        if [ -d "$cursor" ]; then
            cname="$(basename "$cursor")"
            backup_and_copy "$cursor" "$icons_dir/$cname"
        fi
    done
fi

echo "Installation and configuration setup complete!"
