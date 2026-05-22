#!/usr/bin/bash

ansi_art='
▄█████▄    ▄███████████▄    ▄███████   ▄███████   ▄███████   ▄█   █▄    ▄█   █▄
███   ███  ███   ███   ███  ███   ███  ███   ███  ███   ███  ███   ███  ███   ███
███   ███  ███   ███   ███  ███   ███  ███   ███  ███   █▀   ███   ███   ▀███▄██▀
███   ███  ███   ███   ███ ▄███▄▄▄███ ▄███▄▄▄██▀  ███       ▄███▄▄▄███▄   █████
███   ███  ███   ███   ███ ▀███▀▀▀███ ▀███▀▀▀▀    ███      ▀▀███▀▀▀███   ▄██▀██▄
███   ███  ███   ███   ███  ███   ███ ██████████  ███   █▄   ███   ███  ███   ███
███   ███  ███   ███   ███  ███   ███  ███   ███  ███   ███  ███   ███  ███   ███
 ▀█████▀    ▀█   ███   █▀   ███   █▀   ███   ███  ███████▀   ███   █▀   ▀█   █▀
                                       ███   █▀
'
clear
echo -e "$ansi_art\n\nInstalling Omarchx..."

export OMARCHX_PATH="$HOME/.local/share/Omarchx"
export OMARCHX_INSTALL="$OMARCHX_PATH/install"
export OMARCHX_INSTALL_LOG_FILE="/var/log/omarchx-install.log"
export PATH="$OMARCHX_PATH/bin:$PATH"


source "$OMARCHX_INSTALL/helpers/all.sh"
source "$OMARCHX_INSTALL/preflight/all.sh"
source "$OMARCHX_INSTALL/packaging/all.sh"
source "$OMARCHX_INSTALL/config/all.sh"
source "$OMARCHX_INSTALL/login/all.sh"
source "$OMARCHX_INSTALL/post-install/all.sh"
source "$OMARCHX_INSTALL/other/all.sh"
