using namespace System.Management.Automation.Language

Register-ArgumentCompleter -Native -CommandName runc -ScriptBlock {
  param ([string]$wordToComplete, [CommandAst]$commandAst, [int]$cursorPosition)
  $commands = @()
  foreach ($i in $commandAst.CommandElements) {
    if ($i.Extent.StartOffset -eq $commandAst.Extent.StartOffset -or $i.Extent.EndOffset -eq $cursorPosition) {
      continue
    }
    if ($i -isnot [StringConstantExpressionAst] -or
      $i.StringConstantType -ne [StringConstantType]::BareWord) {
      break
    }
    if ($i.Value.StartsWith('-')) {
      if ($commands.Count -ne 0) {
        break
      }
      continue
    }
    $commands += $i.Value
  }
  $command = $commands -join ' '
  $command = switch ($command) {
    'h' { 'help'; break }
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
  @(switch ($command) {
      '' {
        if ($wordToComplete.StartsWith('-')) {
          '--debug', '--log', '--log-format', '--root', '--systemd-cgroup', '--rootless', '--help', '-h', '--version', '-v'
          break
        }
        'checkpoint', 'create', 'delete', 'events', 'exec', 'kill', 'list', 'pause', 'ps', 'restore', 'resume', 'run', 'spec', 'start', 'state', 'update', 'features', 'help', 'h'
        break
      }
      'checkpoint' {
        if ($wordToComplete.StartsWith('-')) {
          '--image-path', '--work-path', '--parent-path', '--leave-running', '--tcp-established', '--tcp-skip-in-flight', '--link-remap', '--ext-unix-sk', '--shell-job', '--lazy-pages', '--status-fd', '--page-server', '--file-locks', '--pre-dump', '--manage-cgroups-mode', '--empty-ns', '--auto-dedup'
          break
        }
        runc list -q
        break
      }
      'create' {
        if ($wordToComplete.StartsWith('-')) {
          '--bundle', '-b', '--console-socket', '--pidfd-socket', '--pid-file', '--no-pivot', '--no-new-keyring', '--preserve-fds'
          break
        }
        runc list -q
        break
      }
      'delete' {
        if ($wordToComplete.StartsWith('-')) {
          '--force', '-f'
          break
        }
        runc list -q
        break
      }
      'events' {
        if ($wordToComplete.StartsWith('-')) {
          '--interval', '--stats'
          break
        }
        runc list -q
        break
      }
      'exec' {
        if ($prev -ceq '--cap' -or $prev -ceq '-c') {
          'ALL', 'AUDIT_CONTROL', 'AUDIT_WRITE', 'AUDIT_READ', 'BLOCK_SUSPEND', 'BPF', 'CHECKPOINT_RESTORE', 'CHOWN', 'DAC_OVERRIDE', 'DAC_READ_SEARCH', 'FOWNER', 'FSETID', 'IPC_LOCK', 'IPC_OWNER', 'KILL', 'LEASE', 'LINUX_IMMUTABLE', 'MAC_ADMIN', 'MAC_OVERRIDE', 'MKNOD', 'NET_ADMIN', 'NET_BIND_SERVICE', 'NET_BROADCAST', 'NET_RAW', 'PERFMON', 'SETFCAP', 'SETGID', 'SETPCAP', 'SETUID', 'SYS_ADMIN', 'SYS_BOOT', 'SYS_CHROOT', 'SYSLOG', 'SYS_MODULE', 'SYS_NICE', 'SYS_PACCT', 'SYS_PTRACE', 'SYS_RAWIO', 'SYS_RESOURCE', 'SYS_TIME', 'SYS_TTY_CONFIG', 'WAKE_ALARM'
          break
        }
        if ($wordToComplete.StartsWith('-')) {
          '--console-socket', '--pidfd-socket', '--cwd', '--env', '-e', '--tty', '-t', '--user', '-u', '--additional-gids', '-g', '--process', '-p', '--detach', '-d', '--pid-file', '--process-label', '--apparmor', '--no-new-privs', '--cap', '-c', '--preserve-fds', '--cgroup', '--ignore-paused'
          break
        }
        runc list -q
        break
      }
      'kill' {
        if ($wordToComplete.StartsWith('-')) {
          '--help', '-h', '--all', '-a'
          break
        }
        runc list -q
        break
      }
      { $_.StartsWith('kill ') } {
        if ($wordToComplete.StartsWith('-')) {
          '--help', '-h', '--all', '-a'
          break
        }
        (bash -c 'kill -l') -csplit '\s+' | ForEach-Object {
          if ($_.StartsWith('SIG')) {
            $_.Substring(3)
          }
        }
        break
      }
      'list' {
        if ($wordToComplete.StartsWith('-')) {
          '--format', '-f', '--quiet', '-q'
          break
        }
        break
      }
      'pause' {
        runc list -q
        break
      }
      'ps' {
        if ($wordToComplete.StartsWith('-')) {
          '--format', '-f'
          break
        }
        runc list -q
        break
      }
      'restore' {
        if ($wordToComplete.StartsWith('-')) {
          '--console-socket', '--image-path', '--work-path', '--tcp-established', '--ext-unix-sk', '--shell-job', '--file-locks', '--manage-cgroups-mode', '--bundle', '-b', '--detach', '-d', '--pid-file', '--no-subreaper', '--no-pivot', '--empty-ns', '--auto-dedup', '--lazy-pages', '--lsm-profile', '--lsm-mount-context'
          break
        }
        runc list -q
        break
      }
      'resume' {
        if ($wordToComplete.StartsWith('-')) {
          '-h', '--help'
          break
        }
        runc list -q
        break
      }
      'run' {
        if ($wordToComplete.StartsWith('-')) {
          '--bundle', '-b', '--console-socket', '--pidfd-socket', '--detach', '-d', '--keep', '--pid-file', '--no-subreaper', '--no-pivot', '--no-new-keyring', '--preserve-fds'
          break
        }
        runc list -q
        break
      }
      'spec' {
        if ($wordToComplete.StartsWith('-')) {
          '--bundle', '-b', '--rootless'
          break
        }
        break
      }
      'start' {
        if ($wordToComplete.StartsWith('-')) {
          '-h', '--help'
          break
        }
        runc list -q
        break
      }
      'state' {
        if ($wordToComplete.StartsWith('-')) {
          '-h', '--help'
          break
        }
        runc list -q
        break
      }
      'update' {
        if ($wordToComplete.StartsWith('-')) {
          '--blkio-weight', '--cpu-period', '--cpu-quota', '--cpu-burst', '--cpu-share', '--cpu-rt-period', '--cpu-rt-runtime', '--cpuset-cpus', '--cpuset-mems', '--memory', '--cpu-idle', '--memory-reservation', '--memory-swap', '--pids-limit', '--l3-cache-schema', '--mem-bw-schema'
          break
        }
        runc list -q
        break
      }
      'help' {
        'checkpoint', 'create', 'delete', 'events', 'exec', 'kill', 'list', 'pause', 'ps', 'restore', 'resume', 'run', 'spec', 'start', 'state', 'update', 'features', 'help', 'h'
        break
      }
    }).Where{ $_ -like "$wordToComplete*" }
}
