if ((BASH_VERSINFO[0] < 5 || BASH_VERSINFO[0] == 5 && BASH_VERSINFO[1] < 3)); then
  return
fi

declare LAST_CMD_DUR_C LAST_CMD_DUR_T LAST_CMD_TIME=$EPOCHREALTIME

PS0='${ LAST_CMD_TIME=$EPOCHREALTIME;}'
enable -f /usr/local/lib/bash/fltexpr fltexpr 2> /dev/null

_prompt() {
  local dur color
  fltexpr 'dur=EPOCHREALTIME-LAST_CMD_TIME'
  # colors: green, cyan, blue, yellow, magenta, red
  if fltexpr 'dur<0.001'; then
    color=32
    fltexpr 'dur*=1000000'
    printf -v dur '%.0fμs' "$dur"
  elif fltexpr 'dur<1'; then
    color=36
    fltexpr 'dur*=1000'
    printf -v dur '%.0fms' "$dur"
  elif fltexpr 'dur<1000'; then
    color=34
    printf -v dur '%.3fs' "$dur"
  else
    local left right
    printf -v left '%.0f' "$dur"
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

if [ -v __vsc_original_prompt_command ]; then
  declare -n name=__vsc_original_prompt_command
else
  declare -n name=PROMPT_COMMAND
fi
if [[ $name != *$'\n_prompt;'* ]]; then
  name=$'\n_prompt;'$name
fi
unset -n name

MAPFILE=(
  '\[\e[$((31 + !$?))m\]$?\[\e[0m\]'
  '(\!:\[\e[${LAST_CMD_DUR_C}m\]$LAST_CMD_DUR_T\[\e[0m\])'
  '\[\e]8;;file://$PWD\e\\\\\]\w\[\e]8;;\e\\\\\]'
  '$'
)
case "$OSTYPE" in
  msys | cygwin)
    MAPFILE[2]=${MAPFILE[2]/'$PWD'/'$(cygpath -w "$PWD")'}
    ;;
  linux-gnu)
    if declare -xp WSL_DISTRO_NAME &> /dev/null; then
      MAPFILE[2]=${MAPFILE[2]/'$PWD'/'$(wslpath -w "$PWD")'}
    fi
    ;;
esac
if declare -Fp __git_ps1 &> /dev/null; then
  MAPFILE[3]='$(__git_ps1)'${MAPFILE[3]}
fi
printf -v PS1 '%s ' "${MAPFILE[@]}"

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
