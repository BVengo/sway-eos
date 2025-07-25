#!/bin/bash

set -euo pipefail

echo "🧩 Setting up Sway environment..."

### 1. Update System
echo "🔄 Updating system..."
sudo pacman -Syu --noconfirm

### 2. Install Packages with Descriptions
echo "📦 Installing packages..."

sudo pacman -S --needed --noconfirm \
    sway \                   # Tiling Wayland compositor
    swaybg \                 # Wallpaper tool
    vim \                    # Editor for config and text files
    nemo \                   # File manager
    rofi-wayland \           # App launcher (Wayland version)
    swayidle \               # Idle management daemon
    swaylock \               # Screen locker
    polkit-kde-agent \       # Authentication agent (request elevation)
    brightnessctl \          # Control screen brightness from CLI
    kitty \                  # Terminal emulator
    tmux \                   # Terminal multiplexer
    grim \                   # Screenshot utility (for Wayland)
    slurp \                  # Region selector (used with grim)
    mako \                   # Notification daemon
    inotify-tools \          # File system event monitoring
    waybar \                 # Customizable status bar
    otf-font-awesome \       # Font Awesome icons
    ttf-arimo-nerd \         # Nerd fonts for icons
    noto-fonts \             # Noto fonts for text rendering
    xdg-desktop-portal-gtk \ # Portal backend for file pickers (GTK)
    xdg-desktop-portal-wlr \ # Portal backend for Wayland (Sway)
    sway-contrib \           # Helpful scripts and tools for sway
    wl-clipboard             # Clipboard manager for Wayland

    ### 3. Copy Config Files
    echo "📁 Syncing configuration files to ~/.config..."

    SOURCE_DIR="./config"
    DEST_DIR="$HOME/.config"

    # Recursively process each file in the source config directory
    find "$SOURCE_DIR" -type f | while read -r src_file; do
      rel_path="${src_file#$SOURCE_DIR/}"           # Relative path from source dir
      dest_file="$DEST_DIR/$rel_path"               # Target file path
      dest_dir=$(dirname "$dest_file")

      mkdir -p "$dest_dir"                          # Ensure destination subdir exists

      if [ -f "$dest_file" ]; then
        echo "⚠️  Conflict: $dest_file exists, backing up as $dest_file.old"
        mv "$dest_file" "$dest_file.old"
      fi

      cp "$src_file" "$dest_file"
      echo "✅ Copied: $rel_path"
    done

    echo "🎉 All config files copied successfully."
