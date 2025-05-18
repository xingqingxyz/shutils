Register-ArgumentCompleter -CommandName vw -ParameterName Path -ScriptBlock {
  param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)
  $r = @([System.Management.Automation.CompletionCompleters]::CompleteFilename($wordToComplete))
  if ($r.Length) { $r } else {
    [System.Management.Automation.CompletionCompleters]::CompleteCommand($wordToComplete)
  }
}
