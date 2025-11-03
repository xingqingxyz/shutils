using namespace System.Management.Automation.Language

Register-ArgumentCompleter -Native -CommandName setsid -ScriptBlock {
  param ([string]$wordToComplete, [CommandAst]$commandAst, [int]$cursorPosition)
  [int]$index = 0
  [bool]$startOptsFiltered = $false
  [string[]]$commands = foreach ($i in $commandAst.CommandElements) {
    $index++
    if ($i.Extent.StartOffset -eq $commandAst.Extent.StartOffset -or $i.Extent.EndOffset -eq $cursorPosition) {
      continue
    }
    if ($i -isnot [StringConstantExpressionAst] -or
      $i.StringConstantType -ne [StringConstantType]::BareWord) {
      break
    }
    if ($i.Value.StartsWith('-')) {
      if ($startOptsFiltered) {
        break
      }
    }
    $index--
    $startOptsFiltered = $true
    $i.Value
  }
  if ($commands) {
    $astList = $commandAst.CommandElements | Select-Object -Skip $index
    $commandName = Split-Path -LeafBase $astList[0].Value
    $cursorPosition -= $astList[0].Extent.StartOffset
    $commandAst = [Parser]::ParseInput("$astList", [ref]$null, [ref]$null).EndBlock.Statements[0].PipelineElements[0]
    return & (Get-ArgumentCompleter $commandName) $wordToComplete $commandAst $cursorPosition
  }
  if ($wordToComplete.StartsWith('-')) {
    '-c', '--ctty', '-f', '--fork', '-w', '--wait', '-h', '--help', '-V', '--version' | Where-Object { $_ -like "$wordToComplete*" }
  }
  else {
    [System.Management.Automation.CompletionCompleters]::CompleteCommand($wordToComplete)
  }
}
