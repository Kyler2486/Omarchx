# Must not be run as root
if [[ $EUID -eq 0 ]]; then
  abort "Must not be run as root"
fi

# Must be an Arch distro
if [[ ! -f /etc/arch-release ]]; then
  abort "Vanilla Arch"
fi

# Must not have Gnome or KDE already installed
if pacman -Qe gnome-shell &>/dev/null || pacman -Qe plasma-desktop &>/dev/null; then
  abort "Fresh + Vanilla Arch"
fi

# Cleared all guards
echo "Guards: OK"
