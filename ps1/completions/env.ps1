using namespace System.Management.Automation.Language

Register-ArgumentCompleter -Native -CommandName env -ScriptBlock {
  param ([string]$wordToComplete, [CommandAst]$commandAst, [int]$cursorPosition)
  $shouldPassive = $false
  for ($i = 0; $i -lt $commandAst.CommandElements.Count; $i++) {
    $el = $commandAst.CommandElements[$i]
    if ($el.Extent.StartOffset -eq 0) {
      continue
    }
    if ($el.Extent.StartOffset -le $cursorPosition -and $cursorPosition -le $el.Extent.EndOffset) {
      break
    }
    if ($el -is [StringConstantExpressionAst]) {
      [string]$text = $el.Value
      if (!$text.StartsWith('-') -and $text -cnotmatch '^\w+=') {
        $shouldPassive = $true
        break
      }
    }
  }
  if ($shouldPassive) {
    $astList = $commandAst.CommandElements | Select-Object -Skip $i
    $commandName = Split-Path -LeafBase $astList[0].Value
    $cursorPosition -= $astList[0].Extent.StartOffset
    $commandAst = [Parser]::ParseInput("$astList", [ref]$null, [ref]$null).EndBlock.Statements[0].PipelineElements[0]
    return & (Get-ArgumentCompleter $commandName) $wordToComplete $commandAst $cursorPosition
  }
  if (!$IsWindows -and $wordToComplete.StartsWith('-')) {
    return @('-a', '--argv0=', '-i', '--ignore-environment', '-0', '--null', '-u', '--unset=', '-C', '--chdir=', '-S', '--split-string=', '--block-signal', '--block-signal=', '--default-signal', '--default-signal=', '--ignore-signal', '--ignore-signal=', '--list-signal-handling', '-v', '--debug', '--help', '--version').Where{ $_ -like "$wordToComplete*" }
  }
  if ($wordToComplete -cmatch '^\w+=?') {
    Get-Item env:$($wordToComplete.TrimEnd('='))* -ea Ignore | ForEach-Object { [System.Management.Automation.CompletionResult]::new($_.Name + '=') }
  }
  @([System.Management.Automation.CompletionCompleters]::CompleteCommand($wordToComplete)) ??
  @([System.Management.Automation.CompletionCompleters]::CompleteFilename($wordToComplete))
}
