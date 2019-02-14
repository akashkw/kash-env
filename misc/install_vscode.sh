#!/bin/bash

set -x

SCRIPT_PATH=$(dirname $(readlink -f $0))
cd $SCRIPT_PATH
cd /tmp

sudo wget https://go.microsoft.com/fwlink/?LinkID=760868
sudo dpkg -i code*.deb
sudo apt-get install -f -y
sudo rm code*.deb
