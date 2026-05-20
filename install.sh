#!/bin/bash
ansi_art='
▄█████▄    ▄███████████▄    ▄███████   ▄███████   ▄███████   ▄█   █▄    ▄█   █▄
███   ███  ███   ███   ███  ███   ███  ███   ███  ███   ███  ███   ███  ███   ███
███   ███  ███   ███   ███  ███   ███  ███   ███  ███   █▀   ███   ███   ▀███▄██▀
███   ███  ███   ███   ███ ▄███▄▄▄███ ▄███▄▄▄██▀  ███       ▄███▄▄▄███▄   █████
███   ███  ███   ███   ███ ▀███▀▀▀███ ▀███▀▀▀▀    ███      ▀▀███▀▀▀███   ▄██▀██▄
███   ███  ███   ███   ███  ███   ███ ██████████  ███   █▄   ███   ███  ███   ███
███   ███  ███   ███   ███  ███   ███  ███   ███  ███   ███  ███   ███  ███   ███
 ▀█████▀    ▀█   ███   █▀   ███   █▀   ███   ███  ███████▀   ███   █▀   ▀█   █▀
                                       ███   █▀
'
clear
printf "%b\n" "$ansi_art\n\n"
sleep 1

echo "Let's set you Omarchx user and password."

# Create user
while true; do
    read -p "Set your username: " username
    username="$(echo "$username" | xargs)"

    if [ -z "$username" ]; then
        echo "Username cannot be empty."
        continue
    fi

    if ! [[ "$username" =~ ^[a-z_][a-z0-9_-]*$ ]]; then
        echo "Invalid username format."
        continue
    fi

    if id "$username" &>/dev/null; then
        echo "User $username already exists."
        continue
    fi

    if useradd -m "$username"; then
        echo "User $username created successfully."
        break
    else
        echo "Failed to create user."
    fi
done

# Setup password
while true; do
    read -s -p "Set your password: " pass1
    echo

    if [ -z "$pass1" ]; then
        echo "Password cannot be empty."
        continue
    fi

    read -s -p "Confirm password: " pass2
    echo

    if [ "$pass1" != "$pass2" ]; then
        echo "Passwords do not match."
        continue
    fi

    echo "$username:$pass1" | chpasswd
    echo "Password set successfully!"
    break
done

# Setup sudo
options=("No sudo" "Sudo user" "No passwd  sudo")
selected=0

BLUE_BG="\e[104m"
RESET="\e[0m"

draw_menu() {
    clear
    echo "Sudo configuration"
    echo ""
    echo "Use   to navigate, 󰌑 to select"
    echo ""

    line=""
    for i in "${!options[@]}"; do
        if [ "$i" -eq "$selected" ]; then
            line+="${BLUE_BG}  ${options[$i]}  ${RESET} "
        else
            line+="  ${options[$i]}  "
        fi

        [ "$i" -lt $((${#options[@]} - 1)) ] && line+="|"
    done

    echo -e "$line"
}

while true; do
    draw_menu

    IFS= read -rsn1 key

    case "$key" in
        $'\x1b')
            read -rsn2 key2
            case "$key2" in
                "[C") ((selected++)) ;;  # right
                "[D") ((selected--)) ;;  # left
            esac
            ;;
        "") break ;;
    esac

    ((selected < 0)) && selected=$((${#options[@]} - 1))
    ((selected >= ${#options[@]})) && selected=0
done

# Apply sudo setttings
SUDOERS_DIR="/etc/sudoers.d"
SUDOERS_FILE="$SUDOERS_DIR/$username"

# ensure directory exists (FIX FOR YOUR ERROR)
mkdir -p "$SUDOERS_DIR"

case "$selected" in
    0)
        echo "No sudo granted."
        rm -f "$SUDOERS_FILE"
        ;;

    1)
        echo "$username ALL=(ALL:ALL) ALL" > "$SUDOERS_FILE"
        chmod 440 "$SUDOERS_FILE"
        echo "Sudo granted."
        ;;

    2)
        echo "$username ALL=(ALL) NOPASSWD: ALL" > "$SUDOERS_FILE"
        chmod 440 "$SUDOERS_FILE"
        echo "NOPASSWD sudo granted."
        ;;
esac

echo ""
echo "Setup complete for user: $username"
# Exit immediately if a command exits with a non-zero status
set -eEo pipefail

# Define Omarchx locations
export OMARCHX_PATH="$HOME/.local/share/Omarchx"
export OMARCHX_INSTALL="$OMARCHX_PATH/install"
export OMARCHX_INSTALL_LOG_FILE="/var/log/omarchx-install.log"
export PATH="$OMARCHX_PATH/bin:$PATH"

# Install
source "$OMARCHX_INSTALL/helpers/all.sh"
source "$OMARCHX_INSTALL/preflight/all.sh"
source "$OMARCHX_INSTALL/packaging/all.sh"
source "$OMARCHX_INSTALL/config/all.sh"
source "$OMARCHX_INSTALL/login/all.sh"
source "$OMARCHX_INSTALL/post-install/all.sh"
source "$OMARCHX_INSTALL/others/all.sh
