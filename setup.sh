#!/usr/bin/bash

ansi_art='
    ▄█████▄    ▄███████████▄    ▄███████   ▄███████   ▄███████   ▄█   █▄    ▄█   █▄
    ███   ███  ███   ███   ███  ███   ███  ███   ███  ███   ███  ███   ███  ███   ███
    ███   ███  ███   ███   ███  ███   ███  ███   ███  ███   █▀   ███   ███   ▀███▄██▀
    ███   ███  ███   ███   ███ ▄███▄▄▄███ ▄███▄▄▄██▀  ███       ▄███▄▄▄███▄   █████
    ███   ███  ███   ███   ███ ▀███▀▀▀███ ▀███▀▀▀▀    ███      ▀▀███▀▀▀███   ▄██▀██▄
    ███   ███  ███   ███   ███  ███   ███ ██████████  ███   █▄   ███   ███  ███   ███
    ███   ███  ███   ███   ███  ███   ███  ███   ███  ███   ███  ███   ███  ███   ███
     ▀█████▀    ▀█   ███   █▀   ███   █▀   ███   █▀   ███████▀   ███   █▀   ▀█   █▀
                                           ███   █▀
'
clear

echo -e "$ansi_art"
sleep 2

# Sync package databases
gum spin --spinner dot --spinner.foreground "#7aa2f7" --title "Syncing package databases..." -- \
  bash -c "pacman -Sy --disable-sandbox --noconfirm >/dev/null 2>&1; echo \$? > /tmp/pacman_status"

# Install sudo
gum spin --spinner dot --spinner.foreground "#7aa2f7" --title "Installing sudo..." -- \
  bash -c "pacman -S --disable-sandbox --noconfirm --needed sudo >/dev/null 2>&1; echo \$? > /tmp/pacman_status"

if [[ -f /tmp/pacman_status ]]; then
  status=$(cat /tmp/pacman_status)
  rm -f /tmp/pacman_status
else
  status=1
fi

if [ "$status" -eq 0 ]; then
  gum style --foreground 2 "✓ Installed sudo"
else
  gum style --foreground 1 "✗ Install failed (exit $status)"
  exit 1
fi

echo ""
gum style --foreground 4 --bold "Setup user and password for Omarchx!"
echo ""

# Create user
while true; do
    username=$(gum input \
      --placeholder "Username" \
      --prompt "  Username › " \
      --prompt.foreground "#7aa2f7" \
      --cursor.foreground "#7aa2f7")
    username="$(echo "$username" | tr -d '[:cntrl:]' | xargs)"

    if [ -z "$username" ]; then
        gum style --foreground 1 "Username cannot be empty."
        continue
    fi

    if ! [[ "$username" =~ ^[a-z_][a-z0-9_-]*$ ]]; then
        gum style --foreground 1 "Invalid username format."
        continue
    fi

    if id "$username" &>/dev/null; then
        gum style --foreground 1 "User $username already exists."
        continue
    fi

    if useradd -m "$username"; then
        gum style --foreground 2 "✓ User $username created successfully."
        break
    else
        gum style --foreground 1 "Failed to create user."
    fi
done

# Setup password
while true; do
    pass1=$(gum input \
      --password \
      --placeholder "Password" \
      --prompt "  Password › " \
      --prompt.foreground "#7aa2f7" \
      --cursor.foreground "#7aa2f7")

    if [ -z "$pass1" ]; then
        gum style --foreground 1 "Password cannot be empty."
        continue
    fi

    pass2=$(gum input \
      --password \
      --placeholder "Confirm password" \
      --prompt "  Confirm › " \
      --prompt.foreground "#7aa2f7" \
      --cursor.foreground "#7aa2f7")

    if [ "$pass1" != "$pass2" ]; then
        gum style --foreground 1 "Passwords do not match."
        continue
    fi

    echo "$username:$pass1" | chpasswd
    gum style --foreground 2 "✓ Password set successfully!"
    break
done

sleep 1.5

# Sudo setup
echo ""
gum style --foreground 4 "Sudo configuration"
echo ""

sudo_choice=$(gum choose "No sudo" "Sudo user" "No passwd sudo" \
  --header "Select sudo access level:" \
  --cursor.foreground "#7aa2f7" \
  --selected.foreground "#c0caf5" \
  --header.foreground "#565f89" \
  --height 6)

SUDOERS_DIR="/etc/sudoers.d"
SUDOERS_FILE="$SUDOERS_DIR/$username"
mkdir -p "$SUDOERS_DIR"

case "$sudo_choice" in
    "No sudo")
        rm -f "$SUDOERS_FILE"
        gum style --foreground 3 "No sudo granted."
        ;;
    "Sudo user")
        echo "$username ALL=(ALL:ALL) ALL" > "$SUDOERS_FILE"
        chmod 440 "$SUDOERS_FILE"
        gum style --foreground 2 "✓ Sudo granted."
        ;;
    "No passwd sudo")
        echo "$username ALL=(ALL) NOPASSWD: ALL" > "$SUDOERS_FILE"
        chmod 440 "$SUDOERS_FILE"
        gum style --foreground 2 "✓ NOPASSWD sudo granted."
        ;;
esac

sleep 1.5

# Save username before git reads corrupt it
_username="$username"

# Git configuration
clear
echo -e "$ansi_art"
echo ""
gum style --foreground 4 "Git configuration"
gum style --foreground 8 "Used for git config (Enter to skip)"
echo ""

git_username=$(gum input \
  --placeholder "GitHub username (Enter to skip)" \
  --prompt "  Username › " \
  --prompt.foreground "#7aa2f7" \
  --cursor.foreground "#7aa2f7")
export OMARCHX_USER_NAME="$git_username"

git_email=$(gum input \
  --placeholder "GitHub email (Enter to skip)" \
  --prompt "  Email › " \
  --prompt.foreground "#7aa2f7" \
  --cursor.foreground "#7aa2f7")
export OMARCHX_USER_EMAIL="$git_email"

git_token=$(gum input \
  --password \
  --placeholder "GitHub token (Enter to skip)" \
  --prompt "  Token › " \
  --prompt.foreground "#7aa2f7" \
  --cursor.foreground "#7aa2f7")
export OMARCHX_GIT_TOKEN="$git_token"

# Restore username
username="$_username"

# Apply git config
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
gum style --foreground 2 "✓ Setup complete for user: $username"

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
