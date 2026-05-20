#!/bin/bash

set -e
WORKDIR="/tmp/yay-build"

rm -rf "$WORKDIR"
git clone --quiet https://aur.archlinux.org/yay.git "$WORKDIR" >/dev/null 2>&1

cd "$WORKDIR"

# build + install
makepkg -si --noconfirm --needed >/dev/null 2>&1
sleep 10
