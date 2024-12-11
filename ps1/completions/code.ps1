Register-ArgumentCompleter -Native -CommandName code -ScriptBlock {
  param([string]$wordToComplete, [System.Management.Automation.Language.CommandAst]$commandAst, [int]$cursorPosition)
  $cursorPosition -= $wordToComplete.Length
  foreach ($key in $commandAst.CommandElements) {
    if ($key.Extent.StartOffset -eq $cursorPosition) {
      break
    }
    $prev = $key
  }
  @(switch ($prev.ToString()) {
      '--sync' { 
        @('on', 'off')
      }
      '--locale' {
        @('en-US', 'zh-CN', 'zh-TW')
      }
      '--log' { 
        @('critical', 'error', 'warn', 'info', 'debug', 'trace', 'off')
      }
      { @('--disable-extension', '--uninstall-extension', '--enable-proposed-api').Contains($_) } { 
        code --list-extensions
      }
      Default {
        if ($wordToComplete.StartsWith('-')) {
          @('-d', '--diff', '-m', '--merge', '-a', '--add', '-g', '--goto', '-n', '--new-window', '-r', '--reuse-window', '-w', '--wait', '--locale', '--user-data-dir', '--profile', '-h', '--help', '--extensions-dir', '--list-extensions', '--show-versions', '--category', '--install-extension', '--force', '--pre-release', '--install-extension', '--uninstall-extension', '--update-extensions', '--enable-proposed-api', '-v', '--version', '--verbose', '--log', '-s', '--status', '--prof-startup', '--disable-extensions', '--disable-extension', '--sync', '--inspect-extensions', '--inspect-brk-extensions', '--disable-lcd-text', '--disable-gpu', '--disable-chromium-sandbox', '--telemetry')
        }
        else {
          @('tunnel', 'serve-web')
        }
      }
    }) | Where-Object { $_ -like "$wordToComplete*" }
}
