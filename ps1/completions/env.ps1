Register-ArgumentCompleter -Native -CommandName env -ScriptBlock {
  param([string]$wordToComplete)
  if ($wordToComplete.StartsWith('-')) {
    return @('-a', '--argv0=', '-i', '--ignore-environment', '-0', '--null', '-u', '--unset=', '-C', '--chdir=', '-S', '--split-string=', '--block-signal', '--block-signal=', '--default-signal', '--default-signal=', '--ignore-signal', '--ignore-signal=', '--list-signal-handling', '-v', '--debug', '--help', '--version').Where{ $_ -like "$wordToComplete*" }
  }
  $words = @((Get-Item env:$wordToComplete* -ea Ignore).Name)
  if ($words) {
    $words.ForEach{ "$_=" }
  }
  else {
    [System.Management.Automation.CompletionCompleters]::CompleteCommand($wordToComplete)
  }
}
