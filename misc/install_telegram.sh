#!/bin/bash

set -x

SCRIPT_PATH=$(dirname $(readlink -f $0))
cd $SCRIPT_PATH

sudo apt-get update
sudo apt-get install -y telegram-desktop

