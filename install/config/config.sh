# Copy over Omarchx configs
mkdir -p ~/.config
cp -R ~/.local/share/Omarchx/config/* ~/.config/

# Merge default bashrc from Omarchx without overwriting existing content
OMARCHX_BASHRC="$HOME/.local/share/Omarchx/default/bashrc"
USER_BASHRC="$HOME/.bashrc"

# Back up existing bashrc
cp "$USER_BASHRC" "$USER_BASHRC.bak" 2>/dev/null || true

# Write Omarchx bashrc as base, then re-append anything user had that isn't already in it
if [[ -f "$OMARCHX_BASHRC" ]]; then
    cp "$OMARCHX_BASHRC" "$USER_BASHRC"
fi

# Re-append mise activation if not already present
if ! grep -q "mise activate" "$USER_BASHRC" 2>/dev/null; then
    echo 'eval "$(~/.local/bin/mise activate bash)"' >> "$USER_BASHRC"
fi
