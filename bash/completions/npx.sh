_npx() {
  local prev
  if [ "$3" = = ]; then
    prev=${COMP_WORDS[COMP_CWORD - 2]}
  else
    prev=$3
  fi
  if [[ $COMP_CWORD == 1 && $2 != -* && -d node_modules/.bin ]]; then
    mapfile -t COMPREPLY < <(compgen -W "$(ls node_modules/.bin || true)" -- "$2")
  elif [[ $prev == --package && -f package.json ]]; then
    mapfile -t COMPREPLY < <(compgen -W "$(jq -r '.dependencies + .devDependencies|keys|.[]' < package.json || true)" -- "$2")
  else
    mapfile -t COMPREPLY < <(compgen -W '-w --workspace --package -c --call -ws --workspaces --include-workspace-root --help -v --version' -- "$2")
  fi
}

complete -o default -F _npx npx
