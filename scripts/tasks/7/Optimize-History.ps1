# dedup
Convert-Path -LiteralPath @(
  (Get-PSReadLineOption).HistorySavePath
  "$HOME/.bash_history"
  "$([System.Environment]::GetFolderPath('ApplicationData'))/nushell/history.txt"
) -ea Ignore | ForEach-Object {
  Out-File -InputObject (Get-Content -LiteralPath $_ | Select-Object -Unique) $_
}
