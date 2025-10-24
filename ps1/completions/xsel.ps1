Register-ArgumentCompleter -Native -CommandName xsel -ScriptBlock {
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
      '-a', '--append', '-f', '--follow', '-z', '--zeroflush', '-i', '--input', '-o', '--output', '-c', '--clear', '-d', '--delete', '-p', '--primary', '-s', '--secondary', '-b', '--clipboard', '-k', '--keep', '-x', '--exchange', '--display', '-m', '--name', '-t', '--selectionTimeout', '--trim', '-l', '--logfile', '-n', '--nodetach', '-h', '--help', '-v', '--verbose', '--version'
    }
    else {
      switch ($prev) {
        --display { 'localhost:0'; break }
        --selectionTimeout { '0', '300', '1000'; break }
      }
    }).Where{ $_ -like "$wordToComplete*" }
}
