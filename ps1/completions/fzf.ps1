Register-ArgumentCompleter -Native -CommandName fzf -ScriptBlock {
  param([string]$wordToComplete, [System.Management.Automation.Language.CommandAst]$commandAst, [int]$cursorPosition)
  $cursorPosition -= $wordToComplete.Length
  foreach ($i in $commandAst.CommandElements) {
    if ($i.Extent.StartOffset -ge $cursorPosition) {
      break
    }
    $prev = $i
  }
  $prev = $prev.ToString()

  $wordToComplete = $wordToComplete.TrimEnd("'")

  @(switch ($prev) {
      '--scheme' { @('default', 'path', 'history'); break }
      '--tiebreak' { @('length', 'chunk', 'begin', 'end', 'index'); break }
      '--tmux' {
        $options = $wordToComplete.TrimStart("'").Split(',')
        if ($options.Length -eq 1) {
          @('left', 'right', 'down', 'up').ForEach{ "'$_'" }
        }
        else {
          @(20, 25, 30, 40, 50, 60, 70, 75, 80, 90, 100).ForEach{ "'$(@(($options | Select-Object -SkipLast 1); "$_%") -join ',')'" }
        }
        break
      }
      '--layout' { @('default', 'reverse', 'reverse-list'); break }
      '--border' { @('rounded', 'sharp', 'bold', 'block', 'thinblock', 'double', 'horizontal', 'vertical', 'top', 'bottom', 'left', 'right', 'none'); break }
      '--info' { @('default', 'right', 'hidden', 'inline', 'inline-right'); break }
      '--color' { @('dark', 'light', '16', 'bw'); break }
      '--preview-window' {
        $options = $wordToComplete.TrimStart("'").Split(',')
        @(
          @('up', 'down', 'left', 'right')
          @('border-block', 'border-bold', 'border-bottom', 'border-double', 'border-horizontal', 'border-left', 'border-none', 'border-right', 'border-rounded', 'border-sharp', 'border-thinblock', 'border-top', 'border-vertical', 'cycle', 'default', 'follow', 'hidden', 'info', 'nocycle', 'nofollow', 'nohidden', 'noinfo', 'nowrap', 'wrap')
          @(20, 25, 30, 40, 50, 60, 70, 75, 80, 90, 100).ForEach{ "$_%" }
        ).ForEach{ "'$(@(($options | Select-Object -SkipLast 1); $_) -join ',')'" }
        break
      }
      '--with-shell' { @('bash -c', 'pwsh -nop -c', 'zsh -c', 'fish -c', 'cmd /d /c', 'powershell -nop -c').ForEach{ "'$_'" }; break }
      '--walker' {
        $options = $wordToComplete.TrimStart("'").Split(',')
        @('file', 'dir', 'follow', 'hidden').ForEach{ "'$(@(($options | Select-Object -SkipLast 1); $_) -join ',')'" }
        break
      }
      Default {
        if ($wordToComplete.StartsWith('-')) {
          @('-x', '--extended', '-e', '--exact', '-i', '--ignore-case', '--scheme', '--literal', '-n', '--nth', '--with-nth', '-d', '--delimiter', '--track', '--tac', '--disabled', '--tiebreak', '-m', '--multi', '--no-mouse', '--no-sort', '--bind', '--cycle', '--keep-right', '--scroll-off', '--no-hscroll', '--hscroll-off', '--filepath-word', '--jump-labels', '--height', '--min-height', '--layout', '--border', '--border-label', '--border-label-pos', '--margin', '--padding', '--info', '--separator', '--no-separator', '--scrollbar', '--no-scrollbar', '--prompt', '--pointer', '--marker', '--header', '--header-lines', '--header-first', '--ellipsis', '--ansi', '--tabstop', '--color', '--highlight-line', '--no-bold', '--history', '--history-size', '--preview', '--preview-window', '--preview-label', '--preview-label-pos', '-q', '--query', '-1', '--select-1', '-0', '--exit-0', '-f', '--filter', '--print-query', '--expect', '--read0', '--print0', '--sync', '--with-shell', '--listen', '--walker', '--walker-root', '--walker-skip', '--tmux', '--bash', '--zsh', '--fish', '--version', '--help', '--man')
        }
        break
      }
    }).Where{ $_ -like "$wordToComplete*" }
}
