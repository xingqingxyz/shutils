Register-ArgumentCompleter -Native -CommandName pwsh -ScriptBlock {
  param([string]$wordToComplete, [System.Management.Automation.Language.CommandAst]$commandAst, [int]$cursorPosition)
  $cursorPosition -= $wordToComplete.Length
  foreach ($key in $commandAst.CommandElements) {
    if ($key.Extent.StartOffset -eq $cursorPosition) {
      break
    }
    $prev = $key
  }
  @(switch ($prev.ToString()) {
      { $_ -eq '-w' -or $_ -eq '-WindowStyle' } { @('Normal', 'Minimized', 'Maximized' , 'Hidden') }
      { $_ -eq '-ex' -or $_ -eq '-ep' -or $_ -eq '-ExecutionPolicy' } { @('AllSigned', 'Bypass', 'Default', 'RemoteSigned', 'Restricted', 'Undefined', 'Unrestricted') }
      { @('-inp', '-if', '-InputFormat', '-o', '-of', '-OutputFormat').Contains($_) } { @('Text', 'XML') }
      Default { 
        @('-File', '-f', '-Command', '-c', '-CommandWithArgs', '-cwa', '-ConfigurationName', '-config', '-ConfigurationFile', '-CustomPipeName', '-EncodedCommand', '-e', '-ec', '-ExecutionPolicy', '-ex', '-ep', '-InputFormat', '-inp', '-if', '-Interactive', '-i', '-Login', '-l', '-MTA', '-NoExit', '-noe', '-NoLogo', '-nol', '-NonInteractive', '-noni', '-NoProfile', '-nop', '-NoProfileLoadTime', '-OutputFormat', '-o', '-of', '-SettingsFile', '-settings', '-SSHServerMode', '-sshs', '-STA', '-Version', '-v', '-WindowStyle', '-w', '-WorkingDirectory', '-wd', '-Help', '-?', '/?')
      }
    }) | Where-Object { $_ -like "$wordToComplete*" }
}
