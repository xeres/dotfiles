#!/usr/bin/env bats

@test "user login shell is zsh" {
    run dscl . -read /Users/"$USER" UserShell
    [[ -z "$CI" ]] || skip "shell change not available in CI (actual: $output)"
    [[ "$output" == *"/zsh"* ]]
}
