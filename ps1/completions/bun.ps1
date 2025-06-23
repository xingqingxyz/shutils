using namespace System.Management.Automation.Language

Register-ArgumentCompleter -Native -CommandName bun -ScriptBlock {
  param([string]$wordToComplete, [CommandAst]$commandAst, [int]$cursorPosition)
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
  $command = switch ($command) {
    'a' { 'add'; break }
    'c' { 'create'; break }
    'i' { 'install'; break }
    'rm' { 'remove'; break }
    Default { $command }
  }

  $cursorPosition -= $wordToComplete.Length
  foreach ($i in $commandAst.CommandElements) {
    if ($i.Extent.StartOffset -ge $cursorPosition) {
      break
    }
    $prev = $i
  }
  $prev = $prev.ToString()

  @(switch ($command) {
      '' {
        if ($wordToComplete.StartsWith('-')) {
          @('--watch', '--hot', '--no-clear-screen', '--smol', '-r', '--preload', '--inspect', '--inspect-wait', '--inspect-brk', '--if-present', '--no-install', '--install', '-e', '--eval', '--print', '--prefer-offline', '--prefer-latest', '-p', '--port', '--conditions', '--fetch-preconnect', '--max-http-header-size', '--silent', '-v', '--version', '--revision', '--filter', '-b', '--bun', '--shell', '--env-file', '--cwd', '-c', '--config', '-h', '--help')
        }
        elseif ($prev.StartsWith('bun')) {
          @('a', 'add', 'build', 'create', 'exec', 'i', 'init', 'install', 'link', 'outdated', 'patch', 'pm', 'publish', 'remove', 'repl', 'rm', 'run', 'test', 'unlink', 'update', 'upgrade', 'x')
          (packageJSON).scripts.Keys
        }
        break
      }
      'add' {
        if ($wordToComplete.StartsWith('-')) {
          @('-c', '--config', '-y', '--yarn', '-p', '--production', '--no-save', '--save', '--ca', '--cafile', '--dry-run', '--frozen-lockfile', '-f', '--force', '--cache-dir', '--no-cache', '--silent', '--verbose', '--no-progress', '--no-summary', '--no-verify', '--ignore-scripts', '--trust', '-g', '--global', '--cwd', '--backend', '--registry', '--concurrent-scripts', '--network-concurrency', '-h', '--help', '-d', '--dev', '--optional', '-E', '--exact')
        }
        break
      }
      'create' {
        if ($wordToComplete.StartsWith('-')) {
          # TODO: update this
          @('react', 'vue', 'vite', 'svelte', 'astro', 'next', 'nuxt', 'preact', 'uniapp')
        }
        break
      }
      'exec' {
        if ($wordToComplete.StartsWith('-')) {
          @('--silent', '--filter', '-b', '--bun', '--shell', '--watch', '--hot', '--no-clear-screen', '--smol', '-r', '--preload', '--inspect', '--inspect-wait', '--inspect-brk', '--if-present', '--no-install', '--install', '-e', '--eval', '--print', '--prefer-offline', '--prefer-latest', '-p', '--port', '--conditions', '--fetch-preconnect', '--max-http-header-size', '--main-fields', '--extension-order', '--tsconfig-override', '-d', '--define', '--drop', '-l', '--loader', '--no-macros', '--jsx-factory', '--jsx-fragment', '--jsx-import-source', '--jsx-runtime', '--ignore-dce-annotations', '--env-file', '--cwd', '-c', '--config', '-h', '--help')
        }
        elseif ($prev -eq 'exec') {
          bash -c 'compgen -bc' | Select-Object -Unique
        }
        break
      }
      'run' {
        if ($wordToComplete.StartsWith('-')) {
          @('--silent', '--filter', '-b', '--bun', '--shell', '--watch', '--hot', '--no-clear-screen', '--smol', '-r', '--preload', '--inspect', '--inspect-wait', '--inspect-brk', '--if-present', '--no-install', '--install', '-e', '--eval', '--print', '--prefer-offline', '--prefer-latest', '-p', '--port', '--conditions', '--fetch-preconnect', '--max-http-header-size', '--main-fields', '--extension-order', '--tsconfig-override', '-d', '--define', '--drop', '-l', '--loader', '--no-macros', '--jsx-factory', '--jsx-fragment', '--jsx-import-source', '--jsx-runtime', '--ignore-dce-annotations', '--env-file', '--cwd', '-c', '--config', '-h', '--help')
        }
        elseif ($prev.StartsWith('run')) {
          (packageJSON).scripts.Keys
        }
        break
      }
      'update' {
        if ($wordToComplete.StartsWith('-')) {
          @('-c', '--config', '-y', '--yarn', '-p', '--production', '--no-save', '--save', '--ca', '--cafile', '--dry-run', '--frozen-lockfile', '-f', '--force', '--cache-dir', '--no-cache', '--silent', '--verbose', '--no-progress', '--no-summary', '--no-verify', '--ignore-scripts', '--trust', '-g', '--global', '--cwd', '--backend', '--registry', '--concurrent-scripts', '--network-concurrency', '-h', '--help', '--latest')
        }
        else {
          foreach ($item in packageJSON) {
            if ($item.Name -like '*dependencies') {
              $item.Value.Keys
            }
          }
        }
        break
      }
      'outdated' {
        if ($wordToComplete.StartsWith('-')) {
          @('-c', '--config', '-y', '--yarn', '-p', '--production', '--no-save', '--save', '--ca', '--cafile', '--dry-run', '--frozen-lockfile', '-f', '--force', '--cache-dir', '--no-cache', '--silent', '--verbose', '--no-progress', '--no-summary', '--no-verify', '--ignore-scripts', '--trust', '-g', '--global', '--cwd', '--backend', '--registry', '--concurrent-scripts', '--network-concurrency', '-h', '--help', '--filter')
        }
        break
      }
      'link' {
        if ($wordToComplete.StartsWith('-')) {
          @('-c', '--config', '-y', '--yarn', '-p', '--production', '--no-save', '--save', '--ca', '--cafile', '--dry-run', '--frozen-lockfile', '-f', '--force', '--cache-dir', '--no-cache', '--silent', '--verbose', '--no-progress', '--no-summary', '--no-verify', '--ignore-scripts', '--trust', '-g', '--global', '--cwd', '--backend', '--registry', '--concurrent-scripts', '--network-concurrency', '-h', '--help')
        }
        break
      }
      'unlink' {
        if ($wordToComplete.StartsWith('-')) {
          @('-c', '--config', '-y', '--yarn', '-p', '--production', '--no-save', '--save', '--ca', '--cafile', '--dry-run', '--frozen-lockfile', '-f', '--force', '--cache-dir', '--no-cache', '--silent', '--verbose', '--no-progress', '--no-summary', '--no-verify', '--ignore-scripts', '--trust', '-g', '--global', '--cwd', '--backend', '--registry', '--concurrent-scripts', '--network-concurrency', '-h', '--help')
        }
        break
      }
      'publish' {
        if ($wordToComplete.StartsWith('-')) {
          @('-c', '--config', '-y', '--yarn', '-p', '--production', '--no-save', '--save', '--ca', '--cafile', '--dry-run', '--frozen-lockfile', '-f', '--force', '--cache-dir', '--no-cache', '--silent', '--verbose', '--no-progress', '--no-summary', '--no-verify', '--ignore-scripts', '--trust', '-g', '--global', '--cwd', '--backend', '--registry', '--concurrent-scripts', '--network-concurrency', '-h', '--help', '--access', '--tag', '--otp', '--auth-type', '--gzip-level')
        }
        break
      }
      'patch' {
        if ($wordToComplete.StartsWith('-')) {
          @('-c', '--config', '-y', '--yarn', '-p', '--production', '--no-save', '--save', '--ca', '--cafile', '--dry-run', '--frozen-lockfile', '-f', '--force', '--cache-dir', '--no-cache', '--silent', '--verbose', '--no-progress', '--no-summary', '--no-verify', '--ignore-scripts', '--trust', '-g', '--global', '--cwd', '--backend', '--registry', '--concurrent-scripts', '--network-concurrency', '-h', '--help', '--commit', '--patches-dir')
        }
        break
      }
      'pm' {
        @('pack', 'bin', 'ls', 'whoami', 'hash', 'hash-string', 'hash-print', 'cache', 'migrate', 'untrusted', 'trust', 'default-trusted')
        break
      }
      'pm;bin' {
        @('-g')
        break
      }
      'pm;cache' {
        @('rm')
        break
      }
      'pm;ls' {
        @('--all')
        break
      }
      'pm;pack' {
        @('--dry-run', '--destination', '--help', '--ignore-scripts', '--gzip-level')
        break
      }
      'pm;trust' {
        if ($wordToComplete.StartsWith('-')) {
          @('--all')
        }
        break
      }
      'build' {
        if ($wordToComplete.StartsWith('-')) {
          @('--compile', '--bytecode', '--watch', '--help', '--no-clear-screen', '--target', '--outdir', '--outfile', '--sourcemap', '--banner', '--footer', '--format', '--root', '--splitting', '--public-path', '-e', '--external', '--packages', '--entry-naming', '--chunk-naming', '--asset-naming', '--react-fast-refresh', '--no-bundle', '--emit-dce-annotations', '--minify', '--minify-syntax', '--minify-whitespace', '--minify-identifiers', '--experimental-css', '--experimental-css-chunking', '--conditions', '--app', '--server-components')
        }
        break
      }
      'upgrade' {
        if ($wordToComplete.StartsWith('-')) {
          @('--canary')
        }
        break
      }
      'x' {
        if ($wordToComplete.StartsWith('-')) {
          @('--bun')
        }
        else {
          (Get-ChildItem node_modules/.bin -ea Ignore).BaseName | Select-Object -Unique
        }
        break
      }
      'repl' {
        if ($wordToComplete.StartsWith('-')) {
          @('-h', '--help', '-p', '--print', '-e', '--eval', '--sloppy')
        }
        break
      }
      'test' {
        if ($wordToComplete.StartsWith('-')) {
          @('--timeout', '-u', '--update-snapshots', '--rerun-each', '--only', '--todo', '--coverage', '--coverage-reporter', '--coverage-dir', '--bail', '-t', '--test-name-pattern', '--reporter', '--reporter-outfile')
        }
        break
      }
      'init' {
        if ($wordToComplete.StartsWith('-')) {
          @('--help', '-y', '--yes')
        }
        break
      }
      'install' {
        if ($wordToComplete.StartsWith('-')) {
          @('-c', '--config', '-y', '--yarn', '-p', '--production', '--no-save', '--save', '--ca', '--cafile', '--dry-run', '--frozen-lockfile', '-f', '--force', '--cache-dir', '--no-cache', '--silent', '--verbose', '--no-progress', '--no-summary', '--no-verify', '--ignore-scripts', '--trust', '-g', '--global', '--cwd', '--backend', '--registry', '--concurrent-scripts', '--network-concurrency', '-h', '--help', '-d', '--dev', '--optional', '-E', '--exact')
        }
        break
      }
      'remove' {
        if ($wordToComplete.StartsWith('-')) {
          @('-c', '--config', '-y', '--yarn', '-p', '--production', '--no-save', '--save', '--ca', '--cafile', '--dry-run', '--frozen-lockfile', '-f', '--force', '--cache-dir', '--no-cache', '--silent', '--verbose', '--no-progress', '--no-summary', '--no-verify', '--ignore-scripts', '--trust', '-g', '--global', '--cwd', '--backend', '--registry', '--concurrent-scripts', '--network-concurrency', '-h', '--help')
        }
        else {
          foreach ($item in packageJSON) {
            if ($item.Name -like '*dependencies') {
              $item.Value.Keys
            }
          }
        }
        break
      }
    }).Where{ $_ -like "$wordToComplete*" }
}
