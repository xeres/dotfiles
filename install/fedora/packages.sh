#!/usr/bin/env bash

set -euo pipefail

# Shared libraries required by prebuilt binaries that mise installs.
# - libatomic: required by node (nodejs.org official builds)
sudo dnf install --assumeyes \
    libatomic
