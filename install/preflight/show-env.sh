# Show installation environment variables
gum log --level info "Installation Environment:"

env | grep -E "^(OMARCHX_CHROOT_INSTALL|OMARCHX_ONLINE_INSTALL|OMARCHX_USER_NAME|OMARCHX_USER_EMAIL|USER|HOME|OMARCHX_REPO|OMARCHX_REF|OMARCHX_PATH)=" | sort | while IFS= read -r var; do
  gum log --level info "  $var"
done
