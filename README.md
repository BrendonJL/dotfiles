# dotfiles

Personal dotfiles for **ZenaOS 43** — a Fedora Atomic-based immutable desktop running **niri** (Wayland tiling compositor) with **DankMaterialShell** status bar, managed with [GNU Stow](https://www.gnu.org/software/stow/).

## Setup

```bash
# Clone with sparse checkout (only pulls metadata, not all files)
git clone --filter=blob:none --sparse https://github.com/BrendonJL/dotfiles.git ~/dotfiles
cd ~/dotfiles

# Enable the packages you need
git sparse-checkout add nvim niri dms zsh starship kitty yazi bashrc bin claude bat git fastfetch matugen satty

# Stow them into your home directory
stow nvim niri dms zsh starship kitty yazi bashrc bin claude bat git fastfetch matugen satty
```

> **Note:** If a target file already exists, move it aside first (`mv ~/.config/nvim ~/.config/nvim.bak`) before stowing.

## Packages

### Active (ZenaOS + Niri)

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
| `matugen` | Material You color generation config |
| `niri` | Niri compositor config with DMS keybinds and colors |
| `nvim` | Neovim/LazyVim with 28 plugin configs and dankcolors theme |
| `satty` | Screenshot annotation tool config |
| `starship` | Starship prompt config |
| `yazi` | Yazi file manager config (keybinds, theme, init.lua) |
| `zsh` | ZSH config with modern CLI tool aliases |

### Legacy (in git history)

These packages are from a previous Hyprland + KDE setup and remain in the repo history:

`btop` · `cava` · `eww` · `gtk-3.0` · `gtk-4.0` · `hypr` · `konsole` · `newsboat` · `qt5ct` · `qt6ct` · `rofi` · `swaync` · `waybar`

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
