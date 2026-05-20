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

pkg=git

  install_pkg() {
  pacman -Syu --noconfirm --needed "$pkg" --quiet >/dev/null 2>&1
}

dots_spinner() {
  local pid=$1 delay=0.4 n=0 max=3 dots='...'
  tput civis 2>/dev/null
  while kill -0 "$pid" 2>/dev/null; do
    n=$(( (n % max) + 1 ))
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
fi
done
sleep 1
printf "Installation starting..."
rm -rf ~/.local/share/Omarchx
git clone --quiet https://github.com/Kyler2486/Omarchx.git ~/.local/share/>/dev/null 2>&1
sleep 1
clear
source ~/.local/share/Omarchx/install.sh

