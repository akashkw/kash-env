#!/bin/bash

set -x

SCRIPT_PATH=$(cd "$(dirname "$0")"; pwd)
cd $SCRIPT_PATH

# Install brew
yes "" | /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

# Install dependencies
brew update && brew upgrade
brew cask install iterm2
brew cask install google-cloud-sdk
brew install git vim curl wget tmux fish python3
brew link --overwrite python
sudo -H pip3 install --upgrade pip
sudo -H pip3 install pylint

# Clear out old environment
sudo rm -rf ~/.vim ~/.vimrc ~/.tmux.conf ~/.config/fish ~/.local/share/omf ~/.config/omf ~/.cache/omf

# Set fish to default shell
if [ "$SHELL" != "/usr/local/bin/fish" ]; then
    sudo sed -i '/usr/local/bin/fish/d' /etc/shells
    sudo sh -c "echo /usr/local/bin/fish >> /etc/shells"
    chsh -s /usr/local/bin/fish
fi

# Initialize Oh My Fish
curl -L http://get.oh-my.fish > install
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

# Install pathogen
mkdir -p ~/.vim/autoload ~/.vim/bundle
curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim

# Install colorschemes
git clone  https://github.com/flazz/vim-colorschemes.git ~/.vim/bundle/colorschemes
curl https://raw.githubusercontent.com/nightsense/wonka/master/colors/wonka-dark.vim > ~/.vim/bundle/colorschemes/colors/wonka-dark.vim

# Install airline
git clone https://github.com/vim-airline/vim-airline ~/.vim/bundle/vim-airline
vim -u NONE -c "helptags ~/.vim/bundle/vim-airline/doc" -c q

# Install airline-themes
git clone https://github.com/vim-airline/vim-airline-themes ~/.vim/bundle/vim-airline-themes
vim -u NONE -c "helptags ~/.vim/bundle/vim-airline-themes/doc" -c q

# Install tmuxline
git clone https://github.com/edkolev/tmuxline.vim ~/.vim/bundle/tmuxline.vim
vim -u NONE -c "helptags ~/.vim/bundle/tmuxline.vim/doc" -c q

# Install fugitive
git clone https://github.com/tpope/vim-fugitive.git ~/.vim/bundle/vim-fugitive
vim -u NONE -c "helptags ~/.vim/bundle/vim-fugitive/doc" -c q

# Install nerdcommenter
git clone https://github.com/scrooloose/nerdcommenter.git ~/.vim/bundle/nerdcommenter
vim -u NONE -c "helptags ~/.vim/bundle/nerdcommenter/doc" -c q

# Install syntastic
git clone --depth=1 https://github.com/vim-syntastic/syntastic.git ~/.vim/bundle/syntastic
vim -u NONE -c "helptags ~/.vim/bundle/syntastic/doc" -c q

# Install easymotion
git clone https://github.com/easymotion/vim-easymotion ~/.vim/bundle/vim-easymotion
vim -u NONE -c "helptags ~/.vim/bundle/vim-easymotion/doc" -c q

# Log out
osascript -e 'tell application "loginwindow" to  «event aevtrlgo»'
