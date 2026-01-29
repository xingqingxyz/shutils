using namespace System.Management.Automation.Language

Register-ArgumentCompleter -Native -CommandName wt -ScriptBlock {
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
  $command = switch ($command) {
    'nt' { 'new-tab'; break }
    'sp' { 'split-pane'; break }
    'ft' { 'focus-tab'; break }
    'mf' { 'move-focus'; break }
    'mp' { 'move-pane'; break }
    'fp' { 'focus-pane'; break }
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
          '-V', '--version', '-h', '--help', '-M', '--maximized', '-F', '--fullscreen', '-f', '--focus', '--pos', '--size', '-w', '--window', '-s', '--saved'
          break
        }
        'new-tab', 'nt', 'split-pane', 'sp', 'focus-tab', 'ft', 'move-focus', 'mf', 'move-pane', 'mp', 'swap-pane', 'focus-pane', 'fp', 'x-save'
        break
      }
      'new-tab' {
        if ($wordToComplete.StartsWith('-')) {
          '-h', '--help', '-p', '--profile', '--sessionId', '-d', '--startingDirectory', '--title', '--tabColor', '--suppressApplicationTitle', '--useApplicationTitle', '--colorScheme', '--appendCommandLine', '--inheritEnvironment', '--reloadEnvironment'
          break
        }
        break
      }
      'split-pane' {
        if ($wordToComplete.StartsWith('-')) {
          '-h', '--help', '-p', '--profile', '--sessionId', '-d', '--startingDirectory', '--title', '--tabColor', '--suppressApplicationTitle', '--useApplicationTitle', '--colorScheme', '--appendCommandLine', '--inheritEnvironment', '--reloadEnvironment', '-H', '--horizontal', '-V', '--vertical', '-s', '--size', '-D', '--duplicate'
          break
        }
        break
      }
      'focus-tab' {
        if ($wordToComplete.StartsWith('-')) {
          '-h', '--help', '-t', '--target', '-n', '--next', '-p', '--previous'
          break
        }
        break
      }
      'move-pane' {
        if ($wordToComplete.StartsWith('-')) {
          '-h', '--help', '-t', '--tab'
          break
        }
        break
      }
      'focus-pane' {
        if ($wordToComplete.StartsWith('-')) {
          '-h', '--help', '-t', '--target'
          break
        }
        break
      }
      'x-save' {
        if ($wordToComplete.StartsWith('-')) {
          '-h', '--help', '-n', '--name', '-k', '--keychord'
          break
        }
        break
      }
    }).Where{ $_ -like "$wordToComplete*" }
}
