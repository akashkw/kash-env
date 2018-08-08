#!/bin/bash

# Run this to set up environment

# Options
# -g gnome environment
# -m mac environment
# -v visual environment
# -p pure environment

set -x

if [ "$(uname)" == "Darwin" ]; then
SCRIPT_PATH=$(cd "$(dirname "$0")"; pwd)
else
SCRIPT_PATH=$(dirname $(readlink -f $0))
fi
cd $SCRIPT_PATH

git pull

while getopts "gmvp" option; do
    case "${option}" in
        g ) sh gnome-env/env_setup.sh ;;
        m ) sh mac-env/env_setup.sh;;
        v ) sh visual-cli-env/env_setup.sh;;
        p ) sh pure-cli-env/env_setup.sh;;
    esac
done
