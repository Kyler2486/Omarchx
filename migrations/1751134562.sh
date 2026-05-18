echo "Ensure all indexes and packages are up to date"

omarchx-update-keyring
omarchx-refresh-pacman
sudo pacman -Syu --noconfirm
