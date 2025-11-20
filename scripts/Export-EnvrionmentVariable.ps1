$SHUTILS_ROOT = [System.IO.Path]::GetFullPath("$PSScriptRoot/..")
$PNPM_HOME = "$HOME/.local/share/pnpm"

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
"@.ReplaceLineEndings(':')
$PATH += if ($env:XDG_SESSION_DESKTOP -ceq 'ubuntu') {
  ':/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/snap/bin'
}
else {
  ':/usr/local/bin:/usr/bin'
}

$PSModulePath = @"
$SHUTILS_ROOT/ps1/modules
$HOME/.local/share/powershell/Modules
/usr/local/share/powershell/Modules
$([System.IO.Path]::GetFullPath("$((Get-Module Microsoft.PowerShell.Management).Path)/../.."))
"@.ReplaceLineEndings(':')

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

$linuxVar = [ordered]@{
  ANDROID_HOME             = "$HOME/Android/Sdk"
  DSC_RESOURCE_PATH        = "$HOME/.local/dsc"
  EDITOR                   = 'edit'
  FLUTTER_STORAGE_BASE_URL = 'https://storage.flutter-io.cn'
  FZF_DEFAULT_OPTS         = $FZF_DEFAULT_OPTS
  LESS                     = '-R --quit-if-one-screen --use-color --wordwrap --ignore-case --incsearch --search-options=W'
  MANPAGER                 = "sh -c `"sed 's/\x1b\[[0-9;]*m\|.\x08//g' 2>/dev/null | bat -plman`""
  MANROFFOPT               = '-c'
  no_proxy                 = $no_proxy
  NODE_PATH                = "$PNPM_HOME/global/5/node_modules"
  PAGER                    = 'less'
  PATH                     = $PATH
  PNPM_HOME                = $PNPM_HOME
  PSModulePath             = $PSModulePath
  PUB_HOSTED_URL           = 'https://pub.flutter-io.cn'
  RUSTUP_DIST_SERVER       = 'https://mirrors.tuna.tsinghua.edu.cn/rustup'
  RUSTUP_UPDATE_ROOT       = 'https://mirrors.tuna.tsinghua.edu.cn/rustup/rustup'
  SHUTILS_ROOT             = $SHUTILS_ROOT
  SYSTEMD_PAGER            = ''
}
if ($IsLinux) {
  $linuxVar.GetEnumerator().ForEach{
    [System.Environment]::SetEnvironmentVariable($_.Key, $_.Value)
    $_.Key + '=' + $_.Value
  } > ~/.env
}
elseif ($IsWindows) {
  $PNPM_HOME = "$env:LOCALAPPDATA\pnpm"
  $common = @{}
  @('EDITOR', 'FLUTTER_STORAGE_BASE_URL', 'FZF_DEFAULT_OPTS', 'LESS', 'no_proxy', 'PAGER', 'PUB_HOSTED_URL', 'RUSTUP_DIST_SERVER', 'RUSTUP_UPDATE_ROOT').ForEach{ $common[$_] = $linuxVar[$_] }
  ($common + @{
    ANDROID_HOME      = "$env:LOCALAPPDATA\Android\Sdk"
    NODE_PATH         = "$PNPM_HOME\global\5\node_modules"
    PNPM_HOME         = $PNPM_HOME
    PSModulePath      = "$SHUTILS_ROOT\ps1\modules"
    UV_PYTHON_BIN_DIR = "$HOME\tools"
    UV_TOOL_BIN_DIR   = "$HOME\tools"
  }).GetEnumerator().ForEach{
    [System.Environment]::SetEnvironmentVariable($_.Key, $_.Value)
    Set-ItemProperty -LiteralPath HKCU:\Environment $_.Key $_.Value
  }
  # notify only one time
  [System.Environment]::SetEnvironmentVariable('SHUTILS_ROOT', $SHUTILS_ROOT, 'User')
}
else {
  throw [System.NotImplementedException]::new()
}
