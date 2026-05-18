echo "Update Waybar screen recording command"

WAYBAR_CONFIG="$HOME/.config/waybar/config.jsonc"

if [[ -f $WAYBAR_CONFIG ]] && grep -q 'omarchx-cmd-screenrecord' "$WAYBAR_CONFIG"; then
  sed -i 's/omarchx-cmd-screenrecord/omarchx-capture-screenrecording/g' "$WAYBAR_CONFIG"
  omarchx-restart-waybar
fi
