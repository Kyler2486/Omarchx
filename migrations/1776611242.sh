echo "Install socat so we can reactivate internal display when external display is removed"

omarchx-pkg-add socat
uwsm-app -- omarchx-hyprland-monitor-watch &
