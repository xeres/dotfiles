#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
TEST_DIR="$SCRIPT_DIR/../test"

# OS 検出
case "$(uname -s)" in
  Darwin) os=macos ;;
  Linux)
    # shellcheck source=/dev/null
    . /etc/os-release
    case " ${ID:-} ${ID_LIKE:-} " in
      *" debian "*) os=ubuntu ;;
      *" fedora "*) os=fedora ;;
      *) echo "Unsupported Linux distribution: ${ID:-unknown}" >&2; exit 1 ;;
    esac
    ;;
  *)      echo "Unsupported OS: $(uname -s)" >&2; exit 1 ;;
esac

echo "=== Common tests ==="
bats "$TEST_DIR/common"

if [[ -d "$TEST_DIR/$os" && -n "$(ls "$TEST_DIR/$os"/*.bats 2>/dev/null)" ]]; then
  echo "=== OS-specific tests ($os) ==="
  bats "$TEST_DIR/$os"
fi
