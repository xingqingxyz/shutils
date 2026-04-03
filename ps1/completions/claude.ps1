using namespace System.Management.Automation.Language

Register-ArgumentCompleter -Native -CommandName claude -ScriptBlock {
  param ([string]$wordToComplete, [CommandAst]$commandAst, [int]$cursorPosition)
  $commands = @(foreach ($i in $commandAst.CommandElements) {
      if ($i.Extent.StartOffset -eq $commandAst.Extent.StartOffset -or $i.Extent.EndOffset -eq $cursorPosition) {
        continue
      }
      if ($i -isnot [StringConstantExpressionAst] -or
        $i.StringConstantType -ne [StringConstantType]::BareWord -or
        $i.Value.StartsWith('-')) {
        break
      }
      $i.Value
    })
  if ($commands.Count) {
    $commands[0] = switch ($commands[0]) {
      'plugin' { 'plugins'; break }
      default { $_; break }
    }
  }
  if ($commands.Count -gt 1) {
    $commands[1] = switch ($commands[0]) {
      'plugins' {
        switch ($commands[1]) {
          'i' { 'install'; break }
          'remove' { 'uninstall'; break }
          default { $_; break }
        }
        break
      }
      'marketplace' {
        switch ($commands[1]) {
          'rm' { 'remove'; break }
          default { $_; break }
        }
        break
      }
      default { $commands[1]; break }
    }
  }
  @(if ($wordToComplete.StartsWith('-')) {
      '-h', '--help'
    }
    switch ($commands -join ' ') {
      '' {
        if ($wordToComplete.StartsWith('-')) {
          '--add-dir=', '--agent=', '--agents=', '--allow-dangerously-skip-permissions', '--allowedTools', '--allowed-tools=', '--append-system-prompt=', '--bare', '--betas=', '--brief', '--chrome', '-c', '--continue', '--dangerously-skip-permissions', '-d', '--debug', '--debug=api', '--debug-file=', '--disable-slash-commands', '--disallowedTools', '--disallowed-tools=', '--effort=low', '--effort=medium', '--effort=high', '--effort=max', '--fallback-model=sonnet', '--fallback-model=opus', '--file=', '--fork-session', '--from-pr', '--from-pr=', '--ide', '--include-hook-events', '--include-partial-messages', '--input-format=text', '--input-format=stream-json', '--json-schema=', '--max-budget-usd=', '--mcp-config=', '--mcp-debug', '--model=sonnet', '--model=opus', '-n', '--name=', '--no-chrome', '--no-session-persistence', '--output-format=text', '--output-format=json', '--output-format=stream-json', '--permission-mode=acceptEdits', '--permission-mode=bypassPermissions', '--permission-mode=default', '--permission-mode=dontAsk', '--permission-mode=plan', '--permission-mode=auto', '--plugin-dir=', '-p', '--print', '--replay-user-messages', '-r', '--resume', '--resume=', '--session-id=', '--setting-sources=', '--settings=', '--strict-mcp-config', '--system-prompt=', '--tmux', '--tools=', '--tools=default', '--verbose', '-v', '--version', '-w', '--worktree', '--worktree='
          break
        }
        'agents', 'auth', 'auto-mode', 'doctor', 'install', 'mcp', 'plugin', 'plugins', 'setup-token', 'update', 'upgrade'
        break
      }
      { $_ -ceq 'auth' -or $_ -ceq 'auth help' } {
        if ($wordToComplete.StartsWith('-')) {
          '-h', '--help'
          break
        }
        'help', 'login', 'logout', 'status'
        break
      }
      { $_ -ceq 'auto-mode' -or $_ -ceq 'auto-mode help' } {
        if ($wordToComplete.StartsWith('-')) {
          '-h', '--help'
          break
        }
        'config', 'critique', 'defaults', 'help'
        break
      }
      { $_ -ceq 'mcp' -or $_ -ceq 'mcp help' } {
        if ($wordToComplete.StartsWith('-')) {
          '-h', '--help'
          break
        }
        'add', 'add-from-claude-desktop', 'add-json', 'get', 'help', 'list', 'remove', 'reset-project-choices', 'serve'
        break
      }
      { $_ -ceq 'mcp add-from-claude-desktop' -or $_ -ceq 'mcp remove' -or $_ -ceq 'plugins enable' -or $_ -ceq 'plugins install' -or $_ -ceq 'plugins update' } {
        if ($wordToComplete.StartsWith('-')) {
          '-s', '--scope=local', '--scope=user', '--scope=project'
          break
        }
        break
      }
      { $_ -ceq 'plugins' -or $_ -ceq 'plugins help' } {
        if ($wordToComplete.StartsWith('-')) {
          '-h', '--help'
          break
        }
        'disable', 'enable', 'help', 'install', 'i', 'list', 'marketplace', 'uninstall', 'remove', 'update', 'validate'
        break
      }
      { $_ -ceq 'plugins marketplace' -or $_ -ceq 'plugins marketplace help' } {
        if ($wordToComplete.StartsWith('-')) {
          '-h', '--help'
          break
        }
        'add', 'help', 'list', 'remove', 'rm', 'update'
        break
      }
      'auto-mode critique' {
        if ($wordToComplete.StartsWith('-')) {
          '--model=sonnet', '--model=opus'
          break
        }
        break
      }
      'install' {
        if ($wordToComplete.StartsWith('-')) {
          '--force'
          break
        }
        break
      }
      'mcp add' {
        if ($wordToComplete.StartsWith('-')) {
          '--callback-port=', '--client-id=', '--client-secret', '-e', '--env=', '-H', '--header=', '-s', '--scope=local', '--scope=user', '--scope=project', '-t', '--transport=stdio', '--transport=sse', '--transport=http'
          break
        }
        break
      }
      'mcp add-json' {
        if ($wordToComplete.StartsWith('-')) {
          '--client-secret', '-s', '--scope=local', '--scope=user', '--scope=project'
          break
        }
        break
      }
      'mcp serve' {
        if ($wordToComplete.StartsWith('-')) {
          '-d', '--debug', '--verbose'
          break
        }
        break
      }
      'plugins disable' {
        if ($wordToComplete.StartsWith('-')) {
          '-a', '--all', '-s', '--scope=local', '--scope=user', '--scope=project'
          break
        }
        break
      }
      'plugins list' {
        if ($wordToComplete.StartsWith('-')) {
          '--available', '--json'
          break
        }
        break
      }
      'plugins marketplace add' {
        if ($wordToComplete.StartsWith('-')) {
          '-s', '--scope=local', '--scope=user', '--scope=project', '--sparse'
          break
        }
        break
      }
      'plugins marketplace list' {
        if ($wordToComplete.StartsWith('-')) {
          '--json'
          break
        }
        break
      }
      'plugins uninstall' {
        if ($wordToComplete.StartsWith('-')) {
          '--keep-data', '-s', '--scope=local', '--scope=user', '--scope=project'
          break
        }
        break
      }
    }).Where{ $_ -like "$wordToComplete*" }
}
