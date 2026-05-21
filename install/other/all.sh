# set -eEo pipefail  # comment this out temporarily
set -x  # print every command as it runs

source "$OMARCHX_INSTALL/helpers/all.sh"
source "$OMARCHX_INSTALL/preflight/all.sh"
source "$OMARCHX_INSTALL/packaging/all.sh"
source "$OMARCHX_INSTALL/config/all.sh"
source "$OMARCHX_INSTALL/login/all.sh"
source "$OMARCHX_INSTALL/post-install/all.sh"
source "$OMARCHX_INSTALL/other/all.sh"
