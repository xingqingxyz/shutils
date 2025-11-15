using namespace System.Management.Automation.Language

Register-ArgumentCompleter -Native -CommandName gdbus -ScriptBlock {
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
  @(switch ($command) {
      '' {
        if ($wordToComplete.StartsWith('-')) {
          '-h', '--help', '-V', '--version'
          break
        }
        'help', 'introspect', 'monitor', 'call', 'emit', 'wait'
        break
      }
      'introspect' {
        if ($wordToComplete.StartsWith('-')) {
          '-y', '--system', '-e', '--session', '-a', '--address=', '-d', '--dest', '-o', '--object-path', '-x', '--xml', '-r', '--recurse', '-p', '--only-properties'
          break
        }
        break
      }
      'monitor' {
        if ($wordToComplete.StartsWith('-')) {
          '-y', '--system', '-e', '--session', '-a', '--address=', '-d', '--dest', '-o', '--object-path'
          break
        }
        break
      }
      'call' {
        if ($wordToComplete.StartsWith('-')) {
          '-y', '--system', '-e', '--session', '-a', '--address=', '-d', '--dest', '-o', '--object-path', '-m', '--method', '-t', '--timeout', '-i', '--interactive'
          break
        }
        break
      }
      'emit' {
        if ($wordToComplete.StartsWith('-')) {
          '-y', '--system', '-e', '--session', '-a', '--address=', '-d', '--dest', '-o', '--object-path', '-s', '--signal'
          break
        }
        break
      }
      'wait' {
        if ($wordToComplete.StartsWith('-')) {
          '-y', '--system', '-e', '--session', '--address=', '-a', '--activate=', '-t', '--timeout=', '--timeout=0'
          break
        }
        break
      }
    }).Where{ $_ -like "$wordToComplete*" }
}
