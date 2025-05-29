# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
  . /etc/bashrc
fi

# shopt -s histappend
shopt -s globstar
HISTCONTROL=ignoreboth
HISTSIZE=5000
HISTFILESIZE=10000

# aliases
alias code='code --enable-proposed-api xingqingxyz.mvext'

# shutils
for i in ${BASH_SOURCE[0]%/*}/bash/**/*.sh; do
  . "$i"
done

# fzf
# export FZF_DEFAUT_OPTS=
# export FZF_DEFAUT_COMMAND=

FZF_CTRL_T_OPTS='--preview="bat --color=always --plain --no-pager {}"'
FZF_CTRL_R_OPTS='--preview="echo {}"'
FZF_CTRL_O_OPTS=''
FZF_ALT_C_OPTS='--preview="tree {} | head -n 200"'
# FZF_COMP_OPTS=
# FZF_COMP_TRIGGER='*'

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

_idefault_complete() {
  mapfile -t COMPREPLY < <(compgen -v -S = -- "$2")
  [ ${#COMPREPLY} != 0 ] && compopt -o nospace
}

complete -o bashdefault -F _idefault_complete -I

unset i
