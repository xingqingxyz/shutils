Register-ArgumentCompleter -Native -CommandName pip -ScriptBlock {
  param (
    [string]$wordToComplete,
    [System.Management.Automation.Language.CommandAst]$commandAst,
    [int]$cursorPosition
  )
  $env:COMP_WORDS = $commandAst.ToString()
  $env:COMP_CWORD = $commandAst.CommandElements.Count - 1
  $env:PIP_AUTO_COMPLETE = 1
  (pip) -split ' '
  Remove-Item Env:COMP_WORDS, Env:COMP_CWORD, Env:PIP_AUTO_COMPLETE
}
