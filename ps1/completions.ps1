Register-ArgumentCompleter -Native -CommandName gh, glow, vhs, tstoy -ScriptBlock {
  . $PSScriptRoot/lib/cobra.ps1 gh, glow, vhs, tstoy
  ''
}

Register-ArgumentCompleter -Native -CommandName (Get-Item $PSScriptRoot/completions/*.ps1).BaseName -ScriptBlock {
  param($wordToComplete, $commandAst, $cursorPosition)
  . $PSScriptRoot/completions/$($commandAst.CommandElements[0].Value)
  ''
}
