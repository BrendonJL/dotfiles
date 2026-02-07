# ZenaOS Migration Checklist

Migration from Fedora 43 KDE (with Niri/DMS) to ZenaOS.

**ZenaOS Info:** https://zena-linux.github.io
**Base:** Fedora bootc (immutable) with CachyOS LTO kernel
**Package Manager:** Zix (Nix wrapper with declarative `zix.json` support)
**Desktop:** Niri + Dank Material Shell (pre-installed!)

---

## Phase 1: Prepare Dotfiles (On Fedora)

### 1.1 Commit & Push Everything
```bash
cd ~/dotfiles

# Check status
git status

# Add any uncommitted changes
git add -A
git commit -m "Pre-ZenaOS migration snapshot"

# Push to GitHub
git push origin main
```

### 1.2 Make Repo Private (Optional)
If you want your dotfiles private:
```bash
gh repo edit BrendonJL/dotfiles --visibility private
```

### 1.3 Verify Push Worked
```bash
# Check remote is up to date
git log origin/main --oneline -3
```

---

## Phase 2: Backup Secrets (Do NOT Commit to Git)

Copy these to an encrypted USB or password manager:

- [ ] **SSH Keys** - `~/.ssh/id_ed25519` and `id_ed25519.pub`
- [ ] **GPG Keys** - `gpg --export-secret-keys -a > gpg-private.asc`
- [ ] **API Keys** - Document any in environment:
  - `ANTHROPIC_API_KEY` (currently in .zshrc - **ROTATE THIS KEY!**)
- [ ] **Bitwarden** - Verify vault is synced to cloud

> These can wait - you can `gh auth login` without SSH keys and set them up later.

---

## Phase 3: Document What to Install

### CLI Tools for Zix
```bash
# Core tools - create zix.json or install imperatively
zix add bat eza ripgrep fd fzf starship zoxide neovim lazygit btop delta
```

| Tool | Purpose |
|------|---------|
| `bat` | Better cat |
| `eza` | Better ls |
| `ripgrep` | Fast grep |
| `fd` | Better find |
| `fzf` | Fuzzy finder |
| `delta` | Git diff viewer |
| `starship` | Shell prompt |
| `zoxide` | Smart cd |
| `neovim` | Editor |
| `lazygit` | Git TUI |
| `btop` | System monitor |

### Flatpaks to Reinstall
```bash
flatpak install flathub com.bitwarden.desktop
flatpak install flathub com.stremio.Stremio
flatpak install flathub no.mifi.losslesscut
```

### Dev Tools
- Node.js via `nvm`
- Rust via `rustup`
- Python tools via `pipx` (poetry, pgcli)
- Go via `zix add go`

---

## Phase 4: ZenaOS Installation

### 4.1 Boot & Install
- [ ] Download ZenaOS ISO
- [ ] Boot from USB on laptop
- [ ] Follow TUI installer
- [ ] Set up user account (encrypted home directory)
- [ ] Complete first boot

### 4.2 First Boot Setup
```bash
# Update system
zix update

# Verify niri and DMS are working
niri --version
```

---

## Phase 5: Clone Dotfiles (HTTPS + gh auth)

No SSH keys needed - use browser-based GitHub authentication:

```bash
# Install git and GitHub CLI
zix add git gh stow

# Authenticate via browser
gh auth login
# Select: GitHub.com → HTTPS → Login with browser

# Clone your dotfiles
gh repo clone BrendonJL/dotfiles ~/dotfiles
```

---

## Phase 6: Apply Dotfiles

### 6.1 Stow Your Configs
```bash
cd ~/dotfiles

# Core configs (should work directly on ZenaOS):
stow niri          # Niri + DMS config (ZenaOS has these pre-installed!)
stow nvim          # Neovim
stow starship      # Shell prompt
stow bat           # Bat config
stow kitty         # Terminal
stow btop          # System monitor
stow fastfetch     # Fetch script

# Theme configs:
stow matugen       # Material You generator
stow gtk-3.0
stow gtk-4.0
stow Kvantum
stow qt5ct
stow qt6ct
stow swaync        # Notifications

# Optional:
stow rofi          # Launcher
stow eww           # Widgets
stow cava          # Audio viz
stow newsboat      # RSS
```

