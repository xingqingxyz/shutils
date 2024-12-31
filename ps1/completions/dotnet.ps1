Register-ArgumentCompleter -Native -CommandName dotnet -ScriptBlock {
  param([string]$wordToComplete, [System.Management.Automation.Language.CommandAst]$commandAst, [int]$cursorPosition)
  dotnet complete --position $cursorPosition $commandAst.ToString()
}
