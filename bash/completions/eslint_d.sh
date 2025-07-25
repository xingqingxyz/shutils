_eslint_d() {
  mapfile -t COMPREPLY < <({
    case "$3" in
      --ext)
        compgen -W '.js .cjs .mjs .jsx .ts .cts .mts .tsx .vue' -- "$2"
        ;;
      -f | --format)
        # TODO: recognize real formats
        compgen -W 'json stylish' -- "$2"
        ;;
      *)
        false
        ;;
    esac || compgen -W '-c --cache --cache-file --cache-location --config --debug --env --env-info --eslint-path --ext -f --fix --fix-dry-run --fix-to-stdout --fix-type --format --global -h --help --ignore-path --ignore-pattern --init --max-warnings --no-color --no-error-on-unmatched-pattern --no-eslintrc --no-ignore --no-inline-config --no-no-color -o --output-file --parser --parser-options --plugin --print-config --quiet --report-unused-disable-directives --resolve-plugins-relative-to --rule --rulesdir --stdin --stdin-filename -v --version' -- "$2"
  })
}

complete -o default -F _eslint_d eslint_d
