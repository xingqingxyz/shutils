_sudo_accept() {
  READLINE_LINE="sudo $READLINE_LINE"
  ((READLINE_POINT += 5))
}

bind -x '"\es": _sudo_accept'
