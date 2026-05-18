echo "Fix JetBrains font setting"

if [[ $(omarchx-font-current) == JetBrains* ]]; then
  omarchx-font-set "JetBrainsMono Nerd Font"
fi
