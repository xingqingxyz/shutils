using namespace System.Management.Automation.Language

Register-ArgumentCompleter -Native -CommandName setsid -ScriptBlock {
  param ([string]$wordToComplete, [CommandAst]$commandAst, [int]$cursorPosition)
  for ($i = 1; $i -lt $commandAst.CommandElements.Count; $i++) {
    if (!$commandAst.CommandElements[$i].ToString().StartsWith('-')) {
      break
    }
  }
  switch ($commandAst.CommandElements.Count - $i) {
    { $_ -le 1 } {
      if ($wordToComplete.StartsWith('-')) {
        @('-c', '--ctty', '-f', '--fork', '-w', '--wait', '-h', '--help', '-V', '--version').Where{ $_ -like "$wordToComplete*" }
        break
      }
      (Get-Command $wordToComplete* -Type Application).Name | Sort-Object -Unique
      break
    }
    default {
      [string]$line = $commandAst
      $commandName = [System.IO.Path]::GetFileNameWithoutExtension($commandAst.CommandElements[$i])
      $i = $commandAst.CommandElements[$i].Extent.StartOffset
      $line = $line.Substring($i)
      $cursorPosition -= $i
      $commandAst = [Parser]::ParseInput($line, [ref]$null, [ref]$null).EndBlock.Statements[0].PipelineElements[0]
      & (Get-ArgumentCompleter $commandName) $wordToComplete $commandAst $cursorPosition
      break
    }
  }
}
