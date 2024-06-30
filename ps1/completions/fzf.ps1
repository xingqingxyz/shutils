Register-ArgumentCompleter -Native -CommandName fzf -ScriptBlock {
  param([string]$wordToComplete, [System.Management.Automation.Language.CommandAst]$commandAst, [int]$cursorPosition)
  $cursorPosition -= $wordToComplete.Length
  foreach ($key in $commandAst.CommandElements) {
    if ($key.Extent.StartOffset -eq $cursorPosition) {
      break
    }
    $prev = $key
  }
  @(switch ($prev) {
      '--scheme' {

        @('default', 'path', 'history')
      }
      '--tiebreak' {
        @('length', 'chunk', 'begin', 'end', 'index')
      }
      '--layout' {
        @('default', 'reverse', 'reverse-list')
      }
      '--border' {
        @('rounded', 'sharp', 'bold', 'block', 'thinblock', 'double', 'horizontal', 'vertical', 'top', 'bottom', 'left', 'right', 'none')
      }
      '--info' {
        @('default', 'right', 'hidden', 'inline', 'inline-right')
      }
      '--color' {
        @('dark', 'light', '16', 'bw')
      }
      '--preview-window' {
        @('up', 'down', 'left', 'right')
      }
      '--walker' {

      }
      Default {
        @('-x', '--extended', '-e', '--exact', '-i', '--ignore-case', '--scheme', '--literal', '-n', '--nth', '--with-nth', '-d', '--delimiter', '--track', '--tac', '--disabled', '--tiebreak', '-m', '--multi', '--no-mouse', '--no-sort', '--bind', '--cycle', '--keep-right', '--scroll-off', '--no-hscroll', '--hscroll-off', '--filepath-word', '--jump-labels', '--height', '--min-height', '--layout', '--border', '--border-label', '--border-label-pos', '--margin', '--padding', '--info', '--separator', '--no-separator', '--scrollbar', '--no-scrollbar', '--prompt', '--pointer', '--marker', '--header', '--header-lines', '--header-first', '--ellipsis', '--ansi', '--tabstop', '--color', '--highlight-line', '--no-bold', '--history', '--history-size', '--preview', '--preview-window', '--preview-label', '--preview-label-pos', '-q', '--query', '-1', '--select-1', '-0', '--exit-0', '-f', '--filter', '--print-query', '--expect', '--read0', '--print0', '--sync', '--with-shell', '--listen', '--version', '--walker', '--walker-root', '--walker-skip', '--bash', '--zsh', '--fish')
      }
    }) | Where-Object { $_ -like "$wordToComplete*" }
}
