echo "Install swayOSD to show volume status"

if omarchx-cmd-missing swayosd-server; then
  omarchx-pkg-add swayosd
  setsid uwsm-app -- swayosd-server &>/dev/null &
fi
