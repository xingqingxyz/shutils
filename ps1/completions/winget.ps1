Register-ArgumentCompleter -Native -CommandName winget -ScriptBlock {
  param(
    [string]$wordToComplete,
    [System.Management.Automation.Language.CommandAst]$commandAst,
    [int]$cursorPosition
  )
  $word = $wordToComplete.Replace('"', '""')
  $ast = $commandAst.ToString().Replace('"', '""')
  winget.exe complete --word $word --commandline $ast --position $cursorPosition
}
