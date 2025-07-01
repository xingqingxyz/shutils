declare _ZOLDPWD

_z() {
  local out
  out=$(py "${BASH_SOURCE[0]%/*}/z.py" "$@")
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

if [[ $PROMPT_COMMAND != *'_z_prompt;'* ]]; then
  PROMPT_COMMAND[0]="_z_prompt;${PROMPT_COMMAND[0]}"
  alias z=_z
fi
