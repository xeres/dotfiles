#!/usr/bin/env bats

@test "mise is available in zsh interactive session" {
  run zsh -i -c 'command -v mise'
  [ "$status" -eq 0 ]
}

@test "mise activate is working" {
  run zsh -i -c 'mise doctor 2>&1 | grep -q "activated"'
  [ "$status" -eq 0 ]
}
