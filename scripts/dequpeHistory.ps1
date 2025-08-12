$history = switch ($true) {
  $IsWindows { "${env:APPDATA}/Microsoft/Windows/PowerShell/PSReadLine/$($Host.Name)_history.txt"; break }
  $IsLinux { "${env:HOME}/.local/share/powershell/PSReadLine/$($Host.Name)_history.txt"; break }
  default { throw 'not implemented' }
}
$content = Get-Content $history | Select-Object -Unique
$content > $history
