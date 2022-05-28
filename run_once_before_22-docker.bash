#!/bin/bash

set -e

IPTABLES_CMD=$(readlink /etc/alternatives/iptables)

if [ "$IPTABLES_CMD" != "/usr/sbin/iptables-legacy" ]; then
    sudo update-alternatives --set iptables /usr/sbin/iptables-legacy
fi

sudo apt-get install \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/trusted.gpg.d/docker.gpg

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/trusted.gpg.d/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update
sudo apt-get install \
    docker-ce \
    docker-ce-cli \
    containerd.io \
    docker-compose-plugin

sudo usermod -aG docker ${USER}
sudo service docker start
