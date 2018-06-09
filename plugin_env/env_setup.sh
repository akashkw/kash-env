#!/bin/bash
set -x

SCRIPT_PATH=$(dirname $(readlink -f $0))
cd $SCRIPT_PATH

# Install dependencies
sudo apt-add-repository -y ppa:fish-shell/release-2
sudo apt-get update -y && sudo apt-get upgrade -y
sudo apt-get install -y curl git vim tmux fish dconf-cli

# Get newest config data
git pull

# Clear out old environment
rm -rf ~/.vim ~/.vimrc ~/.tmux.conf ~/.config/fish ~/.local/share/omf ~/.config/omf ~/.cache/omf

# Initialize Fish
if [ "$SHELL" != "/usr/bin/fish" ]; then
    chsh -s /usr/bin/fish
fi
mkdir -p ~/.config/fish

# Initialize Oh My Fish
curl -L https://get.oh-my.fish > install
fish install --noninteractive --yes --path=~/.local/share/omf --config=~/.config/omf
rm install
fish -c "omf install bobthefish"
fish -c "omf update"

# Set primary editor to vim in bashrc
sed -i '/export VISUAL/d' ~/.bashrc
echo export VISUAL=vim >> ~/.bashrc
sed -i '/export EDITOR/d' ~/.bashrc
echo export EDITOR=vim >> ~/.bashrc
git config --global core.editor "vim"

# Create config files
cp vimrc ~/.vimrc
cp tmux.conf ~/.tmux.conf
cp config.fish ~/.config/fish/

# Install Gruvbox Dark gnome-terminal profile
wget -O xt  http://git.io/v7eBS && chmod +x xt && ./xt && rm xt

# Set default gnome-terminal profile
TARGET="'Gruvbox Dark'"
DCONF_GTERM_PROFILE="/org/gnome/terminal/legacy/profiles:"
DUPLICATE=false
dconf list "$DCONF_GTERM_PROFILE/" | grep : | cut -c 2-37 | while read -r PID ; do
    NAME=$(dconf read "$DCONF_GTERM_PROFILE/:$PID/visible-name")
    if [ "$NAME" == "$TARGET" ]; then
        if [ "$DUPLICATE" == false ]; then
            dconf write "$DCONF_GTERM_PROFILE/default" "'$PID'"
            DUPLICATE=true
        else
            dconf reset -f "$DCONF_GTERM_PROFILE/:$PID/"
            LIST=`dconf read "$DCONF_GTERM_PROFILE/list"`
            NEWLIST="`python <<END
array = $LIST
array.remove('$PID')
print(array)
END`"
            dconf write "$DCONF_GTERM_PROFILE/list" "$NEWLIST"
        fi
    fi
done

# Install powerline fonts
wget https://github.com/powerline/powerline/raw/develop/font/PowerlineSymbols.otf
mkdir ~/.fonts
mv PowerlineSymbols.otf ~/.fonts/
fc-cache -vf ~/.fonts/
wget https://github.com/powerline/powerline/raw/develop/font/10-powerline-symbols.conf
mkdir -p ~/.config/fontconfig/conf.d
mv 10-powerline-symbols.conf ~/.config/fontconfig/conf.d/

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
