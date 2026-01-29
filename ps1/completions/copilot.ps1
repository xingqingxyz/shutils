using namespace System.Management.Automation.Language

Register-ArgumentCompleter -Native -CommandName copilot -ScriptBlock {
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
          '--add-dir=', '--add-github-mcp-tool=', '--add-github-mcp-tool=*', '--add-github-mcp-toolset=', '--additional-mcp-config=', '--agent=', '--allow-all', '--allow-all-paths', '--allow-all-tools', '--allow-all-urls', '--allow-tool=', '--allow-url=', '--available-tools=', '--banner', '--config-dir=', '--continue', '--deny-tool=', '--deny-url=', '--disable-builtin-mcps', '--disable-mcp-server=', '--disable-parallel-tools-execution', '--disallow-temp-dir', '--enable-all-github-mcp-tools', '--excluded-tools=', '-h', '--help', '-i', '--interactive', '--log-dir', '--log-level=none', '--log-level=error', '--log-level=warning', '--log-level=info', '--log-level=debug', '--log-level=all', '--log-level=default', '--model=claude-sonnet-4.5', '--model=claude-haiku-4.5', '--model=claude-opus-4.5', '--model=claude-sonnet-4', '--model=gpt-5.2-codex', '--model=gpt-5.1-codex-max', '--model=gpt-5.1-codex', '--model=gpt-5.2', '--model=gpt-5.1', '--model=gpt-5', '--model=gpt-5.1-codex-mini', '--model=gpt-5-mini', '--model=gpt-4.1', '--model=gemini-3-pro-preview', '--no-ask-user', '--no-auto-update', '--no-color', '--no-custom-instructions', '-p', '--prompt=', '--plain-diff', '--resume=', '-s', '--silent', '--screen-reader', '--share=', '--share-gist', '--stream=on', '--stream=off', '-v', '--version', '--yolo'
          break
        }
        break
      }
      'help' {
        if ($wordToComplete.StartsWith('-')) {
          break
        }
        'config', 'commands', 'environment', 'logging', 'permissions'
        break
      }
    }).Where{ $_ -like "$wordToComplete*" }
}
