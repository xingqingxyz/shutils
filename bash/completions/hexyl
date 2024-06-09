_hexyl() {
  mapfile -t COMPREPLY < <({
    case "$3" in
      --color)
        compgen -W 'auto always never force' -- "$2"
        ;;
      --border)
        compgen -W 'unicode ascii none' -- "$2"
        ;;
      --character-table)
        compgen -W 'default ascii codepage-437' -- "$2"
        ;;
      --endiannes)
        compgen -W 'big little' -- "$2"
        ;;
      -b | --base)
        compgen -W 'binary octal decimal hexadecimal' -- "$2"
        ;;
      *)
        false
        ;;
    esac || compgen -W '-b --base --block-size --border --bytes -c -C --characters --character-table --color --display-offset --endiannes -g --group-size -h --help --length -n --no-characters --no-position --no-squeezing -o -p -P --panels --plain -s --skip --terminal-width -v -V --version' -- "$2"
  })
}

complete -o default -F _hexyl hexyl
