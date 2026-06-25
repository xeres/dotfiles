#!/usr/bin/env bash

set -euo pipefail

curl -fsSL https://mise.jdx.dev/install.sh | sh
~/.local/bin/mise install
