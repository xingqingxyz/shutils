declare LAST_CMD_TIME=$EPOCHREALTIME LAST_CMD_DUR

format_dur() {
  local color text
  # colors: green, cyan, blue, yellow, magenta, red
  if [ ${1:0:-3} = 0000000000.000 ]; then
    color=32
    text=$(( "1${1: -3}" - 1000 ))μs
  elif [ ${1:0:10} = 0000000000 ]; then
    color=36
    text=$(( "1${1: -6:3}" - 1000 )).${1: -3}ms
  elif [ ${1:0:7} = 0000000 ]; then
    color=34
    text=$(( "1${1:7:3}" - 1000 )).${1: -6:3}s
  else
    local left=${1:0:10} right
    if (( right = left % 60 )) && (( (left /= 60) < 60 )); then
      color=33
      text=${left}m${right}s
    elif (( right = left % 60 )) && (( (left /= 60) < 24 )); then
      color=35
      text=${left}h${right}m
    else
      (( right = left % 24 ))
      (( left /= 24 ))
      color=31
      text=${left}d${right}h
    fi
  fi
  echo -e "\\e[${color}m$text\\e[0m"
}

make_link() {
  local path=$1
  case "$OSTYPE" in
    msys|cygwin)
      path=$(cygpath -w "$1")
      ;;
    linux-gnu|darwin)
      if [ -v WSLENV ]; then
        # FIXME: ${val@P} expansion bugs
        path=$(wslpath -w "$1")
        path=${path//\\/'\\\\'}
      fi
      ;;
    *)
      echo "$path"
      return
  esac
  printf '\e]8;;file://%s\a%s\e]8;;\a' "$path" "${2:-$1}"
}

_on_invoke() {
  LAST_CMD_TIME=$EPOCHREALTIME
}

_prompt() {
  local code=$?
  LAST_CMD_DUR=$(awk "{printf \"%017.6f\", ($EPOCHREALTIME - $LAST_CMD_TIME)}" <<< '')
  if [ $code = 0 ]; then
    PS1="\e[32mOK\e[0m ($(format_dur "$LAST_CMD_DUR")) $(make_link "$PWD") \e[32m$\e[0m "
  else
    PS1="\e[31m$code\e[0m ($(format_dur "$LAST_CMD_DUR")) $(make_link "$PWD") \e[31m$\e[0m "
  fi
  return $code
}

_idefault_complete() {
  mapfile -t COMPREPLY < <(compgen -v -S = -- "$2")
  [ ${#COMPREPLY[@]} != 0 ] && compopt -o nospace
}

bind '"\C-x\C-j": accept-line'
bind -x '"\C-x\C-i": _on_invoke'
bind '"\C-j": "\C-m"'
bind '"\C-m": "\C-x\C-i\C-x\C-j"'

if [[ $PROMPT_COMMAND != '_prompt;'* ]]; then
  PROMPT_COMMAND="_prompt;$PROMPT_COMMAND"
fi

if [[ $OSTYPE = @(linux-gnu|darwin) ]]; then
  complete -o bashdefault -F _idefault_complete -I
fi
