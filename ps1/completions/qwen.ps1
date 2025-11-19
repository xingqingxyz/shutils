using namespace System.Management.Automation.Language

Register-ArgumentCompleter -Native -CommandName qwen -ScriptBlock {
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
          '--telemetry', '--telemetry-target=local', '--telemetry-target=gcp', '--telemetry-otlp-endpoint', '--telemetry-otlp-protocol=grpc', '--telemetry-otlp-protocol=http', '--telemetry-log-prompts', '--telemetry-outfile', '-d', '--debug', '--proxy', '-m', '--model', '-p', '--prompt', '-i', '--prompt-interactive', '-s', '--sandbox', '--sandbox-image', '-a', '--all-files', '--show-memory-usage', '-y', '--yolo', '--approval-mode=plan', '--approval-mode=default', '--approval-mode=auto-edit', '--approval-mode=yolo', '-c', '--checkpointing', '--experimental-acp', '--allowed-mcp-server-names', '--allowed-tools', '-e', '--extensions', '-l', '--list-extensions', '--include-directories', '--openai-logging', '--openai-logging-dir', '--openai-api-key', '--openai-base-url', '--tavily-api-key', '--google-api-key', '--google-search-engine-id', '--web-search-default', '--screen-reader', '--vlm-switch-mode=once', '--vlm-switch-mode=session', '--vlm-switch-mode=persist', '-o', '--output-format=text', '--output-format=json', '-v', '--version', '-h', '--help'
          break
        }
        'mcp', 'extensions'
        break
      }
      'mcp' {
        if ($wordToComplete.StartsWith('-')) {
          '--telemetry', '--telemetry-target=local', '--telemetry-target=gcp', '--telemetry-otlp-endpoint', '--telemetry-otlp-protocol', '--telemetry-log-prompts', '--telemetry-outfile', '-d', '--debug', '--proxy', '-h', '--help'
          break
        }
        'add', 'remove', 'list'
        break
      }
      'mcp add' {
        if ($wordToComplete.StartsWith('-')) {
          '--telemetry', '--telemetry-target=local', '--telemetry-target=gcp', '--telemetry-otlp-endpoint', '--telemetry-otlp-protocol=grpc', '--telemetry-otlp-protocol=http', '--telemetry-log-prompts', '--telemetry-outfile', '-d', '--debug', '--proxy', '-s', '--scope=user', '--scope=project', '-t', '--transport=stdio', '--transport=sse', '--transport=http', '-e', '--env', '-H', '--header', '--timeout', '--trust', '--description', '--include-tools', '--exclude-tools', '-h', '--help'
          break
        }
        break
      }
      'mcp remove' {
        if ($wordToComplete.StartsWith('-')) {
          '--telemetry', '--telemetry-target=local', '--telemetry-target=gcp', '--telemetry-otlp-endpoint', '--telemetry-otlp-protocol=grpc', '--telemetry-otlp-protocol=http', '--telemetry-log-prompts', '--telemetry-outfile', '-d', '--debug', '--proxy', '-s', '--scope=user', '--scope=project', '-h', '--help'
          break
        }
        break
      }
      'mcp list' {
        if ($wordToComplete.StartsWith('-')) {
          '--telemetry', '--telemetry-target=local', '--telemetry-target=gcp', '--telemetry-otlp-endpoint', '--telemetry-otlp-protocol=grpc', '--telemetry-otlp-protocol=http', '--telemetry-log-prompts', '--telemetry-outfile', '-d', '--debug', '--proxy', '-h', '--help'
          break
        }
        break
      }
      'extensions' {
        if ($wordToComplete.StartsWith('-')) {
          '--telemetry', '--telemetry-target=local', '--telemetry-target=gcp', '--telemetry-otlp-endpoint', '--telemetry-otlp-protocol=grpc', '--telemetry-otlp-protocol=http', '--telemetry-log-prompts', '--telemetry-outfile', '-d', '--debug', '--proxy', '-h', '--help'
          break
        }
        'install', 'uninstall', 'list', 'update', 'disable', 'enable', 'link', 'new'
        break
      }
      { $_.StartsWith('extensions ') } {
        if ($wordToComplete.StartsWith('-')) {
          '--telemetry', '--telemetry-target=local', '--telemetry-target=gcp', '--telemetry-otlp-endpoint', '--telemetry-otlp-protocol=grpc', '--telemetry-otlp-protocol=http', '--telemetry-log-prompts', '--telemetry-outfile', '-d', '--debug', '--proxy', '-h', '--help', '--all', '--scope=user', '--scope=project'
          break
        }
        break
      }
    }).Where{ $_ -like "$wordToComplete*" }
}
