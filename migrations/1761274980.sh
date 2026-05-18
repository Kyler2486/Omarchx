echo "Migrate to proper packages for localsend and asdcontrol"

if omarchx-pkg-present localsend-bin; then
  omarchx-pkg-drop localsend-bin
  omarchx-pkg-add localsend
fi

if omarchx-pkg-present asdcontrol-git; then
  omarchx-pkg-drop asdcontrol-git
  omarchx-pkg-add asdcontrol
fi
