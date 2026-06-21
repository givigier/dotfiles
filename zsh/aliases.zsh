# Aliases. Prefer abbreviations (see zsh/abbreviations) for things you want
# expanded in your history; use aliases for things you never need to see expanded.

# ls -> eza
if command -v eza &>/dev/null; then
  alias ls='eza --group-directories-first --icons=auto'
  alias ll='eza -l --group-directories-first --icons=auto --git'
  alias la='eza -la --group-directories-first --icons=auto --git'
  alias lt='eza --tree --level=2 --icons=auto'
else
  alias ll='ls -lh'
  alias la='ls -lAh'
fi

# cat -> bat
if command -v bat &>/dev/null; then
  alias cat='bat --paging=never'
  export BAT_THEME="ansi"
fi

# Safer defaults
alias cp='cp -i'
alias mv='mv -i'
alias rm='rm -i'
alias mkdir='mkdir -p'

# Quick edits
alias dotfiles='cd "$DOTFILES"'
alias zshconfig='${EDITOR} "$DOTFILES/zsh"'
alias reload='exec zsh'

# Misc
alias path='echo $PATH | tr ":" "\n"'
alias ip='curl -s ifconfig.me; echo'
