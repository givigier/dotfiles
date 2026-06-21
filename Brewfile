# Brewfile — declarative list of everything Homebrew should install.
# Apply with:  brew bundle  (or it runs automatically from ./install)

# ----------------------------------------------------------------------------
# Taps
# ----------------------------------------------------------------------------
tap "homebrew/bundle"
tap "olets/tap", trusted: true   # zsh-abbr lives here, not in homebrew-core

# ----------------------------------------------------------------------------
# CLIs (brew)
# ----------------------------------------------------------------------------
# Core unix niceties
brew "coreutils"
brew "curl"
brew "wget"

# Git & friends
brew "git"
brew "gh"
brew "git-lfs"      # large file versioning
brew "lazygit"

# Runtime / env management
brew "mise"
brew "direnv"
brew "rustup"       # Rust toolchain manager (keg-only; toolchain set up by ./install)

# Prompt
brew "starship"

# Modern CLI replacements / search
brew "fzf"          # fuzzy finder
brew "ripgrep"      # fast grep (rg)
brew "fd"           # fast find
brew "bat"          # cat with wings
brew "eza"          # modern ls
brew "zoxide"       # smarter cd

# Data wrangling
brew "jq"
brew "yq"
brew "sqlite"       # SQLite CLI

# System / misc
brew "btop"         # resource monitor
brew "tmux"         # terminal multiplexer
brew "mas"          # Mac App Store CLI
brew "mole"         # deep clean & optimize macOS

# zsh experience (fish-like, via plugins)
brew "zsh-autosuggestions"
brew "zsh-syntax-highlighting"
brew "zsh-abbr"
# Note: fzf-tab is cloned by ./setup (not available as a formula).

# ----------------------------------------------------------------------------
# Fonts
# ----------------------------------------------------------------------------
cask "font-jetbrains-mono-nerd-font"

# ----------------------------------------------------------------------------
# GUI apps (cask)
# ----------------------------------------------------------------------------
# NOTE: the 1Password app is intentionally NOT auto-installed. Install it
# manually from https://1password.com/downloads (account/license required).
# The CLI below works standalone and is safe to auto-install.
cask "1password-cli"
cask "claude"
cask "claude-code"
cask "cloudflare-warp"
cask "cursor"
cask "discord"
cask "displaylink"
cask "firefox"
cask "ghostty"
cask "google-chrome"
cask "hammerspoon"
cask "obsidian"
cask "orbstack"
cask "spotify"
cask "telegram"
cask "todoist-app"
cask "zoom"

# ----------------------------------------------------------------------------
# Mac App Store apps (mas)
# IDs verified against common App Store listings. After installing `mas`,
# run `mas list` on a configured machine to confirm/add your own IDs.
# ----------------------------------------------------------------------------
mas "Be Focused Pro", id: 961632517
mas "Tailscale", id: 1475387142