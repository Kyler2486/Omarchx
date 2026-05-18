echo "Add new matte black theme"

if [[ ! -L $HOME/.config/omarchx/themes/matte-black ]]; then
  ln -snf ~/.local/share/omarchx/themes/matte-black ~/.config/omarchx/themes/
fi
