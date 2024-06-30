Register-ArgumentCompleter -Native -CommandName pdftotext -ScriptBlock {
  param([string]$wordToComplete, [System.Management.Automation.Language.CommandAst]$commandAst, [int]$cursorPosition)
  $cursorPosition -= $wordToComplete.Length
  foreach ($key in $commandAst.CommandElements) {
    if ($key.Extent.StartOffset -eq $cursorPosition) {
      break
    }
    $prev = $key
  }
  @(switch ($prev.ToString()) {
      '-enc' { pdftotext -listenc }
      '-eol' { @('unix', 'dos', 'mac') }
      Default { @('-f', '-l', '-r', '-x', '-y', '-W', '-H', '-layout', '-fixed', '-raw', '-nodiag', '-htmlmeta', '-tsv', '-enc', '-listenc', '-eol', '-nopgbrk', '-bbox', '-bbox-layout', '-cropbox', '-colspacing', '-opw', '-upw', '-q', '-v', '-h', '-help', '--help') }
    }) | Where-Object { $_ -like "$wordToComplete*" }
}
