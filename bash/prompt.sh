declare LAST_CMD_TIME=$EPOCHREALTIME LAST_CMD_DUR=0

_on_invoke() {
  LAST_CMD_TIME=$EPOCHREALTIME
}

_prompt() {
  LAST_CMD_DUR=$(awk "{printf \"%017.6f\", ($EPOCHREALTIME - $LAST_CMD_TIME)}" <<< '')
}

_format_excution() {
  local code=$? dur=$LAST_CMD_DUR color
  color=$((31 + !$?))
  echo -ne "\e[${color}m$code\e[0m:"
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
  echo -ne "\e[${color}m$dur\e[0m"
}

_idefault_complete() {
  mapfile -t COMPREPLY < <(compgen -v -S = -- "$2")
  [ ${#COMPREPLY[@]} != 0 ] && compopt -o nospace
}

complete -o bashdefault -F _idefault_complete -I

if ! declare -Fp _completion_loader &> /dev/null; then
  _completion_loader() {
    local name
    name=$(basename -- "$1")
    if [ -f "$SHUTILS_ROOT/bash/completions/$name.sh" ]; then
      . "$SHUTILS_ROOT/bash/completions/$name.sh"
      return 124
    fi
    return 1
  }
  complete -o bashdefault -o default -F _completion_loader -D
fi

path='$PWD'
case "$OSTYPE" in
  msys | cygwin)
    path='$(cygpath -w "$PWD")'
    ;;
  linux-gnu)
    if [ -v WSL_DISTRO_NAME ]; then
      path='$(wslpath -w "$PWD")'
    fi
    ;;
esac
PS1='\!:$(_format_excution):\e]8;;file://'"$path"'\e\\\\\w\e]8;;\e\\\\$(__git_ps1) $ '
unset path

if [[ $PROMPT_COMMAND != *'_prompt;'* ]]; then
  PROMPT_COMMAND[0]="_prompt;${PROMPT_COMMAND[0]}"
  bind -x '"\eo": _on_invoke'
  bind '"\C-m": "\eo\C-j"'
fi
