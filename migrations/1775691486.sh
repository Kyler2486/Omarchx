echo "Copy Fcitx5 autostart desktop file to ~/.config/autostart"

mkdir -p ~/.config/autostart/
cp "$OMARCHX_PATH/config/autostart/org.fcitx.Fcitx5.desktop" ~/.config/autostart/

omarchx-restart-xcompose
