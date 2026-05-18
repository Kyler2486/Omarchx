echo "Use interactive background selector menu"

mkdir -p ~/.config/elephant/menus
ln -snf $OMARCHX_PATH/default/elephant/omarchx_background_selector.lua ~/.config/elephant/menus/omarchx_background_selector.lua
omarchx-restart-walker
