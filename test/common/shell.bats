#!/usr/bin/env bats

@test "PATH contains ~/.local/bin" {
    zsh -c 'echo "$PATH"' | grep -q "$HOME/.local/bin"
}

@test "PATH contains mise shims" {
    zsh -c 'echo "$PATH"' | grep -q "$HOME/.local/share/mise/shims"
}

@test "zinit is loaded" {
    zsh -i -c 'whence zinit' 2>/dev/null
}

@test "starship is initialized in zsh" {
    zsh -i -c 'echo "$STARSHIP_SHELL"' 2>/dev/null | grep -q "zsh"
}
