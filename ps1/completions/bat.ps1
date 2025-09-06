using namespace System.Management.Automation
using namespace System.Management.Automation.Language

Register-ArgumentCompleter -Native -CommandName bat -ScriptBlock {
  param ([string]$wordToComplete, [CommandAst]$commandAst, [int]$cursorPosition)
  $command = @(foreach ($i in $commandAst.CommandElements) {
      if ($i.Extent.StartOffset -eq 0 -or $i.Extent.EndOffset -eq $cursorPosition) {
        continue
      }
      if ($i -isnot [StringConstantExpressionAst] -or
        $i.StringConstantType -ne [StringConstantType]::BareWord -or
        $i.Value.StartsWith('-')) {
        break
      }
      $i.Value
    }) -join ';'

  $cursorPosition -= $wordToComplete.Length
  foreach ($i in $commandAst.CommandElements) {
    if ($i.Extent.StartOffset -ge $cursorPosition) {
      break
    }
    $prev = $i
  }
  $prev = $prev -is [System.Management.Automation.Language.StringConstantExpressionAst] ? $prev.Value : $prev.ToString()
  $prev = switch ($prev) {
    '-l' { '--language'; break }
    '--theme-light' { '--theme'; break }
    '--theme-dark' { '--theme'; break }
    default { $prev }
  }

  @(switch ($command) {
      '' {
        switch ($prev) {
          '--binary' {
            @('as-text', 'no-printing').ForEach{ [CompletionResult]::new($_) }
            break
          }
          '--color' {
            @('always', 'auto', 'never').ForEach{ [CompletionResult]::new($_) }
            break
          }
          '--completion' {
            @('bash', 'fish', 'ps1', 'zsh').ForEach{ [CompletionResult]::new($_) }
            break
          }
          '--decorations' {
            @('always', 'auto', 'never').ForEach{ [CompletionResult]::new($_) }
            break
          }
          '--language' {
            @('bash', 'zsh', 'fish', 'elvish', 'pwsh', 'ps1', 'sh', 'py', 'python', 'js', 'ts', 'rs', 'go', 'man', 'help', 'awk', 'md', 'ini', 'json', 'jsonc', 'yml', 'xml', 'html', 'cs', 'vb', 'cpp', 'c', 'lua', 'codeql', 'sql', 'rb', 'makefile', 'cmake', 'gql', 'tsx', 'mdx', 'svelte', 'vue', 'angular', 'astro', 'css', 'scss', 'sass', 'stylus', 'htmx', 'rst', 'ipynb').ForEach{ [CompletionResult]::new($_) }
            break
          }
          '--strip-ansi' {
            @('always', 'auto', 'never').ForEach{ [CompletionResult]::new($_) }
            break
          }
          '--style' {
            @('default', 'full', 'auto', 'changes', 'header', 'header-filename', 'header-filesize', 'grid', 'rule', 'ship', 'plain', 'numbers').ForEach{ [CompletionResult]::new($_) }
            break
          }
          '--theme' {
            @(
              bat --list-themes --color=never
              @('auto', 'dark', 'light')
            ).ForEach{ [CompletionResult]::new($_) }
            break
          }
          '--paging' {
            @('always', 'auto', 'never').ForEach{ [CompletionResult]::new($_) }
            break
          }
          '--wrap' {
            @('character', 'auto', 'never').ForEach{ [CompletionResult]::new($_) }
            break
          }
          '--italic-text' {
            @('always', 'never').ForEach{ [CompletionResult]::new($_) }
            break
          }
          default {
            if ($wordToComplete.StartsWith('-')) {
              [CompletionResult]::new('-l', 'l', [CompletionResultType]::ParameterName, 'Set the language for syntax highlighting.')
              [CompletionResult]::new('--language', 'language', [CompletionResultType]::ParameterName, 'Set the language for syntax highlighting.')
              [CompletionResult]::new('-H', 'H', [CompletionResultType]::ParameterName, 'Highlight lines N through M.')
              [CompletionResult]::new('--highlight-line', 'highlight-line', [CompletionResultType]::ParameterName, 'Highlight lines N through M.')
              [CompletionResult]::new('--file-name', 'file-name', [CompletionResultType]::ParameterName, 'Specify the name to display for a file.')
              [CompletionResult]::new('--diff-context', 'diff-context', [CompletionResultType]::ParameterName, 'diff-context')
              [CompletionResult]::new('--tabs', 'tabs', [CompletionResultType]::ParameterName, 'Set the tab width to T spaces.')
              [CompletionResult]::new('--wrap', 'wrap', [CompletionResultType]::ParameterName, 'Specify the text-wrapping mode (*auto*, never, character).')
              [CompletionResult]::new('--terminal-width', 'terminal-width', [CompletionResultType]::ParameterName, 'Explicitly set the width of the terminal instead of determining it automatically. If prefixed with ''+'' or ''-'', the value will be treated as an offset to the actual terminal width. See also: ''--wrap''.')
              [CompletionResult]::new('--color', 'color', [CompletionResultType]::ParameterName, 'When to use colors (*auto*, never, always).')
              [CompletionResult]::new('--italic-text', 'italic-text', [CompletionResultType]::ParameterName, 'Use italics in output (always, *never*)')
              [CompletionResult]::new('--decorations', 'decorations', [CompletionResultType]::ParameterName, 'When to show the decorations (*auto*, never, always).')
              [CompletionResult]::new('--paging', 'paging', [CompletionResultType]::ParameterName, 'Specify when to use the pager, or use `-P` to disable (*auto*, never, always).')
              [CompletionResult]::new('--pager', 'pager', [CompletionResultType]::ParameterName, 'Determine which pager to use.')
              [CompletionResult]::new('-m', 'm', [CompletionResultType]::ParameterName, 'Use the specified syntax for files matching the glob pattern (''*.cpp:C++'').')
              [CompletionResult]::new('--map-syntax', 'map-syntax', [CompletionResultType]::ParameterName, 'Use the specified syntax for files matching the glob pattern (''*.cpp:C++'').')
              [CompletionResult]::new('--theme', 'theme', [CompletionResultType]::ParameterName, 'Set the color theme for syntax highlighting.')
              [CompletionResult]::new('--theme-dark', 'theme', [CompletionResultType]::ParameterName, 'Set the color theme for syntax highlighting for dark backgrounds.')
              [CompletionResult]::new('--theme-light', 'theme', [CompletionResultType]::ParameterName, 'Set the color theme for syntax highlighting for light backgrounds.')
              [CompletionResult]::new('--strip-ansi', 'strip-ansi', [CompletionResultType]::ParameterName, 'Specify when to strip ANSI escape sequences from the input.')
              [CompletionResult]::new('--style', 'style', [CompletionResultType]::ParameterName, 'Comma-separated list of style elements to display (*default*, auto, full, plain, changes, header, header-filename, header-filesize, grid, rule, numbers, snip).')
              [CompletionResult]::new('-r', 'r', [CompletionResultType]::ParameterName, 'Only print the lines from N to M.')
              [CompletionResult]::new('--line-range', 'line-range', [CompletionResultType]::ParameterName, 'Only print the lines from N to M.')
              [CompletionResult]::new('-A', 'A', [CompletionResultType]::ParameterName, 'Show non-printable characters (space, tab, newline, ..).')
              [CompletionResult]::new('--show-all', 'show-all', [CompletionResultType]::ParameterName, 'Show non-printable characters (space, tab, newline, ..).')
              [CompletionResult]::new('-p', 'p', [CompletionResultType]::ParameterName, 'Show plain style (alias for ''--style=plain'').')
              [CompletionResult]::new('--plain', 'plain', [CompletionResultType]::ParameterName, 'Show plain style (alias for ''--style=plain'').')
              [CompletionResult]::new('-d', 'd', [CompletionResultType]::ParameterName, 'Only show lines that have been added/removed/modified.')
              [CompletionResult]::new('--diff', 'diff', [CompletionResultType]::ParameterName, 'Only show lines that have been added/removed/modified.')
              [CompletionResult]::new('-n', 'n', [CompletionResultType]::ParameterName, 'Show line numbers (alias for ''--style=numbers'').')
              [CompletionResult]::new('--number', 'number', [CompletionResultType]::ParameterName, 'Show line numbers (alias for ''--style=numbers'').')
              [CompletionResult]::new('-f', 'f', [CompletionResultType]::ParameterName, 'f')
              [CompletionResult]::new('--force-colorization', 'force-colorization', [CompletionResultType]::ParameterName, 'force-colorization')
              [CompletionResult]::new('-P', 'P', [CompletionResultType]::ParameterName, 'Alias for ''--paging=never''')
              [CompletionResult]::new('--no-paging', 'no-paging', [CompletionResultType]::ParameterName, 'Alias for ''--paging=never''')
              [CompletionResult]::new('--list-themes', 'list-themes', [CompletionResultType]::ParameterName, 'Display all supported highlighting themes.')
              [CompletionResult]::new('-L', 'L', [CompletionResultType]::ParameterName, 'Display all supported languages.')
              [CompletionResult]::new('--list-languages', 'list-languages', [CompletionResultType]::ParameterName, 'Display all supported languages.')
              [CompletionResult]::new('-u', 'u', [CompletionResultType]::ParameterName, 'u')
              [CompletionResult]::new('--unbuffered', 'unbuffered', [CompletionResultType]::ParameterName, 'unbuffered')
              [CompletionResult]::new('--no-config', 'no-config', [CompletionResultType]::ParameterName, 'Do not use the configuration file')
              [CompletionResult]::new('--no-custom-assets', 'no-custom-assets', [CompletionResultType]::ParameterName, 'Do not load custom assets')
              [CompletionResult]::new('--lessopen', 'lessopen', [CompletionResultType]::ParameterName, 'Enable the $LESSOPEN preprocessor')
              [CompletionResult]::new('--no-lessopen', 'no-lessopen', [CompletionResultType]::ParameterName, 'Disable the $LESSOPEN preprocessor if enabled (overrides --lessopen)')
              [CompletionResult]::new('--config-file', 'config-file', [CompletionResultType]::ParameterName, 'Show path to the configuration file.')
              [CompletionResult]::new('--generate-config-file', 'generate-config-file', [CompletionResultType]::ParameterName, 'Generates a default configuration file.')
              [CompletionResult]::new('--config-dir', 'config-dir', [CompletionResultType]::ParameterName, 'Show bat''s configuration directory.')
              [CompletionResult]::new('--cache-dir', 'cache-dir', [CompletionResultType]::ParameterName, 'Show bat''s cache directory.')
              [CompletionResult]::new('--diagnostic', 'diagnostic', [CompletionResultType]::ParameterName, 'Show diagnostic information for bug reports.')
              [CompletionResult]::new('-h', 'h', [CompletionResultType]::ParameterName, 'Print this help message.')
              [CompletionResult]::new('--help', 'help', [CompletionResultType]::ParameterName, 'Print this help message.')
              [CompletionResult]::new('-V', 'V', [CompletionResultType]::ParameterName, 'Show version information.')
              [CompletionResult]::new('--version', 'version', [CompletionResultType]::ParameterName, 'Show version information.')
            }
            elseif ($commandAst.CommandElements.Count -le 2) {
              [CompletionResult]::new('cache')
            }
            break
          }
        }
      }
      'cache' {
        if ($wordToComplete.StartsWith('-')) {
          [CompletionResult]::new('--source', 'source', [CompletionResultType]::ParameterName, 'Use a different directory to load syntaxes and themes from.')
          [CompletionResult]::new('--target', 'target', [CompletionResultType]::ParameterName, 'Use a different directory to store the cached syntax and theme set.')
          [CompletionResult]::new('-b', 'b', [CompletionResultType]::ParameterName, 'Initialize (or update) the syntax/theme cache.')
          [CompletionResult]::new('--build', 'build', [CompletionResultType]::ParameterName, 'Initialize (or update) the syntax/theme cache.')
          [CompletionResult]::new('-c', 'c', [CompletionResultType]::ParameterName, 'Remove the cached syntax definitions and themes.')
          [CompletionResult]::new('--clear', 'clear', [CompletionResultType]::ParameterName, 'Remove the cached syntax definitions and themes.')
          [CompletionResult]::new('--blank', 'blank', [CompletionResultType]::ParameterName, 'Create completely new syntax and theme sets (instead of appending to the default sets).')
          [CompletionResult]::new('-h', 'h', [CompletionResultType]::ParameterName, 'Prints help information')
          [CompletionResult]::new('--help', 'help', [CompletionResultType]::ParameterName, 'Prints help information')
          [CompletionResult]::new('-V', 'V', [CompletionResultType]::ParameterName, 'Prints version information')
          [CompletionResult]::new('--version', 'version', [CompletionResultType]::ParameterName, 'Prints version information')
        }
        break
      }
    }) | Where-Object CompletionText -Like "$wordToComplete*"
}
