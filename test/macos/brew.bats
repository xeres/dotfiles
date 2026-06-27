#!/usr/bin/env bats

@test "brew is installed" {
    command -v brew
}
