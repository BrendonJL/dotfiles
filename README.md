# dotfiles

Personal dotfiles for **ZenaOS 43** — a Fedora Atomic-based immutable desktop running **niri** (Wayland tiling compositor) with **DankMaterialShell** status bar, managed with [GNU Stow](https://www.gnu.org/software/stow/).

## Quick Setup

```bash
git clone --filter=blob:none --sparse https://github.com/BrendonJL/dotfiles.git ~/dotfiles
cd ~/dotfiles && bash setup/install.sh
```

The install script handles: Nix packages (via zix), Flatpak apps, Nerd Fonts, stow linking, wallpapers, and prints remaining manual steps.

### Manual Setup

```bash
# Clone with sparse checkout
git clone --filter=blob:none --sparse https://github.com/BrendonJL/dotfiles.git ~/dotfiles
cd ~/dotfiles

# Enable specific packages
git sparse-checkout add nvim niri dms zsh starship kitty yazi bashrc bin claude bat git fastfetch matugen satty zix openrazer

# Stow them
stow nvim niri dms zsh starship kitty yazi bashrc bin claude bat git fastfetch matugen satty zix openrazer
```

> **Note:** If a target file already exists, move it aside first (`mv ~/.config/nvim ~/.config/nvim.bak`) before stowing.

## Packages

### Stow Packages

| Package | Description |
|---------|-------------|
| `bashrc` | Bash config with interactive zsh exec guard |
| `bat` | Bat syntax highlighter (Dracula theme) |
| `bin` | Custom scripts (`niri-record`, `niri-toggle`, `rebuild-modules`, `colorscript`, `mcp-memory-stdio`) |
| `claude` | Claude Code global config and MCP settings |
| `dms` | DankMaterialShell bar config, settings, and 20+ plugins |
| `fastfetch` | System info display config |
| `git` | Git config (GPG signing, delta pager, aliases) |
| `kitty` | Kitty terminal emulator config |
| `matugen` | Material You color generation templates and config |
| `niri` | Niri compositor config with DMS keybinds and colors |
| `nvim` | Neovim/LazyVim with 28 plugin configs and dankcolors theme |
| `openrazer` | OpenRazer daemon systemd user service |
| `satty` | Screenshot annotation tool config |
| `starship` | Starship prompt config |
| `yazi` | Yazi file manager config (keybinds, theme, init.lua) |
| `zix` | Nix package manifest (declarative package list) |
| `zsh` | ZSH config with modern CLI tool aliases |

### Setup (non-stow)

| Path | Contents |
|------|----------|
| `setup/install.sh` | Automated setup script for fresh installs |
| `setup/suricata/` | Suricata IDS/IPS config (suricata.yaml, NFQ rules) |
| `setup/wallpapers/` | Wallpaper collection for matugen theming |

## System

| | |
|---|---|
| **OS** | ZenaOS 43 (Fedora Atomic, CachyOS LTO kernel) |
| **WM** | niri 25.11 (Wayland tiling compositor) |
| **Bar** | DankMaterialShell |
| **Terminal** | Kitty (nixGL-wrapped) |
| **Shell** | ZSH (via bash exec) |
| **Editor** | Neovim (LazyVim) |
| **Packages** | Nix (via zix wrapper) + Flatpak |
