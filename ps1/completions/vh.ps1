Register-ArgumentCompleter -CommandName vh -ParameterName Command -ScriptBlock {
  param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)
  [System.Management.Automation.CompletionCompleters]::CompleteCommand($wordToComplete)
}
