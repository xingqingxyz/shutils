Register-ArgumentCompleter -Native -CommandName chafa -ScriptBlock {
  param([string]$wordToComplete, [System.Management.Automation.Language.CommandAst]$commandAst, [int]$cursorPosition)
  $cursorPosition -= $wordToComplete.Length
  foreach ($i in $commandAst.CommandElements) {
    if ($i.Extent.StartOffset -eq $cursorPosition) {
      break
    }
    $prev = $i
  }
  $prev = $prev.ToString()

  @(switch ($prev) {
      '--passthrough' {
        @('auto', 'none', 'screen', 'tmux')
      }
      '--align' {
        @('top', 'bottom', 'left', 'right')
      }
      '--exact-size' {
        @('auto', 'on', 'off')
      }
      '--color-extractor' {
        @('average', 'median')
      }
      '--color-space' {
        @('rgb', 'din99d')
      }
      '--dither' {
        @('none', 'ordered', 'diffusion')
      }
      { $_ -eq '-f' -or $_ -eq '--format' } {
        @('conhost', 'iterm', 'kitty', 'sixels', 'symbols')
      }
      { $_ -eq '--symbols' -or $_ -eq '--fill' } {
        @('all', 'ascii', 'braille', 'extra', 'imported', 'narrow', 'solid', 'ugly', 'alnum', 'bad', 'diagonal', 'geometric', 'inverted', 'none', 'space', 'vhalf', 'alpha', 'block', 'digit', 'half', 'latin', 'quad', 'stipple', 'wedge', 'ambiguous', 'border', 'dot', 'hhalf', 'legacy', 'sextant', 'technical', 'wide')
      }
      { @('--animate', '-p', '--preprocess', '--polite', '--relative').Contains($_) } {
        @('on', 'off')
      }
      Default {
        @('-h', '--help', '--version', '-v', '--verbose', '-f', '--format', '-O', '--optimize', '--relative', '--passthrough', '--polite', '--align', '--clear', '--exact-size', '--fit-width', '--font-ratio', '--margin-bottom', '--margin-right', '--scale', '-s', '--size', '--stretch', '--view-size', '--animate', '-d', '--duration', '--speed', '--watch', '--bg', '-c', '--colors', '--color-extractor', '--color-space', '--dither', '--dither-grain', '--dither-intensity', '--fg', '--invert', '-p', '--preprocess', '-t', '--threshold', '--threads', '-w', '--work', '--fg-only', '--fill', '--glyph-file', '--symbols')
      }
    }) | Where-Object { $_ -like "$wordToComplete*" }
}
