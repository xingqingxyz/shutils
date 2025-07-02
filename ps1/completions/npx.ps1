Register-ArgumentCompleter -Native -CommandName npx, pnpx, bunx -ScriptBlock {
  param([string]$wordToComplete, [System.Management.Automation.Language.CommandAst]$commandAst, [int]$cursorPosition)
  if ($commandAst.CommandElements.Count -eq 1 -or
    ($commandAst.CommandElements.Count -eq 2 -and
    $cursorPosition -le $commandAst.CommandElements[1].Extent.EndOffset)) {
    return (Get-ChildItem -LiteralPath node_modules/.bin -ea Ignore | Where-Object BaseName -Like $wordToComplete* | Select-Object -Unique).BaseName
  }
  $astList = $commandAst.CommandElements | Select-Object -Skip 1
  $commandName = Split-Path -LeafBase $astList[0].Value
  $cursorPosition -= $astList[0].Extent.StartOffset
  $tuple = [System.Management.Automation.CommandCompletion]::MapStringInputToParsedInput("$astList", $cursorPosition)
  $commandAst = $tuple.Item1.EndBlock.Statements[0].PipelineElements[0]
  & (Get-ArgumentCompleter $commandName) $wordToComplete $commandAst $cursorPosition
}
