Register-ArgumentCompleter -Native -CommandName sudo -ScriptBlock {
  param([string]$wordToComplete, [System.Management.Automation.Language.CommandAst]$commandAst, [int]$cursorPosition)
  if ($commandAst.CommandElements.Count -le 2 -and
    $cursorPosition -le $commandAst.CommandElements[-1].Extent.EndOffset) {
    return [System.Management.Automation.CompletionCompleters]::CompleteCommand($wordToComplete)
  }
  $astList = $commandAst.CommandElements | Select-Object -Skip 1
  $commandName = Split-Path -LeafBase $astList[0].Value
  if (!$_completionFuncMap.Contains($commandName)) {
    try {
      . ${env:SHUTILS_ROOT}/ps1/completions/$commandName.ps1
      if (!$_completionFuncMap.Contains($commandName)) {
        throw 'not found'
      }
    }
    catch {
      return Write-Debug "no completions found for $commandName in ${env:SHUTILS_ROOT}/ps1/completions"
    }
  }
  $cursorPosition -= $astList[0].Extent.StartOffset
  $tuple = [System.Management.Automation.CommandCompletion]::MapStringInputToParsedInput("$astList", $cursorPosition)
  $commandAst = $tuple.Item1.EndBlock.Statements[0].PipelineElements[0]
  & $_completionFuncMap.$commandName $wordToComplete $commandAst $cursorPosition
}
