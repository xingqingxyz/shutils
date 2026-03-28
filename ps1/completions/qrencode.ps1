Register-ArgumentCompleter -Native -CommandName qrencode -ScriptBlock {
  param ([string]$wordToComplete, [System.Management.Automation.Language.CommandAst]$commandAst, [int]$cursorPosition)
  $cursorPosition -= $wordToComplete.Length
  foreach ($i in $commandAst.CommandElements) {
    if ($i.Extent.StartOffset -ge $cursorPosition) {
      break
    }
    $prev = $i
  }
  $prev = $prev -is [System.Management.Automation.Language.StringConstantExpressionAst] ? $prev.Value : $prev.ToString()
  @(if ($wordToComplete.StartsWith('-')) {
      '-h', '--help', '-o', '-r', '-s', '-l', '-v', '-m', '-d', '-t', '-S', '-k', '-c', '-i', '-8', '-M', '-V'
    }
    else {
      switch ($prev) {
        '-l' { 'L', 'M', 'Q', 'H'; break }
        '-t' { 'PNG', 'PNG32', 'EPS', 'SVG', 'XPM', 'ANSI', 'ANSI256', 'ASCII', 'ASCIIi', 'UTF8', 'UTF8i', 'ANSIUTF8', 'ANSIUTF8i', 'ANSI256UTF8'; break }
      }
    }).Where{ $_ -like "$wordToComplete*" }
}
