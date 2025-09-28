$baseDir = switch ($true) {
  $IsWindows { "$env:APPDATA/Microsoft/Windows/PowerShell/PSReadLine"; break }
  $IsLinux { "$HOME/.local/share/powershell/PSReadLine"; break }
  default { throw 'not implemented' }
}
Convert-Path $baseDir/*_history.txt | ForEach-Object {
  $content = Get-Content -LiteralPath $_ | Select-Object -Unique
  $content > $_
}
