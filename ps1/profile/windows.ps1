using namespace System.Security.Principal

function winget {
  if ($args.Length -gt 1 -and
    @('install', 'upgrade', 'update', 'import', 'uninstall').Contains($args[0]) -and
    ![WindowsPrincipal]::new([WindowsIdentity]::GetCurrent()).IsInRole([WindowsBuiltInRole]::Administrator)) {
    throw 'needs to be run as administrator'
  }
  winget.exe @args
}

Get-ChildItem ${env:LOCALAPPDATA}/Microsoft/WinGet/Links | ForEach-Object { Set-Alias $_.BaseName $_.ResolvedTarget }
