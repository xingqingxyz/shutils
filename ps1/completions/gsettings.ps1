using namespace System.Management.Automation.Language

Register-ArgumentCompleter -Native -CommandName gsettings -ScriptBlock {
  param ([string]$wordToComplete, [CommandAst]$commandAst, [int]$cursorPosition)
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
  if ($commandAst.CommandElements.Count -gt 3 -and $commandAst.CommandElements[1].Value -ceq '--schemadir') {
    $schemaArgs = '--schemadir', $commandAst.CommandElements[2].Value
  }
  @(switch -CaseSensitive -Regex ($commands -join ' ') {
      '^(|help)$' {
        if ($wordToComplete.StartsWith('-')) {
          '--version', '--schemadir'
          break
        }
        'help', 'list-schemas', 'list-relocatable-schemas', 'list-keys', 'list-children', 'list-recursively', 'range', 'describe', 'get', 'set', 'reset', 'reset-recursively', 'writable', 'monitor'
        break
      }
      '^(list-schemas)$' {
        if ($wordToComplete.StartsWith('-')) {
          '--print-paths'
          break
        }
        break
      }
      '^(list-keys|list-children|list-recursively|reset-recursively|get|range|set|reset|writable|monitor|describe)$' {
        if ($wordToComplete.StartsWith('-')) {
          break
        }
        gsettings @schemaArgs list-schemas
        @(gsettings @schemaArgs list-relocatable-schemas).ForEach{ $_ + ':/' }
        break
      }
      '^(get|set|range|reset|writable|monitor|describe) \S+$' {
        if ($wordToComplete.StartsWith('-')) {
          break
        }
        gsettings @schemaArgs list-keys $commands[1]
        break
      }
    }).Where{ $_ -like "$wordToComplete*" }
}
