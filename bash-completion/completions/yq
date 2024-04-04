_yq() {
  mapfile -t COMPREPLY < <({
    case "$3" in
      --yaml-output-version | --yml-out-ver)
        compgen -W '1.1 1.2' -- "$2"
        ;;
      *) false ;;
    esac || compgen -W '-h --help --yaml-output --yml-output -y --yaml-roundtrip --yml-roundtrip -Y --yaml-output-grammer-version --yml-out-ver --width --indentless-lists --indentless --explicit-start --explicit-end --in-place -i --version' -- "$2"
    if [ "$(type -t _jq)" = function ]; then
      _jq "$@" && printf '%s\n' "${COMPREPLY[@]}"
    fi
  })
}

complete -o default -F _yq yq
