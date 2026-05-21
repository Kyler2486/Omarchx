if [[ $(plymouth-set-default-theme) != "omarchx" ]]; then
  sudo cp -r "$HOME/.local/share/Omarchx/default/plymouth" /usr/share/plymouth/themes/omarchx/
  sudo plymouth-set-default-theme omarchx
fi
