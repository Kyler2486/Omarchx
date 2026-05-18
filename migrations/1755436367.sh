echo "Add minimal starship prompt to terminal"

if omarchx-cmd-missing starship; then
  omarchx-pkg-add starship
  cp $OMARCHX_PATH/config/starship.toml ~/.config/starship.toml
fi
