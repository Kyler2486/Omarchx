echo "Replace buggy native Zoom client with webapp"

if omarchx-pkg-present zoom; then
  omarchx-pkg-drop zoom
  omarchx-webapp-install "Zoom" https://app.zoom.us/wc/home https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/png/zoom.png
fi
