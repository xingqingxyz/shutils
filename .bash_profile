# .bash_profile

# Get the aliases and functions
if [ -f ~/.bashrc ]; then
  . ~/.bashrc
fi

# less
export LESS='--quit-if-one-screen --quit-at-eof --use-color --wordwrap --mouse --ignore-case --incsearch --search-options=W'

# bat
export BAT_THEME_LIGHT='GitHub'

# Rustup
export RUSTUP_UPDATE_ROOT=https://mirrors.tuna.tsinghua.edu.cn/rustup/rustup
export RUSTUP_DIST_SERVER=https://mirrors.tuna.tsinghua.edu.cn/rustup

# Cargo
. "$HOME/.cargo/env"

# Fcitx5
export XMODIFIERS=@im=fcitx
export QT_IM_MODULE=fcitx
export GTK_IM_MODULE=fcitx
if [ -n "$DESKTOP_SESSION" ] && type -fP fcitx5 &>/dev/null; then
  fcitx5 &
fi

# Added by Toolbox App
export PATH="$PATH:/home/uv/.local/share/JetBrains/Toolbox/scripts"

# PowerShell DSC V3
export PATH+=":$HOME/.local/share/dscV3"
