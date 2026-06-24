#!/usr/bin/env bash

set -euo pipefail

sudo apt-get update
sudo apt-get install --yes --no-install-recommends zsh
sudo chsh -s "$(which zsh)" "$USER"
