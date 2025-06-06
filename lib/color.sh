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
  printf '\e[%dm%s\e[0m' "$color" "$text"
}

vmake_link() {
  local path=$1
  case "$OSTYPE" in
    msys|cygwin)
      path=$(cygpath -w "$1")
      ;;
    linux-gnu|darwin)
      if [ -v WSLENV ]; then
        # FIXME: ${val@P} expansion bugs
        path=$(wslpath -w "$1")
      fi
      ;;
    *)
      echo "$path"
      return
  esac
  path=${path//\\/'\\\\'}
  printf '\e]8;;file://%s\a%s\e]8;;\a' "$path" "${2:-$1}"
}
