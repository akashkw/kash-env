#!/bin/bash

DCONF_GTERM_PROFILE="/org/gnome/terminal/legacy/profiles:"

profiles=( $ (dconf list "$DGP/" | grep : | cut -c 2-37) )

#dconf write "$DCONF_GTERM_PROFILEdefault" "'35a2c209-987b-4a7e-a2cf-2429e89c8e59'"
