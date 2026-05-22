# Track if we're already handling an error to prevent double-trapping
ERROR_HANDLING=false

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
      echo "This looks like a network error. Check your internet connection and try again."
      ;;
    "permission")
      echo "This looks like a permission error. Make sure you have the right sudo access."
      ;;
    "missing")
      echo "A required command or file is missing. It may not have been installed yet."
      ;;
    "conflict")
      echo "A package conflict was detected. You may need to remove conflicting packages first."
      ;;
    "package")
      echo "A package installation failed. Try running 'pacman -Syu --disable-sandbox' manually."
      ;;
    *)
      echo "An unexpected error occurred. Check the full log for more details."
      ;;
  esac
}

show_log_tail() {
  if [[ -f $OMARCHX_INSTALL_LOG_FILE ]]; then
    local log_lines=25
    tail -n $log_lines "$OMARCHX_INSTALL_LOG_FILE" | while IFS= read -r line; do
      if (( ${#line} > 76 )); then
        gum style --foreground 8 "  ${line:0:76}..."
      else
        gum style --foreground 8 "  $line"
      fi
    done
    echo
  fi
}

show_failed_script_or_command() {
  local cmd="$BASH_COMMAND"

  if [[ -n ${CURRENT_SCRIPT:-} ]]; then
    gum style --foreground 1 "  Failed script: $CURRENT_SCRIPT"
  fi

  if [[ -n "$cmd" ]]; then
    gum style --foreground 1 "  Failed command: $cmd"
  fi

  if [[ -n ${BASH_LINENO[0]:-} ]]; then
    gum style --foreground 8 "  Line: ${BASH_LINENO[0]}"
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

catch_errors() {
  if [[ $ERROR_HANDLING == "true" ]]; then
    return 0
  else
    ERROR_HANDLING=true
  fi

  trap 'exit 1' INT

  local exit_code=$?
  local failed_cmd="$BASH_COMMAND"

  stop_log_output
  restore_outputs

  clear_logo
  show_cursor

  gum style --foreground 1 --padding "1 0 0 $PADDING_LEFT" "Omarchx installation stopped!"

  show_log_tail

  gum style --foreground 3 "  Exit code $exit_code:"
  show_failed_script_or_command
  echo

  local log_tail=""
  if [[ -f $OMARCHX_INSTALL_LOG_FILE ]]; then
    log_tail=$(tail -n 20 "$OMARCHX_INSTALL_LOG_FILE")
  fi

  local category
  category=$(categorize_error "$failed_cmd" "$exit_code" "$log_tail")

  gum style --foreground 6 "  Error type: $category"
  gum style --foreground 7 "  $(get_error_advice "$category")"
  echo

  if [[ "$category" == "network" ]]; then
    gum style --foreground 3 "  Network error detected — retrying in 5 seconds..."
    sleep 5
    if ping -c 1 -W 3 1.1.1.1 >/dev/null 2>&1; then
      gum style --foreground 2 "  Connection restored. Retrying installation..."
      sleep 1
      ERROR_HANDLING=false
      bash ~/.local/share/Omarchx/install.sh
      return
    else
      gum style --foreground 1 "  Still no connection. Please check your network."
      echo
    fi
  fi

  gum style --foreground 8 "  Get help from the community via QR code or at https://discord.gg/tXFUdasqhY"
  echo

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

    choice=$(gum choose "${options[@]}" --header "What would you like to do?" --height 6 --padding "1 $PADDING_LEFT")

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
