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

# Persist to bashrc
if ! grep -q "OMARCHX_PATH" ~/.bashrc; then
  echo "export OMARCHX_PATH=\"$HOME/.local/share/Omarchx\"" >> ~/.bashrc
  echo "export PATH=\"\$OMARCHX_PATH/bin:\$PATH\"" >> ~/.bashrc
fi

source "$OMARCHX_INSTALL/helpers/all.sh"
source "$OMARCHX_INSTALL/preflight/all.sh"
source "$OMARCHX_INSTALL/packaging/all.sh"
source "$OMARCHX_INSTALL/config/all.sh"
source "$OMARCHX_INSTALL/login/all.sh"
source "$OMARCHX_INSTALL/post-install/all.sh"
source "$OMARCHX_INSTALL/other/all.sh"
