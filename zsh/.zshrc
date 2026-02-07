# Created by newuser for 5.9
# Enable plugins
source ~/.zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

typeset -A ZSH_HIGHLIGHT_STYLES


# ZSH Syntax Highlighting - MAXIMUM CONTRAST Purple Cat Theme (256-color)
ZSH_HIGHLIGHT_STYLES[default]='fg=189,bold'                       # Light purple
ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=204,bold'                 # Bright pink-red for errors
ZSH_HIGHLIGHT_STYLES[reserved-word]='fg=183,bold'                 # Bright purple for keywords
ZSH_HIGHLIGHT_STYLES[alias]='fg=226,bold'                         # Bright yellow for aliases
ZSH_HIGHLIGHT_STYLES[builtin]='fg=183,bold'                       # Bright purple for builtins
ZSH_HIGHLIGHT_STYLES[function]='fg=117,bold'                      # Bright cyan for functions
ZSH_HIGHLIGHT_STYLES[command]='fg=155,bold'                       # Lime green for commands
ZSH_HIGHLIGHT_STYLES[precommand]='fg=204,bold,underline'          # Bright pink for sudo
ZSH_HIGHLIGHT_STYLES[commandseparator]='fg=226,bold'              # Bright yellow for ; | &&
ZSH_HIGHLIGHT_STYLES[hashed-command]='fg=141,bold'                # Purple for valid commands
ZSH_HIGHLIGHT_STYLES[path]='fg=87,bold,underline'                 # Bright cyan for paths
ZSH_HIGHLIGHT_STYLES[globbing]='fg=213,bold'                      # Hot pink for wildcards
ZSH_HIGHLIGHT_STYLES[history-expansion]='fg=219,bold'             # Bright magenta for !!
ZSH_HIGHLIGHT_STYLES[single-hyphen-option]='fg=114,bold'          # Bright green for -a
ZSH_HIGHLIGHT_STYLES[double-hyphen-option]='fg=114,bold'          # Bright green for --help
ZSH_HIGHLIGHT_STYLES[back-quoted-argument]='fg=215,bold'          # Orange for `cmd`
ZSH_HIGHLIGHT_STYLES[single-quoted-argument]='fg=213,bold'        # Hot pink for 'text'
ZSH_HIGHLIGHT_STYLES[double-quoted-argument]='fg=213,bold'        # Hot pink for "text"
ZSH_HIGHLIGHT_STYLES[dollar-double-quoted-argument]='fg=226,bold' # Bright yellow for "$var"
ZSH_HIGHLIGHT_STYLES[back-double-quoted-argument]='fg=219,bold'   # Bright magenta
ZSH_HIGHLIGHT_STYLES[assign]='fg=189,bold'                        # Light purple for VAR=

[ -f /usr/share/fzf/shell/key-bindings.zsh ] && source /usr/share/fzf/shell/key-bindings.zsh
[ -f /usr/share/fzf/shell/completion.zsh ] && source /usr/share/fzf/shell/completion.zsh

# ============================================
# BAT Configuration (better cat)
# ============================================
# Simple cat replacement (uses config file for styling)
alias cat='bat --paging=never'

# Fancy bat with paging for long files
alias batt='bat'

# Plain bat (like original cat)
alias catp='bat --plain --paging=never'

# ============================================
# BAT + FZF Integration
# ============================================
# Preview files with bat in fzf
export FZF_DEFAULT_OPTS="--height 60% --layout=reverse --border --preview-window=right:60%"
export FZF_CTRL_T_OPTS="--preview 'bat --color=always --style=numbers --line-range=:500 {}'"
export FZF_ALT_C_OPTS="--preview 'ls -la --color=always {}'"

# Interactive file finder with bat preview
ff() {
    fzf --preview 'bat --color=always --style=numbers,changes,header --line-range=:500 {}' "$@"
}

# Open file in editor with fzf+bat preview
fe() {
    local file
    file=$(fzf --preview 'bat --color=always --style=numbers,changes,header --line-range=:500 {}')
    [[ -n "$file" ]] && ${EDITOR:-nvim} "$file"
}

