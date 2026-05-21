# Set default XCompose that is triggered with CapsLock
tee ~/.XCompose >/dev/null <<EOF
# Run omarchx-restart-xcompose to apply changes

# Include fast emoji access
include "%H/.local/share/Omarchx/default/xcompose"

# Identification
<Multi_key> <space> <n> : "$OMARCHX_USER_NAME"
<Multi_key> <space> <e> : "$OMARCHX_USER_EMAIL"
EOF
