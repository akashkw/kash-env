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

# Install Powerline Fonts
wget https://github.com/powerline/powerline/raw/develop/font/PowerlineSymbols.otf
mkdir ~/.fonts
mv PowerlineSymbols.otf ~/.fonts/
fc-cache -vf ~/.fonts/
wget https://github.com/powerline/powerline/raw/develop/font/10-powerline-symbols.conf
mkdir -p ~/.config/fontconfig/conf.d
mv 10-powerline-symbols.conf ~/.config/fontconfig/conf.d/

# Install Pathogen
mkdir -p ~/.vim/autoload ~/.vim/bundle
curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim

# Install Airline
git clone https://github.com/vim-airline/vim-airline ~/.vim/bundle/vim-airline
vim -u NONE -c "helptags ~/.vim/bundle/vim-airline/doc" -c q

# Install Airline Themes
git clone https://github.com/vim-airline/vim-airline-themes ~/.vim/bundle/vim-airline-themes
vim -u NONE -c "helptags ~/.vim/bundle/vim-airline-themes/doc" -c q

# Install Tmux Airline
git clone https://github.com/edkolev/tmuxline.vim ~/.vim/bundle/tmuxline.vim
vim -u NONE -c "helptags ~/.vim/bundle/tmuxline.vim/doc" -c q

# Install Fugitive
git clone https://github.com/tpope/vim-fugitive.git ~/.vim/bundle/vim-fugitive
vim -u NONE -c "helptags ~/.vim/bundle/vim-fugitive/doc" -c q

# TEMPORARY REVERT UNTIL VIM_FUGITIVE BUGFIX IS RELEASED
# ------------------------------------------------------
cd ~/.vim/bundle/vim-fugitive
git reset --hard dd4d4c7
cd $SCRIPT_PATH
# ------------------------------------------------------

# Install NERDCommenter
git clone https://github.com/scrooloose/nerdcommenter.git ~/.vim/bundle/nerdcommenter
vim -u NONE -c "helptags ~/.vim/bundle/nerdcommenter/doc" -c q

