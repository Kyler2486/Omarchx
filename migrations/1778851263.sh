echo "Set BROWSER to Omarchx browser launcher for detached terminal URL opens"

if [[ -f ~/.config/uwsm/default ]]; then
  if grep -q '^export BROWSER=' ~/.config/uwsm/default; then
    sed -i 's|^export BROWSER=.*|export BROWSER=omarchx-launch-browser|' ~/.config/uwsm/default
  else
    printf '\n# Used by terminal programs (like gh) to open URLs detached from the terminal process tree\nexport BROWSER=omarchx-launch-browser\n' >> ~/.config/uwsm/default
  fi
else
  omarchx-refresh-config uwsm/default
fi
