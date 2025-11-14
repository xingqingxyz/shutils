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
  if (Test-Path -LiteralPath ./scripts/onEnterPSES.ps1) {
    . ./scripts/onEnterPSES.ps1
  }
}
catch { }
