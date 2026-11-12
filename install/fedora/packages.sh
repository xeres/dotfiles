#!/usr/bin/env bash

set -euo pipefail

# Shared libraries required by prebuilt binaries that mise installs.
sudo dnf install --assumeyes \
    libatomic
