#!/usr/bin/env bats

@test "user login shell is zsh" {
    run dscl . -read /Users/"$USER" UserShell
    [[ "$output" == *"/zsh"* ]]
}
