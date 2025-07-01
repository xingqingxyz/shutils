if ($IsCoreCLR) {
  if (Test-Path $PSScriptRoot/Microsoft.PowerShell_profile.ps1) {
    . $PSScriptRoot/Microsoft.PowerShell_profile.ps1
  }
}
else {
  $MyDocuments = [Environment]::GetFolderPath('MyDocuments')
  if (Test-Path $MyDocuments/WindowsPowerShell/Microsoft.PowerShell_profile.ps1) {
    . $MyDocuments/WindowsPowerShell/Microsoft.PowerShell_profile.ps1
  }
}

$ErrorActionPreference = 'Stop'
$InformationPreference = 'Continue'
$DebugPreference = 'Continue'
