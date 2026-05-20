# Must be an Arch distro
if [[ ! -f /etc/arch-release ]]; then
  abort "Vanilla Arch"
fi

# Must not have Gnome or KDE already install
if pacman -Qe gnome-shell &>/dev/null || pacman -Qe plasma-desktop &>/dev/null; then
  abort "Fresh + Vanilla Arch"
fi

# Cleared all guards
echo "Guards: OK"
