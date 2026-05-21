if [[ -n ${OMARCHX_ONLINE_INSTALL:-} ]]; then
  # Install build tools
  omarchx-pkg-add base-devel

  # Configure pacman
  sudo cp -f ~/.local/share/Omarchx/default/pacman/pacman-${OMARCHX_MIRROR:-stable}.conf /etc/pacman.conf
  sudo cp -f ~/.local/share/Omarchx/default/pacman/mirrorlist-${OMARCHX_MIRROR:-stable} /etc/pacman.d/mirrorlist

  sudo pacman-key --recv-keys 40DFB630FF42BCFFB047046CF0134EE680CAC571 --keyserver keys.openpgp.org
  sudo pacman-key --lsign-key 40DFB630FF42BCFFB047046CF0134EE680CAC571

  sudo pacman -Sy
  omarchx-pkg-add omarchx-keyring

  # Refresh all repos
  sudo pacman -Syyuu --noconfirm
fi
