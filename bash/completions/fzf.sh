_fzf_opts_completion() {
  mapfile -t COMPREPLY < <(
    case "$3" in
      --algo)
        compgen -W 'v1 v2' -- "$2"
        ;;
      --scheme)
        compgen -W 'default path history' -- "$2"
        ;;
      --tiebreak)
        compgen -W 'length chunk begin end index' -- "$2"
        ;;
      --color)
        compgen -W 'dark light 16 bw no' -- "$2"
        ;;
      --layout)
        compgen -W 'default reverse reverse-list' -- "$2"
        ;;
      --info)
        compgen -W 'default right hidden inline inline-right' -- "$2"
        ;;
      --preview-window)
        compgen -W 'default hidden nohidden wrap cycle nocycle up top bottom left right rounded border border-rounded sharp border-sharp border-bold border-block border-thinblock border-double noborder border-none border-horizontal border-vertical border-up border-top border-down border-bottom border-left border-right follow nofollow' -- "$2"
        ;;
      --border)
        compgen -W 'rounded sharp bold block thinblock double horizontal vertical top bottom left right none' -- "$2"
        ;;
      --border-label-pos | --preview-label-pos)
        compgen -W 'center bottom top' -- "$2"
        ;;
      *)
        if [[ $2 == [-+]* ]]; then
          compgen -W '-h --help -x --extended -e --exact --extended-exact +x --no-extended +e --no-exact -q --query -f --filter --literal --no-literal --algo --scheme --expect --no-expect --enabled --no-phony --disabled --phony --tiebreak --bind --color --toggle-sort -d --delimiter -n --nth --with-nth -s --sort +s --no-sort --track --no-track --tac --no-tac -i +i -m --multi +m --no-multi --ansi --no-ansi --no-mouse +c --no-color +2 --no-256 --black --no-black --bold --no-bold --layout --reverse --no-reverse --cycle --no-cycle --keep-right --no-keep-right --hscroll --no-hscroll --hscroll-off --scroll-off --filepath-word --no-filepath-word --info --no-info --inline-info --no-inline-info --separator --no-separator --scrollbar --no-scrollbar --jump-labels -1 --select-1 +1 --no-select-1 -0 --exit-0 +0 --no-exit-0 --read0 --no-read0 --print0 --no-print0 --print-query --no-print-query --prompt --pointer --marker --sync --no-sync --async --no-history --history --history-size --no-header --no-header-lines --header --header-lines --header-first --no-header-first --ellipsis --preview --no-preview --preview-window --height --min-height --no-height --no-margin --no-padding --no-border --border --no-border-label --border-label --border-label-pos --no-preview-label --preview-label --preview-label-pos --no-unicode --unicode --margin --padding --tabstop --listen --no-listen --clear --no-clear --version' -- "$2"
        fi
        ;;
    esac
  )
}

complete -o default -F _fzf_opts_completion fzf
