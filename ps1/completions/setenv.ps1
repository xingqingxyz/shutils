Register-ArgumentCompleter -Native -CommandName setenv -ScriptBlock {
  param([string]$wordToComplete)
  $results = (Get-Item env:$wordToComplete* -ea Ignore).Name
  # prevent transform $null -> '='
  if ($results) {
    $results.ForEach{ "$_=" }
  }
}
