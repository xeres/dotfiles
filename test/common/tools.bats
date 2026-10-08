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

@test "python is available" {
    command -v python
}

@test "UV_PYTHON points to the mise-managed python" {
    [ -n "$UV_PYTHON" ]
    [ "$(cd "$(dirname "$UV_PYTHON/bin/python")" && pwd -P)" \
      = "$(cd "$(dirname "$(mise which python)")" && pwd -P)" ]
}

@test "uv uses the mise-managed python" {
    [ "$(cd "$(dirname "$(uv python find --no-python-downloads)")" && pwd -P)" \
      = "$(cd "$(dirname "$(mise which python)")" && pwd -P)" ]
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

@test "herdr is available" {
    command -v herdr
}

@test "op is available" {
    command -v op
}

@test "lazygit is available" {
    command -v lazygit
}

@test "jq is available" {
    command -v jq
}

@test "yq is available" {
    command -v yq
}
