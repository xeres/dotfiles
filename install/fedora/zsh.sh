#!/usr/bin/env bash

set -euo pipefail

# util-linux-user provides chsh, which minimal images (e.g. amazonlinux:2023) lack.
sudo dnf install --assumeyes \
    zsh \
    util-linux-user
sudo chsh -s "$(command -v zsh)" "$USER"
