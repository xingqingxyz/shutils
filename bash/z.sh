declare _ZOLDPWD

_z() {
  local out
  out=$(python "${BASH_SOURCE[0]%/*}/z.py" "$@")
  if [ $? = 99 ]; then
    cd -- "$out"
  elif [ "$out" ]; then
    echo "$out"
  fi
}

_z_prompt() {
  if [[ $_ZOLDPWD != $PWD ]]; then
    _ZOLDPWD=$PWD
    (_z -a . &)
  fi
}

if [ -v __vsc_original_prompt_command ]; then
  declare -n name=__vsc_original_prompt_command
else
  declare -n name=PROMPT_COMMAND
fi
if [[ $name != *$'\n_z_prompt;'* ]]; then
  name+=$'\n_z_prompt;'
  alias z=_z
fi
unset -n name
