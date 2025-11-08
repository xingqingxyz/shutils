using namespace System.Management.Automation.Language

Register-ArgumentCompleter -Native -CommandName scalar -ScriptBlock {
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
      '--help'
    }
    switch ($command) {
      '' {
        if ($wordToComplete.StartsWith('-')) {
          '--version'
          break
        }
        'clone', 'list', 'register', 'unregister', 'run', 'reconfigure', 'delete', 'help', 'version', 'diagnose'
        break
      }
      'help' {
        'clone', 'list', 'register', 'unregister', 'run', 'reconfigure', 'delete', 'help', 'version', 'diagnose'
        break
      }
      'clone' {
        if ($wordToComplete.StartsWith('-')) {
          '-b', '--branch', '--full-clone', '--single-branch', '--src', '--tags', '--maintenance=enable', '--maintenance=disable', '--maintenance=keep', '--no-branch', '--no-full-clone', '--no-single-branch', '--no-src', '--no-tags', '--no-maintenance'
          break
        }
        break
      }
      'register' {
        if ($wordToComplete.StartsWith('-')) {
          '--maintenance=enable', '--maintenance=disable', '--maintenance=keep', '--no-maintenance'
          break
        }
        break
      }
      'run' {
        if (!$wordToComplete.StartsWith('-')) {
          'config', 'commit-graph', 'fetch', 'loose-objects', 'pack-files'
          break
        }
        break
      }
      'reconfigure' {
        if ($wordToComplete.StartsWith('-')) {
          '-a', '--all', '--maintenance=enable', '--maintenance=disable', '--maintenance=keep', '--no-maintenance', '--no-all'
          break
        }
        break
      }
      'verbose' {
        if ($wordToComplete.StartsWith('-')) {
          '-v', '--verbose', '--build-options', '--no-verbose', '--no-build-options'
          break
        }
        break
      }
    }).Where{ $_ -like "$wordToComplete*" }
}
