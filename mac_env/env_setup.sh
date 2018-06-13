#!/bin/bash
set -x
SCRIPT_PATH=$(cd "$(dirname "$0")"; pwd)
cd $SCRIPT_PATH

yes "" | /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

brew update && brew upgrade

brew cask install iterm2
brew install git curl wget tmux fish

git pull

# Clear out old environment
rm -rf ~/.vim ~/.vimrc ~/.tmux.conf ~/.config/fish ~/.local/share/omf ~/.config/omf ~/.cache/omf

# Initialize Oh My Fish
curl -L https://get.oh-my.fish > install
fish install --noninteractive --yes --path=~/.local/share/omf --config=~/.config/omf
rm install
fish -c "omf install bobthefish"
fish -c "omf update"

sudo echo /usr/local/bin/fish >> /etc/shells

# Initialize Fish
if [ "$SHELL" != "/usr/local/bin/fish" ]; then
    chsh -s /usr/local/bin/fish
fi

