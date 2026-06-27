#!/usr/bin/env bats

setup() {
    export PATH="$HOME/.local/bin:$PATH"
    eval "$(mise activate bash)"
}

@test "mise minimum_release_age is 7d" {
    run mise settings get minimum_release_age
    [[ "$output" == *"7d"* ]]
}

@test "npm applies min-release-age from npmrc" {
    run npm config list
    [[ "$output" == *"before"* ]]
}

@test "uv exclude-newer is configured" {
    run cat "$HOME/.config/uv/uv.toml"
    [[ "$output" == *'exclude-newer = "7 days"'* ]]
}

@test "gitconfig has includeIf for repos/works" {
    grep -q 'includeIf "gitdir:~/repos/works/"' "$HOME/.gitconfig"
}
