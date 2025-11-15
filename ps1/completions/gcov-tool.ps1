using namespace System.Management.Automation.Language

Register-ArgumentCompleter -Native -CommandName gcov-tool -ScriptBlock {
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
          '-h', '--help', '-v', '--version'
          break
        }
        'merge', 'merge-stream', 'file', 'rewrite', 'overlap'
        break
      }
      'merge' {
        if ($wordToComplete.StartsWith('-')) {
          '-o', '--output', '-v', '--verbose', '-w', '--weight'
          break
        }
        break
      }
      'file' {
        if ($wordToComplete.StartsWith('-')) {
          '-v', '--verbose', '-w', '--weight'
          break
        }
        break
      }
      'rewrite' {
        if ($wordToComplete.StartsWith('-')) {
          '-n', '--normalize', '-o', '--output', '-s', '--scale', '-v', '--verbose'
          break
        }
        break
      }
      'overlap' {
        if ($wordToComplete.StartsWith('-')) {
          '-f', '--function', '-F', '--fullname', '-h', '--hotonly', '-o', '--object', '-t', '--hot_threshold', '-v', '--verbose'
          break
        }
        break
      }
    }).Where{ $_ -like "$wordToComplete*" }
}

