# .bash_profile

# Get the aliases and functions
. "${BASH_SOURCE[0]%/*}/.bashrc"

export \
  PAGER='less' \
  EDITOR='nano' \
  BAT_THEME_LIGHT='GitHub' \
  LESS='--quit-if-one-screen --quit-at-eof --use-color --wordwrap --mouse --ignore-case --incsearch --search-options=W' \
  no_proxy='127.0.0.1,localhost,internal.domain,kkgithub.com,gitdl.cn,raw.githubusercontents.com,mirror.sjtu.edu.cn,  mirrors.tuna.tsinghua.edu.cn' \
  RUSTUP_UPDATE_ROOT='https://mirrors.tuna.tsinghua.edu.cn/rustup/rustup' \
  RUSTUP_DIST_SERVER='https://mirrors.tuna.tsinghua.edu.cn/rustup' \
  XMODIFIERS='@im=fcitx' \
  QT_IM_MODULE='fcitx' \
  GTK_IM_MODULE='fcitx' \
  SHUTILS_ROOT="$HOME/p/shutils" \
  PATH="$HOME/.local/bin:$PATH:$HOME/.local/share/dscV3"

if [ -n "$DESKTOP_SESSION" ] && type -fP fcitx5 &> /dev/null; then
  fcitx5 &
fi