> **Note:** Stow is still useful for dotfile management. Zix's declarative `zix.json` manages *packages*, not config files. If you want fully declarative dotfiles later, look into **home-manager** (Nix ecosystem).

### 6.2 If Stow Conflicts with Existing Files
```bash
# Adopt existing files into your dotfiles
stow --adopt <package>

# Or backup and force
mv ~/.config/niri ~/.config/niri.bak
stow niri
```

---

## Phase 7: Install Packages

### 7.1 CLI Tools
```bash
zix add bat eza ripgrep fd fzf starship zoxide neovim lazygit btop delta

# ZSH + plugins
zix add zsh zsh-autosuggestions zsh-syntax-highlighting zsh-completions

# Set zsh as default
chsh -s $(which zsh)
```

### 7.2 Desktop Apps
```bash
zix add kitty matugen
# Check what's already included with ZenaOS's niri/DMS setup
```

### 7.3 Flatpaks
```bash
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak install flathub com.bitwarden.desktop
flatpak install flathub com.stremio.Stremio
flatpak install flathub no.mifi.losslesscut
```

### 7.4 Development Environment
```bash
# Node.js
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
nvm install --lts

# Rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

# Python tools
zix add pipx
pipx install poetry
pipx install pgcli

# Go
zix add go
```

---

## Phase 8: Gaming Setup

ZenaOS has built-in gaming support - no need for Bottles/Wine manually:

```bash
# This provisions Steam, Heroic, Lutris in a CachyOS Distrobox
gaming install
```

This gives you an optimized gaming container with everything pre-configured.

---

## Phase 9: Install Fonts

```bash
# Via package manager
zix add jetbrains-mono

# Or copy from backup
mkdir -p ~/.local/share/fonts
# Copy JetBrains Mono, FiraCode from backup
fc-cache -fv
```

---

## Phase 10: Final Setup

### 10.1 SSH Keys (When Ready)
```bash
# Generate new keys
ssh-keygen -t ed25519 -C "lasleybrendon@gmail.com"

# Add to GitHub
gh ssh-key add ~/.ssh/id_ed25519.pub --title "ZenaOS Laptop"

# Switch dotfiles remote to SSH (optional)
cd ~/dotfiles
git remote set-url origin git@github.com:BrendonJL/dotfiles.git
```

### 10.2 Restore Other Secrets
- [ ] Import GPG keys if backed up
- [ ] Configure API keys in `~/.config/environment.d/secrets.conf`
- [ ] Set up Bitwarden SSH agent

---

## Phase 11: Verification Checklist

- [ ] Niri launches correctly
- [ ] DMS theme applies
- [ ] Keybindings work
- [ ] Rofi launches
- [ ] SwayNC notifications appear
- [ ] Kitty terminal works with correct theme
- [ ] Neovim plugins install
- [ ] Git with delta works
- [ ] Starship prompt appears
- [ ] `gh` commands work

---

## Troubleshooting

### If packages not found in Zix
```bash
# Search for alternatives
zix search <keyword>

# Check Nix packages directly
nix search nixpkgs#<package>
```

### If Niri config conflicts with ZenaOS defaults
```bash
# Check ZenaOS default locations
ls /etc/niri/
ls /usr/share/niri/

# Your ~/.config/niri/ should override system defaults
```

### If stow conflicts
```bash
stow --adopt <package>  # Adopt existing files
# Then check git diff to see what changed
```

---

## Future Improvements

Once settled on ZenaOS, consider:
- [ ] Create a `zix.json` for reproducible package installs
- [ ] Explore **home-manager** for declarative dotfile management
- [ ] Set up Suricata/security monitoring if desired
- [ ] Document ZenaOS-specific tweaks in this file

---

*Created: 2026-02-06*
