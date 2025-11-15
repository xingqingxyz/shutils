$ErrorActionPreference = 'Stop'
$InformationPreference = 'Continue'
$VerbosePreference = 'Continue'
$DebugPreference = 'Continue'

try {
  if ($IsCoreCLR) {
    . $PSScriptRoot/Microsoft.PowerShell_profile.ps1
  }
  else {
    # symlinks escape hatch
    . $([System.Environment]::GetFolderPath('MyDocuments'))/WindowsPowerShell/Microsoft.PowerShell_profile.ps1
  }
  if (Test-Path -LiteralPath $env:SHUTILS_ROOT/scripts/onEnterPSES.ps1) {
    . $env:SHUTILS_ROOT/scripts/onEnterPSES.ps1
  }
}
catch { }
