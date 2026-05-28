<#
.SYNOPSIS
Clear temp files at startup.
#>
[CmdletBinding()]
param (
  [Parameter()]
  [switch]
  $Uninstall
)

if (!$IsWindows) {
  return
}

if ($Uninstall) {
  return Unregister-PSScheduledTask 'Clear-TempDirectory'
}

Register-PSScheduledTask 'Clear-TempDirectory' { Remove-Item Temp:/* -Recurse -Force -ea Ignore } -AtStartup -UsePowerShell -Force
