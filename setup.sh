#!/usr/bin/bash

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

echo -e "$ansi_art"
sleep 2

#!/bin/bash

echo "Setup user and password for Omarchx!"

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

# Sudo setup
options=("No sudo" "Sudo user" "No passwd sudo")
selected=0

BLUE_BG="\e[104m"
RESET="\e[0m"

draw_menu() {
    clear
    echo "Sudo configuration"
    echo ""
    echo "Use   to navigate, 󰌑 to select"
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

# Apply sudo settings
SUDOERS_DIR="/etc/sudoers.d"
SUDOERS_FILE="$SUDOERS_DIR/$username"

# ensure directory exists
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
su - "$username"
