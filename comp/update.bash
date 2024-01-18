_update() {
  local dir i
  dir="$(dirname "$BASH_SOURCE")/../pkgs"
  for i in "$dir/"*; do
    i=$(basename "$i" .sh)
    if [[ "$i" == "$2"* ]]; then
      COMPREPLY+=("$i")
    fi
  done
}

complete -o nosort -F _update update
