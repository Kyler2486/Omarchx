# Overwrite parts of the omarchx-menu with user-specific submenus.
# See $OMARCHX_PATH/bin/omarchx-menu for functions that can be overwritten.
#
# WARNING: Overwritten functions will obviously not be updated when Omarchx changes.
#
# Example of minimal system menu:
#
# show_system_menu() {
#   case $(menu "System" "  Lock\n󰐥  Shutdown") in
#   *Lock*) omarchx-system-lock ;;
#   *Shutdown*) omarchx-system-shutdown ;;
#   *) back_to show_main_menu ;;
#   esac
# }
#
# Example of overriding just the about menu action: (Using zsh instead of bash (default))
#
# show_about() {
#   exec omarchx-launch-or-focus-tui "zsh -c 'fastfetch; read -k 1'"
# }
