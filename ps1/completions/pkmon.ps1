using namespace System.Management.Automation.Language

Register-ArgumentCompleter -Native -CommandName pkmon -ScriptBlock {
  param ([string]$wordToComplete, [CommandAst]$commandAst, [int]$cursorPosition)
  $command = @(foreach ($i in $commandAst.CommandElements) {
      if ($i.Extent.StartOffset -eq $commandAst.Extent.StartOffset -or $i.Extent.EndOffset -eq $cursorPosition) {
        continue
      }
      if ($i -isnot [StringConstantExpressionAst] -or
        $i.StringConstantType -ne [StringConstantType]::BareWord -or
        $i.Value.StartsWith('-')) {
        break
      }
      $i.Value
    }) -join ' '

  @(
    if ($wordToComplete.StartsWith('-')) {
      '--version', '--help'
    }
    switch ($command) {
      '' {
        if ($wordToComplete.StartsWith('-')) {
          break
        }
        'search', 'debug install', 'remove'
        break
      }
    }
  ).Where{ $_ -like "$wordToComplete*" }
}
