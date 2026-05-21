echo "Make new Osaka Jade theme available as new default"

if [[ ! -L ~/.config/omarchx/themes/osaka-jade ]]; then
  rm -rf ~/.config/omarchx/themes/osaka-jade
  git -C ~/.local/share/Omarchx checkout -f themes/osaka-jade
  ln -nfs ~/.local/share/Omarchx/themes/osaka-jade ~/.config/omarchx/themes/osaka-jade
fi
