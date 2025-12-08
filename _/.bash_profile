# .bash_profile

# fcitx
if type -aP fcitx; then
  export GTK_IM_MODULE='fcitx' QT_IM_MODULE='fcitx' XMODIFIERS='@im=fcitx'
fi

# init env
if [[ $- = *i* && -f ~/.bashrc ]]; then
  . ~/.bashrc
elif [ -f ~/.env ]; then
  while read -r line; do
    export "$line"
  done < ~/.env
fi
