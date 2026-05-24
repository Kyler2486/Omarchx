# Set default XCompose that is triggered with CapsLock
{
    echo "# Run omarchx-restart-xcompose to apply changes"
    echo ""
    echo "# Include fast emoji access"
    echo "include \"%H/.local/share/Omarchx/default/xcompose\""
    echo ""
    echo "# Identification"

    if [[ -n "${OMARCHX_USER_NAME//[[:space:]]/}" ]]; then
        echo "<Multi_key> <space> <n> : \"$OMARCHX_USER_NAME\""
    fi

    if [[ -n "${OMARCHX_USER_EMAIL//[[:space:]]/}" ]]; then
        echo "<Multi_key> <space> <e> : \"$OMARCHX_USER_EMAIL\""
    fi
} | tee ~/.XCompose >/dev/null
