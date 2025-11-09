using namespace System.Management.Automation.Language

Register-ArgumentCompleter -Native -CommandName wsb -ScriptBlock {
  param ([string]$wordToComplete, [CommandAst]$commandAst, [int]$cursorPosition)
  [string[]]$commands = foreach ($i in $commandAst.CommandElements) {
    if ($i.Extent.StartOffset -eq $commandAst.Extent.StartOffset -or $i.Extent.EndOffset -eq $cursorPosition) {
      continue
    }
    if ($i -isnot [StringConstantExpressionAst] -or
      $i.StringConstantType -ne [StringConstantType]::BareWord -or
      $i.Value.StartsWith('-')) {
      break
    }
    $i.Value
  }
  if ($commands.Count -gt 0) {
    $commands[0] = switch ($commands[0]) {
      start { 'StartSandbox'; break }
      list { 'ListRunningSandboxes'; break }
      exec { 'Execute'; break }
      share { 'ShareFolder'; break }
      stop { 'StopSandbox'; break }
      connect { 'ConnectToSandbox'; break }
      ip { 'GetIpAddress'; break }
      default { $_; break }
    }
  }
  $command = $commands -join ' '
  @(switch ($command) {
      '' {
        if ($wordToComplete.StartsWith('-')) {
          '--raw', '-?', '-h', '--help', '--version'
          break
        }
        'StartSandbox', 'start', 'ListRunningSandboxes', 'list', 'Execute', 'exec', 'ShareFolder', 'share', 'StopSandbox', 'stop', 'ConnectToSandbox', 'connect', 'GetIpAddress', 'ip'
        break
      }
      'StartSandbox' {
        if ($wordToComplete.StartsWith('-')) {
          '--id', '-c', '--config', '--raw', '-?', '-h', '--help'
          break
        }
        break
      }
      'ListRunningSandboxes' {
        if ($wordToComplete.StartsWith('-')) {
          '--raw', '-?', '-h', '--help'
          break
        }
        break
      }
      'Execute' {
        if ($wordToComplete.StartsWith('-')) {
          '--id', '-c', '--command', '-d', '--working-directory', '-r', '--run-as', '--raw', '-?', '-h', '--help'
          break
        }
        break
      }
      'ShareFolder' {
        if ($wordToComplete.StartsWith('-')) {
          '--id', '-f', '--host-path', '-s', '--sandbox-path', '-w', '--allow-write', '--raw', '-?', '-h', '--help'
          break
        }
        break
      }
      'StopSandbox' {
        if ($wordToComplete.StartsWith('-')) {
          '--id', '--raw', '-?', '-h', '--help'
          break
        }
        break
      }
      'ConnectToSandbox' {
        if ($wordToComplete.StartsWith('-')) {
          '--id', '--raw', '-?', '-h', '--help'
          break
        }
        break
      }
      'GetIpAddress' {
        if ($wordToComplete.StartsWith('-')) {
          '--id', '--raw', '-?', '-h', '--help'
          break
        }
        break
      }
    }).Where{ $_ -like "$wordToComplete*" }
}
