echo "Allow updating of timezone by right-clicking on the clock (or running omarchx-cmd-tzupdate)"

if omarchx-cmd-missing tzupdate; then
  bash "$OMARCHX_PATH/install/config/timezones.sh"
  omarchx-refresh-waybar
fi
