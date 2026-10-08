#!/usr/bin/env bats

@test "PATH contains ~/.local/bin" {
    zsh -c 'echo "$PATH"' | grep -q "$HOME/.local/bin"
}

@test "PATH contains mise shims" {
    zsh -c 'echo "$PATH"' | grep -q "$HOME/.local/share/mise/shims"
}

# Interactive zsh runs .zshrc, which spawns background daemons (e.g. `op
# completion zsh` starts `op daemon --background`). Those daemons inherit
# bats' TAP stream on FD 3 and keep it open, so bats waits for EOF forever.
# Close FD 3 (and stdin) for the whole zsh process tree.
# https://bats-core.readthedocs.io/en/stable/writing-tests.html#file-descriptor-3-read-this-if-bats-hangs
@test "zinit is loaded" {
    zsh -i -c 'whence zinit' </dev/null 2>/dev/null 3>&-
}

@test "starship is initialized in zsh" {
    zsh -i -c 'echo "$STARSHIP_SHELL"' </dev/null 2>/dev/null 3>&- | grep -q "zsh"
}
