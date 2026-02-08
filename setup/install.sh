#!/bin/bash
# ZenaOS Dotfiles Setup Script
# Run this on a fresh ZenaOS 43 install to restore the full environment.
#
# Prerequisites:
#   - ZenaOS 43 (Fedora Atomic base) installed
#   - User account created, logged in
#   - Internet connection
#
# Usage:
#   git clone --filter=blob:none https://github.com/BrendonJL/dotfiles.git ~/dotfiles
#   cd ~/dotfiles && bash setup/install.sh

set -euo pipefail

DOTFILES="$(cd "$(dirname "$0")/.." && pwd)"
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

info()  { echo -e "${GREEN}[+]${NC} $*"; }
warn()  { echo -e "${YELLOW}[!]${NC} $*"; }
error() { echo -e "${RED}[x]${NC} $*"; }

# ─── Step 1: Install zix (Nix wrapper) ───────────────────────────────────────
info "Step 1: Nix + zix package manager"
if ! command -v nix &>/dev/null; then
    warn "Nix not installed. Install via: https://nixos.org/download/"
    warn "Then install zix: nix profile install github:BrendonJL/zix"
    exit 1
fi

if ! command -v zix &>/dev/null; then
    warn "zix not found. Install: nix profile install github:BrendonJL/zix"
    exit 1
fi

info "Restoring Nix packages via zix..."
if [ -f "$DOTFILES/zix/.zix/zix.json" ]; then
    mkdir -p ~/.zix
    cp "$DOTFILES/zix/.zix/zix.json" ~/.zix/zix.json
    zix apply
    info "Nix packages installed"
else
    error "zix.json not found in repo"
fi

# ─── Step 2: Flatpak apps ────────────────────────────────────────────────────
info "Step 2: Flatpak apps"
FLATPAKS=(
    "app.polychromatic.controller"
    "com.bitwarden.desktop"
    "com.discordapp.Discord"
    "com.github.wwmm.easyeffects"
    "com.stremio.Stremio"
    "no.mifi.losslesscut"
)
for app in "${FLATPAKS[@]}"; do
    if ! flatpak info "$app" &>/dev/null; then
        info "Installing $app..."
        flatpak install -y flathub "$app"
    else
        info "$app already installed"
    fi
done

# ─── Step 3: Fonts ───────────────────────────────────────────────────────────
info "Step 3: Nerd Fonts"
FONT_DIR="$HOME/.local/share/fonts"
mkdir -p "$FONT_DIR"

NERD_FONTS=("FiraCode" "JetBrainsMono")
NERD_FONT_VERSION="v3.3.0"

for font in "${NERD_FONTS[@]}"; do
    if ls "$FONT_DIR"/${font}NerdFont-Regular.ttf &>/dev/null; then
        info "$font Nerd Font already installed"
    else
        info "Downloading $font Nerd Font..."
        TMP=$(mktemp -d)
        curl -fsSL "https://github.com/ryanoasis/nerd-fonts/releases/download/${NERD_FONT_VERSION}/${font}.tar.xz" -o "$TMP/${font}.tar.xz"
        tar xf "$TMP/${font}.tar.xz" -C "$FONT_DIR"
        rm -rf "$TMP"
        info "$font installed"
    fi
done
fc-cache -f "$FONT_DIR"

# ─── Step 4: Sparse checkout all packages ────────────────────────────────────
info "Step 4: Sparse checkout stow packages"
cd "$DOTFILES"
PACKAGES=(bashrc bat bin claude dms fastfetch git kitty matugen niri nvim openrazer satty starship yazi zix zsh)
git sparse-checkout add "${PACKAGES[@]}" setup

# ─── Step 5: Stow packages ───────────────────────────────────────────────────
info "Step 5: Stowing packages"
# Move aside any existing configs that would conflict
CONFLICTS=()
for pkg in "${PACKAGES[@]}"; do
    case "$pkg" in
        bashrc)    [ -f ~/.bashrc ] && ! [ -L ~/.bashrc ] && mv ~/.bashrc ~/.bashrc.bak && CONFLICTS+=(".bashrc") ;;
        git)       [ -f ~/.gitconfig ] && ! [ -L ~/.gitconfig ] && mv ~/.gitconfig ~/.gitconfig.bak && CONFLICTS+=(".gitconfig") ;;
        zix)       [ -f ~/.zix/zix.json ] && ! [ -L ~/.zix/zix.json ] && mv ~/.zix/zix.json ~/.zix/zix.json.bak && CONFLICTS+=(".zix/zix.json") ;;
    esac
done

for pkg in "${PACKAGES[@]}"; do
    if stow --no-folding "$pkg" 2>/dev/null || stow "$pkg" 2>/dev/null; then
        info "Stowed: $pkg"
    else
        warn "Stow conflict for $pkg — move existing config aside first"
    fi
done

[ ${#CONFLICTS[@]} -gt 0 ] && warn "Backed up conflicting files: ${CONFLICTS[*]}"

# ─── Step 6: Wallpapers ──────────────────────────────────────────────────────
info "Step 6: Wallpapers"
if [ -d "$DOTFILES/setup/wallpapers" ]; then
    mkdir -p ~/Pictures/Wallpapers
    cp -rn "$DOTFILES/setup/wallpapers/"* ~/Pictures/Wallpapers/ 2>/dev/null || true
    info "Wallpapers copied to ~/Pictures/Wallpapers/"
fi

# ─── Step 7: Suricata IDS/IPS ────────────────────────────────────────────────
info "Step 7: Suricata setup (requires sudo)"
if command -v suricata &>/dev/null; then
    warn "Suricata configs are in setup/suricata/"
    warn "To install: sudo cp setup/suricata/suricata.yaml /etc/suricata/"
    warn "            sudo cp setup/suricata/nfq-rules.nft /etc/suricata/"
    warn "            sudo systemctl enable --now suricata"
    warn "            sudo suricata-update"
else
    warn "Suricata not installed yet — will be available after zix apply"
fi

# ─── Step 8: OpenRazer kernel module ─────────────────────────────────────────
info "Step 8: OpenRazer"
warn "After stowing openrazer package, enable the service:"
warn "  systemctl --user enable --now openrazer-daemon"
warn "  rebuild-modules  (after kernel updates)"

# ─── Step 9: nixGL for GPU apps ──────────────────────────────────────────────
info "Step 9: nixGL wrapper"
warn "Kitty needs nixGL for GPU acceleration:"
warn '  nix build --no-link github:nix-community/nixGL#nixGL'
warn '  Create ~/.local/bin/kitty with: exec nixGL ~/.nix-profile/bin/kitty "\$@"'

# ─── Step 10: Yazi plugins ───────────────────────────────────────────────────
info "Step 10: Yazi plugins"
if command -v ya &>/dev/null; then
    ya pkg install
    info "Yazi plugins installed"
else
    warn "ya not found — install yazi first, then run: ya pkg install"
fi

# ─── Done ─────────────────────────────────────────────────────────────────────
echo ""
info "Setup complete!"
info "Remaining manual steps:"
echo "  1. Import GPG key and configure git signing"
echo "  2. Generate SSH key for GitHub"
echo "  3. Set up Claude Code API key"
echo "  4. Copy suricata configs (see step 7 above)"
echo "  5. Run: rebuild-modules (for OpenRazer after first boot)"
echo "  6. Log out and back in for all changes to take effect"
