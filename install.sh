#!/bin/bash
set -eEuo pipefail

export PATH=/usr/bin:/bin:/usr/sbin:/sbin:$PATH

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
printf "%b\n\n" "$ansi_art"
sleep 1

echo "Let's set your Omarchx user and password."

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
        echo "User already exists."
        continue
    fi

    useradd -m "$username"
    echo "User created."
    break
done

while true; do
    read -s -p "Set your password: " pass1
    echo

    [ -z "$pass1" ] && echo "Password cannot be empty." && continue

    read -s -p "Confirm password: " pass2
    echo

    [ "$pass1" != "$pass2" ] && echo "Passwords do not match." && continue

    echo "$username:$pass1" | chpasswd
    echo "Password set."
    break
done

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
                "[C") ((selected++)) ;;
                "[D") ((selected--)) ;;
            esac
            ;;
        "") break ;;
    esac

    ((selected < 0)) && selected=$((${#options[@]} - 1))
    ((selected >= ${#options[@]})) && selected=0
done

SUDOERS_DIR="/etc/sudoers.d"
SUDOERS_FILE="$SUDOERS_DIR/$username"

mkdir -p "$SUDOERS_DIR"

case "$selected" in
    0)
        rm -f "$SUDOERS_FILE"
        ;;
    1)
        echo "$username ALL=(ALL:ALL) ALL" > "$SUDOERS_FILE"
        chmod 440 "$SUDOERS_FILE"
        ;;
    2)
        echo "$username ALL=(ALL) NOPASSWD: ALL" > "$SUDOERS_FILE"
        chmod 440 "$SUDOERS_FILE"
        ;;
esac

echo "Setup complete for user: $username"

exec su - "$username"
