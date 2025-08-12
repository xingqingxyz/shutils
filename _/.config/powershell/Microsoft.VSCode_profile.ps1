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
    . $([Environment]::GetFolderPath('MyDocuments'))/WindowsPowerShell/Microsoft.PowerShell_profile.ps1
  }
}
catch { }
