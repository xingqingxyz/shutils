using namespace System.Management.Automation.Language

Register-ArgumentCompleter -Native -CommandName adb -ScriptBlock {
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
  $command = switch ($command) {
    'install-multiple' { 'install'; break }
    'install-multi-package' { 'install'; break }
    default { $_; break }
  }
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
      '-a', '-d', '-e', '-s', '-t', '-H', '-P', '-P5037', '-P5555', '-P9999', '-L', '-Ltcp:localhost:5037', '--one-device', '--exit-on-write-error', '--help', '--version'
    }
    switch ($command) {
      '' {
        if (!$wordToComplete.StartsWith('-')) {
          'devices', 'help', 'version', 'connect', 'disconnect', 'pair', 'forward', 'forward', 'reverse', 'mdns', 'push', 'pull', 'sync', 'shell', 'install', 'install-multiple', 'install-multi-package', 'uninstall', 'bugreport', 'jdwp', 'logcat', 'disable-verity', 'enable-verity', 'keygen', 'wait-for-usb-device', 'wait-for-usb-recovery', 'wait-for-usb-rescue', 'wait-for-usb-sideload', 'wait-for-usb-bootloader', 'wait-for-usb-disconnect', 'wait-for-local-device', 'wait-for-local-recovery', 'wait-for-local-rescue', 'wait-for-local-sideload', 'wait-for-local-bootloader', 'wait-for-local-disconnect', 'wait-for-any-device', 'wait-for-any-recovery', 'wait-for-any-rescue', 'wait-for-any-sideload', 'wait-for-any-bootloader', 'wait-for-any-disconnect', 'get-state', 'get-serialno', 'get-devpath', 'remount', 'reboot', 'sideload', 'root', 'unroot', 'usb', 'tcpip', 'start-server', 'kill-server', 'reconnect', 'attach', 'detach'
        }
        break
      }
      'forward' {
        if ($wordToComplete.StartsWith('-')) {
          '--list', '--no-rebind', '--remove', '--remove-all'
        }
        break
      }
      'reverse' {
        if ($wordToComplete.StartsWith('-')) {
          '--list', '--no-rebind', '--remove', '--remove-all'
        }
        break
      }
      'mdns' {
        if (!$wordToComplete.StartsWith('-')) {
          'check', 'services'
        }
        break
      }
      'push' {
        if ($wordToComplete.StartsWith('-')) {
          '-n', '-q', '-Z', '-z', '-zany', '-znone', '-zbrotli', '-zlz4', '-zzstd', '--sync'
        }
        break
      }
      'pull' {
        if ($wordToComplete.StartsWith('-')) {
          '-a', '-q', '-Z', '-z', '-zany', '-znone', '-zbrotli', '-zlz4', '-zzstd'
        }
        break
      }
      'sync' {
        if ($wordToComplete.StartsWith('-')) {
          '-l', '-n', '-q', '-Z', '-z', '-zany', '-znone', '-zbrotli', '-zlz4', '-zzstd'
        }
        break
      }
      'shell' {
        if ($wordToComplete.StartsWith('-')) {
          '-e', '-enone', '-e~', '-n', '-T', '-t', '-x'
        }
        break
      }
      'install' {
        if ($wordToComplete.StartsWith('-')) {
          '-r', '-t', '-d', '-p', '-g', '--abi', '--instant', '--no-streaming', '--streaming', '--fastdeploy', '--no-fastdeploy', '--force-agent', '--date-check-agent', '--version-check-agent', '--local-agent'
        }
        break
      }
      'uninstall' {
        if ($wordToComplete.StartsWith('-')) {
          '-k'
        }
        break
      }
      'remount' {
        if ($wordToComplete.StartsWith('-')) {
          '-R'
        }
        break
      }
      'reboot' {
        if (!$wordToComplete.StartsWith('-')) {
          'bootloader', 'recovery', 'sideload', 'sideload-auto-reboot'
        }
        break
      }
      'reconnect' {
        if (!$wordToComplete.StartsWith('-')) {
          'device', 'offline'
        }
        break
      }
    }).Where{ $_ -like "$wordToComplete*" }
}
