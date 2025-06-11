using namespace System.Management.Automation.Language

Register-ArgumentCompleter -Native -CommandName pnpm -ScriptBlock {
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
  # foreach ($i in $commandAst.CommandElements) {
  #   if ($i.Extent.StartOffset -ge $cursorPosition) {
  #     break
  #   }
  #   $prev = $i
  # }
  # $prev = $prev.ToString()
  $command = switch ($command) {
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
    Default { $command }
  }
  @(switch ($command) {
      '' {
        if ($wordToComplete.StartsWith('-')) {
          @('-r', '--recursive')
        }
        else {
          @('add', 'audit', 'cat-file', 'cat-index', 'exec', 'find-hash', 'help', 'i', 'import', 'install-test', 'install', 'it', 'licenses', 'link', 'list', 'ln', 'ls', 'outdated', 'pack', 'prune', 'publish', 'rb', 'rebuild', 'remove', 'rm', 'root', 'run', 'start', 'store', 't', 'test', 'unlink', 'up', 'update')
        }
      }
      'add' {
        if ($wordToComplete.StartsWith('-')) {
          @('-E', '--save-exact', '--save-workspace-protocol', '--no-save-exact', '--no-save-workspace-protocol', '--aggregate-output', '--workspace-concurrency', '--reporter', '-C', '--dir', '-g', '--global', '--global-dir', '-h', '--help', '--ignore-scripts', '--loglevel', '--offline', '--prefer-offline', '-r', '--recursive', '-D', '--save-dev', '-O', '--save-optional', '--save-peer', '-P', '--save-prod', '--store-dir', '--stream', '--use-stderr', '--virtual-store-dir', '--workspace', '-w', '--workspace-root', '--changed-files-ignore-pattern', '--filter', '--changed-files-ignore-', '--fail-if-no-match', '--filter', '--filter-prod', '--test-pattern', '--test-pattern')
        }
      }
      'audit' {
        @('--audit-level', '-D', '--dev', '--fix', '--ignore-registry-errors', '--json', '--no-optional', '-P', '--prod')
      }
      'exec' {
        if ($wordToComplete.StartsWith('-')) {
          @('--color', '--no-color', '--aggregate-output', '--parallel', '--reporter', '-C', '--dir', '-h', '--help', '--loglevel', '--no-reporter-hide-prefix', '--parallel', '-r', '--recursive', '--report-summary', '--resume-from', '-c', '--shell-mode', '--stream', '--use-stderr', '-w', '--workspace-root', '--changed-files-ignore-pattern', '--filter', '--changed-files-ignore-', '--fail-if-no-match', '--filter', '--filter-prod', '--test-pattern', '--test-pattern')
        }
        else {
          (Get-ChildItem node_modules/.bin -ea Ignore).BaseName | Select-Object -Unique
        }
      }
      'licenses' {
        if ($wordToComplete.StartsWith('-')) {
          @('-D', '--dev', '--json', '--long', '--no-optional', '-P', '--prod', '--changed-files-ignore-pattern', '--filter', '--changed-files-ignore-', '--fail-if-no-match', '--filter', '--filter', '--filter', '--filter', '--filter', '--filter', '--filter', '--filter', '--filter', '--filter', '--filter', '--filter-prod', '--test-pattern', '--filter', '--test-pattern')
        }
      }
      'unlink' {
        if ($wordToComplete.StartsWith('-')) {
          @('--aggregate-output', '--workspace-concurrency', '-C', '--dir', '-h', '--help', '--loglevel', '-r', '--recursive', '--stream', '--use-stderr', '-w', '--workspace-root')
        }
      }
      'prune' {
        if ($wordToComplete.StartsWith('-')) {
          @('--aggregate-output', '--workspace-concurrency', '-C', '--dir', '-h', '--help', '--ignore-scripts', '--loglevel', '--no-optional', '--prod', '--stream', '--use-stderr', '-w', '--workspace-root')
        }
      }
      'outdated' {
        if ($wordToComplete.StartsWith('-')) {
          @('--aggregate-output', '--workspace-concurrency', '--compatible', '-D', '--dev', '-C', '--dir', '--format', '--global-dir', '-h', '--help', '--loglevel', '--long', '--no-optional', '--no-table', '-P', '--prod', '-r', '--recursive', '--sort-by', '--stream', '--use-stderr', '-w', '--workspace-root', '--changed-files-ignore-pattern', '--filter', '--changed-files-ignore-', '--fail-if-no-match', '--filter', '--filter-prod', '--test-pattern', '--test-pattern')
        }
      }
      'run' {
        if ($wordToComplete.StartsWith('-')) {
          @('--color', '--no-color', '--aggregate-output', '-C', '--dir', '-h', '--help', '--if-present', '--loglevel', '--no-bail', '--parallel', '-r', '--recursive', '--report-summary', '--reporter-hide-prefix', '--resume-from', '--sequential', '--stream', '--use-stderr', '-w', '--workspace-root', '--changed-files-ignore-pattern', '--fail-if-no-match', '--filter', '--filter-prod', '--test-pattern', '--test-pattern')
        }
      }
      'pack' {
        if ($wordToComplete.StartsWith('-')) {
          @('--json', '--pack-destination')
        }
      }
      'publish' {
        if ($wordToComplete.StartsWith('-')) {
          @('--access', '--dry-run', '--force', '--ignore-scripts', '--json', '--no-git-checks', '--otp', '--publish-branch', '-r', '--recursive', '--report-summary', '--tag', '--changed-files-ignore-pattern', '--filter', '--changed-files-ignore-', '--fail-if-no-match', '--filter', '--filter-prod', '--test-pattern', '--test-pattern')
        }
      }
      'root' {
        if ($wordToComplete.StartsWith('-')) {
          @('-g', '--global')
        }
      }
      'store' {
        @('add', 'path', 'prune', 'status')
      }
      'store;prune' {
        @('--force')
      }
      'list' {
        @('--color', '--no-color', '--aggregate-output', '--workspace-concurrency', '--depth', '-r', '--depth', '--depth', '--depth', '-D', '--dev', '-C', '--dir', '--exclude-peers', '-g', '--global', '--global-dir', '-h', '--help', '--json', '--loglevel', '--long', '--no-optional', '--only-projects', '--parseable', '-P', '--prod', '-r', '--recursive', '--stream', '--use-stderr', '-w', '--workspace-root', '--changed-files-ignore-pattern', '--filter', '--changed-files-ignore-', '--fail-if-no-match', '--filter', '--filter-prod', '--test-pattern', '--test-pattern')
        break
      }
      'test' {
        @('-r', '--recursive', '--changed-files-ignore-pattern', '--filter', '--changed-files-ignore-', '--fail-if-no-match', '--filter', '--filter-prod', '--test-pattern', '--test-pattern')
        break
      }
      'install' {
        if ($wordToComplete.StartsWith('-')) {
          @('--no-frozen-lockfile', '--aggregate-output', '--parallel', '--workspace-concurrency', '--reporter', '--child-concurrency', '-D', '--dev', '-C', '--dir', '--fix-lockfile', '--force', '--global-dir', '-h', '--help', '--hoist-pattern', '--ignore-pnpmfile', '--ignore-scripts', '--ignore-workspace', '--lockfile-dir', '--lockfile-only', '--loglevel', '--silent', '--merge-git-branch-lockfiles', '--modules-dir', '--network-concurrency', '--no-hoist', '--no-lockfile', '--no-optional', '--offline', '--package-import-method', '--package-import-method', '--package-import-method', '--package-import-method', '--prefer-frozen-lockfile', '--prefer-offline', '-P', '--prod', '--public-hoist-pattern', '-r', '--recursive', '--resolution-only', '--shamefully-hoist', '--side-effects-cache', '--side-effects-cache-readonly', '--store-dir', '--stream', '--strict-peer-dependencies', '--use-running-store-server', '--use-stderr', '--use-store-server', '--virtual-store-dir', '-w', '--workspace-root', '--reporter', '--reporter', '--reporter', '-s', '--silent', '--changed-files-ignore-pattern', '--filter', '--changed-files-ignore-', '--fail-if-no-match', '--filter', '--filter', '--filter', '--filter', '--filter', '--filter', '--filter', '--filter', '--filter', '--filter', '--filter', '--filter-prod', '--test-pattern', '--filter', '--test-pattern')
        }
        break
      }
      'link' {
        if ($wordToComplete.StartsWith('-')) {
          @('--aggregate-output', '--workspace-concurrency', '-C', '--dir', '-g', '--global', '-h', '--help', '--loglevel', '--stream', '--use-stderr', '-w', '--workspace-root')
        }
        break
      }
      'rebuild' {
        @('--aggregate-output', '--workspace-concurrency', '-C', '--dir', '-h', '--help', '--loglevel', '--pending', '-r', '--recursive', '--store-dir', '--stream', '--use-stderr', '-w', '--workspace-root', '--changed-files-ignore-pattern', '--filter', '--changed-files-ignore-', '--fail-if-no-match', '--filter', '--filter', '--filter', '--filter', '--filter', '--filter', '--filter', '--filter', '--filter', '--filter', '--filter', '--filter-prod', '--test-pattern', '--filter', '--test-pattern')
        break
      }
      'remove' {
        if ($wordToComplete.StartsWith('-')) {
          @('--aggregate-output', '--workspace-concurrency', '-C', '--dir', '-h', '--help', '--loglevel', '--pending', '-r', '--recursive', '--store-dir', '--stream', '--use-stderr', '-w', '--workspace-root', '--changed-files-ignore-pattern', '--filter', '--changed-files-ignore-', '--fail-if-no-match', '--filter', '--filter', '--filter', '--filter', '--filter', '--filter', '--filter', '--filter', '--filter', '--filter', '--filter', '--filter-prod', '--test-pattern', '--filter', '--test-pattern')
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
      'update' {
        if ($wordToComplete.StartsWith('-')) {
          @('--aggregate-output', '--workspace-concurrency', '--depth', '-D', '--dev', '-C', '--dir', '-g', '--global', '--global-dir', '-h', '--help', '-i', '--interactive', '-L', '--latest', '--loglevel', '--no-optional', '-P', '--prod', '-r', '--recursive', '--stream', '--use-stderr', '--workspace', '-w', '--workspace-root', '--changed-files-ignore-pattern', '--filter', '--changed-files-ignore-', '--fail-if-no-match', '--filter', '--filter', '--filter', '--filter', '--filter', '--filter', '--filter', '--filter', '--filter', '--filter', '--filter', '--filter-prod', '--test-pattern', '--filter', '--test-pattern')
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
