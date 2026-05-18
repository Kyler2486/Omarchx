echo "Replace volume control GUI with a TUI"

if omarchx-cmd-missing wiremix; then
  omarchx-pkg-add wiremix
  omarchx-pkg-drop pavucontrol
  omarchx-refresh-applications
  omarchx-refresh-waybar
fi
