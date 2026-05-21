# Save username before git reads
_username="$username"

# Git configuration
clear
echo "Git configuration"
echo ""
echo "Used for git config (Enter to skip)"
echo ""
echo -ne "${BLUE_BG}  Username › ${RESET} "
IFS= read -r git_username < /dev/tty
export OMARCHX_USER_NAME="$git_username"

echo -ne "${BLUE_BG}  Email › ${RESET} "
IFS= read -r git_email < /dev/tty
export OMARCHX_USER_EMAIL="$git_email"

echo -ne "${BLUE_BG}  GitHub Token › ${RESET} "
IFS= read -rs git_token < /dev/tty
echo
export OMARCHX_GIT_TOKEN="$git_token"

# Restore username
username="$_username"
