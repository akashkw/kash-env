#!/bin/bash


# TODO
# Integrate powerline fonts
# Get vim plugins
# Get color scheme for vim and iterm



set -x
SCRIPT_PATH=$(cd "$(dirname "$0")"; pwd)
cd $SCRIPT_PATH

yes "" | /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

brew update && brew upgrade

brew cask install iterm2
brew install git curl wget tmux fish

git pull

# Clear out old environment
sudo rm -rf ~/.vim ~/.vimrc ~/.tmux.conf ~/.config/fish ~/.local/share/omf ~/.config/omf ~/.cache/omf

# Initialize Oh My Fish
curl -L https://get.oh-my.fish > install
fish install --noninteractive --yes --path=~/.local/share/omf --config=~/.config/omf
rm install
fish -c "omf install bobthefish"
fish -c "omf update"

sudo sed -i '/usr/local/bin/fish/d' /etc/shells
sudo sh -c "echo /usr/local/bin/fish >> /etc/shells"

# Initialize Fish
if [ "$SHELL" != "/usr/local/bin/fish" ]; then
    chsh -s /usr/local/bin/fish
fi

git config --global core.editor "vim"

# Create config files
cp vimrc ~/.vimrc
cp tmux.conf ~/.tmux.conf
cp config.fish ~/.config/fish/
