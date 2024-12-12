Register-ArgumentCompleter -Native -CommandName powershell -ScriptBlock {
  param([string]$wordToComplete, [System.Management.Automation.Language.CommandAst]$commandAst, [int]$cursorPosition)
  $cursorPosition -= $wordToComplete.Length
  foreach ($key in $commandAst.CommandElements) {
    if ($key.Extent.StartOffset -eq $cursorPosition) {
      break
    }
    $prev = $key
  }
  @(switch ($prev.ToString()) {
      { $_ -eq '-ex' -or $_ -eq '-ep' -or $_ -eq '-ExecutionPolicy' } { @('AllSigned', 'Bypass', 'Default', 'RemoteSigned', 'Restricted', 'Undefined', 'Unrestricted') }
      { $_ -eq '-InputFormat' -or $_ -eq '-OutputFormat' } { @('Text', 'XML') }
      Default { 
        @('-PSConsoleFile', '-Version', '-NoLogo', '-NoExit', '-Sta', '-Mta', '-NoProfile', '-NonInteractive', '-InputFormat', '-OutputFormat', '-WindowStyle', '-EncodedCommand', '-ConfigurationName', '-File', '-ExecutionPolicy', '-Command', '-Help', '-?', '/?')
      }
    }) | Where-Object { $_ -like "$wordToComplete*" }
}
