Register-ArgumentCompleter -Native -CommandName dnx -ScriptBlock {
  param ([string]$wordToComplete, [System.Management.Automation.Language.CommandAst]$commandAst, [int]$cursorPosition)
  $index = $commandAst.CommandElements[0].Extent.EndOffset
  dotnet complete --position ($cursorPosition - $index + 10) ('dotnet dnx' + $commandAst.ToString().Substring($index))
}
