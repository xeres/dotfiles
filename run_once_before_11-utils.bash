#!/bin/bash

set -e

sudo apt-get install -y \
    git \
    zip unzip \
    tofrodos \
    jq \
    wslu \
    make build-essential libssl-dev zlib1g-dev \
    libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm \
    libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev
