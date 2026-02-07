# Global CLAUDE.md

This file provides system-wide context to Claude Code across all projects.
Project-specific CLAUDE.md files take precedence over this one.

## System Overview

**User**: Brendon Lasley
**OS**: Fedora 43 (Linux 6.18.x)
**Shell**: zsh with starship prompt
**Editor**: Neovim

### Desktop Environment
- **Compositor**: niri (Wayland scrolling tiling compositor)
- **Shell/Theme**: Dank Material Shell (DMS) via Quickshell
- **Notifications**: SwayNC
- **Theming**: Matugen (Material You color generation)

### Key Configurations
- **Dotfiles**: `~/dotfiles/` (managed with stow)
- **Niri config**: `~/.config/niri/config.kdl`
- **DMS modules**: `~/.config/niri/dms/`

### Security
- **IDS/IPS**: Suricata in NFQUEUE mode (4 queues)
- **Monitoring**: OpenSearch dashboard for Suricata logs
- **Notifications**: `~/.local/bin/suricata-notify.sh`

## CLI Tools

Enhanced command-line setup:
- `bat` - cat replacement with syntax highlighting
- `eza` - ls replacement with icons and git status
- `tldr` - simplified man pages (piped through bat)
- `delta` - git diff viewer (side-by-side)
- `sd` - sed replacement with simpler syntax
- `pay-respects` - command autocorrect (alias: `f`)
- `zoxide` - smarter cd with frecency
- `ripgrep` - fast grep
- `fzf` - fuzzy finder with bat preview

## Interaction Preferences

### General Style
- Provide educational insights with `★ Insight` boxes
- Be direct and technical, avoid unnecessary praise
- Explain the "why" behind decisions

### Autonomy Level
- **Default**: Ask before making significant changes
- **Documentation**: May update .md files freely
- **Config files**: Ask before modifying system configs

### Output Preferences
- Keep responses concise for simple tasks
- Use tables for comparisons
- Provide command examples when relevant

## Active Projects

### Machine Learning Project (`~/mlp/`)
- Reinforcement learning for game AI
- Has its own detailed CLAUDE.md with learning-focused interaction style
- Uses Poetry, PostgreSQL, W&B

### Dotfiles (`~/dotfiles/`)
- Managed with GNU Stow
- Contains: hypr, niri, waybar, eww, rofi, nvim, etc.

## Recent Context

See `~/.claude/memories.md` for rolling recent context and session history.

---

*Last updated: 2026-01-31*
