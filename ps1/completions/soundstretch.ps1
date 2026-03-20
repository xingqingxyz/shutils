Register-ArgumentCompleter -Native -CommandName soundstretch -ScriptBlock {
  param ([string]$wordToComplete, [System.Management.Automation.Language.CommandAst]$commandAst, [int]$cursorPosition)
  @(if ($wordToComplete.StartsWith('-')) {
      '-tempo=-95', '-tempo=5000', '-pitch=-60', '-pitch=60', '-rate=-95', '-rate=5000', '-bpm=', '-quick', '-naa', '-speech', '-license', '--help'
    }).Where{ $_ -like "$wordToComplete*" }
}
