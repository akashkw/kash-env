#!/bin/bash
set -x

SCRIPT_PATH=$(dirname $(readlink -f $0))
cd $SCRIPT_PATH

# Install dependencies
sudo apt-get update && sudo apt-get upgrade
sudo apt-get install -y curl git vim tmux

# Clear out old environment
rm -rf ~/.vim ~/.vimrc ~/.tmux.conf

# Create Config files
cp vimrc ~/.vimrc
cp tmux.conf ~/.tmux.conf

