echo "Add sample low battery notification hook"

mkdir -p ~/.config/omarchx/hooks/battery-low.d

if [[ ! -f ~/.config/omarchx/hooks/battery-low.d/play-warning-sound.sample ]]; then
  cp "$OMARCHX_PATH/config/omarchx/hooks/battery-low.d/play-warning-sound.sample" ~/.config/omarchx/hooks/battery-low.d/play-warning-sound.sample
fi
