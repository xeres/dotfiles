#!/usr/bin/env bash

set -euo pipefail

# Shared libraries required by prebuilt binaries that mise installs.
sudo apt-get update
sudo apt-get install --yes --no-install-recommends \
    libatomic1
