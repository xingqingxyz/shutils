Register-ArgumentCompleter -Native -CommandName flutter -ScriptBlock {
  param ([string]$wordToComplete, [System.Management.Automation.Language.CommandAst]$commandAst, [int]$cursorPosition)
  $env:COMP_LINE = $commandAst.ToString()
  $env:COMP_POINT = $cursorPosition
  [string[]]$words = $commandAst.CommandElements
  if ($commandAst.CommandElements[-1].Extent.EndOffset -lt $cursorPosition) {
    $words += ''
  }
  flutter completion `-- $words
  Remove-Item -LiteralPath Env:/COMP_LINE, Env:/COMP_POINT
}
