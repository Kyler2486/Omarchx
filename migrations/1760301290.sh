echo "Add the new Flexoki Light theme"

if [[ ! -L ~/.config/omarchx/themes/flexoki-light ]]; then
  ln -nfs ~/.local/share/omarchx/themes/flexoki-light ~/.config/omarchx/themes/
fi
