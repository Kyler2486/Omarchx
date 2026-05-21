# Copy over Omarchx configs
mkdir -p ~/.config
cp -R ~/.local/share/Omarchx/config/* ~/.config/

# Use default bashrc from Omarchx
cp ~/.local/share/Omarchx/default/bashrc ~/.bashrc
