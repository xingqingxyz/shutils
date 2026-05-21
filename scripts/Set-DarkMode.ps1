[CmdletBinding()]
param (
  [Parameter()]
  [switch]
  $Off,
  [Parameter()]
  [switch]
  $OnlyDesktop
)

if ($Off -ne (Get-DarkMode)) {
  return Write-Warning 'dark mode is already set'
}
if ($IsWindows) {
  Set-ItemProperty -LiteralPath 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize' -Name 'SystemUsesLightTheme' -Value ([int]$Off.IsPresent) -Type DWord
  Set-ItemProperty -LiteralPath 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize' -Name 'AppsUseLightTheme' -Value ([int]$Off.IsPresent) -Type DWord

  # 发送 WM_SETTINGCHANGE 消息以刷新主题，无需重启 Explorer
  $type = Add-Type -Namespace Win32 _SendMessageTimeout -PassThru @'
[DllImport("user32.dll", SetLastError = true, CharSet = CharSet.Auto)]
public static extern bool SendMessageTimeout(
    IntPtr hWnd,
    uint Msg,
    UIntPtr wParam,
    string lParam,
    uint fuFlags,
    uint uTimeout,
    out UIntPtr lpdwResult
);
'@
  $HWND_BROADCAST = [IntPtr]0xffff
  $WM_SETTINGCHANGE = 0x001A
  $SMTO_ABORTIFHUNG = 0x0002
  $result = [UIntPtr]::Zero

  # 发送消息通知主题更改
  $null = $type::SendMessageTimeout($HWND_BROADCAST, $WM_SETTINGCHANGE, [UIntPtr]::Zero, 'ImmersiveColorSet', $SMTO_ABORTIFHUNG, 1000, [ref]$result)
  $null = $type::SendMessageTimeout($HWND_BROADCAST, $WM_SETTINGCHANGE, [UIntPtr]::Zero, 'Theme', $SMTO_ABORTIFHUNG, 1000, [ref]$result)
}
elseif ($IsMacOS) {
  throw [System.NotImplementedException]::new()
}
elseif ($IsLinux) {
  if ($env:XDG_CURRENT_DESKTOP -clike '*GNOME') {
    gsettings set org.gnome.desktop.interface color-scheme ($Off ? 'prefer-light' : 'prefer-dark')
  }
  elseif ($env:XDG_CURRENT_DESKTOP -clike '*KDE') {
    plasma-apply-colorscheme ($Off ? 'Breeze' : 'BreezeDark')
    plasma-apply-desktopscheme ($Off ? 'breeze' : 'breeze-dark')
  }
  elseif (Get-Process dms -ea Ignore) {
    dms ipc theme ($Off ? 'light' : 'dark')
  }
  else {
    throw "unknown desktop '$env:XDG_CURRENT_DESKTOP'"
  }
}
else {
  throw [System.NotImplementedException]::new()
}
if ($OnlyDesktop) {
  return
}

$theme = Get-Content -LiteralPath $PSScriptRoot/data/theme.json -Raw | ConvertFrom-Json -AsHashtable
$mode = $Off ? 'light' : 'dark'
$theme[$mode].GetEnumerator().ForEach{
  bash $PSScriptRoot/theme.sh set $_.Key $_.Value $mode
}
