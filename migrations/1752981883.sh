echo "Replace wofi with walker as the default launcher"

if omarchx-cmd-missing walker; then
  omarchx-pkg-add walker-bin libqalculate

  omarchx-pkg-drop wofi
  rm -rf ~/.config/wofi

  mkdir -p ~/.config/walker
  cp -r ~/.local/share/Omarchx/config/walker/* ~/.config/walker/
fi
