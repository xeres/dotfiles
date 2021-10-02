#!/bin/bash

set -e

sudo apt-get install -y tmux
if [ ! -d ~/.tmux/plugins/tpm ]; then
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

    cat /dev/null | tmux -C
    tmux run-shell ~/.tmux/plugins/tpm/bindings/install_plugins
    tmux kill-session -t $(tmux list-sessions -F '#{session_id}' | tail -1) || :
fi
