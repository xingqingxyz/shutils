_chafa() {
  mapfile -t COMPREPLY < <({
    case "$3" in
      --align)
        compgen -P "${2%%*([^,])}" -W 'bottom left right top' -- "${2#*,}"
        ;;
      --animate)
        compgen -W 'on off' -- "$2"
        ;;
      -c | --colors)
        compgen -W 'none 2 8 16/8 16 240 256 full' -- "$2"
        ;;
      --color-extractor)
        compgen -W 'average median' -- "$2"
        ;;
      --color-space)
        compgen -W 'rgb din99d' -- "$2"
        ;;
      --dither)
        compgen -W 'none ordered diffusion' -- "$2"
        ;;
      -f | --format)
        compgen -W 'iterm kitty sixels symbols' -- "$2"
        ;;
      --relative)
        compgen -W 'on off' -- "$2"
        ;;
      --scale)
        compgen -W 'max' -- "$2"
        ;;
      --symbols | --fill)
        compgen -P "${2%%*([^-+])}" -W 'all alnum alpha ambiguous ascii bad block border braile diagonal digit dot extra geometric half hhalf imported inverted latin legacy narrow none quad sextant solid space stipple technical ugly vhalf wedge wide' -- "${2##*[-+]}"
        ;;
      *)
        false
        ;;
    esac || compgen -W '-h --help -v --verbose --version --format -f --optimize -O --relative --passthrough --polite --align --clear --exact-size --fit-width --font-ratio --margin-bottom --margin-right --scale --size -s --stretch --view-size --animate --duration -d --speed --watch --bg --colors -c --color-extractor --color-space --dither --dither-grain --dither-intensity --fg --invert --preprocess -p -t --threshold --threads --word -w --fg-only --fill --glyph-file --symbols' -- "$2"
  })
}

complete -o default -F _chafa chafa
