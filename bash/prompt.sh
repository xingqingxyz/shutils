declare LAST_CMD_DUR_C LAST_CMD_DUR_T

coproc COPROC_PS0 {
  cat
}

PS0='$(echo "$EPOCHREALTIME" >&"${COPROC_PS0[1]}")'
: "${PS0@P}"

_prompt() {
  local a1 a2 b1 b2
  IFS=. read -r a1 a2 <<< "$EPOCHREALTIME"
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

name=PROMPT_COMMAND
if [ -v __vsc_original_prompt_command ]; then
  name=__vsc_original_prompt_command
fi
if [[ ${!name} != *'_prompt;'* ]]; then
  printf -v "$name" '_prompt;%s' "${!name}"
  unset name
fi

items=(
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
IFS= PS1=${items[*]}
unset items

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
