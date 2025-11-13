# dedup
$historyPath = (Get-PSReadLineOption).HistorySavePath
$lines = Get-Content -LiteralPath $historyPath | Select-Object -Unique
$lines > $historyPath
