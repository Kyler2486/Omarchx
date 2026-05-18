source $OMARCHX_INSTALL/preflight/guard.sh
source $OMARCHX_INSTALL/preflight/begin.sh
run_logged $OMARCHX_INSTALL/preflight/show-env.sh
run_logged $OMARCHX_INSTALL/preflight/pacman.sh
run_logged $OMARCHX_INSTALL/preflight/migrations.sh
run_logged $OMARCHX_INSTALL/preflight/first-run-mode.sh
run_logged $OMARCHX_INSTALL/preflight/disable-mkinitcpio.sh
