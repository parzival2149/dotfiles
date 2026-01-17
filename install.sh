#!/bin/bash
# install.sh - Complete system setup for EndeavourOS

set -e

echo "╔════════════════════════════════════════╗"
echo "║     System Installation Script         ║"
echo "╚════════════════════════════════════════╝"

# Check if running on Arch-based system
if ! command -v pacman &> /dev/null; then
    echo "Error: This script is for Arch-based systems"
    exit 1
fi

# Update system
echo "
=== Updating System ==="
sudo pacman -Syu --noconfirm

# Install yay if not present
if ! command -v yay &> /dev/null; then
    echo "
=== Installing yay ==="
    sudo pacman -S --needed git base-devel --noconfirm
    git clone https://aur.archlinux.org/yay.git /tmp/yay
    cd /tmp/yay && makepkg -si --noconfirm
    cd ~
fi

# Backup existing configs
echo "
=== Backing Up Existing Configs ==="
mkdir -p ~/.config-backup
cp ~/.bashrc ~/.config-backup/ 2>/dev/null || true
cp ~/.config/kdeglobals ~/.config-backup/ 2>/dev/null || true
cp ~/.config/katerc ~/.config-backup/ 2>/dev/null || true

# Link configs
echo "
=== Linking Configuration Files ==="
ln -sf ~/dotfiles/configs/.bashrc ~/.bashrc
ln -sf ~/dotfiles/configs/kdeglobals ~/.config/kdeglobals
ln -sf ~/dotfiles/configs/katerc ~/.config/katerc
ln -sf ~/dotfiles/configs/kwinrc ~/.config/kwinrc
ln -sf ~/dotfiles/configs/plasma-org.kde.plasma.desktop-appletsrc ~/.config/plasma-org.kde.plasma.desktop-appletsrc

# Restore TeXstudio config
if [ -d ~/dotfiles/configs/texstudio ]; then
    echo "→ Restoring TeXstudio config..."
    mkdir -p ~/.config/texstudio
    cp -r ~/dotfiles/configs/texstudio/* ~/.config/texstudio/
fi

# Restore Obsidian config
if [ -d ~/dotfiles/configs/obsidian ]; then
    echo "→ Restoring Obsidian config..."
    mkdir -p ~/.config/obsidian
    cp -r ~/dotfiles/configs/obsidian/* ~/.config/obsidian/
fi

# Install Docker
echo "
=== Installing Docker ==="
sudo pacman -S --needed --noconfirm docker docker-compose
sudo systemctl enable docker
sudo systemctl start docker
sudo usermod -aG docker $USER

# Install Tailscale
echo "
=== Installing Tailscale ==="
sudo pacman -S --needed --noconfirm tailscale
sudo systemctl enable tailscaled
sudo systemctl start tailscaled

# Install Development Tools
echo "
=== Installing Development Tools ==="
sudo pacman -S --needed --noconfirm \
    python \
    python-pip \
    kate

# Install comprehensive LaTeX
echo "
=== Installing LaTeX (Comprehensive) ==="
sudo pacman -S --needed --noconfirm \
    texlive-basic \
    texlive-bin \
    texlive-binextra \
    texlive-latex \
    texlive-latexrecommended \
    texlive-latexextra \
    texlive-mathscience \
    texlive-fontsrecommended \
    texlive-fontsextra \
    texlive-publishers \
    texlive-pictures \
    texlive-bibtexextra \
    texlive-langenglish \
    texstudio

# Install Python packages
echo "
=== Installing Python Packages ==="
pip install --user numpy pandas matplotlib seaborn scikit-learn jupyter python-lsp-server

# Install Communication Apps
echo "
=== Installing Communication Apps ==="
sudo pacman -S --needed --noconfirm \
    syncthing \
    signal-desktop \
    discord

yay -S --needed --noconfirm \
    zoom \
    localsend-bin

# Install VPN
echo "
=== Installing ProtonVPN ==="
sudo pacman -S --needed --noconfirm \
    protonvpn-gtk-app \
    gnome-keyring \
    network-manager-applet

# Install Music Management
echo "
=== Installing Music Tools ==="
sudo pacman -S --needed --noconfirm \
    strawberry \
    picard

yay -S --needed --noconfirm dupeguru

# Install Notes & Productivity
echo "
=== Installing Productivity Tools ==="
yay -S --needed --noconfirm obsidian

# Install Keyboard Support
echo "
=== Installing ZSA Voyager Support ==="
yay -S --needed --noconfirm zsa-keymapp-bin

# Install Offline Wiki & reMarkable Tools
echo "
=== Installing Reading Tools ==="
sudo pacman -S --needed --noconfirm kiwix-desktop

yay -S --needed --noconfirm rmapi

# Install Utilities
echo "
=== Installing Utilities ==="
sudo pacman -S --needed --noconfirm p7zip

# Install Emulators
echo "
=== Installing Emulators ==="
sudo pacman -S --needed --noconfirm \
    retroarch \
    retroarch-assets-ozone \
    retroarch-assets-xmb \
    dolphin-emu

yay -S --needed --noconfirm \
    rpcs3-bin \
    cemu \
    xemu-bin \
    pcsx2

# Install Media Tools
echo "
=== Installing Media Tools ==="
sudo pacman -S --needed --noconfirm \
    calibre \
    k3b \
    handbrake \
    cdrtools \
    cdrdao \
    dvd+rw-tools

yay -S --needed --noconfirm asunder

# Install Steam
echo "
=== Installing Steam ==="
sudo pacman -S --needed --noconfirm steam

# Install Fonts
echo "
=== Installing Fonts ==="
yay -S --needed --noconfirm ttf-meslo-nerd
sudo pacman -S --needed --noconfirm \
    ttf-liberation \
    noto-fonts \
    noto-fonts-emoji

# Set up Docker services
echo "
=== Setting Up Docker Services ==="
mkdir -p ~/.local/share/docker-data/jellyfin/{config,cache}
mkdir -p ~/.local/share/docker-data/navidrome
mkdir -p ~/.local/share/docker-data/southwest-checkin
mkdir -p ~/.local/share/docker-data/portainer
mkdir -p ~/docker-services

cp ~/dotfiles/docker-compose.yml ~/docker-services/

# Pull Docker images
echo "
=== Pulling Docker Images ==="
docker pull jdholtz/auto-southwest-check-in
docker pull jellyfin/jellyfin
docker pull deluan/navidrome
docker pull portainer/portainer-ce

# Set up Syncthing
echo "
=== Configuring Syncthing ==="
systemctl --user enable syncthing
systemctl --user start syncthing

echo "
╔════════════════════════════════════════╗"
echo "║   Installation Complete!               ║"
echo "╚════════════════════════════════════════╝"
echo "
IMPORTANT NEXT STEPS:"
echo "1. Log out and back in for Docker group to take effect"
echo "2. Run: sudo tailscale up"
echo "3. Configure Syncthing at http://localhost:8384"
echo "4. Edit ~/docker-services/docker-compose.yml with:"
echo "   - Southwest credentials"
echo "   - HDD mount paths"
echo "5. cd ~/docker-services && docker-compose up -d"
echo "
Access web interfaces:"
echo "  Syncthing:  http://localhost:8384"
echo "  Jellyfin:   http://localhost:8096"
echo "  Navidrome:  http://localhost:4533"
echo "  Portainer:  http://localhost:9000"
