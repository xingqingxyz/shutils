# .bash_profile

# tty or gui
if [ "$XDG_SESSION_TYPE" = tty ]; then
  export LC_ALL='en_US.UTF-8'
elif type -aP fcitx; then
  export GTK_IM_MODULE='fcitx' QT_IM_MODULE='fcitx' XMODIFIERS='@im=fcitx'
fi

# import env
if [ -f ~/.env ]; then
  while read -r line; do
    export "$line"
  done < ~/.env
fi
