declare LAST_CMD_TIME=$EPOCHREALTIME

_on_invoke() {
  LAST_CMD_TIME=$EPOCHREALTIME
}

_prompt() {
  local code=$? path=$PWD items color dur
  dur=$(awk "{printf \"%017.6f\", ($EPOCHREALTIME - $LAST_CMD_TIME)}" <<< '')

  # colors: green, cyan, blue, yellow, magenta, red
  if [ ${dur:0:-3} = 0000000000.000 ]; then
    color=32
    dur=$(("1${dur: -3}" - 1000))μs
  elif [ ${dur:0:10} = 0000000000 ]; then
    color=36
    dur=$(("1${dur: -6:3}" - 1000)).${dur: -3}ms
  elif [ ${dur:0:7} = 0000000 ]; then
    color=34
    dur=$(("1${dur:7:3}" - 1000)).${dur: -6:3}s
  else
    local left=$(("1${dur:0:10}" - 10000000000)) right
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

  case "$OSTYPE" in
    msys | cygwin)
      path=$(cygpath -w "$path")
      ;;
    linux-gnu | darwin)
      if [ -v WSLENV ]; then
        path=$(wslpath -w "$path")
      fi
      ;;
  esac
  # FIXME: ${val@P} expansion bugs
  path=${path//\\/'\\\\'}

  items=(
    '\!'
    '(\e['"${color}m$dur"'\e[0m)'
    '\e]8;;file://'"$path"'\e\\\w\e]8;;\e\\'
    '\n$ '
  )
  if [ $code != 0 ]; then
    items[0]='\e[31m'$code'\e[0m:\!'
  fi
  PS1=${items[*]}
}

_idefault_complete() {
  mapfile -t COMPREPLY < <(compgen -v -S = -- "$2")
  [ ${#COMPREPLY[@]} != 0 ] && compopt -o nospace
}

if [[ $PROMPT_COMMAND != '_prompt;'* ]]; then
  PROMPT_COMMAND[0]='_prompt;'
  bind -x '"\C-x\C-i": _on_invoke'
  bind '"\C-m": "\C-x\C-i\C-j"'
fi

complete -o bashdefault -F _idefault_complete -I
