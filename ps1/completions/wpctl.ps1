using namespace System.Management.Automation.Language

Register-ArgumentCompleter -Native -CommandName wpctl -ScriptBlock {
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
      '-h', '--help'
    }
    else {
      switch ($command) {
        '' {
          'status', 'get-volume', 'inspect', 'set-default', 'set-volume', 'set-mute', 'set-profile', 'set-route', 'clear-default', 'settings', 'set-log-level'
          break
        }
        'set-mute' {
          '0', '1', 'toggle'
          break
        }
        'set-log-level' {
          '0'
          break
        }
      }
    }).Where{ $_ -like "$wordToComplete*" }
}
