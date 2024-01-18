_nix-build() {
  mapfile -t COMPREPLY < <({
    case "$3" in
      -I)
        compgen -f -- "$2" | sort
        ;;
      --log-format)
        compgen -W 'bar bar-with-logs internal-json raw' -- "$2"
        ;;
      *)
        compgen -W '--arg --argstr --attr --cores --dry-run --expr --fallback --help --keep-failed --keep-going --log-format --max-jobs --max-silent-time --no-build-output --no-out-link --option --out-link --quiet --readonly-mode --repair --timeout --verbose --version -A -E -I -K -Q -W -j -k -o -v' -- "$2"
        ;;
    esac
  })
}

complete -o nosort -F _nix-build nix-build
