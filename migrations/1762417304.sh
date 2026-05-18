echo "Replace bluetooth GUI with TUI"

omarchx-pkg-add bluetui
omarchx-pkg-drop blueberry

if ! grep -q "omarchx-launch-bluetooth" ~/.config/waybar/config.jsonc; then
  sed -i 's/blueberry/omarchx-launch-bluetooth/' ~/.config/waybar/config.jsonc
fi
