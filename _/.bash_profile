# .bash_profile
export \
  ANDROID_HOME="$HOME/Android/Sdk" \
  DSC_RESOURCE_PATH="$HOME/.local/dsc" \
  EDITOR='code' \
  FLUTTER_STORAGE_BASE_URL='https://storage.flutter-io.cn' \
  JAVA_HOME='/usr/lib/jvm/java-latest-openjdk' \
  LANG='zh_CN.UTF-8' \
  LESS='-R --quit-if-one-screen --use-color --wordwrap --ignore-case --incsearch --search-options=W' \
  LESSOPEN="||$HOME/.local/bin/lesspipe.sh %s 2>/dev/null" \
  MANPAGER="sh -c \"sed 's/\x1b\[[0-9;]*m\|.\x08//g' 2>/dev/null | bat -plman\"" \
  MANROFFOPT='-c' \
  no_proxy='127.0.0.1,localhost,internal.domain,kkgithub.com,raw.githubusercontents.com,mirror.sjtu.edu.cn,mirrors.ustc.edu.cn,mirrors.tuna.tsinghua.edu.cn' \
  NODE_PATH+="${NODE_PATH+:}$HOME/.local/share/pnpm/global/5/node_modules" \
  PAGER='less' \
  PNPM_HOME="$HOME/.local/share/pnpm" \
  PUB_HOSTED_URL='https://pub.flutter-io.cn' \
  RUSTUP_DIST_SERVER='https://mirrors.tuna.tsinghua.edu.cn/rustup' \
  RUSTUP_UPDATE_ROOT='https://mirrors.tuna.tsinghua.edu.cn/rustup/rustup' \
  SHUTILS_ROOT="$HOME/p/shutils" \
  SYSTEMD_PAGER=

# tty or gui
if [ "$XDG_SESSION_TYPE" = tty ]; then
  export LC_ALL='en_US.UTF-8'
else
  export GTK_IM_MODULE='fcitx' QT_IM_MODULE='fcitx' XMODIFIERS='@im=fcitx'
fi

# fzf default opts
MAPFILE=(
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
  'ctrl-\\:preview-top'
  ctrl-/:preview-bottom
)
export FZF_DEFAULT_OPTS="--cycle ${MAPFILE[*]/*/--bind=&}"

# PATH
mapfile -t << EOF
$HOME/.local/bin
$PNPM_HOME
$HOME/go/bin
$HOME/.cargo/bin
$ANDROID_HOME/platform-tools
$HOME/.local/share/powershell/Scripts
$SHUTILS_ROOT/scripts
EOF
printf -v MAPFILE '%s:' "${MAPFILE[@]}"
if [[ :$PATH: != *":$MAPFILE"* ]]; then
  export PATH=$MAPFILE$PATH
fi

#region UserEnv
#endregion
