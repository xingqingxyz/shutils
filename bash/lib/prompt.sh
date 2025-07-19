_prompt() {
  local a1 a2 b1 b2
  IFS=. read -r a1 a2 <<< $EPOCHREALTIME
  IFS=. read -ru "${COPROC_PS0[0]}" b1 b2
  ((a1 -= b1))
  ((a2 = "1${a2}" - "1${b2}"))
  if ((a2 < 0)); then
    ((a2 += 1000000))
    ((a1--))
  fi
  local dur=$1 color
  # colors: green, cyan, blue, yellow, magenta, red
  if ((a1 == 0)); then
    if ((a2 < 1000)); then
      color=32
      dur=${a2}μs
    else
      color=36
      printf -v dur $((a2 / 1000)).%03dms $((a2 % 1000))
    fi
  elif ((a1 < 1000)); then
    color=34
    printf -v dur $a1.%03ds $((a2 / 1000))
  else
    local left=$a1 right
    if ((right = left % 60)) && (((left /= 60) < 60)); then
      color=33
      dur=${left}m${right}s
    elif ((right = left % 60)) && (((left /= 60) < 24)); then
      color=35
      dur=${left}h${right}m
    else
      ((right = left % 24))
      ((left /= 24))
      color=31
      dur=${left}d${right}h
    fi
  fi
  LAST_CMD_DUR_C=$color
  LAST_CMD_DUR_T=$dur
}
