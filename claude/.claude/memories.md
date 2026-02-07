# Recent Memories

This file contains rolling context from recent Claude Code sessions.
Keep this file focused and trim older entries to avoid token bloat.

**Management Guidelines:**
- Keep ~10-20 most relevant recent items
- Move important permanent info to CLAUDE.md instead
- Delete entries older than 2-4 weeks unless still relevant
- Group related items together

---

## Recent Session Notes

### 2026-01-31 - System Maintenance & CLI Setup

**Tasks Completed:**
- Fixed Discord EPIPE error (launch with nohup, clear crashpad)
- Fixed Suricata config (typos: stray `f`, `$HOME_NETS` → `$HOME_NET`)
- Updated `suricata-notify.sh` for niri/DMS (added to spawn-at-startup)
- Installed CLI tools: delta, eza, tldr, sd, curlie, pgcli, pay-respects
- Configured per-monitor niri workspaces (Main-L/R, Secondary-L/R, Tertiary-L/R, SPs)
- Set up this CLAUDE.md documentation system

**Key Configs Changed:**
- `~/.zshrc` - Added eza aliases, tldr+bat, pay-respects, delta, curlie PATH
- `~/.gitconfig` - Added delta as pager with side-by-side diff
- `~/.config/niri/config.kdl` - Per-monitor workspaces, suricata-notify spawn

**Known Issues (To Fix):**
- Neovim matugen stuck on static purple (not controlled by DMS)
- Claude autocomplete in Neovim (API-based) not working

**Tools Installed This Session:**
- `git-delta` (dnf)
- `eza`, `tealdeer`, `sd` (cargo)
- `curlie` (go install)
- `pgcli` (pipx)
- `pay-respects` (cargo) - replaced thefuck (Python 3.14 incompatible)

---

## Pending/Ongoing

- [ ] Fix Neovim matugen DMS integration
- [ ] Fix Claude autocomplete in Neovim

---

## Quick Reference (Temporary)

**Monitors:**
- Left: Dell S3222DGM (DVI-I-2) - Primary
- Right: Dell S3220DGF (DVI-I-1)
- Laptop: Sharp LQ156M1JW03 (eDP-1) - Disabled

**Suricata:**
- Config: `/etc/suricata/suricata.yaml`
- Mode: NFQUEUE IPS with 4 queues (0-3)
- Logs: `/var/log/suricata/eve.json`
