using namespace System.Management.Automation.Language

Register-ArgumentCompleter -Native -CommandName playerctl -ScriptBlock {
  param ([string]$wordToComplete, [System.Management.Automation.Language.CommandAst]$commandAst, [int]$cursorPosition)
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
  @(if ($wordToComplete.StartsWith('-')) {
      '-h', '--help', '-p', '--player=', '-a', '--all-players', '-i', '--ignore-player=', '-f', '--format', '-F', '--follow', '-l', '--list-all', '-s', '--no-messages', '-v', '--version'
    }
    else {
      switch ($command) {
        '' {
          'play', 'pause', 'play-pause', 'stop', 'next', 'previous', 'position', 'volume', 'status', 'metadata', 'open', 'loop', 'shuffle'
          break
        }
        loop {
          'None', 'Track', 'Playlist'
          break
        }
        shuffle {
          'On', 'Off', 'Toggle'
          break
        }
      }
    }).Where{ $_ -like "$wordToComplete*" }
}
