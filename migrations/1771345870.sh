echo "Switch lmstudio -> lmstudio-bin"

if pacman -Q lmstudio &>/dev/null; then
  omarchx-pkg-drop lmstudio
  omarchx-pkg-add lmstudio-bin
fi
