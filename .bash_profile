# .bash_profile

export SHUTILS_ROOT=$(dirname -- "$(realpath -- "$BASH_SOURCE")")
export \
  LANG='zh_CN.UTF-8' \
  PAGER='less' \
  SYSTEMD_PAGER= \
  EDITOR='msedit' \
  LESS='-R --quit-if-one-screen --use-color --wordwrap --ignore-case --incsearch --search-options=W' \
  LESSOPEN="||'$SHUTILS_ROOT/scripts/lesspipe.sh' %s 2>/dev/null" \
  MANROFFOPT='-c' \
  MANPAGER="sh -c \"sed 's/\x1b\[[0-9;]*m\|.\x08//g' 2>/dev/null | bat -plman\"" \
  no_proxy='127.0.0.1,localhost,internal.domain,kkgithub.com,raw.githubusercontents.com,mirror.sjtu.edu.cn,mirrors.ustc.edu.cn,mirrors.tuna.tsinghua.edu.cn' \
  RUSTUP_UPDATE_ROOT='https://mirrors.tuna.tsinghua.edu.cn/rustup/rustup' \
  RUSTUP_DIST_SERVER='https://mirrors.tuna.tsinghua.edu.cn/rustup' \
  PNPM_HOME="$HOME/.local/share/pnpm" \
  XMODIFIERS='@im=fcitx' \
  QT_IM_MODULE='fcitx' \
  GTK_IM_MODULE='fcitx'

items=(
  alt-+:change-multi
  alt-J:jump
  alt-\\:first
  alt-/:last
  ctrl-alt-f:page-down
  ctrl-alt-b:page-up
  ctrl-alt-d:half-page-down
  ctrl-alt-u:half-page-up
  ctrl-a:toggle-all
  ctrl-e:preview-down
  ctrl-y:preview-up
  ctrl-f:preview-page-down
  ctrl-b:preview-page-up
  ctrl-\\:preview-top
  ctrl-/:preview-bottom
)
export FZF_DEFAUT_OPTS="--cycle ${items[*]/*/--bind=&}"
unset items

mapfile -t << EOF
$HOME/.local/bin
$HOME/.bun/bin
$PNPM_HOME
$HOME/.cargo/bin
$HOME/.local/share/JetBrains/Toolbox/scripts
$HOME/.local/share/dscV3
$SHUTILS_ROOT/scripts
EOF
IFS=: MAPFILE=${MAPFILE[*]}
if [[ :$PATH: != *":$MAPFILE:"* ]]; then
  export PATH=$MAPFILE:$PATH
fi

if [[ :$PSModulePath: != *":$SHUTILS_ROOT/ps1/modules:"* ]]; then
  export PSModulePath=$PSModulePath${PSModulePath+:}$SHUTILS_ROOT/ps1/modules
fi

# Get the aliases and functions
. "$SHUTILS_ROOT/.bashrc"
