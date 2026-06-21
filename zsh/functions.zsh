# Shell functions.

# mkcd — create a directory and cd into it.
mkcd() {
  mkdir -p -- "$1" && cd -- "$1"
}

# extract — unpack most archive types.
extract() {
  if [[ -z "$1" || ! -f "$1" ]]; then
    echo "usage: extract <archive>"
    return 1
  fi
  case "$1" in
    *.tar.bz2|*.tbz2) tar xjf "$1" ;;
    *.tar.gz|*.tgz)   tar xzf "$1" ;;
    *.tar.xz)         tar xJf "$1" ;;
    *.tar)            tar xf  "$1" ;;
    *.bz2)            bunzip2 "$1" ;;
    *.gz)             gunzip  "$1" ;;
    *.zip)            unzip   "$1" ;;
    *.Z)              uncompress "$1" ;;
    *.7z)             7z x    "$1" ;;
    *) echo "extract: don't know how to handle '$1'" && return 1 ;;
  esac
}

# gclone — clone a repo and cd into it.
gclone() {
  git clone "$1" && cd "$(basename "${1%.git}")"
}
