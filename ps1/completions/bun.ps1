using namespace System.Management.Automation.Language

Register-ArgumentCompleter -Native -CommandName bun -ScriptBlock {
  param ([string]$wordToComplete, [CommandAst]$commandAst, [int]$cursorPosition)
  [string[]]$commands = foreach ($i in $commandAst.CommandElements) {
    if ($i.Extent.StartOffset -eq $commandAst.Extent.StartOffset -or $i.Extent.EndOffset -eq $cursorPosition) {
      continue
    }
    if ($i -isnot [StringConstantExpressionAst] -or
      $i.StringConstantType -ne [StringConstantType]::BareWord -or
      $i.Value.StartsWith('-')) {
      break
    }
    $i.Value
  }
  switch (0..$commands.Count) {
    $commands.Count { break }
    0 {
      $commands[$_] = switch ($commands[$_]) {
        'a' { 'add'; break }
        'c' { 'create'; break }
        'i' { 'install'; break }
        'rm' { 'remove'; break }
        default { $_; break }
      }
      continue
    }
    default { break }
  }
  $command = $commands -join ' '

  if ($command -ceq 'x') {
    return (Split-Path -Resolve -LeafBase node_modules/.bin/* -ea Ignore | Sort-Object -Unique | Where-Object { $_ -like "$wordToComplete*" }) ?? [System.Management.Automation.CompletionCompleters]::CompleteCommand($wordToComplete, '', [System.Management.Automation.CommandTypes]::Application)
  }
  if ($command.StartsWith('x ')) {
    [string]$line = $commandAst
    $commandName = [System.IO.Path]::GetFileNameWithoutExtension($commandAst.CommandElements[2])
    $i = $commandAst.CommandElements[2].Extent.StartOffset
    $line = $line.Substring($i)
    $cursorPosition -= $i
    $commandAst = [Parser]::ParseInput($line, [ref]$null, [ref]$null).EndBlock.Statements[0].PipelineElements[0]
    return & (Get-ArgumentCompleter $commandName) $wordToComplete $commandAst $cursorPosition
  }

  $cursorPosition -= $wordToComplete.Length
  foreach ($i in $commandAst.CommandElements) {
    if ($i.Extent.StartOffset -ge $cursorPosition) {
      break
    }
    $prev = $i
  }
  $prev = $prev -is [System.Management.Automation.Language.StringConstantExpressionAst] ? $prev.Value : $prev.ToString()

  @(switch ($command) {
      '' {
        if ($wordToComplete.StartsWith('-')) {
          '--watch', '--hot', '--no-clear-screen', '--smol', '-r', '--preload', '--inspect', '--inspect-wait', '--inspect-brk', '--if-present', '--no-install', '--install', '-e', '--eval', '--print', '--prefer-offline', '--prefer-latest', '-p', '--port', '--conditions', '--fetch-preconnect', '--max-http-header-size', '--silent', '-v', '--version', '--revision', '--filter', '-b', '--bun', '--shell', '--env-file', '--cwd', '-c', '--config', '-h', '--help'
        }
        elseif ($prev.StartsWith('bun')) {
          'a', 'add', 'build', 'create', 'exec', 'i', 'init', 'install', 'link', 'outdated', 'patch', 'pm', 'publish', 'remove', 'repl', 'rm', 'run', 'test', 'unlink', 'update', 'upgrade', 'x'
        }
        break
      }
      'add' {
        if ($wordToComplete.StartsWith('-')) {
          '-c', '--config', '-y', '--yarn', '-p', '--production', '--no-save', '--save', '--ca', '--cafile', '--dry-run', '--frozen-lockfile', '-f', '--force', '--cache-dir', '--no-cache', '--silent', '--verbose', '--no-progress', '--no-summary', '--no-verify', '--ignore-scripts', '--trust', '-g', '--global', '--cwd', '--backend', '--registry', '--concurrent-scripts', '--network-concurrency', '-h', '--help', '-d', '--dev', '--optional', '-E', '--exact'
          break
        }
        break
      }
      'create' {
        if ($wordToComplete.StartsWith('-')) {
          break
        }
        'react', 'vue', 'vite', 'svelte', 'astro', 'next', 'nuxt', 'preact', 'uniapp'
        break
      }
      'exec' {
        if ($wordToComplete.StartsWith('-')) {
          '--silent', '--filter', '-b', '--bun', '--shell', '--watch', '--hot', '--no-clear-screen', '--smol', '-r', '--preload', '--inspect', '--inspect-wait', '--inspect-brk', '--if-present', '--no-install', '--install', '-e', '--eval', '--print', '--prefer-offline', '--prefer-latest', '-p', '--port', '--conditions', '--fetch-preconnect', '--max-http-header-size', '--main-fields', '--extension-order', '--tsconfig-override', '-d', '--define', '--drop', '-l', '--loader', '--no-macros', '--jsx-factory', '--jsx-fragment', '--jsx-import-source', '--jsx-runtime', '--ignore-dce-annotations', '--env-file', '--cwd', '-c', '--config', '-h', '--help'
          break
        }
        bash -c 'compgen -bc' | Select-Object -Unique
        break
      }
      'run' {
        if ($wordToComplete.StartsWith('-')) {
          '--silent', '--filter', '-b', '--bun', '--shell', '--watch', '--hot', '--no-clear-screen', '--smol', '-r', '--preload', '--inspect', '--inspect-wait', '--inspect-brk', '--if-present', '--no-install', '--install', '-e', '--eval', '--print', '--prefer-offline', '--prefer-latest', '-p', '--port', '--conditions', '--fetch-preconnect', '--max-http-header-size', '--main-fields', '--extension-order', '--tsconfig-override', '-d', '--define', '--drop', '-l', '--loader', '--no-macros', '--jsx-factory', '--jsx-fragment', '--jsx-import-source', '--jsx-runtime', '--ignore-dce-annotations', '--env-file', '--cwd', '-c', '--config', '-h', '--help'
        }
        elseif ($prev -ceq 'run') {
          jq -r '.scripts | keys[]' package.json
        }
        break
      }
      'update' {
        if ($wordToComplete.StartsWith('-')) {
          '-c', '--config', '-y', '--yarn', '-p', '--production', '--no-save', '--save', '--ca', '--cafile', '--dry-run', '--frozen-lockfile', '-f', '--force', '--cache-dir', '--no-cache', '--silent', '--verbose', '--no-progress', '--no-summary', '--no-verify', '--ignore-scripts', '--trust', '-g', '--global', '--cwd', '--backend', '--registry', '--concurrent-scripts', '--network-concurrency', '-h', '--help', '--latest'
          break
        }
        (npm pkg get | ConvertFrom-Json -AsHashtable).GetEnumerator() | Where-Object Name -Like '*dependencies' | ForEach-Object { $_.Value.Keys }
        break
      }
      'outdated' {
        if ($wordToComplete.StartsWith('-')) {
          '-c', '--config', '-y', '--yarn', '-p', '--production', '--no-save', '--save', '--ca', '--cafile', '--dry-run', '--frozen-lockfile', '-f', '--force', '--cache-dir', '--no-cache', '--silent', '--verbose', '--no-progress', '--no-summary', '--no-verify', '--ignore-scripts', '--trust', '-g', '--global', '--cwd', '--backend', '--registry', '--concurrent-scripts', '--network-concurrency', '-h', '--help', '--filter'
        }
        break
      }
      'link' {
        if ($wordToComplete.StartsWith('-')) {
          '-c', '--config', '-y', '--yarn', '-p', '--production', '--no-save', '--save', '--ca', '--cafile', '--dry-run', '--frozen-lockfile', '-f', '--force', '--cache-dir', '--no-cache', '--silent', '--verbose', '--no-progress', '--no-summary', '--no-verify', '--ignore-scripts', '--trust', '-g', '--global', '--cwd', '--backend', '--registry', '--concurrent-scripts', '--network-concurrency', '-h', '--help'
          break
        }
        break
      }
      'unlink' {
        if ($wordToComplete.StartsWith('-')) {
          '-c', '--config', '-y', '--yarn', '-p', '--production', '--no-save', '--save', '--ca', '--cafile', '--dry-run', '--frozen-lockfile', '-f', '--force', '--cache-dir', '--no-cache', '--silent', '--verbose', '--no-progress', '--no-summary', '--no-verify', '--ignore-scripts', '--trust', '-g', '--global', '--cwd', '--backend', '--registry', '--concurrent-scripts', '--network-concurrency', '-h', '--help'
          break
        }
        break
      }
      'publish' {
        if ($wordToComplete.StartsWith('-')) {
          '-c', '--config', '-y', '--yarn', '-p', '--production', '--no-save', '--save', '--ca', '--cafile', '--dry-run', '--frozen-lockfile', '-f', '--force', '--cache-dir', '--no-cache', '--silent', '--verbose', '--no-progress', '--no-summary', '--no-verify', '--ignore-scripts', '--trust', '-g', '--global', '--cwd', '--backend', '--registry', '--concurrent-scripts', '--network-concurrency', '-h', '--help', '--access', '--tag', '--otp', '--auth-type', '--gzip-level'
          break
        }
        break
      }
      'patch' {
        if ($wordToComplete.StartsWith('-')) {
          '-c', '--config', '-y', '--yarn', '-p', '--production', '--no-save', '--save', '--ca', '--cafile', '--dry-run', '--frozen-lockfile', '-f', '--force', '--cache-dir', '--no-cache', '--silent', '--verbose', '--no-progress', '--no-summary', '--no-verify', '--ignore-scripts', '--trust', '-g', '--global', '--cwd', '--backend', '--registry', '--concurrent-scripts', '--network-concurrency', '-h', '--help', '--commit', '--patches-dir'
          break
        }
        break
      }
      'pm' {
        if ($wordToComplete.StartsWith('-')) {
          break
        }
        'pack', 'bin', 'ls', 'whoami', 'hash', 'hash-string', 'hash-print', 'cache', 'migrate', 'untrusted', 'trust', 'default-trusted'
        break
      }
      'pm bin' {
        if ($wordToComplete.StartsWith('-')) {
          '-g'
          break
        }
        break
      }
      'pm cache' {
        if ($wordToComplete.StartsWith('-')) {
          break
        }
        'rm'
        break
      }
      'pm ls' {
        if ($wordToComplete.StartsWith('-')) {
          '--all'
          break
        }
        break
      }
      'pm pack' {
        if ($wordToComplete.StartsWith('-')) {
          '--dry-run', '--destination', '--help', '--ignore-scripts', '--gzip-level'
          break
        }
        break
      }
      'pm trust' {
        if ($wordToComplete.StartsWith('-')) {
          '--all'
          break
        }
        break
      }
      'build' {
        if ($wordToComplete.StartsWith('-')) {
          '--compile', '--bytecode', '--watch', '--help', '--no-clear-screen', '--target', '--outdir', '--outfile', '--sourcemap', '--banner', '--footer', '--format', '--root', '--splitting', '--public-path', '-e', '--external', '--packages', '--entry-naming', '--chunk-naming', '--asset-naming', '--react-fast-refresh', '--no-bundle', '--emit-dce-annotations', '--minify', '--minify-syntax', '--minify-whitespace', '--minify-identifiers', '--experimental-css', '--experimental-css-chunking', '--conditions', '--app', '--server-components'
          break
        }
        break
      }
      'upgrade' {
        if ($wordToComplete.StartsWith('-')) {
          '--canary'
          break
        }
        break
      }
      'repl' {
        if ($wordToComplete.StartsWith('-')) {
          '-h', '--help', '-p', '--print', '-e', '--eval', '--sloppy'
          break
        }
        break
      }
      'test' {
        if ($wordToComplete.StartsWith('-')) {
          '--timeout', '-u', '--update-snapshots', '--rerun-each', '--only', '--todo', '--coverage', '--coverage-reporter', '--coverage-dir', '--bail', '-t', '--test-name-pattern', '--reporter', '--reporter-outfile'
          break
        }
        break
      }
      'init' {
        if ($wordToComplete.StartsWith('-')) {
          '--help', '-y', '--yes'
          break
        }
        break
      }
      'install' {
        if ($wordToComplete.StartsWith('-')) {
          '-c', '--config', '-y', '--yarn', '-p', '--production', '--no-save', '--save', '--ca', '--cafile', '--dry-run', '--frozen-lockfile', '-f', '--force', '--cache-dir', '--no-cache', '--silent', '--verbose', '--no-progress', '--no-summary', '--no-verify', '--ignore-scripts', '--trust', '-g', '--global', '--cwd', '--backend', '--registry', '--concurrent-scripts', '--network-concurrency', '-h', '--help', '-d', '--dev', '--optional', '-E', '--exact'
          break
        }
        break
      }
      'remove' {
        if ($wordToComplete.StartsWith('-')) {
          '-c', '--config', '-y', '--yarn', '-p', '--production', '--no-save', '--save', '--ca', '--cafile', '--dry-run', '--frozen-lockfile', '-f', '--force', '--cache-dir', '--no-cache', '--silent', '--verbose', '--no-progress', '--no-summary', '--no-verify', '--ignore-scripts', '--trust', '-g', '--global', '--cwd', '--backend', '--registry', '--concurrent-scripts', '--network-concurrency', '-h', '--help'
          break
        }
        (npm pkg get | ConvertFrom-Json -AsHashtable).GetEnumerator() | Where-Object Name -Like *dependencies | ForEach-Object { $_.Value.Keys }
        break
      }
    }).Where{ $_ -like "$wordToComplete*" }
}
