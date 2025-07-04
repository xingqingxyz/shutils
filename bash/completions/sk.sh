# shellcheck disable=SC1091
if false && [ -x "$(type -P sk-share)" ]; then
  . "$(sk-share)/completion.bash"
  . "$(sk-share)/key-bindings.bash"
  return
fi

_sk() {
  mapfile -t COMPREPLY < <({
    case "$3" in
      --algo)
        # TODO
        compgen -W 'skim_v2 fzf' -- "$2"
        ;;
      --color)
        compgen -W 'dark light 16 bw' -- "$2"
        ;;
      --case)
        # TODO
        compgen -W 'smart' -- "$2"
        ;;
      --layout)
        # TODO
        compgen -W 'default' -- "$2"
        ;;
      --tiebreak)
        compgen -W 'length begin end index' -- "$2"
        ;;
      --preview-window)
        # TODO
        compgen -W 'bottom left right top' -- "$2"
        ;;
      *)
        false
        ;;
    esac || compgen -W '-0 -1 --algo --ansi -b --bind --border -c --case --cmd --cmd-history --cmd-history-size --cmd-prompt --cmd-query --color --cycle -d --delimiter -e --exact --exit-0 --expect --extend -f --filepath-word --filter -h --header --header-lines --height --help --history --history-size --hscroll-off -i -I --inline-info --interactive --jump-labels --keep-right --layout --literal -m --margin --min-height --multi -n --no-bold --no-clear --no-clear-if-empty --no-clear-start --no-height --no-hscroll --no-mouse --no-multi --no-sort --nth -p --pre-select-file --pre-select-items --pre-select-n --pre-select-pat --preview --preview-window --print0 --print-cmd --print-query --print-score --prompt -q --query --read0 --regex --reverse --select-1 --show-cmd-error --skip-to-pattern --sync -t --tabstop --tac --tiebreak -V --version --with-nth -x' -- "$2"
  })
}

complete -o default -F _sk sk
