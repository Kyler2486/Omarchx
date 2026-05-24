# Hardcode real user home so udev rules work correctly when triggered as root
REAL_HOME=$(getent passwd "${SUDO_USER:-$USER}" | cut -d: -f6)

if omarchx-battery-present; then
  cat <<EOF | sudo tee "/etc/udev/rules.d/99-wifi-powersave.rules" >/dev/null
SUBSYSTEM=="power_supply", ATTR{type}=="Mains", ATTR{online}=="0", RUN+="/usr/bin/systemd-run --no-block --collect --unit=omarchx-wifi-powersave-on $REAL_HOME/.local/share/Omarchx/bin/omarchx-wifi-powersave on"
SUBSYSTEM=="power_supply", ATTR{type}=="Mains", ATTR{online}=="1", RUN+="/usr/bin/systemd-run --no-block --collect --unit=omarchx-wifi-powersave-off $REAL_HOME/.local/share/Omarchx/bin/omarchx-wifi-powersave off"
EOF

  sudo udevadm control --reload
  sudo udevadm trigger --subsystem-match=power_supply
fi
