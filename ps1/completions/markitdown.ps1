Register-ArgumentCompleter -Native -CommandName markitdown -ScriptBlock {
  param ([string]$wordToComplete, [System.Management.Automation.Language.CommandAst]$commandAst, [int]$cursorPosition)
  @(if ($wordToComplete.StartsWith('-')) {
      '-h', '--help', '-v', '--version', '-o', '--output', '-d', '--use-docintel', '-e', '--endpoint'
    }).Where{ $_ -like "$wordToComplete*" }
}
