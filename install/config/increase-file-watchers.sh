# Increase inotify file watchers for VS Code, webpack, and other dev tools (default 8192 is too low)
# Skipped: sysctl not supported in proot environments
echo "fs.inotify.max_user_watches=524288" | sudo tee /etc/sysctl.d/90-omarchx-file-watchers.conf >/dev/null
