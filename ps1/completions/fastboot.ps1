using namespace System.Management.Automation.Language

Register-ArgumentCompleter -Native -CommandName fastboot -ScriptBlock {
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
    switch ($command) {
      '' {
        if ($wordToComplete.StartsWith('-')) {
          '--dtb', '--cmdline', '--base', '--kernel-offset', '--ramdisk-offset', '--tags-offset', '--dtb-offset', '--page-size', '--header-version', '--os-version', '--os-patch-level', '-w', '-s', '-S', '--force', '--slot', '--slot=all', '--slot=other', '--set-active', '--set-active=all', '--set-active=other', '--skip-secondary', '--skip-reboot', '--disable-verity', '--disable-verification', '--disable-super-optimization', '--exclude-dynamic-partitions', '--disable-fastboot-info', '--fs-options=casefold', '--fs-options=projid', '--fs-options=compress', '--unbuffered', '--verbose', '-v', '--version', '--help', '-h'
        }
        else {
          'update', 'flashall', 'flash', 'devices', 'getvar', 'reboot', 'flashing', 'erase', 'format', 'set_active', 'oem', 'gsi', 'wipe-super', 'create-logical-partition', 'delete-logical-partition', 'resize-logical-partition', 'snapshot-update', 'fetch', 'boot', 'flash:raw', 'stage', 'get_staged'
        }
        break
      }
      'devices' {
        if ($wordToComplete.StartsWith('-')) {
          '-l'
        }
        break
      }
      'flashing' {
        if (!$wordToComplete.StartsWith('-')) {
          'lock', 'lock_critical', 'unlock', 'unlock_critical', 'get_unlock_ability'
        }
        break
      }
      'gsi' {
        if (!$wordToComplete.StartsWith('-')) {
          'wipe', 'disable', 'status'
        }
        break
      }
      'snapshot-update' {
        if (!$wordToComplete.StartsWith('-')) {
          'cancel', 'merge'
        }
        break
      }
    }).Where{ $_ -like "$wordToComplete*" }
}
