# Track if we're already handling an error to prevent double-trapping
ERROR_HANDLING=false

# Colors - Tokyo Night
RESET="\e[0m"
RED="\e[38;2;247;118;142m"
GREEN="\e[38;2;158;206;106m"
YELLOW="\e[38;2;224;175;104m"
BLUE="\e[38;2;122;162;247m"
CYAN="\e[38;2;68;157;171m"
FG="\e[38;2;169;177;214m"
DIM="\e[38;2;120;124;153m"
BG="\e[48;2;26;27;38m"
BLUE_BG="\e[48;2;36;40;59m"

show_cursor() {
  printf "\033[?25h"
}

hide_cursor() {
  printf "\033[?25l"
}

show_log_tail() {
  if [[ -f $OMARCHX_INSTALL_LOG_FILE ]]; then
    local log_lines=15
    echo -e "${DIM}"
    tail -n $log_lines "$OMARCHX_INSTALL_LOG_FILE" | while IFS= read -r line; do
      if (( ${#line} > 76 )); then
        echo "  ${line:0:76}..."
      else
        echo "  $line"
      fi
    done
    echo -e "${RESET}"
  fi
}

show_failed_script_or_command() {
  if [[ -n ${CURRENT_SCRIPT:-} ]]; then
    echo -e "${RED}  Failed script: ${CURRENT_SCRIPT}${RESET}"
  else
    local cmd="$BASH_COMMAND"
    if (( ${#cmd} > 76 )); then
      cmd="${cmd:0:76}..."
    fi
    echo -e "${RED}  ✗ ${cmd}${RESET}"
  fi
}

save_original_outputs() {
  exec 3>&1 4>&2
}

restore_outputs() {
  if [[ -e /proc/self/fd/3 ]] && [[ -e /proc/self/fd/4 ]]; then
    exec 1>&3 2>&4
  fi
}

draw_menu() {
  local options=("$@")
  local selected=0

  if ! [[ -t 1 ]] || ! (echo "" > /dev/tty) 2>/dev/null; then
    echo -e "${BLUE}  What would you like to do?${RESET}\n"
    for i in "${!options[@]}"; do
      echo -e "  $((i+1))) ${FG}${options[$i]}${RESET}"
    done
    echo -ne "\n  Choice: "
    read -r choice_num
    if [[ -z "$choice_num" ]] || ! [[ "$choice_num" =~ ^[0-9]+$ ]]; then
      choice_num=${#options[@]}
    fi
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

catch_errors() {
  if [[ $ERROR_HANDLING == "true" ]]; then
    exit 1
  else
    ERROR_HANDLING=true
  fi

  trap 'exit 1' INT

  local exit_code=$?

  stop_log_output
  restore_outputs

  clear
  show_cursor

  echo -e "\n${RED}  Omarchx installation stopped!${RESET}\n"
  show_log_tail

  echo -e "${YELLOW}  This command halted with exit code $exit_code:${RESET}"
  show_failed_script_or_command
  echo

  echo -e "${DIM}  Get help at https://discord.gg/tXFUdasqhY${RESET}\n"

  while true; do
    options=()

    if [[ -n ${OMARCHX_ONLINE_INSTALL:-} ]]; then
      options+=("Retry installation")
    fi

    if ping -c 1 -W 1 1.1.1.1 >/dev/null 2>&1; then
      options+=("Upload log for support")
    fi

    options+=("View full log")
    options+=("Exit")

    echo -e "${BLUE}  What would you like to do?${RESET}\n"

    choice=$(draw_menu "${options[@]}")

    case "$choice" in
      "Retry installation")
        bash ~/.local/share/Omarchx/install.sh
        break
        ;;
      "View full log")
        if command -v less &>/dev/null; then
          less "$OMARCHX_INSTALL_LOG_FILE"
        else
          tail "$OMARCHX_INSTALL_LOG_FILE"
        fi
        ;;
      "Upload log for support")
        omarchx-upload-log
        ;;
      "Exit" | "")
        exit 1
        ;;
    esac
  done
}

exit_handler() {
  local exit_code=$?

  if (( exit_code != 0 )) && [[ $ERROR_HANDLING != "true" ]]; then
    catch_errors
  else
    stop_log_output
    show_cursor
  fi
}

trap catch_errors ERR TERM
trap 'exit 1' INT
trap exit_handler EXIT

save_original_outputs
