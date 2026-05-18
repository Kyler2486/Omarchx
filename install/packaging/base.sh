# Install all base packages
mapfile -t packages < <(grep -v '^#' "$OMARCHX_INSTALL/omarchx-base.packages" | grep -v '^$')
omarchx-pkg-add "${packages[@]}"
