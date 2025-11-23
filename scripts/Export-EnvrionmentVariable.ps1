$SHUTILS_ROOT = [System.IO.Path]::GetFullPath("$PSScriptRoot/..")
$ANDROID_HOME = $IsWindows ? "$env:LOCALAPPDATA\Android\Sdk" : "$HOME/.local/share/Android/Sdk"
$DSC_RESOURCE_PATH = $IsWindows ? '' : "$HOME/.local/dsc"
$PNPM_HOME = $IsWindows ? "$env:LOCALAPPDATA\pnpm" : "$HOME/.local/share/pnpm"

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
--cycle
--bind=alt-/:last
--bind=alt-\\:first
--bind=alt-J:jump
--bind=alt-z:toggle-wrap
--bind=ctrl-/:preview-bottom
--bind=ctrl-\\:preview-top
--bind=ctrl-a:toggle-all
--bind=ctrl-b:preview-page-up
--bind=ctrl-e:preview-down
--bind=ctrl-f:preview-page-down
--bind=ctrl-m:change-multi
--bind=ctrl-y:preview-up
--bind=ctrl-alt-b:page-up
--bind=ctrl-alt-d:half-page-down
--bind=ctrl-alt-f:page-down
--bind=ctrl-alt-u:half-page-up
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
  DSC_RESOURCE_PATH        = $DSC_RESOURCE_PATH
  EDITOR                   = 'edit'
  FLUTTER_STORAGE_BASE_URL = 'https://storage.flutter-io.cn'
  FZF_DEFAULT_OPTS         = $FZF_DEFAULT_OPTS
  LESS                     = $LESS
  no_proxy                 = $no_proxy
  NODE_PATH                = Join-Path $PNPM_HOME 'global/5/node_modules'
  PAGER                    = 'less'
  PNPM_HOME                = $PNPM_HOME
  PSModulePath             = $PSModulePath
  PUB_HOSTED_URL           = 'https://pub.flutter-io.cn'
  RUSTUP_DIST_SERVER       = 'https://mirrors.tuna.tsinghua.edu.cn/rustup'
  RUSTUP_UPDATE_ROOT       = 'https://mirrors.tuna.tsinghua.edu.cn/rustup/rustup'
  SHUTILS_ROOT             = $SHUTILS_ROOT
}

if ($IsWindows) {
  ($commonVar + @{
    JAVA_HOME         = 'C:\Program Files\Java\jdk-25'
    UV_PYTHON_BIN_DIR = "$HOME\tools"
    UV_TOOL_BIN_DIR   = "$HOME\tools"
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
$PNPM_HOME
$ANDROID_HOME/platform-tools
$HOME/.local/share/powershell/Scripts
/usr/local/share/powershell/Scripts
$SHUTILS_ROOT/scripts
/usr/local/bin
/usr/bin
"@.ReplaceLineEndings(':')
  if (Get-Command snap -CommandType Application -TotalCount 1 -ea Ignore) {
    $PATH += ':/snap/bin'
  }
  if ($env:WSL_DISTRO_NAME) {
    $PATH += ':/usr/lib/wsl/lib:' + ($env:PATH.Split(':').Where{ $_.StartsWith('/mnt/') } -join ':')
  }
  ($commonVar + @{
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
