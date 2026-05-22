# Track if we're already handling an error to prevent double-trapping
ERROR_HANDLING=false
MENU_CHOICE=""

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
BOLD="\e[1m"

show_cursor() {
  printf "\033[?25h"
}

hide_cursor() {
  printf "\033[?25l"
}

categorize_error() {
  local cmd="$1"
  local exit_code="$2"
  local log_tail="$3"

  if echo "$log_tail" | grep -qi "failed to retrieve\|curl\|wget\|network\|dns\|connection refused\|no route to host\|timeout"; then
    echo "network"
  elif echo "$log_tail" | grep -qi "permission denied\|operation not permitted\|cannot open\|access denied"; then
    echo "permission"
  elif echo "$log_tail" | grep -qi "not found\|no such file\|command not found\|unknown command"; then
    echo "missing"
  elif echo "$log_tail" | grep -qi "conflict\|exists in filesystem\|unable to satisfy"; then
    echo "conflict"
  elif echo "$log_tail" | grep -qi "failed to commit transaction\|pacman\|package"; then
    echo "package"
  else
    echo "unknown"
  fi
}

get_error_advice() {
  local category="$1"
  case "$category" in
    "network")
      echo "  This looks like a network error. Check your internet connection and try again."
      ;;
    "permission")
      echo "  This looks like a permission error. Make sure you have the right sudo access."
      ;;
    "missing")
      echo "  A required command or file is missing. It may not have been installed yet."
      ;;
    "conflict")
      echo "  A package conflict was detected. You may need to remove conflicting packages first."
      ;;
    "package")
      echo "  A package installation failed. Try running 'pacman -Syu --disable-sandbox' manually."
      ;;
    *)
      echo "  An unexpected error occurred. Check the full log for more details."
      ;;
  esac
}

show_log_tail() {
  if [[ -f $OMARCHX_INSTALL_LOG_FILE ]]; then
    local log_lines=25
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
  local cmd="$BASH_COMMAND"

  if [[ -n ${CURRENT_SCRIPT:-} ]]; then
    echo -e "${RED}  ${BOLD}Failed script:${RESET}${RED} $CURRENT_SCRIPT${RESET}"
  fi

  if [[ -n "$cmd" ]]; then
    echo -e "${RED}  ${BOLD}Failed command:${RESET}${RED} $cmd${RESET}"
  fi

  if [[ -n ${BASH_LINENO[0]:-} ]]; then
    echo -e "${DIM}  Line: ${BASH_LINENO[0]}${RESET}"
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
  MENU_CHOICE=""

  if ! [[ -t 1 ]] || ! (echo "" > /dev/tty) 2>/dev/null; then
    echo -e "${BLUE}  What would you like to do?${RESET}\n"
    for i in "${!options[@]}"; do
      echo -e "  $((i+1))) ${FG}${options[$i]}${RESET}"
    done
    echo -ne "\n  Choice: "
    read -r choice_num < /dev/tty
    if [[ -z "$choice_num" ]] || ! [[ "$choice_num" =~ ^[0-9]+$ ]]; then
      choice_num=${#options[@]}
    fi
    MENU_CHOICE="${options[$((choice_num-1))]}"
    return
  fi

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
      "")
        MENU_CHOICE="${options[$selected]}"
        return
        ;;
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
  local failed_cmd="$BASH_COMMAND"

  stop_log_output
  restore_outputs

  clear
  show_cursor

  echo -e "\n${RED}${BOLD}  Omarchx installation stopped!${RESET}\n"

  show_log_tail

  echo -e "${YELLOW}${BOLD}  Exit code $exit_code${RESET}"
  show_failed_script_or_command
  echo

  local log_tail=""
  if [[ -f $OMARCHX_INSTALL_LOG_FILE ]]; then
    log_tail=$(tail -n 20 "$OMARCHX_INSTALL_LOG_FILE")
  fi

  local category
  category=$(categorize_error "$failed_cmd" "$exit_code" "$log_tail")

  echo -e "${CYAN}  Error type: ${BOLD}$category${RESET}"
  echo -e "${FG}$(get_error_advice "$category")${RESET}"
  echo

  if [[ "$category" == "network" ]]; then
    echo -e "${YELLOW}  Network error detected — retrying in 5 seconds...${RESET}"
    sleep 5
    if ping -c 1 -W 3 1.1.1.1 >/dev/null 2>&1; then
      echo -e "${GREEN}  Connection restored. Retrying installation...${RESET}"
      sleep 1
      ERROR_HANDLING=false
      bash ~/.local/share/Omarchx/install.sh
      return
    else
      echo -e "${RED}  Still no connection. Please check your network.${RESET}\n"
    fi
  fi

  echo -e "${DIM}  Get help at https://discord.gg/tXFUdasqhY${RESET}\n"

  while true; do
    local options=()

    if [[ -n ${OMARCHX_ONLINE_INSTALL:-} ]]; then
      options+=("Retry installation")
    fi

    if ping -c 1 -W 1 1.1.1.1 >/dev/null 2>&1; then
      options+=("Upload log for support")
    fi

    options+=("View full log")
    options+=("Exit")

    draw_menu "${options[@]}"
    local choice="$MENU_CHOICE"

    case "$choice" in
      "Retry installation")
        ERROR_HANDLING=false
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
