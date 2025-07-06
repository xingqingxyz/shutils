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

name=PROMPT_COMMAND
if [ -v __vsc_original_prompt_command ]; then
  name=__vsc_original_prompt_command
fi
if [[ ${!name} != *'_z_prompt;'* ]]; then
  printf -v "$name" '%s\n_z_prompt;' "${!name}"
  unset name
  alias z=_z
fi
