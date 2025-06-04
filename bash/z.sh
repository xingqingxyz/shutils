_z() {
  local out
  out=$(py "${BASH_SOURCE[0]%/*}/z.py" "$@")
  if [ $? = 99 ]; then
    eval "$out"
  else
    echo -n "$out"
  fi
}

alias z=_z

if [[ $PROMPT_COMMAND != *'(_z '* ]]; then
  # silent job msg
  PROMPT_COMMAND+=$'\n''(_z -a . &)'
fi
