echo "Add Tmux as an option with themed styling"

omarchx-pkg-add tmux

if [[ ! -f ~/.config/tmux/tmux.conf ]]; then
  mkdir -p ~/.config/tmux
  cp $OMARCHX_PATH/config/tmux/tmux.conf ~/.config/tmux/tmux.conf
  omarchx-theme-refresh
fi
