echo "Add opencode with system theming"

omarchx-pkg-add opencode

# Add config using omarchx theme by default
if [[ ! -f ~/.config/opencode/opencode.json ]]; then
  mkdir -p ~/.config/opencode
  cp $OMARCHX_PATH/config/opencode/opencode.json ~/.config/opencode/opencode.json
fi
