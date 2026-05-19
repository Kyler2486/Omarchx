#!/bin/bash

# Set install mode to online since boot.sh is used for curl installations
export OMARCHX_ONLINE_INSTALL=true

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
echo -e "\n$ansi_art\n"

# Use custom branch if instructed, otherwise default to master
OMARCHX_REF="${OMARCHX_REF:-dev}"

# Set mirror based on branch
if [[ $OMARCHX_REF == "dev" ]]; then
  export OMARCHX_MIRROR=edge
  echo 'Server = https://geo.mirror.pkgbuild.com/$repo/os/$arch' | tee /etc/pacman.d/mirrorlist >/dev/null
elif [[ $OMARCHX_REF == "rc" ]]; then
  export OMARCHX_MIRROR=rc
  echo 'Server = https://geo.mirror.pkgbuild.com/$repo/os/$arch' | tee /etc/pacman.d/mirrorlist >/dev/null
else
  export OMARCHX_MIRROR=stable
  echo 'Server = https://geo.mirror.pkgbuild.com/$repo/os/$arch' | tee /etc/pacman.d/mirrorlist >/dev/null
fi

pacman -Syu --noconfirm --needed git

# Use custom repo if specified, otherwise default to Kyler2486/Omarchx
OMARCHX_REPO="${OMARCHX_REPO:-Kyler2486/Omarchx}"

echo -e "\nCloning Omarchx from: https://github.com/${OMARCHX_REPO}.git"
rm -rf ~/.local/share/omarchx/
git clone "https://github.com/${OMARCHX_REPO}.git" ~/.local/share/omarchx >/dev/null

echo -e "\e[32mUsing branch: $OMARCHX_REF\e[0m"
cd ~/.local/share/omarchx
git fetch origin "${OMARCHX_REF}" && git checkout "${OMARCHX_REF}"
cd -

echo -e "\nInstallation starting..."
source ~/.local/share/omarchx/install.sh
