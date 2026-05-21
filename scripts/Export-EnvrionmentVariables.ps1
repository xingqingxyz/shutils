$WISH_ROOT = [System.IO.Path]::GetDirectoryName($PSScriptRoot)
$ANDROID_HOME = $IsWindows ? "$env:LOCALAPPDATA\Android\Sdk" : "$HOME/.local/share/Android/Sdk"
$DSC_RESOURCE_PATH = if (Get-Command dsc -CommandType Application -TotalCount 1 -ea Ignore) {
  ((dsc resource list | ConvertFrom-Json).directory | Sort-Object -Unique) -join [System.IO.Path]::PathSeparator
}
$FLUTTER_HOME = $IsWindows ? "$env:LOCALAPPDATA\prefix\flutter" : "$HOME/.local/flutter"
$JAVA_HOME = if ($cmd = (Get-Command java -CommandType Application -TotalCount 1 -ea Ignore).Source) {
  [System.IO.Path]::GetDirectoryName([System.IO.Path]::GetDirectoryName((Get-Item -LiteralPath $cmd -Force).ResolvedTarget))
}

# PSModulePath
$PSModulePath = $IsWindows ? "$WISH_ROOT\Modules" : @"
$WISH_ROOT/Modules
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
--bind=btab:toggle-in
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
--bind=tab:toggle-out
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
  FLUTTER_HOME             = $FLUTTER_HOME
  FLUTTER_GIT_URL          = 'https://mirrors.tuna.tsinghua.edu.cn/git/flutter-sdk.git'
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
  WISH_ROOT                = $WISH_ROOT
}

if ($IsWindows) {
  ($commonVar + @{
    BAT_PAGER         = 'less.cmd'
    PNPM_HOME         = "$env:LOCALAPPDATA\pnpm"
    UV_PYTHON_BIN_DIR = "$env:LOCALAPPDATA\prefix\bin"
    UV_TOOL_BIN_DIR   = "$env:LOCALAPPDATA\prefix\bin"
  }).GetEnumerator().ForEach{
    [System.Environment]::SetEnvironmentVariable($_.Key, $_.Value)
    Set-ItemProperty -LiteralPath HKCU:\Environment $_.Key $_.Value
  }
  $Path = @'
%USERPROFILE%\.cargo\bin
%USERPROFILE%\go\bin
%PNPM_HOME%\bin
%USERPROFILE%\.dotnet\tools
'@.Split("`n") + (Get-Item -LiteralPath HKCU:\Environment).GetValue('Path', $null, [Microsoft.Win32.RegistryValueOptions]::DoNotExpandEnvironmentNames).Split(';') | Select-Object -Unique | Join-String -Separator ';'
  Set-ItemProperty -LiteralPath HKCU:\Environment Path $Path -Type ExpandString
  # only let windows events notify once
  [System.Environment]::SetEnvironmentVariable('WISH_ROOT', $WISH_ROOT, 'User')
}
elseif ($IsLinux) {
  # path
  $PATH = @"
$HOME/.local/bin
$HOME/.cargo/bin
$HOME/go/bin
$HOME/.local/share/pnpm/bin
$HOME/.dotnet/tools
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
    LANG                 = 'zh_CN.UTF-8'
    MANPAGER             = "sh -c `"sed 's/\x1b\[[0-9;]*m\|.\x08//g' 2>/dev/null | bat -plman`""
    MANROFFOPT           = '-c'
    PATH                 = $PATH
    QT_QPA_PLATFORMTHEME = 'qt6ct'
    SYSTEMD_PAGER        = ''
  }).GetEnumerator() | Sort-Object Key | ForEach-Object {
    [System.Environment]::SetEnvironmentVariable($_.Key, $_.Value)
    $_.Key + '=' + $_.Value
  } > ~/.env
}
else {
  throw [System.NotImplementedException]::new()
}
