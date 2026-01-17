#!/bin/bash
# update-dotfiles.sh - Sync current configs to dotfiles

echo "=== Updating Dotfiles ==="

# Copy configs
cp ~/.bashrc ~/dotfiles/configs/
cp ~/.config/kdeglobals ~/dotfiles/configs/
cp ~/.config/katerc ~/dotfiles/configs/
cp ~/.config/kwinrc ~/dotfiles/configs/
cp ~/.config/plasma-org.kde.plasma.desktop-appletsrc ~/dotfiles/configs/

# Copy TeXstudio config
if [ -d ~/.config/texstudio ]; then
    mkdir -p ~/dotfiles/configs/texstudio
    cp -r ~/.config/texstudio/* ~/dotfiles/configs/texstudio/
fi

# Copy Obsidian config if it exists
if [ -d ~/.config/obsidian ]; then
    mkdir -p ~/dotfiles/configs/obsidian
    cp -r ~/.config/obsidian ~/dotfiles/configs/obsidian/
fi

# Git commit
cd ~/dotfiles
git add .
git commit -m "Update configs - $(date +%Y-%m-%d)"
git push

echo "✓ Dotfiles updated and pushed to GitHub!"
