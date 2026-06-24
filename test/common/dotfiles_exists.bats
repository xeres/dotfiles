#!/usr/bin/env bats

@test "all dotfiles managed by chezmoi exist in home directory" {
  local files=(
    "$HOME/.gitconfig"
    "$HOME/.vimrc"
    "$HOME/.zshrc"
  )
  local missing=()

  for f in "${files[@]}"; do
    if [ ! -e "$f" ]; then
      missing+=("$f")
    fi
  done

  if [ ${#missing[@]} -gt 0 ]; then
    printf 'missing: %s\n' "${missing[@]}"
    return 1
  fi
}

@test "all directories managed by chezmoi exist in home directory" {
  local dirs=(
  )
  local missing=()

  for d in "${dirs[@]}"; do
    if [ ! -d "$d" ]; then
      missing+=("$d")
    fi
  done

  if [ ${#missing[@]} -gt 0 ]; then
    printf 'missing: %s\n' "${missing[@]}"
    return 1
  fi
}
