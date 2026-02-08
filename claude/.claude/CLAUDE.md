# Global Claude Code Instructions

## Work Style
- Be direct and do the work. Explain what you're doing and why, but execute — don't ask me to run commands myself.
- Project-specific CLAUDE.md files may override this (e.g., mlp/ is learning-focused).
- Keep things concise. Don't over-engineer or add unnecessary abstractions.

## System: ZenaOS 43
- **OS**: ZenaOS 43 (Fedora Atomic/immutable base, CachyOS LTO kernel, SELinux enforcing)
- **WM**: niri 25.11 (Wayland tiling compositor)
- **Terminal**: Kitty (nixGL-wrapped at ~/.local/bin/kitty)
- **Shell**: ZSH (exec'd from .bashrc with interactive guard; Claude Code runs in bash)
- **Editor**: Neovim (LazyVim config)
- **Hardware**: MSI GE66 Raider — i7-10750H, RTX 2070 Super, 32GB RAM
- **Home**: /var/home/blasley (encrypted LUKS btrfs loop device)

## Package Management
- **User packages**: `zix add <pkg> && zix apply` (Nix wrapper, primary method)
- **Flatpak**: Discord, EasyEffects, Bitwarden, Stremio, LosslessCut, Polychromatic
- `/opt` and `/usr` are read-only. Use `/var/lib/` for persistent writable system files.
- zix doesn't support nested nix paths (e.g., `libsForQt5.qt5ct`) — use `nix build` + symlink for those.
- Nix GUI apps needing GPU require nixGL wrapper.

## CLI Tools Available
Prefer these modern alternatives over traditional commands:
- `bat` instead of `cat` (Dracula theme)
- `eza` instead of `ls`
- `rg` (ripgrep) instead of `grep`
- `fd` instead of `find`
- `delta` instead of `diff` (configured as git pager)
- `btop` instead of `top`/`htop`
- `zoxide` instead of `cd` (for frecent dirs)
- `fzf` for fuzzy finding
- `lazygit` for git TUI
- `yazi` as file manager
- `ripdrag` for drag-and-drop from terminal
- `wl-copy` / `wl-paste` for Wayland clipboard
- `grim` + `slurp` + `satty` for screenshots
- `pay-respects` for command correction
- `tldr` for quick command reference (piped through `bat`)

## Git & GitHub
- GitHub: BrendonJL (HTTPS auth)
- SSH key: ~/secrets/github_ed25519
- GPG signing: key ID B2EB9F6972533A57, auto-sign enabled
- Email: lasleybrendon@gmail.com
- Dotfiles: ~/dotfiles (sparse checkout, managed with stow)

## ZenaOS Quirks
- rpm-ostree layering is locked — don't suggest `dnf install` or `rpm-ostree install`.
- `chsh` doesn't work — zsh is activated via `exec zsh` in .bashrc.
- Kernel updates break out-of-tree modules (EVDI, OpenRazer) — run `rebuild-modules`.
- SELinux enforcing: binaries in /var/lib/ need `bin_t`, kernel modules need `modules_object_t`. Use `semanage fcontext` + `restorecon`, not `chcon`.
- Flatpak app-ids use reverse-domain (e.g., `com.discordapp.Discord`), needed for niri window rules.
- Yazi config uses `[mgr]` not `[manager]` in version 26+.

## Key Paths
- Dotfiles: ~/dotfiles
- Secrets (never commit): ~/secrets/
- Custom scripts: ~/.local/bin/
- Niri config: ~/.config/niri/
- Suricata config: /etc/suricata/ (IDS/IPS in NFQ mode)

## Active Projects
- **mlp** (~/mlp) — RL agent for Super Mario Bros (has its own CLAUDE.md)
- **Suricata IDS/IPS** — network security monitoring, ET Open rules
- **Dotfiles** (~/dotfiles) — system configs managed with stow
