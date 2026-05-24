#!/bin/bash

# Ensure mise is installed and available before anything else
if ! command -v mise &>/dev/null; then
    REAL_HOME=$(getent passwd "${SUDO_USER:-$USER}" | cut -d: -f6)
    MISE_BIN="$REAL_HOME/.local/bin"
    mkdir -p "$MISE_BIN"
    curl https://mise.run | MISE_INSTALL_PATH="$MISE_BIN/mise" sh >/dev/null 2>&1
    export PATH="$MISE_BIN:$PATH"
    eval "$($MISE_BIN/mise activate bash)"

    if ! command -v mise &>/dev/null; then
        echo "Error: mise failed to install."
        exit 1
    fi
fi

# Setup default work directory (and tries)
mkdir -p "$HOME/Work"
mkdir -p "$HOME/Work/tries"

# Add ./bin to path for all items in ~/Work
cat >"$HOME/Work/.mise.toml" <<'EOF'
[env]
_.path = "{{ cwd }}/bin"
EOF

mise trust ~/Work/.mise.toml

if [[ -n ${OMARCHX_CHROOT_INSTALL:-} ]]; then
  NODE_TARBALL=$(find /opt/packages -name "node-v*-linux-x64.tar.gz" -type f 2>/dev/null | head -n1)

  NODE_VERSION=$(basename "$NODE_TARBALL" | sed 's/node-v\(.*\)-linux-x64.tar.gz/\1/')
  NODE_INSTALL_DIR="$HOME/.local/share/mise/installs/node/$NODE_VERSION"

  mkdir -p "$NODE_INSTALL_DIR"
  tar -xzf "$NODE_TARBALL" \
      --strip-components=1 \
      -C "$NODE_INSTALL_DIR"

  mise use -g node@"$NODE_VERSION"
else
  mise use -g node@latest
fi
