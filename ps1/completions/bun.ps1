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
  # $cursorPosition -= $wordToComplete.Length
  # foreach ($key in $commandAst.CommandElements) {
  #   if ($key.Extent.StartOffset -eq $cursorPosition) {
  #     break
  #   }
  #   $prev = $key
  # }
  @(switch ($command) {
      'exec' {
        if ($wordToComplete.StartsWith('-')) {
          @('--silent', '--filter', '-b', '--bun', '--shell', '--watch', '--hot', '--no-clear-screen', '--smol', '-r', '--preload', '--inspect', '--inspect-wait', '--inspect-brk', '--if-present', '--no-install', '--install', '-e', '--eval', '--print', '--prefer-offline', '--prefer-latest', '-p', '--port', '--conditions', '--fetch-preconnect', '--max-http-header-size', '--main-fields', '--extension-order', '--tsconfig-override', '-d', '--define', '--drop', '-l', '--loader', '--no-macros', '--jsx-factory', '--jsx-fragment', '--jsx-import-source', '--jsx-runtime', '--ignore-dce-annotations', '--env-file', '--cwd', '-c', '--config', '-h', '--help')
        }
        break
      }
      'update' {
        if ($wordToComplete.StartsWith('-')) {
          @('-c', '--config', '-y', '--yarn', '-p', '--production', '--no-save', '--save', '--ca', '--cafile', '--dry-run', '--frozen-lockfile', '-f', '--force', '--cache-dir', '--no-cache', '--silent', '--verbose', '--no-progress', '--no-summary', '--no-verify', '--ignore-scripts', '--trust', '-g', '--global', '--cwd', '--backend', '--registry', '--concurrent-scripts', '--network-concurrency', '-h', '--help', '--latest')
        }
        else {
          $json = npm ls --json | ConvertFrom-Json -AsHashtable
          $json.Keys | ForEach-Object { 
            if ($_ -like '*dependencies') {
              $json.$_.Keys
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
      'init' {
        if ($wordToComplete.StartsWith('-')) {
          @('--help', '-y', '--yes')
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
          (Get-ChildItem node_modules/.bin -Exclude *.* -ErrorAction Ignore).BaseName
        }
        break
      }
      'repl' {
        if ($wordToComplete.StartsWith('-')) {
          @('-h', '--help', '-p', '--print', '-e', '--eval', '--sloppy')
        }
        break
      }
      { $_ -eq '' -or $_ -eq 'run' -or $_ -eq 'exec' } {
        if ($wordToComplete.StartsWith('-')) {
          @('-r', '--recursive')
        }
        else {
          try {
            $json = Get-Content -Raw package.json | ConvertFrom-Json -AsHashtable
            $json.scripts?.Keys
          }
          catch {}
          if ($_ -eq '') {
            @('run', 'test', 'x', 'repl', 'exec', 'install', 'add', 'remove', 'update', 'outdated', 'link', 'unlink', 'publish', 'patch', 'pm', 'build', 'init', 'create', 'upgrade')
          }
        }
        break
      }
      { $_ -eq 't' -or $_ -eq 'test' } {
        if ($wordToComplete.StartsWith('-')) {
          @('--timeout', '-u', '--update-snapshots', '--rerun-each', '--only', '--todo', '--coverage', '--coverage-reporter', '--coverage-dir', '--bail', '-t', '--test-name-pattern', '--reporter', '--reporter-outfile')
        }
        break
      }
      { $_ -eq 'i' -or $_ -eq 'install' } {
        if ($wordToComplete.StartsWith('-')) {
          @('-c', '--config', '-y', '--yarn', '-p', '--production', '--no-save', '--save', '--ca', '--cafile', '--dry-run', '--frozen-lockfile', '-f', '--force', '--cache-dir', '--no-cache', '--silent', '--verbose', '--no-progress', '--no-summary', '--no-verify', '--ignore-scripts', '--trust', '-g', '--global', '--cwd', '--backend', '--registry', '--concurrent-scripts', '--network-concurrency', '-h', '--help', '-d', '--dev', '--optional', '-E', '--exact')
        }
        break
      }
      { $_ -eq 'a' -or $_ -eq 'add' } {
        if ($wordToComplete.StartsWith('-')) {
          @('-c', '--config', '-y', '--yarn', '-p', '--production', '--no-save', '--save', '--ca', '--cafile', '--dry-run', '--frozen-lockfile', '-f', '--force', '--cache-dir', '--no-cache', '--silent', '--verbose', '--no-progress', '--no-summary', '--no-verify', '--ignore-scripts', '--trust', '-g', '--global', '--cwd', '--backend', '--registry', '--concurrent-scripts', '--network-concurrency', '-h', '--help', '-d', '--dev', '--optional', '-E', '--exact')
        }
        break
      }
      { $_ -eq 'r' -or $_ -eq 'remove' } {
        if ($wordToComplete.StartsWith('-')) {
          @('-c', '--config', '-y', '--yarn', '-p', '--production', '--no-save', '--save', '--ca', '--cafile', '--dry-run', '--frozen-lockfile', '-f', '--force', '--cache-dir', '--no-cache', '--silent', '--verbose', '--no-progress', '--no-summary', '--no-verify', '--ignore-scripts', '--trust', '-g', '--global', '--cwd', '--backend', '--registry', '--concurrent-scripts', '--network-concurrency', '-h', '--help')
        }
        else {
          $json = npm ls --json | ConvertFrom-Json -AsHashtable
          $json.Keys | ForEach-Object { 
            if ($_ -like '*dependencies') {
              $json.$_.Keys
            }
          }
        }
        break
      }
    }) | Where-Object { $_ -like "$wordToComplete*" }
}
