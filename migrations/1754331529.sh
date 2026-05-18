echo "Update Waybar for new Omarchx menu"

if ! grep -q "" ~/.config/waybar/config.jsonc; then
  omarchx-refresh-waybar
fi
