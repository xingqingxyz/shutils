using namespace System.Management.Automation.Language

Register-ArgumentCompleter -Native -CommandName alacritty -ScriptBlock {
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
          '--print-events', '--ref-test', '--embed', '--config-file', '--socket', '-qq', '-qqq', '-vv', '-vvv', '--daemon', '--working-directory', '--hold', '-e', '--command', '-T', '--title', '--class', '-o', '--option', '-h', '--help', '-V', '--version'
          break
        }
        'help', 'migrate', 'msg'
        break
      }
      'help' {
        'help', 'migrate', 'msg'
        break
      }
      'migrate' {
        if ($wordToComplete.StartsWith('-')) {
          '-c', '--config-file', '-d', '--dry-run', '-i', '--skip-imports', '--skip-renames', '-s', '--silent', '-h', '--help'
          break
        }
        break
      }
      'msg' {
        if ($wordToComplete.StartsWith('-')) {
          '-s', '--socket', '-h', '--help'
          break
        }
        'create-window', 'config', 'get-config', 'help'
        break
      }
      'msg create-window' {
        if ($wordToComplete.StartsWith('-')) {
          '--working-directory', '--hold', '-e', '--command', '-T', '--title', '--class', '-o', '--option', '-h', '--help'
          break
        }
        break
      }
      'msg config' {
        if ($wordToComplete.StartsWith('-')) {
          '-w', '--window-id', '-r', '--reset', '-h', '--help'
          break
        }
        break
      }
      'msg get-config' {
        if ($wordToComplete.StartsWith('-')) {
          '-w', '--window-id', '-h', '--help'
          break
        }
        break
      }
    }).Where{ $_ -like "$wordToComplete*" }
}
