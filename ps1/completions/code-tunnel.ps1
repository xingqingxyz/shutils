using namespace System.Management.Automation.Language

Register-ArgumentCompleter -Native -CommandName code-tunnel -ScriptBlock {
  param([string]$wordToComplete, [CommandAst]$commandAst, [int]$cursorPosition)
  $command = @(foreach ($i in $commandAst.CommandElements) {
      if ($i.Extent.StartOffset -eq 0 -or $i.Extent.EndOffset -eq $cursorPosition) {
        continue
      }
      if ($i -isnot [StringConstantExpressionAst] -or
        $i.StringConstantType -ne [StringConstantType]::BareWord -or
        $i.Value.StartsWith('-')) {
        break
      }
      $i.Value
    }) -join ';'

  $cursorPosition -= $wordToComplete.Length
  foreach ($i in $commandAst.CommandElements) {
    if ($i.Extent.StartOffset -ge $cursorPosition) {
      break
    }
    $prev = $i
  }
  $prev = $prev.ToString()

  @(switch ($command) {
      '' {
        if ($wordToComplete.StartsWith('-')) {
          @('-d', '--diff', '-a', '--add', '-g', '--goto', '-n', '--new-window', '-r', '--reuse-window', '-w', '--wait', '--locale', '--user-data-dir', '--extensions-dir', '--use-version', '--prof-startup', '--disable-extensions', '--disable-extension', '--sync', '--inspect-extensions', '--inspect-brk-extensions', '--disable-gpu', '--telemetry')
          break
        }
        switch ($prev) {
          '--locale' { @('en-US', 'zh-CN', 'zh-TW'); break }
          '--sync' { @('on', 'off'); break }
          '--use-version' { @('stable', 'insiders'); break }
          Default {
            if ($commandAst.CommandElements.Count -le 2) {
              @('ext', 'status', 'version', 'help', 'tunnel', 'serve-web')
            }
            break
          }
        }
        break
      }
      'ext' {
        if ($wordToComplete.StartsWith('-')) {
          @('--extensions-dir', '--user-data-dir', '--use-version')
          break
        }
        switch ($prev) {
          '--use-version' { @('stable', 'insiders'); break }
          Default {
            if ($commandAst.CommandElements.Count -le 3) {
              @('list', 'install', 'uninstall', 'update', 'help')
            }
            break
          }
        }
        break
      }
      'ext;list' {
        if ($wordToComplete.StartsWith('-')) {
          @('--category', '--show-versions')
          break
        }
        switch ($prev) {
          '--category' {
            @('builtin', 'deprecated', 'disabled', 'enabled', 'featured', 'installed', 'popular', 'recentlyPublished', 'recommended', 'updates', 'workspaceUnsupported', 'ext:', 'id:', 'tag:', 'sort:installs', 'sort:name', 'sort:publishedDate', 'sort:rating', 'sort:updateDate') +
            @(@('ai', 'azure', 'chat', 'data science', 'debuggers', 'education', 'extension packs', 'formatters', 'keymaps', 'language packs', 'linters', 'notebooks', 'machine learning', 'others', 'programming languages', 'scm providers', 'snippets', 'testing', 'themes', 'visualization') | ForEach-Object { "category:`"$_`"" })
            break
          }
        }
        break
      }
      'ext;install' {
        if ($wordToComplete.StartsWith('-')) {
          @('--pre-release', '--force')
        }
        else {
          code-tunnel ext list
        }
        break
      }
      'ext;uninstall' {
        if (!$wordToComplete.StartsWith('-')) {
          code-tunnel ext list
        }
        break
      }
      'version' {
        if ($prev -eq 'version') {
          @('use', 'show', 'help')
        }
        break
      }
      'version:use' {
        if ($wordToComplete.StartsWith('-')) {
          @('--install-dir')
        }
        elseif ($prev -eq 'use') {
          @('stable', 'insiders')
        }
        break
      }
      'serve-web' {
        if ($wordToComplete.StartsWith('-')) {
          @('--host', '--socket-path', '--port', '--connection-token', '--connection-token-file', '--without-connection-token', '--accept-server-license-terms', '--server-base-path', '--server-data-dir', '--user-data-dir', '--extensions-dir')
          break
        }
        switch ($prev) {
          '--host' { @('localhost', '0.0.0.0'); break }
          '--port' { @('8000'); break }
        }
        break
      }
      'tunnel' {
        if ($wordToComplete.StartsWith('-')) {
          @('--install-extension', '--server-data-dir', '--extensions-dir', '--random-name', '--no-sleep', '--name', '--accept-server-license-terms')
        }
        elseif ($commandAst.CommandElements.Count -le 3) {
          @('prune', 'kill', 'restart', 'status', 'rename', 'unregister', 'user', 'service', 'help')
        }
        break
      }
      'tunnel;user' {
        if ($commandAst.CommandElements.Count -le 4) {
          @('login', 'logout', 'show', 'help')
        }
        break
      }
      'tunnel;service' {
        if ($commandAst.CommandElements.Count -le 4) {
          @('install', 'uninstall', 'log', 'help')
        }
        break
      }
      'tunnel;user;login' {
        if ($wordToComplete.StartsWith('-')) {
          @('--access-token', '--refresh-token', '--provider')
        }
        elseif ($prev -eq '--provider') {
          @('microsoft', 'github')
        }
        break
      }
      'tunnel;service;install' {
        if ($wordToComplete.StartsWith('-')) {
          @('--name', '--accept-server-license-terms')
        }
        break
      }
      'tunnel;help' {
        if ($commandAst.CommandElements.Count -le 4) {
          @('prune', 'kill', 'restart', 'status', 'rename', 'unregister', 'user', 'service', 'help')
        }
        break
      }
    }
    if ($wordToComplete.StartsWith('-')) {
      @('--cli-data-dir', '--verbose', '--log', '-h', '--help')
    }
    elseif ($prev -eq '--log') {
      @('trace', 'debug', 'info', 'warn', 'error', 'critical', 'off')
    }
  ).Where{ $_ -like "$wordToComplete*" }
}
