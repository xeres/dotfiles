#!/bin/bash

set -e

set -o history
unset HISTFILE
rm -rf ~/.bash* ~/.landscape ~/.motd_shown ~/.profile
