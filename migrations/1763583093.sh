echo "Make ethereal available as new theme"

if [[ ! -L ~/.config/omarchx/themes/ethereal ]]; then
  rm -rf ~/.config/omarchx/themes/ethereal
  ln -nfs ~/.local/share/Omarchx/themes/ethereal ~/.config/omarchx/themes/
fi
