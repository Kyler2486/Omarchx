echo "Use explicit timezone selector when right-clicking on clock"

sed -i 's/omarchx-cmd-tzupdate/omarchx-launch-floating-terminal-with-presentation omarchx-tz-select/g' ~/.config/waybar/config.jsonc
