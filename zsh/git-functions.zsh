# Helper functions used by the prezto git aliases in zsh/git.zsh.
# Ported verbatim from prezto's git module (with a local `is-true`).
# https://github.com/sorin-ionescu/prezto/tree/master/modules/git/functions

# Returns true for 1/yes/true/on (used to test `git rev-parse` booleans).
function is-true {
  [[ -n "$1" && "$1" == (1|[Tt]rue|[Yy]es|[Oo]n) ]]
}

# Displays the path to the Git directory.
function git-dir {
  local git_dir="${$(command git rev-parse --git-dir):A}"
  if [[ -n "$git_dir" ]]; then
    print "$git_dir"
    return 0
  else
    print "$0: not a repository: $PWD" >&2
    return 1
  fi
}

# Displays the path to the working tree root.
function git-root {
  local root="$(command git rev-parse --show-toplevel 2> /dev/null)"
  if [[ -n "$root" ]]; then
    print "$root"
    return 0
  else
    print "$0: not a repository work tree: $PWD" >&2
    return 1
  fi
}

# Displays the current Git branch.
function git-branch-current {
  if ! command git rev-parse 2> /dev/null; then
    print "$0: not a repository: $PWD" >&2
    return 1
  fi
  local ref="$(command git symbolic-ref HEAD 2> /dev/null)"
  if [[ -n "$ref" ]]; then
    print "${ref#refs/heads/}"
    return 0
  else
    return 1
  fi
}

# Lists lost Git commits.
function git-commit-lost {
  if ! is-true "$(command git rev-parse --is-inside-work-tree 2> /dev/null)"; then
    print "$0: not a repository work tree: $PWD" >&2
    return 1
  fi
  command git fsck 2> /dev/null \
    | grep "^dangling commit" \
    | awk '{print $3}' \
    | command git log \
        --date-order \
        --no-walk \
        --stdin \
        --pretty=format:${_git_log_oneline_format}
}

# Asks for confirmation before clearing the Git stash.
function git-stash-clear-interactive {
  if ! is-true "$(command git rev-parse --is-inside-work-tree 2> /dev/null)"; then
    print "$0: not a repository work tree: $PWD" >&2
    return 1
  fi
  local stashed
  if [[ -f "$(git-dir)/refs/stash" ]]; then
    stashed=${#${(f)"$(command git stash list 2> /dev/null)"}}
    if (( $stashed > 0 )); then
      if read -q "?Clear $stashed stashed state(s) [y/N]? "; then
        command git stash clear
      fi
    fi
  fi
}

# Lists dropped Git stashed states.
function git-stash-dropped {
  if ! is-true "$(command git rev-parse --is-inside-work-tree 2> /dev/null)"; then
    print "$0: not a repository work tree: $PWD" >&2
    return 1
  fi
  command git fsck --unreachable 2> /dev/null \
    | grep 'commit' \
    | awk '{print $3}' \
    | command git log \
        --pretty=format:$_git_log_oneline_format \
        --extended-regexp \
        --grep="${1:-(WIP )?[Oo]n [^:]+:}" \
        --merges \
        --no-walk \
        --stdin
}

# Recovers dropped Git stashed states.
function git-stash-recover {
  if ! is-true "$(command git rev-parse --is-inside-work-tree 2> /dev/null)"; then
    print "$0: not a repository work tree: $PWD" >&2
    return 1
  fi
  local commit
  for commit in "$@"; do
    command git update-ref \
      -m "$(command git log -1 --pretty="format:%s" "$commit")" refs/stash "$commit"
  done
}

# Moves a Git submodule.
function git-submodule-move {
  if ! is-true "$(command git rev-parse --is-inside-work-tree 2> /dev/null)"; then
    print "$0: not a repository work tree: $PWD" >&2
    return 1
  elif [[ "$PWD" != "$(git-root)" ]]; then
    print "$0: must be run from the root of the work tree" >&2
    return 1
  fi
  local src="$1"
  local dst="$2"
  local url
  url="$(command git config --file "$(git-root)/.gitmodules" --get "submodule.${src}.url")"
  if [[ -z "$url" ]]; then
    print "$0: submodule not found: $src" >&2
    return 1
  fi
  mkdir -p "$dst:h"
  git-submodule-remove "$src"
  command git submodule add "$url" "$dst"
  return 0
}

# Removes a Git submodule.
function git-submodule-remove {
  if ! is-true "$(command git rev-parse --is-inside-work-tree 2> /dev/null)"; then
    print "$0: not a repository work tree: $PWD" >&2
    return 1
  elif [[ "$PWD" != "$(git-root)" ]]; then
    print "$0: must be run from the root of the work tree" >&2
    return 1
  elif ! command git config --file .gitmodules --get "submodule.${1}.path" &> /dev/null; then
    print "$0: submodule not found: $1" >&2
    return 1
  fi
  command git config --file "$(git-dir)/config" --remove-section "submodule.${1}" &> /dev/null
  command git config --file "$(git-root)/.gitmodules" --remove-section "submodule.${1}" &> /dev/null
  command git add .gitmodules
  command git rm --cached -rf "$1"
  rm -rf "$1"
  rm -rf "$(git-dir)/modules/$1"
  return 0
}

# Opens a GitHub repository in the default browser ($BROWSER).
function git-hub-browse {
  if ! is-true "$(command git rev-parse --is-inside-work-tree 2> /dev/null)"; then
    print "$0: not a repository work tree: $PWD" >&2
    return 1
  fi
  local remotes remote references reference file url
  remote="${1:-origin}"
  remotes=($(command git remote show))
  if (( $remotes[(i)$remote] == $#remotes + 1 )); then
    print "$0: remote not found: $remote" >&2
    return 1
  fi
  url=$(
    command git remote get-url "$remote" \
        | sed -En "s#(git@|https?://)(github.com)(:|/)(.+)/(.+)\.git#https://\2/\4/\5#p"
  )
  reference="${${2:-$(git-branch-current)}:-HEAD}"
  references=(
    HEAD
    ${${(f)"$(command git ls-remote --heads --tags "$remote")"}##*refs/(heads|tags)/}
  )
  if (( $references[(i)$reference] == $#references + 1 )); then
    print "$0: branch or tag not found: $reference" >&2
    return 1
  fi
  if [[ "$reference" == 'HEAD' ]]; then
    reference="$(command git rev-parse HEAD 2> /dev/null)"
  fi
  file="$3"
  if [[ -n "$url" ]]; then
    url="$url/tree/$reference/$file"
    if [[ -n "$BROWSER" ]]; then
      "$BROWSER" "$url"
      return 0
    else
      print "$0: browser not set or set to a non-existent browser" >&2
      return 1
    fi
  else
    print "$0: not a Git repository or remote not set" >&2
    return 1
  fi
}
