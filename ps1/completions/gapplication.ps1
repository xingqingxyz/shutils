using namespace System.Management.Automation.Language

Register-ArgumentCompleter -Native -CommandName gapplication -ScriptBlock {
  param ([string]$wordToComplete, [CommandAst]$commandAst, [int]$cursorPosition)
  if ($wordToComplete.StartsWith('-')) {
    return
  }
  $commands = @(foreach ($i in $commandAst.CommandElements) {
      if ($i.Extent.StartOffset -eq $commandAst.Extent.StartOffset -or $i.Extent.EndOffset -eq $cursorPosition) {
        continue
      }
      if ($i -isnot [StringConstantExpressionAst] -or
        $i.StringConstantType -ne [StringConstantType]::BareWord -or
        $i.Value.StartsWith('-')) {
        break
      }
      $i.Value
    })
  @(switch -CaseSensitive -Regex ($commands -join ' ') {
      '^(|help)$' {
        'help', 'version', 'list-apps', 'launch', 'action', 'list-actions'
        break
      }
      '^(launch|action)$' {
        gapplication list-apps
        break
      }
      '^action \S+$' {
        gapplication list-actions $commands[1]
        break
      }
    }).Where{ $_ -like "$wordToComplete*" }
}
