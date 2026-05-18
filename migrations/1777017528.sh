echo "Show battery status notification on right-click of the waybar battery icon"

if ! grep -q 'omarchx-battery-status' ~/.config/waybar/config.jsonc; then
  sed -i '/"on-click": "omarchx-menu power",/a\    "on-click-right": "notify-send -u low \\"$(omarchx-battery-status)\\"",' ~/.config/waybar/config.jsonc
  omarchx-restart-waybar
fi
