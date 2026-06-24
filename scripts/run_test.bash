#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
TEST_DIR="$SCRIPT_DIR/../test"

if [[ -f /etc/os-release ]]; then
  OS_ID=$(. /etc/os-release && echo "$ID")
else
  OS_ID=$(uname -s | tr '[:upper:]' '[:lower:]')
fi

dirs=("$TEST_DIR/common")
[[ -d "$TEST_DIR/$OS_ID" ]] && dirs+=("$TEST_DIR/$OS_ID")

bats "${dirs[@]}"
