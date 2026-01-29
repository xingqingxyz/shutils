using namespace System.Management.Automation.Language

Register-ArgumentCompleter -Native -CommandName store -ScriptBlock {
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
          '--help', '--version'
          break
        }
        'addons', 'browse-apps', 'browse-games', 'extension', 'protocol', 'publisher', 'search', 'show', 'similar', 'install', 'installed', 'update', 'updates', 'app-categories', 'game-categories'
        break
      }
      'addons' {
        if ($wordToComplete.StartsWith('-')) {
          if ($prev -ceq '--item-types') {
            'durable', 'consumable'
            break
          }
          '--item-types', '--market', '--language', '--help'
          break
        }
        break
      }
      'browse-apps' {
        if ($wordToComplete.StartsWith('-')) {
          '--category', '--subcategory', '--page', '--only-sale', '--market', '--language', '--help'
          break
        }
        'top-free', 'top-paid', 'new-and-trending', 'most-popular', 'top-grossing'
        break
      }
      'browse-games' {
        if ($wordToComplete.StartsWith('-')) {
          if ($prev -ceq '--number-of-players') {
            'all', 'single-player', 'online-multiplayer', 'local-multiplayer', 'online-coop', 'local-coop'
            break
          }
          '--category', '--page', '--only-sale', '--only-game-pass', '--number-of-players', '--market', '--language', '--help'
          break
        }
        'top-free', 'top-paid', 'top-grossing'
        break
      }
      'extension' {
        if ($wordToComplete.StartsWith('-')) {
          '--market', '--language', '--help'
          break
        }
        break
      }
      'protocol' {
        if ($wordToComplete.StartsWith('-')) {
          '--market', '--language', '--help'
          break
        }
        'ms-settings', 'mailto'
        break
      }
      'publisher' {
        if ($wordToComplete.StartsWith('-')) {
          '--market', '--language', '--help'
          break
        }
        break
      }
      'search' {
        if ($wordToComplete.StartsWith('-')) {
          if ($prev -ceq '--type') {
            'all', 'apps', 'games'
            break
          }
          '--market', '--language', '--type', '--help'
          break
        }
        break
      }
      'show' {
        if ($wordToComplete.StartsWith('-')) {
          '--market', '--language', '--type', '--help'
          break
        }
        break
      }
      'similar' {
        if ($wordToComplete.StartsWith('-')) {
          '--category', '--market', '--language', '--help'
          break
        }
        break
      }
      'installed' {
        if ($wordToComplete.StartsWith('-')) {
          if ($prev -ceq '--sort') {
            'name', 'publisher', 'date'
            break
          }
          '--filter', '--sort', '--reverse', '--help'
          break
        }
        break
      }
      'update' {
        if ($wordToComplete.StartsWith('-')) {
          '--apply', '--help'
          break
        }
        break
      }
      'updates' {
        if ($wordToComplete.StartsWith('-')) {
          if ($prev -ceq '--sort') {
            'name', 'publisher', 'date'
            break
          }
          '--filter', '--sort', '--reverse', '--apply', '--help'
          break
        }
        break
      }
    }).Where{ $_ -like "$wordToComplete*" }
}
