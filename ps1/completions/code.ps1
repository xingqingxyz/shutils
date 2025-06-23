using namespace System.Management.Automation.Language

Register-ArgumentCompleter -Native -CommandName code -ScriptBlock {
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
          @('-d', '--diff', '-m', '--merge', '-a', '--add', '-g', '--goto', '-n', '--new-window', '-r', '--reuse-window', '-w', '--wait', '--locale', '--user-data-dir', '--profile', '--extensions-dir', '--list-extensions', '--show-versions', '--category', '--install-extension', '--force', '--pre-release', '--install-extension', '--uninstall-extension', '--update-extensions', '--enable-proposed-api', '-v', '--version', '--verbose', '--log', '-s', '--status', '--prof-startup', '--disable-extensions', '--disable-extension', '--sync', '--inspect-extensions', '--inspect-brk-extensions', '--disable-lcd-text', '--disable-gpu', '--disable-chromium-sandbox', '--telemetry', '-h', '--help')
          break
        }
        switch ($prev) {
          '--sync' { @('on', 'off'); break }
          '--locale' { @('en-US', 'zh-CN', 'zh-TW'); break }
          '--log' { @('critical', 'error', 'warn', 'info', 'debug', 'trace', 'off'); break }
          '--category' {
            @('builtin', 'deprecated', 'disabled', 'enabled', 'featured', 'installed', 'popular', 'recentlyPublished', 'recommended', 'updates', 'workspaceUnsupported', 'ext:', 'id:', 'tag:', 'sort:installs', 'sort:name', 'sort:publishedDate', 'sort:rating', 'sort:updateDate') +
            @(@('ai', 'azure', 'chat', 'data science', 'debuggers', 'education', 'extension packs', 'formatters', 'keymaps', 'language packs', 'linters', 'notebooks', 'machine learning', 'others', 'programming languages', 'scm providers', 'snippets', 'testing', 'themes', 'visualization') | ForEach-Object { "category:`"$_`"" })
            break
          }
          { @('--disable-extension', '--install-extension', '--uninstall-extension', '--enable-proposed-api').Contains($_) } {
            code --list-extensions
            break
          }
          Default {
            if ($commandAst.CommandElements.Count -le 2) {
              @('tunnel', 'serve-web')
            }
            break
          }
        }
        break
      }
      'serve-web' {
        if ($wordToComplete.StartsWith('-')) {
          @('--host', '--socket-path', '--port', '--connection-token', '--connection-token-file', '--without-connection-token', '--accept-server-license-terms', '--server-base-path', '--server-data-dir', '--user-data-dir', '--extensions-dir', '--cli-data-dir', '--verbose', '--log', '-h', '--help')
          break
        }
        switch ($prev) {
          '--log' { @('trace', 'debug', 'info', 'warn', 'error', 'critical', 'off'); break }
          '--host' { @('localhost', '0.0.0.0'); break }
          '--port' { @('8000'); break }
        }
        break
      }
      { $_.Split(';')[0] -eq 'tunnel' } {
        if ($wordToComplete.StartsWith('-')) {
          @('--cli-data-dir', '--verbose', '--log', '-h', '--help')
        }
        elseif ($prev -eq '--log') {
          @('trace', 'debug', 'info', 'warn', 'error', 'critical', 'off')
          break
        }
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
  ).Where{ $_ -like "$wordToComplete*" }
}
