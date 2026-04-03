Register-ArgumentCompleter -Native -CommandName plocate-build -ScriptBlock {
  param ([string]$wordToComplete, [System.Management.Automation.Language.CommandAst]$commandAst, [int]$cursorPosition)
  @(if ($wordToComplete.StartsWith('-')) {
      '-b', '--block-size=', '-p', '--plaintext', '-l', '--require-visibility', '--help', '--version'
    }).Where{ $_ -like "$wordToComplete*" }
}
