#!/usr/bin/env bats

@test "brew is installed" {
    command -v brew
}

@test "user login shell is zsh" {
    run dscl . -read /Users/"$USER" UserShell
    [[ -z "$CI" ]] || skip "shell change not available in CI"
    [[ "$output" == *"/zsh"* ]]
}
