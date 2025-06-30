# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
  . /etc/bashrc
fi

# shutils
eval "$(printf '. %q\n' "$SHUTILS_ROOT"/bash/*.sh)"

# shopt -s histappend
shopt -s globstar
HISTCONTROL=ignoreboth
HISTSIZE=9000
HISTFILESIZE=120000

# aliases
alias cls=clear \
  r='fc -s' \
  l='ls --color=auto --hyperlink=auto' \
  ls='ls --color=auto --hyperlink=auto -lah' \
  tree='tree -C --hyperlink --gitignore'

if [[ $TERM_PROGRAM != vscode* ]]; then
  alias fd='fd --hyperlink=auto'
  if declare -xp WSL_DISTRO_NAME &> /dev/null; then
    alias rg='--hyperlink-format=file://${wslprefix}${path}'
  else
    alias rg='--hyperlink-format=default'
  fi
fi

# fzf
# export FZF_DEFAUT_OPTS=
# export FZF_DEFAUT_COMMAND=

FZF_CTRL_T_OPTS='--preview="bat --color=always -p {}"'
FZF_CTRL_R_OPTS='--preview=echo {}'
FZF_CTRL_O_OPTS=''
FZF_ALT_C_OPTS='--preview="tree -C --hyperlink {}"'
# FZF_COMP_OPTS=
# FZF_COMP_TRIGGER='*'

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=
