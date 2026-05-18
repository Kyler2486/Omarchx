echo "Move Omarchx Package Repository after Arch core/extra/multilib and remove AUR"

omarchx-refresh-pacman
sudo pacman -Syu --noconfirm
