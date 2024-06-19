#!/usr/bin/zsh

mkdir -p "$HOME/.local/bin"
export PATH="$HOME/.local/bin:$PATH"

export LESSHISTFILE=-

export HISTSIZE=10000
export SAVEHIST=20000
export HISTFILE=~/.zsh_history
