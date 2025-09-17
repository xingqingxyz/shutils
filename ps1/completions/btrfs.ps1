using namespace System.Management.Automation.Language

Register-ArgumentCompleter -Native -CommandName btrfs -ScriptBlock {
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
  $cursorPosition -= $wordToComplete.Length
  foreach ($i in $commandAst.CommandElements) {
    if ($i.Extent.StartOffset -ge $cursorPosition) {
      break
    }
    $prev = $i
  }
  $prev = $prev -is [System.Management.Automation.Language.StringConstantExpressionAst] ? $prev.Value : $prev.ToString()

  @(
    if ($wordToComplete.StartsWith('-')) {
      '--format=text', '--format=json', '-v', '--verbose', '-q', '--quiet', '--log=default', '--log=info', '--log=verbose', '--log=debug', '--log=quiet', '--dry-run'
    }
    switch ($command) {
      '' {
        if ($wordToComplete.StartsWith('-')) {
          '--help', '--version'
        }
        else {
          'subvolume', 'filesystem', 'balance', 'device', 'scrub', 'check', 'rescue', 'restore', 'inspect-internal', 'property', 'send', 'receive', 'quota', 'qgroup', 'replace', 'help', 'version'
        }
        break
      }
      'help' {
        if ($wordToComplete.StartsWith('-')) {
          '--full'
        }
        break
      }
      'subvolume' {
        if (!$wordToComplete.StartsWith('-')) {
          'create', 'delete', 'list', 'snapshot', 'find-new', 'get-default', 'set-default', 'show', 'sync'
        }
        break
      }
      'filesystem' {
        if (!$wordToComplete.StartsWith('-')) {
          'defragment', 'sync', 'resize', 'show', 'df', 'du', 'label', 'usage', 'mkswapfile'
        }
        break
      }
      'balance' {
        if (!$wordToComplete.StartsWith('-')) {
          'start', 'pause', 'cancel', 'resume', 'status'
        }
        break
      }
      'device' {
        if (!$wordToComplete.StartsWith('-')) {
          'scan', 'add', 'delete', 'remove', 'ready', 'stats', 'usage'
        }
        break
      }
      'scrub' {
        if (!$wordToComplete.StartsWith('-')) {
          'start', 'cancel', 'resume', 'status'
        }
        break
      }
      'rescue' {
        if (!$wordToComplete.StartsWith('-')) {
          'chunk-recover', 'super-recover', 'zero-log', 'fix-device-size', 'create-control-device', 'clear-uuid-tree', 'clear-ino-cache', 'clear-space-cache'
        }
        break
      }
      'inspect-internal' {
        if (!$wordToComplete.StartsWith('-')) {
          'inode-resolve', 'logical-resolve', 'subvolid-resolve', 'rootid', 'min-dev-size', 'dump-tree', 'dump-super', 'tree-stats', 'map-swapfile'
        }
        break
      }
      'property' {
        if (!$wordToComplete.StartsWith('-')) {
          'get', 'set', 'list'
        }
        break
      }
      'quota' {
        if (!$wordToComplete.StartsWith('-')) {
          'enable', 'disable', 'rescan'
        }
        break
      }
      'qgroup' {
        if (!$wordToComplete.StartsWith('-')) {
          'assign', 'remove', 'create', 'destroy', 'show', 'limit', 'clear-stale'
        }
        break
      }
      'replace' {
        if (!$wordToComplete.StartsWith('-')) {
          'start', 'status', 'cancel'
        }
        break
      }
    }).Where{ $_ -like "$wordToComplete*" }
}
