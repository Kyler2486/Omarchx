#!/usr/bin/env bash
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
echo -e "\n$ansi_art\n\nLet's install Omarchx!\n"
sleep 1

printf "Installing/updating git.\n"
sleep 1

pkg="git"

install_pkg() {
  sudo pacman -Syu --disable-sandbox --noconfirm --needed "$pkg" >/dev/null 2>&1
}

dots_spinner() {
  local pid=$1 delay=0.4 n=0 dots='...'
  tput civis 2>/dev/null

  while kill -0 "$pid" 2>/dev/null; do
    n=$(( (n % 3) + 1 ))
    printf "\r%.*s\033[K" "$n" "$dots"
    sleep "$delay"
  done

  tput cnorm 2>/dev/null
  printf "\r\033[K"
}

install_pkg & pid=$!
dots_spinner "$pid"

wait "$pid"
status=$?

if [ "$status" -eq 0 ]; then
  printf "Installed %s\n" "$pkg"
else
  printf "Install failed (exit %d)\n" "$status"
  exit 1
fi

sleep 1
printf "Installation starting...\n"
sleep 1

INSTALL_DIR="$HOME/.local/share/Omarchx"

rm -rf "$INSTALL_DIR" >/dev/null 2>&1

git clone --quiet https://github.com/Kyler2486/Omarchx.git "$INSTALL_DIR" >/dev/null 2>&1

if [ $? -ne 0 ]; then
  echo "Clone failed"
  exit 1
fi

clear
bash "$INSTALL_DIR/install.sh"
