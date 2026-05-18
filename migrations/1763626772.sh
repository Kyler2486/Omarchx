echo "Make hackerman available as new theme"

if [[ ! -L ~/.config/omarchx/themes/hackerman ]]; then
  rm -rf ~/.config/omarchx/themes/hackerman
  ln -nfs ~/.local/share/omarchx/themes/hackerman ~/.config/omarchx/themes/
fi
