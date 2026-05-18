echo "Make new Osaka Jade theme available as new default"

if [[ ! -L ~/.config/omarchx/themes/osaka-jade ]]; then
  rm -rf ~/.config/omarchx/themes/osaka-jade
  git -C ~/.local/share/omarchx checkout -f themes/osaka-jade
  ln -nfs ~/.local/share/omarchx/themes/osaka-jade ~/.config/omarchx/themes/osaka-jade
fi
