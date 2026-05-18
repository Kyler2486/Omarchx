echo "Rename screen recording command"

WAYBAR_CONFIG="$HOME/.config/waybar/config.jsonc"

if [[ -f $WAYBAR_CONFIG ]] && grep -q 'omarchx-capture-screencording' "$WAYBAR_CONFIG"; then
  sed -i 's/omarchx-capture-screencording/omarchx-capture-screenrecording/g' "$WAYBAR_CONFIG"
  omarchx-restart-waybar
fi
