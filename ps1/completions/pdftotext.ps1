Register-ArgumentCompleter -Native -CommandName pdftotext -ScriptBlock {
  param ([string]$wordToComplete, [System.Management.Automation.Language.CommandAst]$commandAst, [int]$cursorPosition)
  $cursorPosition -= $wordToComplete.Length
  foreach ($i in $commandAst.CommandElements) {
    if ($i.Extent.StartOffset -ge $cursorPosition) {
      break
    }
    $prev = $i
  }
  $prev = $prev -is [System.Management.Automation.Language.StringConstantExpressionAst] ? $prev.Value : $prev.ToString()

  @(switch ($prev) {
      '-enc' { pdftotext -listenc; break }
      '-eol' { @('unix', 'dos', 'mac'); break }
      default { @('-f', '-l', '-r', '-x', '-y', '-W', '-H', '-layout', '-fixed', '-raw', '-nodiag', '-htmlmeta', '-tsv', '-enc', '-listenc', '-eol', '-nopgbrk', '-bbox', '-bbox-layout', '-cropbox', '-colspacing', '-opw', '-upw', '-q', '-v', '-h', '-help', '--help') }
    }).Where{ $_ -like "$wordToComplete*" }
}
