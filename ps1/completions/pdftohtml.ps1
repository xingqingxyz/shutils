Register-ArgumentCompleter -Native -CommandName pdftohtml -ScriptBlock {
  param([string]$wordToComplete, [System.Management.Automation.Language.CommandAst]$commandAst, [int]$cursorPosition)
  $cursorPosition -= $wordToComplete.Length
  foreach ($i in $commandAst.CommandElements) {
    if ($i.Extent.StartOffset -ge $cursorPosition) {
      break
    }
    $prev = $i
  }
  $prev = $prev.ToString()

  @(switch ($prev) {
      '-enc' { 'ASCII7', 'Latin1', 'Symbol', 'UTF-16', 'UTF-8' }
      '-fmt' { 'png', 'jpg' }
      Default { @('-f', '-l', '-q', '-h', '-help', '--help', '-p', '-c', '-s', '-i', '-noframes', '-stdout', '-zoom', '-xml', '-noroundcoord', '-hidden', '-nomerge', '-enc', '-fmt', '-v', '-opw', '-upw', '-nodrm', '-wbt', '-fontfullname') }
    }) | Where-Object { $_ -like "$wordToComplete*" }
}
