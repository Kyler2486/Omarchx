# Set identification from install inputs
if [[ -n ${OMARCHX_USER_NAME//[[:space:]]/} ]]; then
  git config --global user.name "$OMARCHX_USER_NAME"
fi

if [[ -n ${OMARCHX_USER_EMAIL//[[:space:]]/} ]]; then
  git config --global user.email "$OMARCHX_USER_EMAIL"
fi
