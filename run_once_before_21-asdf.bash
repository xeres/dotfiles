#!/bin/bash

set -e

export ASDF_DIR="${ZI_HOME:-$HOME/.zi}/plugins/asdf-vm---asdf"
export ASDF_DATA_DIR="${XDG_DATA_DIR:-$HOME/.local/share}/asdf"

if [ ! -d "$ASDF_DIR" ]; then
    git clone https://github.com/asdf-vm/asdf $ASDF_DIR
fi

source "${ASDF_DIR:-${ZI_HOME:-$HOME/.zi}/plugins/asdf}/asdf.sh"

function install_asdf_global_plugin() {
  asdf plugin add "$1" || true
  case "$1" in
    # ruby) CONFIGURE_OPTS=--disable-install-doc asdf install "$1" "$2" ;;
    # rust) RUST_WITHOUT=rust-docs,rust-other-component asdf install "$1" "$2" ;;
    *) asdf install "$1" "$2" ;;
  esac
  asdf global "$1" "$2"
  asdf reshim "$1" "$2"
}

install_asdf_global_plugin direnv latest
