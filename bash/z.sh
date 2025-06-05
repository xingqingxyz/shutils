_z() {
  local out
  out=$(py "${BASH_SOURCE[0]%/*}/z.py" "$@")
  if [ $? = 99 ]; then
    cd -- "$out"
  elif [ "$out" ]; then
    echo "$out"
  fi
}

declare _ZOLDPWD=$PWD
alias z=_z

if [[ $PROMPT_COMMAND != *'(_z '* ]]; then
  PROMPT_COMMAND+=('
[[ $_ZOLDPWD != $PWD ]] && {
  _ZOLDPWD=$PWD
  (_z -a . &)
}')
fi
