Register-ArgumentCompleter -Native -CommandName chafa -ScriptBlock {
  param ([string]$wordToComplete, [System.Management.Automation.Language.CommandAst]$commandAst, [int]$cursorPosition)
  $cursorPosition -= $wordToComplete.Length
  foreach ($i in $commandAst.CommandElements) {
    if ($i.Extent.StartOffset -ge $cursorPosition) {
      break
    }
    $prev = $i
  }
  $prev = $prev -is [System.Management.Automation.Language.StringConstantExpressionAst] ? $prev.Value : $prev.ToString()
  $prev = switch ($prev) {
    '-f' { '--format'; break }
    '-p' { '--preprocess'; break }
    Default { $prev }
  }

  @(switch ($prev) {
      '--passthrough' {
        @('auto', 'none', 'screen', 'tmux')
        break
      }
      '--align' {
        @('top', 'bottom', 'left', 'right')
        break
      }
      '--exact-size' {
        @('auto', 'on', 'off')
        break
      }
      '--color-extractor' {
        @('average', 'median')
        break
      }
      '--color-space' {
        @('rgb', 'din99d')
        break
      }
      '--dither' {
        @('none', 'ordered', 'diffusion')
        break
      }
      '--format' {
        @('conhost', 'iterm', 'kitty', 'sixels', 'symbols')
        break
      }
      { $_ -eq '--symbols' -or $_ -eq '--fill' } {
        @('all', 'ascii', 'braille', 'extra', 'imported', 'narrow', 'solid', 'ugly', 'alnum', 'bad', 'diagonal', 'geometric', 'inverted', 'none', 'space', 'vhalf', 'alpha', 'block', 'digit', 'half', 'latin', 'quad', 'stipple', 'wedge', 'ambiguous', 'border', 'dot', 'hhalf', 'legacy', 'sextant', 'technical', 'wide')
        break
      }
      { @('--animate', '--preprocess', '--polite', '--relative').Contains($_) } {
        @('on', 'off')
        break
      }
      Default {
        @('-h', '--help', '--version', '-v', '--verbose', '-f', '--format', '-O', '--optimize', '--relative', '--passthrough', '--polite', '--align', '--clear', '--exact-size', '--fit-width', '--font-ratio', '--margin-bottom', '--margin-right', '--scale', '-s', '--size', '--stretch', '--view-size', '--animate', '-d', '--duration', '--speed', '--watch', '--bg', '-c', '--colors', '--color-extractor', '--color-space', '--dither', '--dither-grain', '--dither-intensity', '--fg', '--invert', '-p', '--preprocess', '-t', '--threshold', '--threads', '-w', '--work', '--fg-only', '--fill', '--glyph-file', '--symbols')
        break
      }
    }).Where{ $_ -like "$wordToComplete*" }
}
