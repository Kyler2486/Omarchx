echo "Use Omarchx UWSM session without graphical.target startup wait"

sudo mkdir -p /usr/local/share/wayland-sessions
sudo cp "$OMARCHX_PATH/default/wayland-sessions/omarchx.desktop" /usr/local/share/wayland-sessions/omarchx.desktop

if [[ -f /etc/sddm.conf.d/autologin.conf ]]; then
  sudo sed -i 's/^Session=hyprland-uwsm$/Session=omarchx/' /etc/sddm.conf.d/autologin.conf
fi
