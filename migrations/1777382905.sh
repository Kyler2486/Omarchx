echo "Use interactive unlock (Plymouth) selector menu"

mkdir -p ~/.config/elephant/menus
ln -snf $OMARCHX_PATH/default/elephant/omarchx_unlocks.lua ~/.config/elephant/menus/omarchx_unlocks.lua
omarchx-restart-walker
