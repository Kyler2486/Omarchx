draw_menu() {
  local options=("$@")
  local selected=0

  if [[ ! -e /dev/tty ]]; then
    # No TTY available, just print options and read normally
    echo -e "${BLUE}  What would you like to do?${RESET}"
    for i in "${!options[@]}"; do
      echo -e "  $((i+1))) ${options[$i]}"
    done
    read -r choice_num
    echo "${options[$((choice_num-1))]}"
    return
  fi

  # Draw initial options
  for opt in "${options[@]}"; do
    echo "    $opt"
  done

  while true; do
    local move_up=$(( ${#options[@]} + 1 ))
    printf "\033[${move_up}A"

    echo -e "${DIM}  Use ↑↓ to navigate, Enter to select${RESET}"
    for i in "${!options[@]}"; do
      if [[ $i -eq $selected ]]; then
        echo -e "${BLUE_BG}${BLUE}  › ${options[$i]}  ${RESET}"
      else
        echo -e "    ${FG}${options[$i]}${RESET}"
      fi
    done

    IFS= read -rsn1 key < /dev/tty
    case "$key" in
      $'\x1b')
        read -rsn2 key2 < /dev/tty
        case "$key2" in
          "[A") (( selected-- )) ;;
          "[B") (( selected++ )) ;;
        esac
        ;;
      "") echo "${options[$selected]}"; return ;;
    esac

    (( selected < 0 )) && selected=$(( ${#options[@]} - 1 ))
    (( selected >= ${#options[@]} )) && selected=0
  done
}
