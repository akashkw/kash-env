#!/bin/bash

set -x

SCRIPT_PATH=$(dirname $(readlink -f $0))
cd $SCRIPT_PATH
cd /tmp

sudo wget https://launcher.mojang.com/download/Minecraft.dmg
sudo dpkg Minecraft.dmg
sudo rm Minecraft.dmg
minecraft


