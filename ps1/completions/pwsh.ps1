Register-ArgumentCompleter -Native -CommandName pwsh -ScriptBlock {
  param ([string]$wordToComplete, [System.Management.Automation.Language.CommandAst]$commandAst, [int]$cursorPosition)
  $cursorPosition -= $wordToComplete.Length
  foreach ($i in $commandAst.CommandElements) {
    if ($i.Extent.StartOffset -ge $cursorPosition) {
      break
    }
    $prev = $i
  }
  $prev = $prev -is [System.Management.Automation.Language.StringConstantExpressionAst] ? $prev.Value : $prev.ToString()
  $prev = switch ($prev) {
    '-w' { '-WindowStyle'; break }
    '-ex' { '-ExecutionPolicy'; break }
    '-ep' { '-ExecutionPolicy'; break }
    '-inp' { '-InputFormat'; break }
    '-if' { '-InputFormat'; break }
    '-o' { '-InputFormat'; break }
    '-of' { '-InputFormat'; break }
    '-OutputFormat' { '-InputFormat'; break }
    Default { $prev }
  }

  @(switch ($prev) {
      '-WindowStyle' { @('Normal', 'Minimized', 'Maximized' , 'Hidden'); break }
      '-ExecutionPolicy' { @('AllSigned', 'Bypass', 'Default', 'RemoteSigned', 'Restricted', 'Undefined', 'Unrestricted'); break }
      '-InputFormat' { @('Text', 'XML'); break }
      Default {
        @('-File', '-f', '-Command', '-c', '-CommandWithArgs', '-cwa', '-ConfigurationName', '-config', '-ConfigurationFile', '-CustomPipeName', '-EncodedCommand', '-e', '-ec', '-ExecutionPolicy', '-ex', '-ep', '-InputFormat', '-inp', '-if', '-Interactive', '-i', '-Login', '-l', '-MTA', '-NoExit', '-noe', '-NoLogo', '-nol', '-NonInteractive', '-noni', '-NoProfile', '-nop', '-NoProfileLoadTime', '-OutputFormat', '-o', '-of', '-SettingsFile', '-settings', '-SSHServerMode', '-sshs', '-STA', '-Version', '-v', '-WindowStyle', '-w', '-WorkingDirectory', '-wd', '-Help', '-?', '/?')
      }
    }).Where{ $_ -like "$wordToComplete*" }
}
