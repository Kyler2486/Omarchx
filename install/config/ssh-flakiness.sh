# Solve common flakiness with SSH
SYSCTL_CONF="/etc/sysctl.d/99-sysctl.conf"
SETTING="net.ipv4.tcp_mtu_probing=1"

if ! grep -qxF "$SETTING" "$SYSCTL_CONF" 2>/dev/null; then
    echo "$SETTING" | sudo tee -a "$SYSCTL_CONF" >/dev/null
fi
