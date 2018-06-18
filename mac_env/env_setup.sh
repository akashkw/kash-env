#!/bin/bash

set -x

SCRIPT_PATH=$(cd "$(dirname "$0")"; pwd)
cd $SCRIPT_PATH

# Install brew
yes "" | /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

# Install dependencies
brew update && brew upgrade
brew cask install iterm2
brew install git curl wget tmux fish

# Get newest config data
git pull

# Clear out old environment
sudo rm -rf ~/.vim ~/.vimrc ~/.tmux.conf ~/.config/fish ~/.local/share/omf ~/.config/omf ~/.cache/omf

# Set fish to default shell
if [ "$SHELL" != "/usr/local/bin/fish" ]; then
    sudo sed -i '/usr/local/bin/fish/d' /etc/shells
    sudo sh -c "echo /usr/local/bin/fish >> /etc/shells"
    chsh -s /usr/local/bin/fish
fi

# Initialize Oh My Fish
curl -L https://get.oh-my.fish > install
fish install --noninteractive --yes --path=~/.local/share/omf --config=~/.config/omf
rm install
fish -c "omf install bobthefish"
fish -c "omf update"

# Create config files
cp vimrc ~/.vimrc
cp tmux.conf ~/.tmux.conf
cp config.fish ~/.config/fish/

# Set primary editor to vim in git
git config --global core.editor "vim"

# Install powerline fonts
git clone https://github.com/powerline/fonts
bash fonts/install.sh
sudo rm -rf fonts

# Update iterm2 preferences
sudo rm ~/Library/Preferences/com.googlecode.iterm2.plist
sudo cp com.googlecode.iterm2.plist ~/Library/Preferences
