#!/usr/bin/env bats

setup() {
    export PATH="$HOME/.local/bin:$PATH"
    eval "$(mise activate bash)"
}

@test "mise is installed" {
    command -v mise
}

@test "node is available" {
    command -v node
}

@test "npm is available" {
    command -v npm
}

@test "uv is available" {
    command -v uv
}

@test "gh is available" {
    command -v gh
}

@test "aws is available" {
    command -v aws
}

@test "starship is available" {
    command -v starship
}
