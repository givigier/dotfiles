# dotfiles

Reproducible macOS setup. From a freshly-wiped Mac to fully configured with a
single command.

## Bootstrap a new Mac

```bash
git clone https://github.com/givigier/dotfiles.git ~/Projects/dotfiles
~/Projects/dotfiles/install
```

`install` will, idempotently:

1. Install the Xcode Command Line Tools
2. Install [Homebrew](https://brew.sh)
3. Clone this repo (if not already cloned)
4. `brew bundle` — install every CLI, app and App Store app in the [`Brewfile`](Brewfile)
5. Run [`setup`](setup) — symlink all configs into place
6. `mise install` — install language runtimes

Then apply the macOS system preferences (kept separate because it restarts apps):

```bash
~/Projects/dotfiles/macos/set-defaults.sh
```

[`macos/set-defaults.sh`](macos/set-defaults.sh) configures the keyboard, trackpad
& mouse, Finder, Dock, menu bar, screenshots, Mail, Safari, the lock screen and
appearance (blue accent, dark mode), plus a round of **security hardening**:
FileVault, the application firewall (stealth mode + block all incoming), disabling
Siri and the Guest user, and turning off every Sharing service.

> **Heads up:** it prompts for your admin password (`sudo`). For the firewall,
> Sharing and power settings to apply, grant your terminal **Full Disk Access**
> (System Settings → Privacy & Security). It also **disables Remote Login (SSH)**,
> and some changes (accent color, login window, trackpad) only take full effect
> after a logout/restart.

## Manual steps (can't be automated)

A few things require a GUI toggle or an admin prompt and can't live in a script:

- **Obsidian CLI** — the `obsidian` cask installs the app only. To get the
  `obsidian` command: in Obsidian, **Settings → General → enable "Command line
  interface"**, then follow the on-screen registration (it symlinks
  `/usr/local/bin/obsidian` and copies the binary to `~/.local/bin/obsidian`,
  which is already on `PATH`). The app must be running for commands to work.
  Docs: <https://obsidian.md/cli>
- **1Password (install manually)** — *not* in the Brewfile. Download it from
  <https://1password.com/downloads>, sign in, then enable *Settings → Developer
  → "Use the SSH agent"* to use it for git commit signing.
- **Sign in** to the apps that need it (Spotify, Telegram, Todoist, etc.).
- **Time Machine backups** — `set-defaults.sh` does *not* configure backups (no
  destination is hard-coded). Add an encrypted disk in **System Settings → General
  → Time Machine**.
- **Wi-Fi "Ask to join networks / hotspots"** — no reliable `defaults` key exists,
  so set these in **System Settings → Wi-Fi** (or ship a configuration profile).

## What's inside

| Path | What it configures |
|---|---|
| `Brewfile` | CLIs (`brew`), GUI apps (`cask`), App Store apps (`mas`) |
| `zsh/` | `zshrc`, aliases, functions, abbreviations |
| `starship/` | Prompt |
| `git/` | Git config + global gitignore |
| `ssh/` | SSH client config |
| `mise/` | Default language runtimes (Ruby, Node…) |
| `ghostty/` | Terminal emulator |
| `tmux/` | Terminal multiplexer |
| `cursor/` | Cursor `settings.json` + extension list |
| `ai/` | Global guidance for AI assistants (`~/.claude/CLAUDE.md`) |
| `macos/` | System preferences + security hardening (`set-defaults.sh`) |
| `bin/` | Personal scripts (linked to `~/.bin`) |

## Shell

zsh + [Starship](https://starship.rs) prompt, with a fish-like experience via
plugins:

- [`zsh-autosuggestions`](https://github.com/zsh-users/zsh-autosuggestions) — ghost-text suggestions from history
- [`zsh-syntax-highlighting`](https://github.com/zsh-users/zsh-syntax-highlighting) — real-time command highlighting
- [`zsh-abbr`](https://github.com/olets/zsh-abbr) — fish-style abbreviations (see [`zsh/abbreviations`](zsh/abbreviations))
- [`fzf-tab`](https://github.com/Aloxaf/fzf-tab) — fuzzy completion menu

### Abbreviations

Edit [`zsh/abbreviations`](zsh/abbreviations) directly, or run `abbr add foo='bar'`
from any shell — it writes straight back to that versioned file. Type the key
then <kbd>Space</kbd> to expand it inline.

### Git & Docker aliases

Adapted verbatim from [prezto](https://github.com/sorin-ionescu/prezto/tree/master/modules):
[`zsh/git.zsh`](zsh/git.zsh) and [`zsh/docker.zsh`](zsh/docker.zsh) (helper
functions in [`zsh/git-functions.zsh`](zsh/git-functions.zsh)). Note prezto's
scheme differs from common habits — e.g. `gs` = `git stash`, while status is
`gws`/`gwS`, and Docker aliases are `dk`-prefixed (`dkps`, `dkcU`, …).

## Secrets

Secrets (SSH keys, tokens, credentials) are **never** committed. This repo is
public. Handle them manually on each machine:

- **Auth & signing**: both come from the 1Password SSH agent — auth via
  `IdentityAgent` in [`ssh/config`](ssh/config), commit signing via `op-ssh-sign`
  in [`git/config`](git/config). Create your keys in 1Password, enable the SSH
  agent (Settings → Developer), and add the key to GitHub.
- **Machine-specific config**: put anything local/secret in `~/.zshrc.local`
  (sourced automatically, git-ignored).

## Maintenance

```bash
# Re-apply symlinks after adding configs
./setup

# Capture currently-installed Homebrew packages back into the Brewfile
brew bundle dump --file=Brewfile --force --describe

# Update everything
brew update && brew upgrade && mise upgrade
```
