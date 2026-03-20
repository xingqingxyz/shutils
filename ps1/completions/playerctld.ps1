using namespace System.Management.Automation.Language

Register-ArgumentCompleter -Native -CommandName playerctld -ScriptBlock {
  param ([string]$wordToComplete, [System.Management.Automation.Language.CommandAst]$commandAst, [int]$cursorPosition)
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
  @(if ($wordToComplete.StartsWith('-')) {
      '-h', '--help'
    }
    elseif (!$command) {
      'daemon', 'shift', 'unshift'
    }).Where{ $_ -like "$wordToComplete*" }
}
