#!/bin/bash

set -x

SCRIPT_PATH=$(dirname $(readlink -f $0))
cd $SCRIPT_PATH
cd /tmp

sudo wget https://launcher.mojang.com/download/Minecraft.deb 
sudo dpkg -i Minecraft.deb
sudo apt-get install -f -y
sudo rm Minecraft.deb
minecraft-launcher


