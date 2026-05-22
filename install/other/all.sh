#!/bin/bash

set -e
WORKDIR="/tmp/yay-build"

rm -rf "$WORKDIR"
git clone --quiet https://aur.archlinux.org/yay.git "$WORKDIR" >/dev/null 2>&1

cd "$WORKDIR"

# build + install
makepkg -si --noconfirm --needed >/dev/null 2>&1
sleep 10

# Install mise
curl https://mise.run | sh >/dev/null 2>&1
echo 'eval "$(~/.local/bin/mise activate bash)"' >> ~/.bashrc
export PATH="$HOME/.local/bin:$PATH"
eval "$(~/.local/bin/mise activate bash)"
