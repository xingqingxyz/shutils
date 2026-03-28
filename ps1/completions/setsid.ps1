using namespace System.Management.Automation.Language

Register-ArgumentCompleter -Native -CommandName setsid -ScriptBlock {
  param ([string]$wordToComplete, [CommandAst]$commandAst, [int]$cursorPosition)
  for ($i = 1; $i -lt $commandAst.CommandElements.Count; $i++) {
    if (!$commandAst.CommandElements[$i].ToString().StartsWith('-')) {
      break
    }
  }
  switch ($commandAst.CommandElements.Count - $i) {
    0 {
      if ($wordToComplete.StartsWith('-')) {
        @('-c', '--ctty', '-f', '--fork', '-w', '--wait', '-h', '--help', '-V', '--version').Where{ $_ -like "$wordToComplete*" }
      }
      break
    }
    1 { [System.Management.Automation.CompletionCompleters]::CompleteCommand($wordToComplete); break }
    default {
      $astList = $commandAst.CommandElements | Select-Object -Skip $i
      $commandName = Split-Path -LeafBase $astList[0].Value
      $cursorPosition -= $astList[0].Extent.StartOffset
      $commandAst = [Parser]::ParseInput("$astList", [ref]$null, [ref]$null).EndBlock.Statements[0].PipelineElements[0]
      & (Get-ArgumentCompleter $commandName) $wordToComplete $commandAst $cursorPosition
      break
    }
  }
}
