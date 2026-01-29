using namespace System.Management.Automation.Language

Register-ArgumentCompleter -Native -CommandName cbc, codebuddy -ScriptBlock {
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
  @(switch ($command) {
      '' {
        if ($wordToComplete.StartsWith('-')) {
          '-V', '--version', '-d', '--debug=', '--verbose', '-p', '--print', '--output-format=text', '--output-format=json', '--output-format=stream-json', '--input-format=text', '--input-format=json', '--input-format=stream-json', '--json-schema=', '--include-partial-messages', '-y', '--dangerously-skip-permissions', '--permission-mode=acceptEdits', '--permission-mode=bypassPermissions', '--permission-mode=default', '--permission-mode=plan', '--allowedTools=', '--disallowedTools=', '--mcp-config=', '-c', '--continue', '-r', '--resume=', '--model=glm-4.7', '--model=glm-4.6', '--model=glm-4.6v', '--model=deepseek-v3-2-volc', '--model=deepseek-v3.1', '--model=deepseek-v3-0324', '--model=kimi-k2-thinking', '--fallback-model=glm-4.7', '--fallback-model=glm-4.6', '--fallback-model=glm-4.6v', '--fallback-model=deepseek-v3-2-volc', '--fallback-model=deepseek-v3.1', '--fallback-model=deepseek-v3-0324', '--fallback-model=kimi-k2-thinking', '--add-dir=', '--ide', '-v', '--version', '--strict-mcp-config', '--session-id=', '-H', '--header=', '--serve', '--port=', '--host=', '--host=127.0.0.1', '--acp', '--acp-transport=stdio', '--acp-transport=streamable-http', '--sandbox=', '--sandbox-upload-dir', '--sandbox-new', '--sandbox-id=', '--sandbox-kill', '--teleport=', '--max-turns=', '--teleport=', '--system-prompt=', '--system-prompt-file=', '--append-system-prompt=', '--agents=', '--settings=', '--setting-sources=', "--setting-sources=user`,project`,local", '--fork-session', '--replay-user-messages', '-h', '--help'
          break
        }
        'config', 'mcp', 'sandbox', 'plugin', 'doctor', 'update', 'install'
        break
      }
      'config' {
        if ($wordToComplete.StartsWith('-')) {
          '-h', '--help'
          break
        }
        'get', 'set', 'remove', 'rm', 'list', 'ls', 'add', 'help'
        break
      }
      'config set' {
        if ($wordToComplete.StartsWith('-')) {
          '-h', '--help', '-g', '--global'
          break
        }
        break
      }
      'mcp' {
        if ($wordToComplete.StartsWith('-')) {
          break
        }
        'add', 'remove', 'list', 'get', 'add-json', 'help'
        break
      }
      'mcp add' {
        if ($wordToComplete.StartsWith('-')) {
          '-s', '--scope=local', '--scope=project', '--scope=user', '-t', '--transport=stdio', '--transport=streamable-http', '-e', '--env=', '-H', '--header=', '-h', '--help'
          break
        }
        break
      }
      'mcp remove' {
        if ($wordToComplete.StartsWith('-')) {
          '-s', '--scope=local', '--scope=project', '--scope=user', '-h', '--help'
          break
        }
        break
      }
      'mcp add-json' {
        if ($wordToComplete.StartsWith('-')) {
          '-s', '--scope=local', '--scope=project', '--scope=user', '-h', '--help'
          break
        }
        break
      }
      'sandbox' {
        if ($wordToComplete.StartsWith('-')) {
          break
        }
        'list', 'info', 'kill', 'clean', 'help'
        break
      }
      'plugin' {
        if ($wordToComplete.StartsWith('-')) {
          break
        }
        'validate', 'marketplace', 'install', 'i', 'uninstall', 'remove', 'enable', 'disable', 'update', 'help'
        break
      }
      'plugin marketplace' {
        if ($wordToComplete.StartsWith('-')) {
          break
        }
        'add', 'list', 'update', 'remove', 'rm', 'help'
        break
      }
    }).Where{ $_ -like "$wordToComplete*" }
}
