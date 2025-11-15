using namespace System.Management.Automation.Language

Register-ArgumentCompleter -Native -CommandName pnpm -ScriptBlock {
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
  if ($commands) {
    $commands[0] = switch ($commands[0]) {
      'c' { 'config'; break }
      'i' { 'install'; break }
      'it' { 'install'; break }
      'install-test' { 'install'; break }
      'rm' { 'remove'; break }
      'up' { 'update'; break }
      'ls' { 'list'; break }
      't' { 'test'; break }
      'ln' { 'link'; break }
      'rb' { 'rebuild'; break }
      default { $_; break }
    }
  }
  [string]$command = $commands -join ' '
  if ($command.StartsWith('exec ')) {
    $command = '#exec'
  }
  @(switch ($command) {
      '' {
        if ($wordToComplete.StartsWith('-')) {
          '-r', '--recursive'
        }
        else {
          'add', 'approve-builds', 'audit', 'cat-file', 'cat-index', 'exec', 'find-hash', 'help', 'i', 'import', 'install-test', 'install', 'it', 'licenses', 'link', 'list', 'ln', 'ls', 'outdated', 'pack', 'prune', 'publish', 'rb', 'rebuild', 'remove', 'rm', 'root', 'run', 'self-update', 'start', 'store', 't', 'test', 'unlink', 'up', 'update'
          break
        }
        break
      }
      'add' {
        if ($wordToComplete.StartsWith('-')) {
          '--color', '--no-color', '-E', '--no-save-exact', '--save-workspace-protocol', '--no-save-workspace-protocol', '--aggregate-output', '--allow-build', '--config', '-C', '--dir', '-g', '--global', '--global-dir', '-h', '--help', '--ignore-scripts', '--logleveldebug', '--loglevelinfo', '--loglevelwarn', '--loglevelerror', '--silent', '--offline', '--prefer-offline', '-r', '--recursive', '--save-catalog', '--save-catalog-name=', '-D', '--save-dev', '-O', '--save-optional', '--save-peer', '-P', '--save-prod', '--store-dir', '--stream', '--use-stderr', '--virtual-store-dir', '--workspace', '-w', '--workspace-root', '--changed-files-ignore-pattern', '--fail-if-no-match', '--filter', '--filter-prod', '--test-pattern'
          break
        }
        break
      }
      'approve-builds' {
        if ($wordToComplete.StartsWith('-')) {
          '-g', '--global'
          break
        }
        break
      }
      'audit' {
        if ($wordToComplete.StartsWith('-')) {
          '--audit-level', '-D', '--dev', '--fix', '--ignore-registry-errors', '--json', '--no-optional', '-P', '--prod'
          break
        }
        break
      }
      'exec' {
        if ($wordToComplete.StartsWith('-')) {
          '--color', '--no-color', '--aggregate-output', '--parallel', '--reporter', '-C', '--dir', '-h', '--help', '--loglevel=debug', '--loglevel=info', '--loglevel=warn', '--loglevel=error', '--silent', '--no-reporter-hide-prefix', '--parallel', '-r', '--recursive', '--report-summary', '--resume-from', '-c', '--shell-mode', '--stream', '--use-stderr', '-w', '--workspace-root', '--changed-files-ignore-pattern', '--changed-files-ignore-', '--fail-if-no-match', '--filter', '--filter-prod', '--test-pattern'
          break
        }
        break
      }
      '#exec' {
        for ($i = 0; $i -lt $commandAst.CommandElements.Count; $i++) {
          if ($commandAst.CommandElements[$i].ToString().Contains('exec')) {
            $i++
            break
          }
        }
        if ($commandAst.CommandElements.Count -eq $i -or
          ($commandAst.CommandElements.Count -eq ($i + 1) -and
          $cursorPosition -le $commandAst.CommandElements[$i].Extent.EndOffset)) {
          (Get-ChildItem -LiteralPath node_modules/.bin -ea Ignore).BaseName | Sort-Object -Unique
        }
        else {
          $astList = $commandAst.CommandElements | Select-Object -Skip 2
          $commandName = Split-Path -LeafBase $astList[0].Value
          $cursorPosition -= $astList[0].Extent.StartOffset
          $commandAst = [Parser]::ParseInput("$astList", [ref]$null, [ref]$null).EndBlock.Statements[0].PipelineElements[0]
          & (Get-ArgumentCompleter $commandName) $wordToComplete $commandAst $cursorPosition
        }
      }
      'licenses' {
        if ($wordToComplete.StartsWith('-')) {
          '-D', '--dev', '--json', '--long', '--no-optional', '-P', '--prod', '--changed-files-ignore-pattern', '--changed-files-ignore-', '--fail-if-no-match', '--filter', '--filter-prod', '--test-pattern'
          break
        }
        break
      }
      'unlink' {
        if ($wordToComplete.StartsWith('-')) {
          '--aggregate-output', '--workspace-concurrency', '-C', '--dir', '-h', '--help', '--loglevel=debug', '--loglevel=info', '--loglevel=warn', '--loglevel=error', '--silent', '-r', '--recursive', '--stream', '--use-stderr', '-w', '--workspace-root'
          break
        }
        break
      }
      'prune' {
        if ($wordToComplete.StartsWith('-')) {
          '--aggregate-output', '--workspace-concurrency', '-C', '--dir', '-h', '--help', '--ignore-scripts', '--loglevel=debug', '--loglevel=info', '--loglevel=warn', '--loglevel=error', '--silent', '--no-optional', '--prod', '--stream', '--use-stderr', '-w', '--workspace-root'
          break
        }
        break
      }
      'outdated' {
        if ($wordToComplete.StartsWith('-')) {
          '--aggregate-output', '--workspace-concurrency', '--compatible', '-D', '--dev', '-C', '--dir', '--format', '--global-dir', '-h', '--help', '--loglevel=debug', '--loglevel=info', '--loglevel=warn', '--loglevel=error', '--silent', '--long', '--no-optional', '--no-table', '-P', '--prod', '-r', '--recursive', '--sort-by', '--stream', '--use-stderr', '-w', '--workspace-root', '--changed-files-ignore-pattern', '--changed-files-ignore-', '--fail-if-no-match', '--filter', '--filter-prod', '--test-pattern', '--test-pattern'
          break
        }
        break
      }
      'run' {
        if ($wordToComplete.StartsWith('-')) {
          '--color', '--no-color', '--aggregate-output', '-C', '--dir', '-h', '--help', '--if-present', '--loglevel=debug', '--loglevel=info', '--loglevel=warn', '--loglevel=error', '--silent', '--no-bail', '--parallel', '-r', '--recursive', '--report-summary', '--reporter-hide-prefix', '--resume-from', '--sequential', '--stream', '--use-stderr', '-w', '--workspace-root', '--changed-files-ignore-pattern', '--fail-if-no-match', '--filter', '--filter-prod', '--test-pattern', '--test-pattern'
          break
        }
        break
      }
      'pack' {
        if ($wordToComplete.StartsWith('-')) {
          '--json', '--pack-destination'
          break
        }
        break
      }
      'publish' {
        if ($wordToComplete.StartsWith('-')) {
          '--access', '--dry-run', '--force', '--ignore-scripts', '--json', '--no-git-checks', '--otp', '--publish-branch', '-r', '--recursive', '--report-summary', '--tag', '--changed-files-ignore-pattern', '--changed-files-ignore-', '--fail-if-no-match', '--filter', '--filter-prod', '--test-pattern'
        }
        break
      }
      'root' {
        if ($wordToComplete.StartsWith('-')) {
          '-g', '--global'
          break
        }
        break
      }
      'store' {
        if ($wordToComplete.StartsWith('-')) {
          break
        }
        break
        'add', 'path', 'prune', 'status'
      }
      'store prune' {
        if ($wordToComplete.StartsWith('-')) {
          '--force'
          break
        }
        break
      }
      'list' {
        if ($wordToComplete.StartsWith('-')) {
          '--color', '--no-color', '--aggregate-output', '--depth=', '--depth=-1', '--depth=0', '-D', '--dev', '-C', '--dir', '--exclude-peers', '-g', '--global', '--global-dir', '-h', '--help', '--json', '--loglevel=debug', '--loglevel=info', '--loglevel=warn', '--loglevel=error', '--silent', '--long', '--no-optional', '--only-projects', '--parseable', '-P', '--prod', '-r', '--recursive', '--stream', '--use-stderr', '-w', '--workspace-root', '--changed-files-ignore-pattern', '--fail-if-no-match', '--filter', '--filter-prod', '--test-pattern'
          break
        }
        break
      }
      'test' {
        if ($wordToComplete.StartsWith('-')) {
          '-r', '--recursive', '--changed-files-ignore-pattern', '--changed-files-ignore-', '--fail-if-no-match', '--filter', '--filter-prod', '--test-pattern'
          break
        }
        break
      }
      'install' {
        if ($wordToComplete.StartsWith('-')) {
          '--no-frozen-lockfile', '--aggregate-output', '--parallel', '--workspace-concurrency', '--reporter', '--child-concurrency', '-D', '--dev', '-C', '--dir', '--fix-lockfile', '--force', '--global-dir', '-h', '--help', '--hoist-pattern', '--ignore-pnpmfile', '--ignore-scripts', '--ignore-workspace', '--lockfile-dir', '--lockfile-only', '--loglevel=debug', '--loglevel=info', '--loglevel=warn', '--loglevel=error', '--silent', '--silent', '--merge-git-branch-lockfiles', '--modules-dir', '--network-concurrency', '--no-hoist', '--no-lockfile', '--no-optional', '--offline', '--package-import-method', '--package-import-method', '--package-import-method', '--package-import-method', '--prefer-frozen-lockfile', '--prefer-offline', '-P', '--prod', '--public-hoist-pattern', '-r', '--recursive', '--resolution-only', '--shamefully-hoist', '--side-effects-cache', '--side-effects-cache-readonly', '--store-dir', '--stream', '--strict-peer-dependencies', '--use-running-store-server', '--use-stderr', '--use-store-server', '--virtual-store-dir', '-w', '--workspace-root', '--reporter', '--reporter', '--reporter', '-s', '--silent', '--changed-files-ignore-pattern', '--changed-files-ignore-', '--fail-if-no-match', '--filter', '--filter-prod', '--test-pattern'
          break
        }
        break
      }
      'link' {
        if ($wordToComplete.StartsWith('-')) {
          '--aggregate-output', '--workspace-concurrency', '-C', '--dir', '-g', '--global', '-h', '--help', '--loglevel=debug', '--loglevel=info', '--loglevel=warn', '--loglevel=error', '--silent', '--stream', '--use-stderr', '-w', '--workspace-root'
          break
        }
        break
      }
      'rebuild' {
        '--aggregate-output', '--workspace-concurrency', '-C', '--dir', '-h', '--help', '--loglevel=debug', '--loglevel=info', '--loglevel=warn', '--loglevel=error', '--silent', '--pending', '-r', '--recursive', '--store-dir', '--stream', '--use-stderr', '-w', '--workspace-root', '--changed-files-ignore-pattern', '--changed-files-ignore-', '--fail-if-no-match', '--filter', '--filter-prod', '--test-pattern'
        break
      }
      'remove' {
        if ($wordToComplete.StartsWith('-')) {
          '--aggregate-output', '--workspace-concurrency', '-C', '--dir', '-h', '--help', '--loglevel=debug', '--loglevel=info', '--loglevel=warn', '--loglevel=error', '--silent', '--pending', '-r', '--recursive', '--store-dir', '--stream', '--use-stderr', '-w', '--workspace-root', '--changed-files-ignore-pattern', '--changed-files-ignore-', '--fail-if-no-match', '--filter', '--filter-prod', '--test-pattern'
          break
        }
        $json = npm ls --json | ConvertFrom-Json -AsHashtable
        $json.Keys.ForEach{
          if ($_ -clike '*[dD]ependencies') {
            $json.$_.Keys
          }
        }
        break
      }
      'update' {
        if ($wordToComplete.StartsWith('-')) {
          '--aggregate-output', '--workspace-concurrency', '--depth', '-D', '--dev', '-C', '--dir', '-g', '--global', '--global-dir', '-h', '--help', '-i', '--interactive', '-L', '--latest', '--loglevel=debug', '--loglevel=info', '--loglevel=warn', '--loglevel=error', '--silent', '--no-optional', '-P', '--prod', '-r', '--recursive', '--stream', '--use-stderr', '--workspace', '-w', '--workspace-root', '--changed-files-ignore-pattern', '--changed-files-ignore-', '--fail-if-no-match', '--filter', '--filter-prod', '--test-pattern'
          break
        }
        $json = npm ls --json | ConvertFrom-Json -AsHashtable
        $json.Keys.ForEach{
          if ($_ -clike '*[dD]ependencies') {
            $json.$_.Keys
          }
        }
        break
      }
    }).Where{ $_ -like "$wordToComplete*" }
}
