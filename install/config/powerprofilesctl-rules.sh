# Hardcode real user home so udev rules work correctly when triggered as root
REAL_HOME=$(getent passwd "${SUDO_USER:-$USER}" | cut -d: -f6)

if omarchx-battery-present; then
  cat <<EOF | sudo tee "/etc/udev/rules.d/99-power-profile.rules" >/dev/null
SUBSYSTEM=="power_supply", ATTR{type}=="Mains", RUN+="/usr/bin/systemd-run --no-block --collect --unit=omarchx-power-profile --property=After=power-profiles-daemon.service $REAL_HOME/.local/share/Omarchx/bin/omarchx-powerprofiles-set"
SUBSYSTEM=="power_supply", ATTR{type}=="USB", RUN+="/usr/bin/systemd-run --no-block --collect --unit=omarchx-power-profile --property=After=power-profiles-daemon.service $REAL_HOME/.local/share/Omarchx/bin/omarchx-powerprofiles-set"
EOF

  sudo systemctl enable power-profiles-daemon

  sudo udevadm control --reload 2>/dev/null
  sudo udevadm trigger --subsystem-match=power_supply 2>/dev/null
fi
