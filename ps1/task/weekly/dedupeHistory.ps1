$historyDir = [System.IO.Path]::GetDirectoryName((Get-PSReadLineOption).HistorySavePath)
Convert-Path $historyDir/*_history.txt | ForEach-Object {
  $content = Get-Content -LiteralPath $_ | Select-Object -Unique
  $content > $_
}
