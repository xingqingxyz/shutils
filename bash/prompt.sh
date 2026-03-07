declare LAST_CMD_DUR_C LAST_CMD_DUR_T LAST_CMD_TIME=$EPOCHREALTIME
has_bash53=$((BASH_VERSINFO[0] > 5 || BASH_VERSINFO[0] == 5 && BASH_VERSINFO[1] >= 3))

if ((has_bash53)); then
  PS0='${ LAST_CMD_TIME=$EPOCHREALTIME;}'
fi

_prompt() {
  if ((!has_bash53)); then
    return
  fi
  local dur color left right
  dur=$(awk "{printf \"%f\", $EPOCHREALTIME-$LAST_CMD_TIME}" <<< '')
  printf -v left '%.0f' "$dur"
  right=${dur: -6}
  # colors: green, cyan, blue, yellow, magenta, red
  if ((left == 0 && ${right##+(0)} < 1000)); then
    color=32
    dur=${right##+(0)}μs
  elif ((left == 0)); then
    color=36
    left=${right:0:3}
    dur=${left##+(0)}.${right:3}ms
  elif ((left < 1000)); then
    color=34
    dur=$left.${right:0:3}s
  elif ((right = left % 60)) && (((left /= 60) < 60)); then
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
  '$ '
)
if ((!has_bash53)); then
  MAPFILE[1]='\!'
fi
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
  MAPFILE[2]+='$(__git_ps1)'
fi
PS1=${MAPFILE[*]}
