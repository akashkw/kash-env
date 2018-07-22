#!/bin/bash

set -x

SCRIPT_PATH=$(dirname $(readlink -f $0))
cd $SCRIPT_PATH

# Install dependencies
CLOUD_SDK_REPO="cloud-sdk-$(lsb_release -c -s)"
sudo sed -i "/deb http:\/\/packages.cloud.google.com\/apt $CLOUD_SDK_REPO main/d" /etc/apt/sources.list.d/google-cloud-sdk.list
echo "deb http://packages.cloud.google.com/apt $CLOUD_SDK_REPO main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
curl http://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
sudo apt-add-repository -y ppa:fish-shell/release-2
sudo apt-get update -y && sudo apt-get upgrade -y
sudo apt-get install -y curl git vim tmux fish dconf-cli apt-transport-https google-cloud-sdk

# Clear out old environment
rm -rf ~/.vim ~/.vimrc ~/.tmux.conf ~/.config/fish ~/.local/share/omf ~/.config/omf ~/.cache/omf

# Set fish to default shell
if [ "$SHELL" != "/usr/bin/fish" ]; then
    chsh -s /usr/bin/fish
fi
mkdir -p ~/.config/fish

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

# Load gnome terminal settings from dconf database
filename="org.gnome.terminal.dump"
db_location="/$(echo "${filename%.dump}" | tr '.' '/')/"
dconf load "$db_location" < "$filename"

# Install powerline fonts
git clone https://github.com/powerline/fonts
bash fonts/install.sh
sudo rm -rf fonts

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

# Logout to reset terminal
gnome-session-quit --force
