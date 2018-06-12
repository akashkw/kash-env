#!/bin/bash
set -x

SCRIPT_PATH=$(dirname $(readlink -f $0))
cd $SCRIPT_PATH

# Install dependencies
sudo apt-get update -y && sudo apt-get upgrade -y
sudo apt-get install -y curl git vim tmux

# Get newest config data
git pull

# Clear out old environment
rm -rf ~/.vim ~/.vimrc ~/.tmux.conf

# Set primary editor to vim in bashrc
sed -i '/export VISUAL/d' ~/.bashrc
sed -i '/export EDITOR/d' ~/.bashrc
echo export VISUAL=vim >> ~/.bashrc
echo export EDITOR=vim >> ~/.bashrc
git config --global core.editor "vim"

# Create Config files
cp vimrc ~/.vimrc
cp tmux.conf ~/.tmux.conf

