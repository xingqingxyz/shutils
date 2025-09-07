Register-ArgumentCompleter -Native -CommandName flutter -ScriptBlock {
  param ([string]$wordToComplete, [System.Management.Automation.Language.CommandAst]$commandAst, [int]$cursorPosition)
  $env:COMP_LINE = $commandAst.ToString()
  $env:COMP_POINT = $cursorPosition
  $words = $commandAst.CommandElements.ForEach{ "$_" }
  flutter completion -- $words
}
