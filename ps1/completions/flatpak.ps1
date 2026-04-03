Register-ArgumentCompleter -Native -CommandName flatpak -ScriptBlock {
  param ([string]$wordToComplete, [System.Management.Automation.Language.CommandAst]$commandAst, [int]$cursorPosition)
  @(flatpak complete $commandAst.ToString().PadRight($cursorPosition) $cursorPosition $wordToComplete).Where({ !$_.StartsWith('__') }).TrimEnd()
}
