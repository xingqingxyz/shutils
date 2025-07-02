declare LAST_CMD_TIME=$EPOCHREALTIME LAST_CMD_DUR_C LAST_CMD_DUR_T

_on_invoke() {
  LAST_CMD_TIME=$EPOCHREALTIME
}

_prompt() {
  local a1 a2 b1 b2
  IFS=. read -r a1 a2 <<< "$EPOCHREALTIME"
  IFS=. read -r b1 b2 <<< "$LAST_CMD_TIME"
  ((a1 -= b1))
  ((a2 = "1${a2}" - "1${b2}"))
  local dur=$1 color
  # colors: green, cyan, blue, yellow, magenta, red
  if ((a1 == 0)); then
    if ((a2 < 1000)); then
      color=32
      dur=${a2}μs
    else
      color=36
      dur=$((a2 / 1000)).$((a2 % 1000))ms
    fi
  elif ((a1 < 1000)); then
    color=34
    dur=$a1.$((a2 / 1000))s
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

_idefault_complete() {
  mapfile -t COMPREPLY < <(compgen -v -S = -- "$2")
}

complete -o bashdefault -o default -o nospace -F _idefault_complete -I

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

declare -a items=(
  '\!:\[\e[$((31 + !$?))m\]$?\[\e[0m\]:'
  '\[\e[${LAST_CMD_DUR_C}m\]$LAST_CMD_DUR_T\[\e[0m\]:'
  '\[\e]8;;file://$PWD\e\\\\\]\w\[\e]8;;\e\\\\\]'
  ' $ '
)
case "$OSTYPE" in
  msys | cygwin)
    items[2]=${items[2]/'$PWD'/'$(cygpath -w "$PWD")'}
    ;;
  linux-gnu)
    if declare -xp WSL_DISTRO_NAME &> /dev/null; then
      items[2]=${items[2]/'$PWD'/'$(wslpath -w "$PWD")'}
    fi
    ;;
esac
if declare -Fp __git_ps1 &> /dev/null; then
  items[3]='$(__git_ps1)'${items[3]}
fi
PS1=$(printf '%s' "${items[@]}")
unset items

if [[ $PROMPT_COMMAND != *'_prompt;'* ]]; then
  PROMPT_COMMAND="_prompt;$PROMPT_COMMAND"
  bind -x '"\eo": _on_invoke'
  bind '"\C-m": "\eo\C-j"'
fi
