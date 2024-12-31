using namespace System.Management.Automation.Language

Register-ArgumentCompleter -Native -CommandName copyq -ScriptBlock {
  param([string]$wordToComplete, [CommandAst]$commandAst, [int]$cursorPosition)
  $command = @(foreach ($i in $commandAst.CommandElements) {
      if ($i.Extent.StartOffset -eq 0 -or $i.Extent.EndOffset -eq $cursorPosition) {
        continue
      }
      if ($i -isnot [StringConstantExpressionAst] -or
        $i.StringConstantType -ne [StringConstantType]::BareWord -or
        $i.Value.StartsWith('-')) {
        break
      }
      $i.Value
    }) -join ';'
  $command = switch ($command) {
    'clipboard' {  }
    Default { $command }
  }

  $cursorPosition -= $wordToComplete.Length
  foreach ($i in $commandAst.CommandElements) {
    if ($i.Extent.StartOffset -eq $cursorPosition) {
      break
    }
    $prev = $i
  }
  $prev = $prev.ToString()

  @(switch ($command) {
      '' {
        if ($wordToComplete.StartsWith('-')) {
          @('-e', '-s', '--session', '-h', '--help', '-v', '--version', '--tests', '--start-server')
        }
        elseif ($prev.StartsWith('copyq')) {
          @('show', 'hide', 'toggle', 'menu', 'exit', 'disable', 'enable', 'clipboard', 'paste', 'copy', 'count', 'select', 'next', 'previous', 'add', 'insert', 'remove', 'edit', 'read', 'write', 'action', 'action', 'popup', 'tab', 'removetab', 'renametab', 'exporttab', 'importtab', 'config', 'eval', 'session', 'help', 'version', 'tests')
        }
        break
      }
      'clipboard' {
        if ($wordToComplete.StartsWith('-')) {
        }
      }
    }) | Where-Object { $_ -like "$wordToComplete*" }
}
