_pkg() {
  mapfile -t COMPREPLY < <({
    case "${COMP_WORDS[1]}" in
      upgrade)
        local i a=("${BASH_SOURCE[0]%/*}/../../pkgs/"*.sh)
        for i in "${!a[@]}"; do
          a[i]=$(basename "${a[i]}" .sh)
        done
        compgen -W "${a[*]}" -- "$2"
        ;;
      *) [ "$COMP_CWORD" = 1 ] && compgen -W 'upgrade -h --help -v --version' -- "$2" ;;
    esac
  })
}

complete -F _pkg pkg
