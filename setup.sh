#!/bin/bash

set -euo pipefail

echo "🧩 Setting up Sway environment..."

### 1. Update System
echo "🔄 Updating system..."
sudo pacman -Syu --noconfirm

### 2. Install Packages with Descriptions
echo "📦 Installing packages..."
sudo pacman -S --needed --noconfirm $(grep -vE '^\s*#' package_list.txt)

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

  # Make copied files executable if they are scripts
  if [[ "$src_file" == *.sh ]]; then
    chmod +x "$dest_file"
    echo "🔧 Made executable: $dest_file"
  fi
done

# Set SDDM as the display manager
echo "🖥️  Setting SDDM as the display manager..."
sudo systemctl enable sddm

echo "🎉 All config files copied successfully."
