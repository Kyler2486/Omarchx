echo "Add right-click terminal action to waybar omarchx menu icon"

WAYBAR_CONFIG="$HOME/.config/waybar/config.jsonc"

if [[ -f $WAYBAR_CONFIG ]] && ! grep -A5 '"custom/omarchx"' "$WAYBAR_CONFIG" | grep -q '"on-click-right"'; then
  sed -i '/"on-click": "omarchx-menu",/a\    "on-click-right": "omarchx-launch-terminal",' "$WAYBAR_CONFIG"
fi
