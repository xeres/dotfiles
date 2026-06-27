#!/usr/bin/env bats

@test "user login shell is zsh" {
    run getent passwd "$USER"
    [[ "$output" == *"/zsh" ]]
}
