#!/bin/bash

set -e

sudo tee -a /etc/wsl.conf << __EOF__ >/dev/null
[automount]
ldconfig = false
__EOF__

sudo umount -f /usr/lib/wsl/lib
sudo rm -f /etc/ld.so.conf.d/ld.wsl.conf
