# .bash_profile

export \
  SHUTILS_ROOT=$(dirname -- "$(realpath -- "$BASH_SOURCE")") \
  LANG='zh_CN.UTF-8' \
  PAGER='less' \
  EDITOR='nano' \
  LESS='-R --quit-if-one-screen --use-color --wordwrap --ignore-case --incsearch --search-options=W' \
  MANROFFOPT='-c' \
  MANPAGER="sh -c \"sed 's/\x1B\[[0-9;]*m\|.\x08//g' | bat -plman\"" \
  no_proxy='127.0.0.1,localhost,internal.domain,kkgithub.com,raw.githubusercontents.com,mirror.sjtu.edu.cn,mirrors.ustc.edu.cn,mirrors.tuna.tsinghua.edu.cn' \
  RUSTUP_UPDATE_ROOT='https://mirrors.tuna.tsinghua.edu.cn/rustup/rustup' \
  RUSTUP_DIST_SERVER='https://mirrors.tuna.tsinghua.edu.cn/rustup' \
  PNPM_HOME="$HOME/.local/share/pnpm" \
  XMODIFIERS='@im=fcitx' \
  QT_IM_MODULE='fcitx' \
  GTK_IM_MODULE='fcitx'

mapfile -t << EOF
$HOME/.local/bin
$HOME/.bun/bin
$PNPM_HOME
$HOME/.cargo/bin
$HOME/.local/share/JetBrains/Toolbox/scripts
$HOME/.local/share/dscV3
EOF
MAPFILE=$(printf %s: "${MAPFILE[@]}")
if [[ :$PATH: != *":$MAPFILE"* ]]; then
  export PATH="$MAPFILE$PATH"
fi

# Get the aliases and functions
. "$SHUTILS_ROOT/.bashrc"
