using namespace System.Management.Automation.Language

Register-ArgumentCompleter -Native -CommandName pnpm -ScriptBlock {
  param([string]$wordToComplete, [CommandAst]$commandAst, [int]$cursorPosition)
  $command = $commandAst.CommandElements | Select-Object -Skip 1 | ForEach-Object {
    if ($_ -isnot [StringConstantExpressionAst] -or
      $_.StringConstantType -ne [StringConstantType]::BareWord -or
      $_.Value.StartsWith('-')) {
      return
    }
    $_.Value
  } | Join-String -Separator ';'
  # $cursorPosition -= $wordToComplete.Length
  # foreach ($key in $commandAst.CommandElements) {
  #   if ($key.Extent.StartOffset -eq $cursorPosition) {
  #     break
  #   }
  #   $prev = $key
  # }
  @(switch ($command) {
      'add' { 
        @('-E', '--save-exact', '--save-workspace-protocol', '--no-save-exact', '--no-save-workspace-protocol', '--aggregate-output', '--workspace-concurrency', '--reporter', '-C', '--dir', '-g', '--global', '--global-dir', '-h', '--help', '--ignore-scripts', '--loglevel', '--offline', '--prefer-offline', '-r', '--recursive', '-D', '--save-dev', '-O', '--save-optional', '--save-peer', '-P', '--save-prod', '--store-dir', '--stream', '--use-stderr', '--virtual-store-dir', '--workspace', '-w', '--workspace-root', '--changed-files-ignore-pattern', '--filter', '--changed-files-ignore-', '--fail-if-no-match', '--filter', '--filter-prod', '--test-pattern', '--test-pattern')
      }
      'audit' {
        @('--audit-level', '-D', '--dev', '--fix', '--ignore-registry-errors', '--json', '--no-optional', '-P', '--prod')
      }
      'exec' {
        @('--color', '--no-color', '--aggregate-output', '--parallel', '--reporter', '-C', '--dir', '-h', '--help', '--loglevel', '--no-reporter-hide-prefix', '--parallel', '-r', '--recursive', '--report-summary', '--resume-from', '-c', '--shell-mode', '--stream', '--use-stderr', '-w', '--workspace-root', '--changed-files-ignore-pattern', '--filter', '--changed-files-ignore-', '--fail-if-no-match', '--filter', '--filter-prod', '--test-pattern', '--test-pattern')    
      }
      'licenses' {
        @('-D', '--dev', '--json', '--long', '--no-optional', '-P', '--prod', '--changed-files-ignore-pattern', '--filter', '--changed-files-ignore-', '--fail-if-no-match', '--filter', '--filter', '--filter', '--filter', '--filter', '--filter', '--filter', '--filter', '--filter', '--filter', '--filter', '--filter-prod', '--test-pattern', '--filter', '--test-pattern')
      }
      'unlink' {
        @('--aggregate-output', '--workspace-concurrency', '-C', '--dir', '-h', '--help', '--loglevel', '-r', '--recursive', '--stream', '--use-stderr', '-w', '--workspace-root')
      }
      'prune' {
        @('--aggregate-output', '--workspace-concurrency', '-C', '--dir', '-h', '--help', '--ignore-scripts', '--loglevel', '--no-optional', '--prod', '--stream', '--use-stderr', '-w', '--workspace-root')
      }
      'outdated' {
        @('--aggregate-output', '--workspace-concurrency', '--compatible', '-D', '--dev', '-C', '--dir', '--format', '--global-dir', '-h', '--help', '--loglevel', '--long', '--no-optional', '--no-table', '-P', '--prod', '-r', '--recursive', '--sort-by', '--stream', '--use-stderr', '-w', '--workspace-root', '--changed-files-ignore-pattern', '--filter', '--changed-files-ignore-', '--fail-if-no-match', '--filter', '--filter-prod', '--test-pattern', '--test-pattern')
      }
      'run' {
        @('--color', '--no-color', '--aggregate-output', '-C', '--dir', '-h', '--help', '--if-present', '--loglevel', '--no-bail', '--parallel', '-r', '--recursive', '--report-summary', '--reporter-hide-prefix', '--resume-from', '--sequential', '--stream', '--use-stderr', '-w', '--workspace-root', '--changed-files-ignore-pattern', '--fail-if-no-match', '--filter', '--filter-prod', '--test-pattern', '--test-pattern')
      }
      'pack' {
        @('--json', '--pack-destination')
      }
      'publish' {
        @('--access', '--dry-run', '--force', '--ignore-scripts', '--json', '--no-git-checks', '--otp', '--publish-branch', '-r', '--recursive', '--report-summary', '--tag', '--changed-files-ignore-pattern', '--filter', '--changed-files-ignore-', '--fail-if-no-match', '--filter', '--filter-prod', '--test-pattern', '--test-pattern')
      }
      'root' {
        @('-g', '--global')
      }
      'store' {
        @('add', 'path', 'prune', 'status')
      }
      'store;prune' {
        @('--force')
      }
      { $_ -eq 'ls' -or $_ -eq 'list' } {
        @('--color', '--no-color', '--aggregate-output', '--workspace-concurrency', '--depth', '-r', '--depth', '--depth', '--depth', '-D', '--dev', '-C', '--dir', '--exclude-peers', '-g', '--global', '--global-dir', '-h', '--help', '--json', '--loglevel', '--long', '--no-optional', '--only-projects', '--parseable', '-P', '--prod', '-r', '--recursive', '--stream', '--use-stderr', '-w', '--workspace-root', '--changed-files-ignore-pattern', '--filter', '--changed-files-ignore-', '--fail-if-no-match', '--filter', '--filter-prod', '--test-pattern', '--test-pattern')
        break
      }
      { $_ -eq 't' -or $_ -eq 'test' } {
        @('-r', '--recursive', '--changed-files-ignore-pattern', '--filter', '--changed-files-ignore-', '--fail-if-no-match', '--filter', '--filter-prod', '--test-pattern', '--test-pattern')
        break
      }
      { @('i', 'install', 'it', 'install-test').Contains($_) } {
        @('--no-frozen-lockfile', '--aggregate-output', '--parallel', '--workspace-concurrency', '--reporter', '--child-concurrency', '-D', '--dev', '-C', '--dir', '--fix-lockfile', '--force', '--global-dir', '-h', '--help', '--hoist-pattern', '--ignore-pnpmfile', '--ignore-scripts', '--ignore-workspace', '--lockfile-dir', '--lockfile-only', '--loglevel', '--silent', '--merge-git-branch-lockfiles', '--modules-dir', '--network-concurrency', '--no-hoist', '--no-lockfile', '--no-optional', '--offline', '--package-import-method', '--package-import-method', '--package-import-method', '--package-import-method', '--prefer-frozen-lockfile', '--prefer-offline', '-P', '--prod', '--public-hoist-pattern', '-r', '--recursive', '--resolution-only', '--shamefully-hoist', '--side-effects-cache', '--side-effects-cache-readonly', '--store-dir', '--stream', '--strict-peer-dependencies', '--use-running-store-server', '--use-stderr', '--use-store-server', '--virtual-store-dir', '-w', '--workspace-root', '--reporter', '--reporter', '--reporter', '-s', '--silent', '--changed-files-ignore-pattern', '--filter', '--changed-files-ignore-', '--fail-if-no-match', '--filter', '--filter', '--filter', '--filter', '--filter', '--filter', '--filter', '--filter', '--filter', '--filter', '--filter', '--filter-prod', '--test-pattern', '--filter', '--test-pattern')
        break
      }
      { $_ -eq 'ln' -or $_ -eq 'link' } {
        @('--aggregate-output', '--workspace-concurrency', '-C', '--dir', '-g', '--global', '-h', '--help', '--loglevel', '--stream', '--use-stderr', '-w', '--workspace-root')
        break
      }
      { $_ -eq 'rb' -or $_ -eq 'rebuild' } {
        @('--aggregate-output', '--workspace-concurrency', '-C', '--dir', '-h', '--help', '--loglevel', '--pending', '-r', '--recursive', '--store-dir', '--stream', '--use-stderr', '-w', '--workspace-root', '--changed-files-ignore-pattern', '--filter', '--changed-files-ignore-', '--fail-if-no-match', '--filter', '--filter', '--filter', '--filter', '--filter', '--filter', '--filter', '--filter', '--filter', '--filter', '--filter', '--filter-prod', '--test-pattern', '--filter', '--test-pattern')
        break
      }
      { $_ -eq 'rm' -or $_ -eq 'remove' } {
        @('--aggregate-output', '--workspace-concurrency', '-C', '--dir', '-h', '--help', '--loglevel', '--pending', '-r', '--recursive', '--store-dir', '--stream', '--use-stderr', '-w', '--workspace-root', '--changed-files-ignore-pattern', '--filter', '--changed-files-ignore-', '--fail-if-no-match', '--filter', '--filter', '--filter', '--filter', '--filter', '--filter', '--filter', '--filter', '--filter', '--filter', '--filter', '--filter-prod', '--test-pattern', '--filter', '--test-pattern')
        break
      }
      { $_ -eq 'up' -or $_ -eq 'update' } {
        @('--aggregate-output', '--workspace-concurrency', '--depth', '-D', '--dev', '-C', '--dir', '-g', '--global', '--global-dir', '-h', '--help', '-i', '--interactive', '-L', '--latest', '--loglevel', '--no-optional', '-P', '--prod', '-r', '--recursive', '--stream', '--use-stderr', '--workspace', '-w', '--workspace-root', '--changed-files-ignore-pattern', '--filter', '--changed-files-ignore-', '--fail-if-no-match', '--filter', '--filter', '--filter', '--filter', '--filter', '--filter', '--filter', '--filter', '--filter', '--filter', '--filter', '--filter-prod', '--test-pattern', '--filter', '--test-pattern')
        break
      }
      Default {
        if ($wordToComplete.StartsWith('-')) {
          @('-r', '--recursive')
        }
        else {
          @('add', 'audit', 'cat-file', 'cat-index', 'exec', 'find-hash', 'i', 'import', 'install-test', 'install', 'it', 'licenses', 'link', 'list', 'ln', 'ls', 'outdated', 'pack', 'prune', 'publish', 'rb', 'rebuild', 'remove', 'rm', 'root', 'run', 'start', 'store', 't', 'test', 'unlink', 'up', 'update')
        }
      }
    }) | Where-Object { $_ -like "$wordToComplete*" }
}
