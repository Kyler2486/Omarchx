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

BLUE_BG="\e[104m"
RESET="\e[0m"

echo "Setup user and password for Omarchx!"

# Reset terminal to clean state before any reads
stty sane 2>/dev/null

# Create user
while true; do
    IFS= read -r -p "Set your username: " username < /dev/tty
    username="$(echo "$username" | tr -d '[:cntrl:]' | xargs)"

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
    IFS= read -rs -p "Set your password: " pass1 < /dev/tty
    echo

    if [ -z "$pass1" ]; then
        echo "Password cannot be empty."
        continue
    fi

    IFS= read -rs -p "Confirm password: " pass2 < /dev/tty
    echo

    if [ "$pass1" != "$pass2" ]; then
        echo "Passwords do not match."
        continue
    fi

    echo "$username:$pass1" | chpasswd
    echo "Password set successfully!"
    break
done

sleep 1.5

# Sudo setup
options=("No sudo" "Sudo user" "No passwd sudo")
selected=0

draw_menu() {
    clear
    echo "Sudo configuration"
    echo ""
    echo "Use   to navigate, 󰌑 to select"
    echo ""

    line=""
    for i in "${!options[@]}"; do
        if [ "$i" -eq "$selected" ]; then
            line+="${BLUE_BG}  ${options[$i]}  ${RESET} "
        else
            line+="  ${options[$i]}  "
        fi

        [ "$i" -lt $((${#options[@]} - 1)) ] && line+="|"
    done

    echo -e "$line"
}

while true; do
    draw_menu

    IFS= read -rsn1 key < /dev/tty

    case "$key" in
        $'\x1b')
            read -rsn2 key2 < /dev/tty
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

# Apply sudo settings
SUDOERS_DIR="/etc/sudoers.d"
SUDOERS_FILE="$SUDOERS_DIR/$username"

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

sleep 1.5

# Save username before git reads corrupt it
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

# Apply git config to root for now
if [[ -n "$git_username" ]]; then
    git config --global user.name "$git_username"
fi
if [[ -n "$git_email" ]]; then
    git config --global user.email "$git_email"
fi
if [[ -n "$git_token" && -n "$git_username" ]]; then
    git config --global credential.helper store
    echo "https://${git_username}:${git_token}@github.com" > ~/.git-credentials
    chmod 600 ~/.git-credentials
fi

echo ""
echo "Setup complete for user: $username"

sleep 1.5

# Pass env vars securely via temp file
env_file=$(mktemp)
chmod 600 "$env_file"
echo "export OMARCHX_USER_NAME='$git_username'" >> "$env_file"
echo "export OMARCHX_USER_EMAIL='$git_email'" >> "$env_file"
echo "export OMARCHX_GIT_TOKEN='$git_token'" >> "$env_file"

su - "$username" -c "
cd ~
source $env_file
wget -q https://raw.githubusercontent.com/Kyler2486/Omarchx/refs/heads/dev/boot.sh -O boot.sh
chmod +x boot.sh
./boot.sh
rm -f $env_file
"
