#!/bin/bash
set -e

WORKDIR="/tmp/yay-build"
rm -rf "$WORKDIR"
git clone --quiet https://aur.archlinux.org/yay.git "$WORKDIR" >/dev/null 2>&1

cd "$WORKDIR"

# build + install
makepkg -si --noconfirm --needed >/dev/null 2>&1
sleep 10

# Resolve the real user home (in case $HOME is /root due to sudo)
REAL_HOME=$(getent passwd "${SUDO_USER:-$USER}" | cut -d: -f6)
MISE_BIN="$REAL_HOME/.local/bin/mise"

# Install mise to the real user's home
curl https://mise.run | MISE_INSTALL_PATH="$MISE_BIN" sh >/dev/null 2>&1

# Activate for current session
export PATH="$(dirname "$MISE_BIN"):$PATH"
eval "$($MISE_BIN activate bash)"

# Persist to the real user's bashrc
BASHRC="$REAL_HOME/.bashrc"
if ! grep -q "mise activate" "$BASHRC" 2>/dev/null; then
    echo 'eval "$(~/.local/bin/mise activate bash)"' >> "$BASHRC"
fi

# Verify mise is available before continuing
if ! command -v mise &>/dev/null; then
    echo "Error: mise failed to install or is not in PATH."
    exit 1
fi
