echo "Update fastfetch config with new Omarchx logo"

omarchx-refresh-config fastfetch/config.jsonc

mkdir -p ~/.config/omarchx/branding
cp $OMARCHX_PATH/icon.txt ~/.config/omarchx/branding/about.txt
