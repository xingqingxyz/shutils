if (!$IsLinux) {
  throw [System.NotImplementedException]::new()
}

$SHUTILS_ROOT = [System.IO.Path]::GetFullPath("$PSScriptRoot/..")
$ANDROID_HOME = "$HOME/Android/Sdk"
$PNPM_HOME = "$HOME/.local/share/pnpm"

# path
$PATH = @(
  "$HOME/.local/bin",
  $PNPM_HOME,
  "$HOME/go/bin",
  "$HOME/.cargo/bin",
  "$ANDROID_HOME/platform-tools",
  "$HOME/.local/share/powershell/Scripts",
  "$SHUTILS_ROOT/scripts"
) -join ':'
$PATH += if ($env:XDG_SESSION_DESKTOP -ceq 'ubuntu') {
  ':/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/snap/bin'
}
else {
  ':/usr/local/bin:/usr/bin'
}

# fzf default opts
$FZF_DEFAULT_OPTS = @(
  '--cycle'
  '--bind=alt-+:change-multi',
  '--bind=alt-J:jump',
  '--bind=alt-\\:first',
  '--bind=alt-/:last',
  '--bind=ctrl-alt-f:page-down',
  '--bind=ctrl-alt-b:page-up',
  '--bind=ctrl-alt-d:half-page-down',
  '--bind=ctrl-alt-u:half-page-up',
  '--bind=ctrl-a:toggle-all',
  '--bind=ctrl-e:preview-down',
  '--bind=ctrl-y:preview-up',
  '--bind=ctrl-f:preview-page-down',
  '--bind=ctrl-b:preview-page-up',
  '--bind=ctrl-\\:preview-top',
  '--bind=ctrl-/:preview-bottom'
) -join ' '

([ordered]@{
  ANDROID_HOME             = $ANDROID_HOME
  DSC_RESOURCE_PATH        = "$HOME/.local/dsc"
  EDITOR                   = 'edit'
  FLUTTER_STORAGE_BASE_URL = 'https://storage.flutter-io.cn'
  FZF_DEFAULT_OPTS         = $FZF_DEFAULT_OPTS
  JAVA_HOME                = '/usr/lib/jvm/java-latest-openjdk'
  LANG                     = 'zh_CN.UTF-8'
  LESS                     = '-R --quit-if-one-screen --use-color --wordwrap --ignore-case --incsearch --search-options=W'
  LESSOPEN                 = "||$HOME/.local/bin/lesspipe.sh %s 2>/dev/null"
  MANPAGER                 = "sh -c `"sed 's/\x1b\[[0-9;]*m\|.\x08//g' 2>/dev/null | bat -plman`""
  MANROFFOPT               = '-c'
  no_proxy                 = '127.0.0.1,localhost,internal.domain,kkgithub.com,raw.githubusercontents.com,mirror.sjtu.edu.cn,mirrors.ustc.edu.cn,mirrors.tuna.tsinghua.edu.cn'
  NODE_PATH                = "$PNPM_HOME/global/5/node_modules"
  PAGER                    = 'less'
  PATH                     = $PATH
  PNPM_HOME                = $PNPM_HOME
  PUB_HOSTED_URL           = 'https://pub.flutter-io.cn'
  RUSTUP_DIST_SERVER       = 'https://mirrors.tuna.tsinghua.edu.cn/rustup'
  RUSTUP_UPDATE_ROOT       = 'https://mirrors.tuna.tsinghua.edu.cn/rustup/rustup'
  SHUTILS_ROOT             = $SHUTILS_ROOT
  SYSTEMD_PAGER            = ''
}).GetEnumerator().ForEach{ $_.Key + '=' + $_.Value } > $SHUTILS_ROOT/_/.env
