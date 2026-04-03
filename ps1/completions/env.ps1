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
    [string]$line = $commandAst
    $commandName = [System.IO.Path]::GetFileNameWithoutExtension($commandAst.CommandElements[$i])
    $i = $commandAst.CommandElements[$i].Extent.StartOffset
    $line = $line.Substring($i)
    $cursorPosition -= $i
    $commandAst = [Parser]::ParseInput($line, [ref]$null, [ref]$null).EndBlock.Statements[0].PipelineElements[0]
    return & (Get-ArgumentCompleter $commandName) $wordToComplete $commandAst $cursorPosition
  }
  if ($wordToComplete.StartsWith('-')) {
    return @('-a', '--argv0=', '-i', '--ignore-environment', '-0', '--null', '-u', '--unset=', '-C', '--chdir=', '-S', '--split-string=', '--block-signal', '--block-signal=', '--default-signal', '--default-signal=', '--ignore-signal', '--ignore-signal=', '--list-signal-handling', '-v', '--debug', '--help', '--version').Where{ $_ -like "$wordToComplete*" }
  }
  if ($wordToComplete -cmatch '^\w+=?') {
    Get-Item Env:$($wordToComplete.TrimEnd('='))* -ea Ignore | ForEach-Object { [System.Management.Automation.CompletionResult]::new($_.Name + '=') }
  }
  @([System.Management.Automation.CompletionCompleters]::CompleteCommand($wordToComplete)) ??
  @([System.Management.Automation.CompletionCompleters]::CompleteFilename($wordToComplete))
}