# ============================================
# BATGREP - Ripgrep with bat highlighting
# ============================================
# Search with ripgrep, display with bat
batgrep() {
    if [[ $# -eq 0 ]]; then
        echo "Usage: batgrep <pattern> [path] [rg options]"
        return 1
    fi
    rg --color=always --line-number --no-heading "$@" | \
        fzf --ansi \
            --delimiter ':' \
            --preview 'bat --color=always --highlight-line {2} --line-range={2}:+50 {1}' \
            --preview-window 'right:60%:+{2}-10' \
            --bind 'enter:become(${EDITOR:-nvim} {1} +{2})'
}

# Simpler grep with bat output (no fzf)
rg-bat() {
    rg --color=never --line-number "$@" | while IFS=: read -r file line content; do
        bat --color=always --style=numbers,changes --highlight-line "$line" --line-range="$((line > 5 ? line - 5 : 1)):$((line + 5))" "$file" 2>/dev/null
        echo ""
    done
}

# ============================================
# BAT for Man pages and Help
# ============================================
export MANPAGER="sh -c 'col -bx | bat -l man -p'"
export MANROFFOPT="-c"

# Colorized help
help() {
    "$@" --help 2>&1 | bat --plain --language=help
}

# ============================================
# BAT extras
# ============================================
# View git diff with bat
batdiff() {
    git diff --name-only --diff-filter=d "$@" | xargs bat --diff
}

# Show git log with bat preview of changes
gitlog() {
    git log --oneline --color=always "$@" | \
        fzf --ansi --no-sort --reverse \
            --preview 'git show --color=always {1} | bat --style=numbers --color=always -l diff' \
            --bind 'enter:become(git show {1})'
}
source ~/.zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fpath+=~/.zsh/plugins/zsh-completions/src
eval "$(starship init zsh)"
eval "$(zoxide init zsh)"

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"
export PATH="$HOME/bin:$PATH"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Then override to put .local/bin first
export PATH="$HOME/.local/bin:$PATH"

# ============================================
# SECRETS - Source from separate file (not in git)
# ============================================
# Create ~/.secrets with your API keys:
#   export ANTHROPIC_API_KEY="your-key-here"
#   export SSH_AUTH_SOCK="$HOME/.bitwarden/ssh-agent.sock"
[ -f ~/.secrets ] && source ~/.secrets

alias bwunlock='export BW_SESSION=$(bw unlock --raw)'

export EDITOR=nvim
export VISUAL=nvim

export PATH="$HOME/.cargo/bin:$PATH"

alias wpbg='~/.config/rofi/generate-wallpaper-thumbs.sh'

# ============================================
# EZA (modern ls replacement)
# ============================================
alias ls='eza --icons --group-directories-first'
alias ll='eza -la --icons --group-directories-first --git'
alias la='eza -a --icons --group-directories-first'
alias lt='eza --tree --icons --group-directories-first -L 2'
alias ltt='eza --tree --icons --group-directories-first -L 3'

# ============================================
# TLDR with BAT formatting
# ============================================
tldr() {
    command tldr --color always "$@" | bat --style=plain --language=markdown --paging=never
}

# ============================================
# DELTA (git diff viewer) - configure git to use it
# ============================================
# Delta is configured via ~/.gitconfig (see below for setup command)

# ============================================
# PAY-RESPECTS (command autocorrect - Rust thefuck alternative)
# ============================================
eval "$(pay-respects zsh --alias f)"
# Use 'f' after a failed command to get suggestions

# ============================================
# SD (modern sed replacement)
# ============================================
# Usage: sd 'find' 'replace' file.txt
# Or pipe: echo "hello" | sd 'hello' 'world'

# ============================================
# CURLIE (curl with httpie-like output)
# ============================================
export PATH="$HOME/go/bin:$PATH"

# ============================================
# PGCLI (Postgres CLI with autocomplete)
# ============================================
# Just run: pgcli -h hostname -U username -d database
