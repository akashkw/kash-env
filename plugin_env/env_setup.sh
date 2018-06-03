#!/bin/bash
set -x

SCRIPT_PATH=$(dirname $(readlink -f $0))
cd $SCRIPT_PATH

# Install dependencies
sudo apt-get update && sudo apt-get upgrade
sudo apt-get install -y curl git vim tmux

# Clear out old environment
rm -rf ~/.vim ~/.vimrc ~/.tmux.conf

# Install Pathogen
mkdir -p ~/.vim/autoload ~/.vim/bundle
curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim

# Install Airline
git clone https://github.com/vim-airline/vim-airline ~/.vim/bundle/vim-airline

# Install Airline Themes
git clone https://github.com/vim-airline/vim-airline-themes ~/.vim/bundle/vim-airline-themes

# Install Tmux Airline
git clone https://github.com/edkolev/tmuxline.vim ~/.vim/bundle/tmuxline.vim

# Install Powerline Fonts
wget https://github.com/powerline/powerline/raw/develop/font/PowerlineSymbols.otf
mkdir ~/.fonts
mv PowerlineSymbols.otf ~/.fonts/
fc-cache -vf ~/.fonts/
wget https://github.com/powerline/powerline/raw/develop/font/10-powerline-symbols.conf
mkdir -p ~/.config/fontconfig/conf.d
mv 10-powerline-symbols.conf ~/.config/fontconfig/conf.d/

# Create Config files
cp vimrc ~/.vimrc
cp tmux.conf ~/.tmux.conf

