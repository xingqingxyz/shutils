$baseDir = switch ($true) {
  $IsWindows { "${env:APPDATA}/Microsoft/Windows/PowerShell/PSReadLine"; break }
  $IsLinux { "$HOME/.local/share/powershell/PSReadLine"; break }
  default { throw 'not implemented' }
}
Get-ChildItem $baseDir/*_history.txt | ForEach-Object {
  $content = Get-Content -LiteralPath $_.FullName | Select-Object -Unique
  $content > $_.FullName
}
