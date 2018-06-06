#!/bin/bash

TARGET="'Hybrid'"

DCONF_GTERM_PROFILE="/org/gnome/terminal/legacy/profiles:"

dconf list "$DCONF_GTERM_PROFILE/" | grep : | cut -c 2-37 | while read -r PID ; do
    NAME=$(dconf read "$DCONF_GTERM_PROFILE/:$PID/visible-name")
    if [ $NAME == $TARGET ]; then
        dconf write "$DCONF_GTERM_PROFILE/default" "'$PID'"
    fi
done

