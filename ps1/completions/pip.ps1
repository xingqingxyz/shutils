Register-ArgumentCompleter -Native -CommandName pip -ScriptBlock {
  param ([string]$wordToComplete, [System.Management.Automation.Language.CommandAst]$commandAst, [int]$cursorPosition)
  for ($i = 0; $i -lt $commandAst.CommandElements.Count; $i++) {
    $e = $commandAst.CommandElements[$i].Extent
    if ($e.StartOffset -le $cursorPosition -and $cursorPosition -le $e.EndOffset) {
      break
    }
  }
  $env:COMP_CWORD = $i
  $env:COMP_POINT = $cursorPosition
  $env:COMP_WORDS = $commandAst.ToString()
  $env:PIP_AUTO_COMPLETE = 1
  (pip).Split(' ')
  Remove-Item Env:\COMP_CWORD, Env:\COMP_POINT, Env:\COMP_WORDS, Env:\PIP_AUTO_COMPLETE
}
