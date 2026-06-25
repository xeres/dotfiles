#!/usr/bin/env bats

setup() {
  export PATH="$HOME/.local/share/zinit/plugins/mise:$PATH"
  eval "$(mise activate bash)"
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

@test "npm applies min-release-age from npmrc" {
  run npm config list
  [[ "$output" == *"before"* ]]
}
