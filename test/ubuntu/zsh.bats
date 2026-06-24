#!/usr/bin/env bats

@test "zsh is installed" {
  command -v zsh
}

@test "user login shell is zsh" {
  run getent passwd "$USER"
  [[ "$output" == *"/zsh" ]]
}
