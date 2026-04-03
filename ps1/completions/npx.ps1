Register-ArgumentCompleter -Native -CommandName npx, pnpx, bunx -ScriptBlock {
  param ([string]$wordToComplete, [System.Management.Automation.Language.CommandAst]$commandAst, [int]$cursorPosition)
  if ($commandAst.CommandElements.Count -eq 1 -or
    ($commandAst.CommandElements.Count -eq 2 -and
    $cursorPosition -le $commandAst.CommandElements[1].Extent.EndOffset)) {
    return (Split-Path -Resolve -LeafBase node_modules/.bin/* -ea Ignore | Sort-Object -Unique | Where-Object { $_ -like "$wordToComplete*" }) ?? [System.Management.Automation.CompletionCompleters]::CompleteCommand($wordToComplete, '', [System.Management.Automation.CommandTypes]::Application)
  }
  [string]$line = $commandAst
  $commandName = [System.IO.Path]::GetFileNameWithoutExtension($commandAst.CommandElements[1])
  $i = $commandAst.CommandElements[1].Extent.StartOffset
  $line = $line.Substring($i)
  $cursorPosition -= $i
  $commandAst = [System.Management.Automation.Language.Parser]::ParseInput($line, [ref]$null, [ref]$null).EndBlock.Statements[0].PipelineElements[0]
  & (Get-ArgumentCompleter $commandName) $wordToComplete $commandAst $cursorPosition
}
