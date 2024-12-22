Register-ArgumentCompleter -Native -CommandName tokei -ScriptBlock {
  param([string]$wordToComplete, [System.Management.Automation.Language.CommandAst]$commandAst, [int]$cursorPosition)
  $cursorPosition -= $wordToComplete.Length
  foreach ($i in $commandAst.CommandElements) {
    if ($i.Extent.StartOffset -eq $cursorPosition) {
      break
    }
    $prev = $i
  }
  $prev = $prev.ToString()

  switch ($prev) {
    Default {
      if ($wordToComplete.StartsWith('-')) {
        @('-C', '--compact', '-f', '--files', '-h', '--help', '--hidden', '-l', '--languages', '--no-ignore', '--no-ignore-dot', '--no-ignore-dot', '--no-ignore-parent', '--no-ignore-vcs', '-V', '--version', '-v', '--verbose', '-c', '--columns', '-e', '--exclude', '-i', '--input', '-n', '--num-format', '-o', '--output', '-s', '--sort', '-t', '--type') | Where-Object { $_ -like "$wordToComplete*" }
      }
    }
  }
}
