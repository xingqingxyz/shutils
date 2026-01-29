Register-ArgumentCompleter -Native -CommandName vcperf -ScriptBlock {
  param ([string]$wordToComplete, [System.Management.Automation.Language.CommandAst]$commandAst, [int]$cursorPosition)
  @(if ($wordToComplete.StartsWith('/')) {
      '/start', '/noadmin', '/nocpusampling', '/level1', '/level2', '/level3', '/stop', '/templates', '/timetrace', '/stopnoanalyze', '/analyze'
    }).Where{ $_ -like "$wordToComplete*" }
}
