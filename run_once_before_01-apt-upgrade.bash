#!/bin/bash

set -e

if [ ! -f /etc/apt/apt.conf.d/00-no-install-recommends ]; then
    sudo tee /etc/apt/apt.conf.d/00-no-install-recommends << __EOF__ >/dev/null
APT::Install-Recommends 0;
APT::Install-Suggests 0;
__EOF__
fi

sudo apt-get update
sudo apt-get upgrade -y
