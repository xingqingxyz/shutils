using namespace System.Management.Automation.Language

Register-ArgumentCompleter -Native -CommandName loginctl -ScriptBlock {
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
  @(if (!$wordToComplete.StartsWith('-')) {
      switch ($prev) {
        '--host' { bash -c 'compgen -A hostname'; break }
        '--machine' { @(machinectl list --full --max-addresses=0 --no-legend --no-pager; '.host').ForEach{ $_.Split(' ', 2)[0] } | Sort-Object -Unique; break }
      }
    }
    switch -CaseSensitive -Regex ($command) {
      '^$' {
        if ($wordToComplete.StartsWith('-')) {
          '-h', '--help', '--version', '--no-pager', '--no-legend', '--no-ask-password', '--host', '--machine', '-p', '--property=', '-a', '--all', '--value', '-l', '--full', '--kill-whom=', '--kill-whom=all', '--kill-whom=leader', '-s', '--signal=HUP', '--signal=INT', '--signal=QUIT', '--signal=ILL', '--signal=TRAP', '--signal=ABRT', '--signal=BUS', '--signal=FPE', '--signal=KILL', '--signal=USR1', '--signal=SEGV', '--signal=USR2', '--signal=PIPE', '--signal=ALRM', '--signal=TERM', '--signal=STKFLT', '--signal=CHLD', '--signal=CONT', '--signal=STOP', '--signal=TSTP', '--signal=TTIN', '--signal=TTOU', '--signal=URG', '--signal=XCPU', '--signal=XFSZ', '--signal=VTALRM', '--signal=PROF', '--signal=WINCH', '--signal=IO', '--signal=PWR', '--signal=SYS', '--signal=RTMIN', '--signal=RTMIN+1', '--signal=RTMIN+2', '--signal=RTMIN+3', '--signal=RTMIN+4', '--signal=RTMIN+5', '--signal=RTMIN+6', '--signal=RTMIN+7', '--signal=RTMIN+8', '--signal=RTMIN+9', '--signal=RTMIN+10', '--signal=RTMIN+11', '--signal=RTMIN+12', '--signal=RTMIN+13', '--signal=RTMIN+14', '--signal=RTMIN+15', '--signal=RTMAX-14', '--signal=RTMAX-13', '--signal=RTMAX-12', '--signal=RTMAX-11', '--signal=RTMAX-10', '--signal=RTMAX-9', '--signal=RTMAX-8', '--signal=RTMAX-7', '--signal=RTMAX-6', '--signal=RTMAX-5', '--signal=RTMAX-4', '--signal=RTMAX-3', '--signal=RTMAX-2', '--signal=RTMAX-1', '--signal=RTMAX', '-n', '--lines=', '--json=pretty', '--json=short', '--json=off', '-j', '-o', '--output=short', '--output=short-precise', '--output=short-iso', '--output=short-iso-precise', '--output=short-full', '--output=short-monotonic', '--output=short-unix', '--output=short-delta', '--output=json', '--output=json-pretty', '--output=json-sse', '--output=json-seq', '--output=cat', '--output=verbose', '--output=export', '--output=with-unit'
          break
        }
        'list-sessions', 'session-status', 'show-session', 'activate', 'lock-session', 'unlock-session', 'lock-sessions', 'unlock-sessions', 'terminate-session', 'kill-session', 'list-users', 'user-status', 'show-user', 'enable-linger', 'disable-linger', 'terminate-user', 'kill-user', 'list-seats', 'seat-status', 'show-seat', 'attach', 'flush-devices', 'terminate-seat'
        break
      }
      '^(session-status|show-session|activate|lock-session|unlock-session|terminate-session|kill-session)$' {
        if ($wordToComplete.StartsWith('-')) {
          break
        }
        loginctl list-sessions --no-legend | ForEach-Object { $_.Split(' ', 2)[0] }
        break
      }
      '^(user-status|show-user|enable-linger|disable-linger|terminate-user|kill-user)$' {
        if ($wordToComplete.StartsWith('-')) {
          break
        }
        loginctl list-users --no-legend | ForEach-Object { $_.Split(' ', 2)[0] }
        break
      }
      '^(seat-status|show-seat|terminate-seat|attach)$' {
        if ($wordToComplete.StartsWith('-')) {
          break
        }
        loginctl list-seats --no-legend
        break
      }
    }).Where{ $_ -like "$wordToComplete*" }
}
