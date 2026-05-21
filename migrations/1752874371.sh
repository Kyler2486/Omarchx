echo "Add Catppuccin Latte light theme"

if [[ ! -L $HOME/.config/omarchx/themes/catppuccin-latte ]]; then
  ln -snf ~/.local/share/Omarchx/themes/catppuccin-latte ~/.config/omarchx/themes/
fi
