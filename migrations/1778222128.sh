echo "Add sample post-boot hook"

mkdir -p ~/.config/omarchx/hooks/post-boot.d

if [[ ! -f ~/.config/omarchx/hooks/post-boot.d/weather.sample ]]; then
  cp "$OMARCHX_PATH/config/omarchx/hooks/post-boot.d/weather.sample" ~/.config/omarchx/hooks/post-boot.d/weather.sample
fi
