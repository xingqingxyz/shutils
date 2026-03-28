Register-ArgumentCompleter -Native -CommandName glib-compile-schemas -ScriptBlock {
  param ([string]$wordToComplete, [System.Management.Automation.Language.CommandAst]$commandAst, [int]$cursorPosition)
  @(if ($wordToComplete.StartsWith('-')) {
      '-h', '--help', '--version', '--targetdir=', '--strict', '--dry-run', '--allow-any-name'
    }).Where{ $_ -like "$wordToComplete*" }
}
