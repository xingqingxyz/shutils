Register-ArgumentCompleter -Native -CommandName setenv -ScriptBlock {
  param([string]$wordToComplete)
  (Get-Item env:$wordToComplete* -ea Ignore).Name.ForEach{ "$_=" }
}
