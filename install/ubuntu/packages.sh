#!/usr/bin/env bash

set -euo pipefail

# Shared libraries required by prebuilt binaries that mise installs.
# - libatomic1: required by node (nodejs.org official builds)
sudo apt-get update
sudo apt-get install --yes --no-install-recommends \
    libatomic1
