echo "Install Impala as new wifi selection TUI"

if omarchx-cmd-missing impala; then
  omarchx-pkg-add impala
  omarchx-refresh-waybar
fi
