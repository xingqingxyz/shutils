_quicktype() {
  case "$3" in
    -l | --lang)
      mapfile -t COMPREPLY < <(compgen -W 'cs go rs cr cjson c++ objc java ts js javascript-prop-types flow swift scala3 Smithy kotlin elm schema ruby dart py pike haskell typescript-zod typescript-effect-schema php' -- "$2")
      ;;
    -s | --src-lang)
      mapfile -t COMPREPLY < <(compgen -W 'json schema graphql postman typescript' -- "$2")
      ;;
    --debug)
      compopt -o nospace
      mapfile -t COMPREPLY < <(compgen -P "${2%%*([^,])}" -W 'all print-graph print-reconstitution print-gather-names print-transformations print-schema-resolving print-times provenance' -- "${2##*,}")
      ;;
    --telemetry)
      mapfile -t COMPREPLY < <(compgen -W 'enable disable' -- "$2")
      ;;
    *)
      local i lang
      for i in "${!COMP_WORDS[@]}"; do
        case "${COMP_WORDS[i]}" in
          -l | --lang)
            lang=${COMP_WORDS[i + 1]}
            break
            ;;
        esac
      done

      case "$lang" in
        cs)
          case "$3" in
            --framework)
              mapfile -t COMPREPLY < <(compgen -W 'NewtonSoft SystemTextJson' -- "$2")
              ;;
            --csharp-version)
              mapfile -t COMPREPLY < <(compgen -W '5 6' -- "$2")
              ;;
            --density)
              mapfile -t COMPREPLY < <(compgen -W 'normal dense' -- "$2")
              ;;
            --array-type)
              mapfile -t COMPREPLY < <(compgen -W 'array list' -- "$2")
              ;;
            --number-type)
              mapfile -t COMPREPLY < <(compgen -W 'double decimal' -- "$2")
              ;;
            --any-type)
              mapfile -t COMPREPLY < <(compgen -W 'object dynamic' -- "$2")
              ;;
            --features)
              mapfile -t COMPREPLY < <(compgen -W 'complete attributes-only just-types-and-namespace just-types' -- "$2")
              ;;
            --base-class)
              mapfile -t COMPREPLY < <(compgen -W 'EntityData Object' -- "$2")
              ;;
            *)
              [[ $2 == -* ]] || return
              mapfile -t COMPREPLY < <(compgen -W '--framework --namespace --csharp-version --density --array-type --number-type --any-type --virtual --no-virtual --features --base-class --check-required --no-check-required --keep-property-name --no-keep-property-name' -- "$2")
              ;;
          esac
          ;;
        go)
          mapfile -t COMPREPLY < <(compgen -W '--just-types --no-just-types --just-types-and-package --no-just-type-and-package --package --multi-file-output --no-multi-file-output --field-tags --omit-empty --no-omit-empty' -- "$2")
          ;;
        rs)
          case "$3" in
            --density)
              mapfile -t COMPREPLY < <(compgen -W 'normal dense' -- "$2")
              ;;
            *)
              [[ $2 == -* ]] || return
              mapfile -t COMPREPLY < <(compgen -W '--density --visibility --derive-debug --no-derive-debug --derive-clone --no-derive-clone --derive-partial-eq --no-derive-partial-eq --edition-2018 --no-edition-2018 --leading-comments --no-leading-comments --skip-serializing-none --no-skip-serializing-none' -- "$2")
              ;;
          esac
          ;;
        cjson)
          case "$3" in
            --source-type)
              mapfile -t COMPREPLY < <(compgen -W 'single-source multi-source' -- "$2")
              ;;
            --integer-size)
              mapfile -t COMPREPLY < <(compgen -W 'int8_t int16_t int32_t int64_t' -- "$2")
              ;;
            --typedef-alias)
              mapfile -t COMPREPLY < <(compgen -W 'no-typedef add-typedef' -- "$2")
              ;;
            --print-style)
              mapfile -t COMPREPLY < <(compgen -W 'print-formatted print-unformatted' -- "$2")
              ;;
            --type-style | --member-style | --enumerator-style)
              mapfile -t COMPREPLY < <(compgen -W 'pascal-case underscore-case camel-case upper-underscore-case pascal-case-upper-acronyms camel-case-upper-acronyms' -- "$2")
              ;;
            *)
              [[ $2 == -* ]] || return
              mapfile -t COMPREPLY < <(compgen -W '--source-type --integer-size --typedef-alias --print-style --hashable-size --type-style --member-style --enumerator-style' -- "$2")
              ;;
          esac
          ;;
        c++)
          case "$3" in
            --code-format)
              mapfile -t COMPREPLY < <(compgen -W 'with-struct with-getter-setter' -- "$2")
              ;;
            --wstring)
              mapfile -t COMPREPLY < <(compgen -W 'use-string use-wstring' -- "$2")
              ;;
            --const-style)
              mapfile -t COMPREPLY < <(compgen -W 'west-const east-const' -- "$2")
              ;;
            --source-style)
              mapfile -t COMPREPLY < <(compgen -W 'single-source multi-source' -- "$2")
              ;;
            --include-location)
              mapfile -t COMPREPLY < <(compgen -W 'local-include global-include' -- "$2")
              ;;
            --type-style | --member-style | --enumerator-style)
              mapfile -t COMPREPLY < <(compgen -W 'pascal-case underscore-case camel-case upper-underscore-case pascal-case-upper-acronyms camel-case-upper-acronyms' -- "$2")
              ;;
            *)
              [[ $2 == -* ]] || return
              mapfile -t COMPREPLY < <(compgen -W '--just-types --no-just-types --namespace --code-format --wstring --const-style --source-style --include-location --type-style --member-style --enumerator-style --enum-type --boost --no-boost --hide-null-optional --no-hide-null-optional' -- "$2")
              ;;
          esac
          ;;
        objc)
          case "$3" in
            --features)
              mapfile -t COMPREPLY < <(compgen -W 'all interface implementation' -- "$2")
              ;;
            *)
              [[ $2 == -* ]] || return
              mapfile -t COMPREPLY < <(compgen -W '--just-types --no-just-types --class-prefix --features --extra-comments --no-extra-comments --functions --no-functions' -- "$2")
              ;;
          esac
          ;;
        java)
          case "$3" in
            --array-type)
              mapfile -t COMPREPLY < <(compgen -W 'array list' -- "$2")
              ;;
            --datetime-provider)
              mapfile -t COMPREPLY < <(compgen -W 'java8 legacy' -- "$2")
              ;;
            --acronym-style)
              mapfile -t COMPREPLY < <(compgen -W 'original pascal camel lowerCase' -- "$2")
              ;;
            *)
              [[ $2 == -* ]] || return
              mapfile -t COMPREPLY < <(compgen -W '--array-type --just-types --no-just-types --datetime-provider --acronym-style --package --lombok --no-lombok --lombok-copy-annotations --no-lombok-copy-annotations' -- "$2")
              ;;
          esac
          ;;
        ts | js | flow | typescript-effect-schema | typescript-zod)
          case "$3" in
            --acronym-style)
              mapfile -t COMPREPLY < <(compgen -W 'original pascal camel lowerCase' -- "$2")
              ;;
            --converters)
              mapfile -t COMPREPLY < <(compgen -W 'top-level all-objects' -- "$2")
              ;;
            --raw-type)
              mapfile -t COMPREPLY < <(compgen -W 'json any' -- "$2")
              ;;
            *)
              [[ $2 == -* ]] || return
              if [ "$3" = js ]; then
                mapfile -t COMPREPLY < <(compgen -W '--runtime-typecheck --no-runtime-check --runtime-typecheck-ignore-unknown-properties --no-runtime-typecheck-ignore-unknown-properties --acronym-style --converters --raw-type' -- "$2")
              else
                mapfile -t COMPREPLY < <(compgen -W '--just-types --no-just-types --nice-property-names --no-nice-property-names --explicit-unions --no-explicit-unions --runtime-typecheck --no-runtime-check --runtime-typecheck-ignore-unknown-properties --no-runtime-typecheck-ignore-unknown-properties --acronym-style --converters --raw-type --prefer-unions --no-prefer-unions --prefer-types --no-prefer-types --prefer-const-values --no-prefer-const-values --readonly --no-readonly' -- "$2")
              fi
              ;;
          esac
          ;;
        javascript-prop-types)
          case "$3" in
            --acronym-style)
              mapfile -t COMPREPLY < <(compgen -W 'original pascal camel lowerCase' -- "$2")
              ;;
            --converters)
              mapfile -t COMPREPLY < <(compgen -W 'top-level all-objects' -- "$2")
              ;;
            *)
              [[ $2 == -* ]] || return
              mapfile -t COMPREPLY < <(compgen -W '--acronym-style --converters' -- "$2")
              ;;
          esac
          ;;
        swift)
          case "$3" in
            --struct-or-class)
              mapfile -t COMPREPLY < <(compgen -W 'struct class' -- "$2")
              ;;
            --density)
              mapfile -t COMPREPLY < <(compgen -W 'dense normal' -- "$2")
              ;;
            --access-level)
              mapfile -t COMPREPLY < <(compgen -W 'internal public' -- "$2")
              ;;
            --protocol)
              mapfile -t COMPREPLY < <(compgen -W 'none equatable hashable' -- "$2")
              ;;
            --acronym-style)
              mapfile -t COMPREPLY < <(compgen -W 'original pascal camel lowerCase' -- "$2")
              ;;
            *)
              [[ $2 == -* ]] || return
              mapfile -t COMPREPLY < <(compgen -W '--just-types --no-just-types --struct-or-class --density --initializers --no-initializers --coding-keys --no-coding-keys --access-level --alamofire --no-alamofire --support-linux --no-support-linux --type-prefix --protocol --acronym-style --objective-c-support --no-objective-c-support --optional-enums --no-optional-enums --sendable --no-sendable --swift-5-support --no-swift-5-support --multi-file-output --no-multi-file-output --mutable-properties --no-mutable-properties' -- "$2")
              ;;
          esac
          ;;
        scala3)
          case "$3" in
            --framework)
              mapfile -t COMPREPLY < <(compgen -W 'just-types circe upickle' -- "$2")
              ;;
            *)
              [[ $2 == -* ]] || return
              mapfile -t COMPREPLY < <(compgen -W '--framework --package' -- "$2")
              ;;
          esac
          ;;
        Smithy)
          case "$3" in
            --framework)
              mapfile -t COMPREPLY < <(compgen -W 'just-types' -- "$2")
              ;;
            *)
              [[ $2 == -* ]] || return
              mapfile -t COMPREPLY < <(compgen -W '--framework --package' -- "$2")
              ;;
          esac
          ;;
        kotlin)
          case "$3" in
            --framework)
              mapfile -t COMPREPLY < <(compgen -W 'just-types jackson klaxon kotlinx' -- "$2")
              ;;
            --acronym-style)
              mapfile -t COMPREPLY < <(compgen -W 'original pascal camel lowerCase' -- "$2")
              ;;
            *)
              [[ $2 == -* ]] || return
              mapfile -t COMPREPLY < <(compgen -W '--framework --acronym-style --package' -- "$2")
              ;;
          esac
          ;;
        elm)
          case "$3" in
            --array-type)
              mapfile -t COMPREPLY < <(compgen -W 'array list' -- "$2")
              ;;
            *)
              [[ $2 == -* ]] || return
              mapfile -t COMPREPLY < <(compgen -W '--just-types --no-just-types --module --array-type' -- "$2")
              ;;
          esac
          ;;
        ruby)
          case "$3" in
            --strictness)
              mapfile -t COMPREPLY < <(compgen -W 'strict coercible none' -- "$2")
              ;;
            *)
              [[ $2 == -* ]] || return
              mapfile -t COMPREPLY < <(compgen -W '--just-types --no-just-types --strictness --namespace' -- "$2")
              ;;
          esac
          ;;
        dart)
          mapfile -t COMPREPLY < <(compgen -W '--null-safety --no-null-safety --just-types --no-just-types --coders-in-class --no-coders-in-class --from-map --no-from-map --required-props --no-required-props --final-props --no-final-props --copy-with --no-copy-with --use-freezed --no-use-freezed --use-hive --no-use-hive --use-json-annotation --no-use-json-annotation --part-name' -- "$2")
          ;;
        py)
          case "$3" in
            --python-version)
              mapfile -t COMPREPLY < <(compgen -W '3.5 3.6 3.7' -- "$2")
              ;;
            *)
              [[ $2 == -* ]] || return
              mapfile -t COMPREPLY < <(compgen -W '--python-version --just-types --no-just-types --nice-property-names --no-nice-property-names' -- "$2")
              ;;
          esac
          ;;
        haskell)
          case "$3" in
            --array-type)
              mapfile -t COMPREPLY < <(compgen -W 'array list' -- "$2")
              ;;
            *)
              [[ $2 == -* ]] || return
              mapfile -t COMPREPLY < <(compgen -W '--just-types --no-just-types --module --array-type' -- "$2")
              ;;
          esac
          ;;
        php)
          case "$3" in
            --acronym-style)
              mapfile -t COMPREPLY < <(compgen -W 'original pascal camel lowerCase' -- "$2")
              ;;
            *)
              [[ $2 == -* ]] || return
              mapfile -t COMPREPLY < <(compgen -W '--with-get --no-with-get --fast-get --no-fast-get --with-set --no-with-set --with-closing --no-with-closing --acronym-style' -- "$2")
              ;;
          esac
          ;;
      esac
      [[ $2 == -* ]] || return
      mapfile -O ${#COMPREPLY[@]} -t COMPREPLY < <(compgen -W '-o --out -t --top-level -l --lang -s --src-lang --src --src-urls --no-maps --no-enums --no-uuids --no-date-times --no-integer-strings --no-boolean-strings --no-combine-classes --no-ignore-refs --graphql-schema --graphql-introspect --http-method --http-header -S --additional-schema --alphabetize-properties --all-properties-optional --quiet --debug --telemetry -h --help -v --version' -- "$2")
      ;;
  esac
}

complete -o default -F _quicktype quicktype
