echo "Switch back to mainline chromium now that it supports full live theming"

if omarchx-pkg-present omarchx-chromium; then
  if gum confirm "Ready to switch to mainstream chromium? (Will close Chromium + reset settings)"; then
    pkill -x chromium
    omarchx-pkg-drop omarchx-chromium
    omarchx-pkg-add chromium
    omarchx-theme-set-browser
  fi
fi
