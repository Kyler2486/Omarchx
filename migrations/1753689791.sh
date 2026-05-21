echo "Add the new ristretto theme as an option"

if [[ ! -L ~/.config/omarchx/themes/ristretto ]]; then
  ln -nfs ~/.local/share/Omarchx/themes/ristretto ~/.config/omarchx/themes/
fi
