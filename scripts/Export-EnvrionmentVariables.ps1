# note: specially for zh_CN users
$SHUTILS_ROOT = [System.IO.Path]::GetFullPath("$PSScriptRoot/..")
$ANDROID_HOME = $IsWindows ? "$env:LOCALAPPDATA\Android\Sdk" : "$HOME/.local/share/Android/Sdk"
if ($cmd = Get-Command java -CommandType Application -TotalCount 1 -ea Ignore) {
  $JAVA_HOME = [System.IO.Path]::GetDirectoryName([System.IO.Path]::GetDirectoryName((Get-Item -LiteralPath $cmd.Source -Force).ResolvedTarget))
}
$DSC_RESOURCE_PATH = $IsWindows ? '' : "$HOME/.local/dsc"

# PSModulePath
$PSModulePath = $IsWindows ? "$SHUTILS_ROOT\ps1\modules" : @"
$SHUTILS_ROOT/ps1/modules
$HOME/.local/share/powershell/Modules
/usr/local/share/powershell/Modules
$PSHOME/Modules
"@.ReplaceLineEndings(':')

# less
$LESS = @'
--ignore-case
--incsearch
--quit-if-one-screen
--search-options=W
--use-color
--wordwrap
-R
'@.ReplaceLineEndings(' ')

# fzf default opts
$FZF_DEFAULT_OPTS = @'
--bind=alt-/:last
--bind=alt-\\:first
--bind=alt-b:preview-page-up
--bind=alt-f:preview-page-down
--bind=alt-J:jump
--bind=alt-n:preview-down
--bind=alt-p:preview-up
--bind=alt-z:toggle-wrap
--bind=ctrl-/:preview-bottom
--bind=ctrl-\\:preview-top
--bind=ctrl-a:toggle-all
--bind=ctrl-alt-m:change-multi
--bind=ctrl-b:page-up
--bind=ctrl-backspace:backward-kill-subword
--bind=ctrl-d:half-page-down
--bind=ctrl-delete:kill-word
--bind=ctrl-f:page-down
--bind=ctrl-left:backward-word
--bind=ctrl-right:forward-word
--bind=ctrl-u:half-page-up
'@.ReplaceLineEndings(' ')

# proxy
$no_proxy = @'
127.0.0.1
localhost
internal.domain
kkgithub.com
mirror.sjtu.edu.cn
mirrors.tuna.tsinghua.edu.cn
mirrors.ustc.edu.cn
raw.githubusercontents.com
'@.ReplaceLineEndings(',')

$commonVar = @{
  ANDROID_HOME             = $ANDROID_HOME
  DSC_RESOURCE_PATH        = $DSC_RESOURCE_PATH
  EDITOR                   = 'edit'
  FLUTTER_STORAGE_BASE_URL = 'https://storage.flutter-io.cn'
  FZF_DEFAULT_OPTS         = $FZF_DEFAULT_OPTS
  JAVA_HOME                = $JAVA_HOME
  LESS                     = $LESS
  no_proxy                 = $no_proxy
  PAGER                    = 'less'
  PSModulePath             = $PSModulePath
  PUB_HOSTED_URL           = 'https://pub.flutter-io.cn'
  RUSTUP_DIST_SERVER       = 'https://mirrors.tuna.tsinghua.edu.cn/rustup'
  RUSTUP_UPDATE_ROOT       = 'https://mirrors.tuna.tsinghua.edu.cn/rustup/rustup'
  SHUTILS_ROOT             = $SHUTILS_ROOT
}

if ($IsWindows) {
  ($commonVar + @{
    UV_PYTHON_BIN_DIR = "$env:LOCALAPPDATA\prefix\bin"
    UV_TOOL_BIN_DIR   = "$env:LOCALAPPDATA\prefix\bin"
  }).GetEnumerator().ForEach{
    [System.Environment]::SetEnvironmentVariable($_.Key, $_.Value)
    Set-ItemProperty -LiteralPath HKCU:\Environment $_.Key $_.Value
  }
  # only let windows events notify once
  [System.Environment]::SetEnvironmentVariable('SHUTILS_ROOT', $SHUTILS_ROOT, 'User')
}
elseif ($IsLinux) {
  # path
  $PATH = @"
$HOME/.local/bin
$HOME/.cargo/bin
$HOME/go/bin
$HOME/.bun/bin
$HOME/.local/share/powershell/Scripts
/usr/local/share/powershell/Scripts
/usr/local/bin
/usr/bin
"@.ReplaceLineEndings(':')
  if ((Get-Item -LiteralPath /usr/sbin).ResolvedTarget -cne '/usr/bin') {
    $PATH += ':/usr/local/sbin:/usr/sbin'
  }
  if (Get-Command snap -CommandType Application -TotalCount 1 -ea Ignore) {
    $PATH += ':/snap/bin'
  }
  if ($env:WSL_DISTRO_NAME) {
    $PATH += ':/usr/lib/wsl/lib:' + ((bash --norc -c 'echo "$PATH"').Split(':').Where{ $_.StartsWith('/mnt/') } -join ':')
  }
  ($commonVar + @{
    LANG          = 'zh_CN.UTF-8'
    MANPAGER      = "sh -c `"sed 's/\x1b\[[0-9;]*m\|.\x08//g' 2>/dev/null | bat -plman`""
    MANROFFOPT    = '-c'
    SYSTEMD_PAGER = ''
    PATH          = $PATH
  }).GetEnumerator() | Sort-Object Key | ForEach-Object {
    [System.Environment]::SetEnvironmentVariable($_.Key, $_.Value)
    $_.Key + '=' + $_.Value
  } > ~/.env
}
else {
  throw [System.NotImplementedException]::new()
}
