Register-ArgumentCompleter -Native -CommandName powershell -ScriptBlock {
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
    '-ex' { '-ExecutionPolicy'; break }
    '-ep' { '-ExecutionPolicy'; break }
    '-OutputFormat' { '-InputFormat'; break }
    Default { $prev }
  }

  @(switch ($prev) {
      '-ExecutionPolicy' { @('AllSigned', 'Bypass', 'Default', 'RemoteSigned', 'Restricted', 'Undefined', 'Unrestricted'); break }
      '-InputFormat' { @('Text', 'XML'); break }
      Default {
        @('-PSConsoleFile', '-Version', '-NoLogo', '-NoExit', '-Sta', '-Mta', '-NoProfile', '-NonInteractive', '-InputFormat', '-OutputFormat', '-WindowStyle', '-EncodedCommand', '-ConfigurationName', '-File', '-ExecutionPolicy', '-Command', '-Help', '-?', '/?')
      }
    }).Where{ $_ -like "$wordToComplete*" }
}
