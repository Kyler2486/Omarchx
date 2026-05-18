echo "Uniquely identify terminal apps with custom app-ids using omarchx-launch-tui"

# Replace terminal -e calls with omarchx-launch-tui in bindings
sed -i 's/\$terminal -e \([^ ]*\)/omarchx-launch-tui \1/g' ~/.config/hypr/bindings.conf

# Update waybar to use omarchx-launch-or-focus with omarchx-launch-tui for TUI apps
sed -i 's|xdg-terminal-exec btop|omarchx-launch-or-focus-tui btop|' ~/.config/waybar/config.jsonc
sed -i 's|xdg-terminal-exec --app-id=com\.omarchx\.Wiremix -e wiremix|omarchx-launch-or-focus-tui wiremix|' ~/.config/waybar/config.jsonc
