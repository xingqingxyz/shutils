#region env
@{
  ANDROID_HOME             = "$HOME\Android\Sdk"
  EDITOR                   = 'code'
  FLUTTER_STORAGE_BASE_URL = 'https://storage.flutter-io.cn'
  LESS                     = '-R --quit-if-one-screen --use-color --wordwrap --ignore-case --incsearch --search-options=W'
  PAGER                    = 'C:\Program Files\Git\usr\bin\less.exe'
  PNPM_HOME                = "$env:LOCALAPPDATA\pnpm"
  PUB_HOSTED_URL           = 'https://pub.flutter-io.cn'
  RUSTUP_DIST_SERVER       = 'https://mirrors.tuna.tsinghua.edu.cn/rustup'
  RUSTUP_UPDATE_ROOT       = 'https://mirrors.tuna.tsinghua.edu.cn/rustup/rustup'
  SHUTILS_ROOT             = 'D:\p\shutils'
  FZF_DEFAUT_OPTS          = @'
--cycle
--bind=alt-+:change-multi
--bind=alt-J:jump
--bind=alt-\:first
--bind=alt-/:last
--bind=ctrl-alt-f:page-down
--bind=ctrl-alt-b:page-up
--bind=ctrl-alt-d:half-page-down
--bind=ctrl-alt-u:half-page-up
--bind=ctrl-a:toggle-all
--bind=ctrl-e:preview-down
--bind=ctrl-y:preview-up
--bind=ctrl-f:preview-page-down
--bind=ctrl-b:preview-page-up
--bind=ctrl-\:preview-top
--bind=ctrl-/:preview-bottom
'@.ReplaceLineEndings(' ')
  no_proxy                 = @'
127.0.0.1
localhost
internal.domain
kkgithub.com
raw.githubusercontents.com
mirror.sjtu.edu.cn
mirrors.ustc.edu.cn
mirrors.tuna.tsinghua.edu.cn
'@.ReplaceLineEndings(',')
}.GetEnumerator().ForEach{
  [System.Environment]::SetEnvironmentVariable($_.Key, $_.Value, 'User')
  [System.Environment]::SetEnvironmentVariable($_.Key, $_.Value)
}
# PATH like envs
@{
  NODE_PATH = "$env:LOCALAPPDATA\pnpm\global\5\node_modules"
  Path      = @"
$env:PNPM_HOME
$HOME\go\bin
$HOME\.cargo\bin
$env:ANDROID_HOME\platform-tools
$HOME\tools
$HOME\tools\numbat
$HOME\tools\codeql
$HOME\Documents\PowerShell\Scripts
$env:SHUTILS_ROOT\scripts
"@.ReplaceLineEndings(';')
}.GetEnumerator().ForEach{
  $value = @(
    [System.Environment]::GetEnvironmentVariable($_.Key, 'User').Split(';')
    $_.Value.Split(';')
  ) | Select-Object -Unique | Join-String -Separator ';'
  [System.Environment]::SetEnvironmentVariable($_.Key, $value, 'User')
}
#endregion
# pwsh PSRepository
Set-PSRepository -Name PSGallery -InstallationPolicy Trusted
# pwsh modules
Install-Module Yayaml, PSToml, Pester, PSScriptAnalyzer
# pwsh scripts
Install-Script Refresh-EnvironmentVariables
# alacritty startup
if (Get-Command alacritty -Type Application -TotalCount 1 -ea Ignore) {
  $null = New-ItemProperty -LiteralPath 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Run' -Name 'Alacritty' -Value 'C:\Program Files\Alacritty\alacritty.exe' -PropertyType String -Force
}
else {
  Remove-ItemProperty -LiteralPath 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Run' -Name 'Alacritty' -ea Ignore
}

function Set-DarkMode ([switch]$On) {
  Set-ItemProperty -LiteralPath 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize' -Name 'SystemUsesLightTheme' -Value (1 - $On.IsPresent) -Type DWord
  Set-ItemProperty -LiteralPath 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize' -Name 'AppsUseLightTheme' -Value (1 - $On.IsPresent) -Type DWord
  Stop-Process explorer
}

function Set-DscResourcePath {
  $env:DSC_RESOURCE_PATH = $null
  $resources = dsc resource list | ConvertFrom-Json
  $env:DSC_RESOURCE_PATH = ($resources.directory | Sort-Object -Unique) -join [System.IO.Path]::PathSeparator
  [System.Environment]::SetEnvironmentVariable('DSC_RESOURCE_PATH', $env:DSC_RESOURCE_PATH, 'User')
}
