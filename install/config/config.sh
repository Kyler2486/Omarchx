# Copy over Omarchx configs
mkdir -p ~/.config
cp -R ~/.local/share/omarchx/config/* ~/.config/

# Use default bashrc from Omarchx
cp ~/.local/share/omarchx/default/bashrc ~/.bashrc
