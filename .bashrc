# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
  . /etc/bashrc
fi

# shutils
eval "$(printf '. %q\n' "${BASH_SOURCE[0]%/*}"/bash/*.sh)"

# shopt -s histappend
shopt -s globstar
HISTCONTROL=ignoreboth
HISTSIZE=5000
HISTFILESIZE=10000

# aliases
alias cls=clear
alias code='code --enable-proposed-api xingqingxyz.mvext'

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
