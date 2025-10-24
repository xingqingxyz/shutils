Register-ArgumentCompleter -Native -CommandName xclip -ScriptBlock {
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
      '-i', '-in', '-filter', '-o', '-out', '-selection', '-target', '-silent', '-quiet', '-verbose', '-debug', '-sensitive', '-l', '-loops', '-wait', '-noutf8', '-rmlastnl', '-d', '-display', '-version', '-h', '-help'
    }
    else {
      switch ($prev) {
        -display { 'localhost:0'; break }
        -loops { '3', '10'; break }
        -selection { 'clipboard', 'secondary', 'buffer-cut'; break }
        -target { 'image/jpeg', 'UTF8_STRING'; break }
        -wait { '30000', '60000'; break }
      }
    }).Where{ $_ -like "$wordToComplete*" }
}
