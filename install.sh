#!/bin/bash
# install.sh - Set up dotfiles and configurations

set -e

echo "=== Dotfiles Installation ==="

# Backup existing configs
echo "→ Backing up existing configs..."
mkdir -p ~/.config-backup
cp ~/.bashrc ~/.config-backup/ 2>/dev/null || true
cp ~/.config/kdeglobals ~/.config-backup/ 2>/dev/null || true
cp ~/.config/katerc ~/.config-backup/ 2>/dev/null || true

# Link configs
echo "→ Linking configuration files..."
ln -sf ~/dotfiles/configs/.bashrc ~/.bashrc
ln -sf ~/dotfiles/configs/kdeglobals ~/.config/kdeglobals
ln -sf ~/dotfiles/configs/katerc ~/.config/katerc

# Copy docker-compose
echo "→ Setting up Docker services..."
mkdir -p ~/docker-services
cp ~/dotfiles/docker-compose.yml ~/docker-services/

echo "
✓ Installation complete!"
echo "Restart your terminal for changes to take effect."
