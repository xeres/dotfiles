#!/usr/bin/env bats

@test "dotfiles exist in home directory" {
    local files=(
        "$HOME/.config/mise/config.toml"
        "$HOME/.config/uv/uv.toml"
        "$HOME/.gitconfig"
        "$HOME/.npmrc"
        "$HOME/.vimrc"
        "$HOME/.zshenv"
        "$HOME/.zshrc"
    )

    local missing=()
    for f in "${files[@]}"; do
        [[ -e "$f" ]] || missing+=("$f")
    done

    if (( ${#missing[@]} )); then
        printf 'missing: %s\n' "${missing[@]}"
        return 1
    fi
}

@test "repos/works directory exists" {
    [[ -d "$HOME/repos/works" ]]
}
