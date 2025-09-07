using namespace System.Management.Automation
using namespace System.Management.Automation.Language

Register-ArgumentCompleter -Native -CommandName ruff -ScriptBlock {
  param ([string]$wordToComplete, [CommandAst]$commandAst, [int]$cursorPosition)
  $commands = @(foreach ($i in $commandAst.CommandElements) {
      if ($i.Extent.StartOffset -eq 0 -or $i.Extent.EndOffset -eq $cursorPosition) {
        continue
      }
      if ($i -isnot [StringConstantExpressionAst] -or
        $i.StringConstantType -ne [StringConstantType]::BareWord -or
        $i.Value.StartsWith('-')) {
        break
      }
      $i.Value
    })

  $cursorPosition -= $wordToComplete.Length
  foreach ($i in $commandAst.CommandElements) {
    if ($i.Extent.StartOffset -ge $cursorPosition) {
      break
    }
    $prev = $i
  }
  $prev = $prev -is [System.Management.Automation.Language.StringConstantExpressionAst] ? $prev.Value : $prev.ToString()

  if ($commands.Length -ge 2) {
    if ($commands[0] -eq 'help') {
      $commands = @('help')
    }
  }

  @(switch ($commands -join ' ') {
      '' {
        'check', 'rule', 'config', 'linter', 'clean', 'format', 'server', 'analyze', 'version', 'help',
        '-h', '--help', '-V', '--version', '-v', '--verbose', '-q', '--quiet', '-s', '--silent', '--config', '--isolated'
        break
      }
      'help' {
        'check', 'rule', 'config', 'linter', 'clean', 'format', 'server', 'analyze', 'version', 'help',
        '--config', '--isolated'
        break
      }
      'check' {
        switch ($prev) {
          '--output-format' { 'concise', 'full', 'json', 'json-lines', 'junit', 'grouped', 'github', 'gitlab', 'pylint', 'rdjson', 'azure', 'sarif'; break }
          '--target-version' { 'py37', 'py38', 'py39', 'py310', 'py311', 'py312', 'py313', 'py314'; break }
          '--extension' { 'ipy:ipynb'; break }
          default {
            '--fix', '--unsafe-fixes', '--show-fixes', '--diff', '-w', '--watch', '--fix-only', '--ignore-noqa', '--output-format', '-o', '--output-file', '--target-version', '--preview', '--extension', '--statistics', '--add-noqa', '--show-files', '--show-settings', '-h', '--help',
            '--select', '--ignore', '--extend-select', '--per-file-ignores', '--extend-per-file-ignores', '--fixable', '--unfixable', '--extend-fixable',
            '--exclude', '--extend-exclude', '--respect-gitignore', '--force-exclude',
            '-n', '--no-cache', '--cache-dir', '--stdin-filename', '-e', '--exit-zero', '--exit-non-zero-on-fix',
            '-v', '--verbose', '-q', '--quiet', '-s', '--silent',
            '--config', '--isolated'
            break
          }
        }
        break
      }
      'rule' {
        if ($prev -eq '--output-format') {
          'text', 'json'
          break
        }
        '--all', '--output-format', '-h', '--help',
        '-v', '--verbose', '-q', '--quiet', '-s', '--silent',
        '--config', '--isolated'
        break
      }
      'config' {
        if ($prev -eq '--output-format') {
          'text', 'json'
          break
        }
        '--output-format', '-h', '--help',
        '-v', '--verbose', '-q', '--quiet', '-s', '--silent',
        '--config', '--isolated'
        break
      }
      'linter' {
        if ($prev -eq '--output-format') {
          'text', 'json'
          break
        }
        '--output-format', '-h', '--help',
        '-v', '--verbose', '-q', '--quiet', '-s', '--silent',
        '--config', '--isolated'
        break
      }
      'clean' {
        '-h', '--help',
        '-v', '--verbose', '-q', '--quiet', '-s', '--silent',
        '--config', '--isolated'
        break
      }
      'format' {
        switch ($prev) {
          '--target-version' { 'py37', 'py38', 'py39', 'py310', 'py311', 'py312', 'py313', 'py314'; break }
          '--extension' { 'ipy:ipynb'; break }
          default {
            '--check', '--diff', '--extension', '--target-version', '--preview', '-h', '--help', '-n', '--no-cache', '--cache-dir', '--stdin-filename', '--exit-non-zero-on-format', '--respect-gitignore', '--exclude', '--force-exclude', '--line-length', '--range', '-v', '--verbose', '-q', '--quiet', '-s', '--silent', '--config', '--isolated'
            break
          }
        }
        break
      }
      'server' {
        '--preview', '-h', '--help', '-v', '--verbose', '-q', '--quiet', '-s', '--silent', '--config', '--isolated'
        break
      }
      'analyze' {
        'graph', 'help',
        '-h', '--help', '-v', '--verbose', '-q', '--quiet', '-s', '--silent', '--config', '--isolated'
        break
      }
      'analyze graph' {
        switch ($prev) {
          '--direction' { 'dependencies', 'dependents'; break }
          '--target-version' { 'py37', 'py38', 'py39', 'py310', 'py311', 'py312', 'py313', 'py314'; break }
          default {
            '--direction', '--detect-string-imports', '--preview', '--target-version', '--python', '-h', '--help', '-v', '--verbose', '-q', '--quiet', '-s', '--silent', '--config', '--isolated'
            break
          }
        }
        break
      }
      'version' {
        if ($prev -eq '--output-format') {
          'text', 'json'
          break
        }
        '--output-format', '-h', '--help',
        '-v', '--verbose', '-q', '--quiet', '-s', '--silent',
        '--config', '--isolated'
        break
      }
    }).Where{ $_ -like "$wordToComplete*" }
}
