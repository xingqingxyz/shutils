using namespace System.Management.Automation.Language

Register-ArgumentCompleter -Native -CommandName apt -ScriptBlock {
  param ([string]$wordToComplete, [CommandAst]$commandAst, [int]$cursorPosition)
  $command = @(foreach ($i in $commandAst.CommandElements) {
      if ($i.Extent.StartOffset -eq $commandAst.Extent.StartOffset -or $i.Extent.EndOffset -eq $cursorPosition) {
        continue
      }
      if ($i -isnot [StringConstantExpressionAst] -or
        $i.StringConstantType -ne [StringConstantType]::BareWord -or
        $i.Value.StartsWith('-')) {
        break
      }
      $i.Value
    }) -join ' '
  @(if ($wordToComplete.StartsWith('-')) {
      switch ($command) {
        '' {
          '-h', '--help', '-v', '--version'
          break
        }
        { $_ -ceq 'clean' -or $_ -ceq 'autoclean' } {
          '-s', '--simulate', '--dry-run'
          break
        }
        { $_ -cmatch '^(?:install|reinstall|remove|purge|upgrade|dist-upgrade|full-upgrade|autoremove|autopurge)$' } {
          '--show-progress', '--fix-broken', '--purge', '--verbose-versions', '--auto-remove', '-s', '--simulate', '--dry-run', '--download', '--fix-missing', '--fix-policy', '--ignore-hold', '--force-yes', '--trivial-only', '--reinstall', '--solver', '-t', '--target-release', '-d', '--download-only', '-y', '--assume-yes', '--assume-no', '-u', '--show-upgraded', '-m', '--ignore-missing', '-t', '--target-release', '--download', '--fix-missing', '--ignore-hold', '--upgrade', '--only-upgrade', '--allow-change-held-packages', '--allow-remove-essential', '--allow-downgrades', '--print-uris', '--trivial-only', '--remove', '--arch-only', '--allow-unauthenticated', '--allow-insecure-repositories', '--install-recommends', '--install-suggests', '--no-install-recommends', '--no-install-suggests', '--fix-policy'
          break
        }
        'update' {
          '--list-cleanup', '--print-uris', '--allow-insecure-repositories'
          break
        }
        'list' {
          '--installed', '--upgradable', '--manual-installed', '-v', '--verbose', '-a', '--all-versions', '-t', '--target-release'
          break
        }
        'show' {
          '-a', '--all-versions'
          break
        }
        { $_ -ceq 'depends' -or $_ -ceq 'rdepends' } {
          '--important', '--installed', '--pre-depends', '--depends', '--recommends', '--suggests', '--replaces', '--breaks', '--conflicts', '--enhances', '--recurse', '--implicit'
          break
        }
        'search' {
          '-n', '--names-only', '-f', '--full'
          break
        }
        'showsrc' {
          '--only-source'
          break
        }
        'source' {
          '-s', '--simulate', '--dry-run', '-b', '--compile', '--build', '-P', '--build-profiles', '--diff-only', '--debian-only', '--tar-only', '--dsc-only', '-t', '--target-release', '-d', '--download-only', '-y', '--assume-yes', '--assume-no', '-u', '--show-upgraded', '-m', '--ignore-missing', '-t', '--target-release', '--download', '--fix-missing', '--ignore-hold', '--upgrade', '--only-upgrade', '--allow-change-held-packages', '--allow-remove-essential', '--allow-downgrades', '--print-uris', '--trivial-only', '--remove', '--arch-only', '--allow-unauthenticated', '--allow-insecure-repositories', '--install-recommends', '--install-suggests', '--no-install-recommends', '--no-install-suggests', '--fix-policy'
          break
        }
        'build-dep' {
          '-a', '--host-architecture', '-s', '--simulate --dry-run', '-P', '--build-profiles', '-t', '--target-release', '--purge', '--solver', '--download', '--fix-missing', '--ignore-hold', '--upgrade', '--only-upgrade', '--allow-change-held-packages', '--allow-remove-essential', '--allow-downgrades', '--print-uris', '--trivial-only', '--remove', '--arch-only', '--allow-unauthenticated', '--allow-insecure-repositories', '--install-recommends', '--install-suggests', '--no-install-recommends', '--no-install-suggests', '--fix-policy'
          break
        }
        'moo' {
          '--color'
          break
        }
      }
    }
    else {
      switch ($command) {
        '' {
          'list', 'search', 'show', 'showsrc', 'install', 'reinstall', 'remove', 'purge', 'autoremove', 'autopurge', 'update', 'upgrade', 'full-upgrade', 'dist-upgrade', 'edit-sources', 'help', 'source', 'build-dep', 'clean', 'autoclean', 'download', 'changelog', 'moo', 'depends', 'rdepends', 'policy'
          break
        }
        { $_ -ceq 'remove' -or $_ -ceq 'autoremove' } {
          grep -A 1 "Package: $wordToComplete" /var/lib/dpkg/status |
            grep -B 1 -Ee 'ok installed|half-installed|unpacked|half-configured' -Ee '^Essential: yes' |
            awk "/Package: $wordToComplete/ { print `$2 }"
          break
        }
        { $_ -ceq 'purge' -or $_ -ceq 'autopurge' } {
          grep -A 1 "Package: $wordToComplete" /var/lib/dpkg/status |
            grep -B 1 -Ee 'ok installed|half-installed|unpacked|half-configured|config-files' -Ee '^Essential: yes' |
            awk "/Package: $wordToComplete/ { print `$2 }"
          break
        }
        { $_ -ceq 'show' -or $_ -ceq 'list' -or $_ -ceq 'download' -or $_ -ceq 'changelog' -or $_ -ceq 'depends' -or $_ -ceq 'rdepends' -or $_ -ceq 'install' -or $_ -ceq 'uninstall' } {
          apt-cache --no-generate pkgnames $wordToComplete
          break
        }
        { $_ -ceq 'source' -or $_ -ceq 'build-dep' -or $_ -ceq 'showsrc' -or $_ -ceq 'policy' } {
          apt-cache --no-generate pkgnames $wordToComplete
          apt-cache dumpavail | Select-String -Raw "^Source: $wordToComplete" | Sort-Object -Unique | ForEach-Object { $_.Split(' ', 2)[1] }
          break
        }
        'edit-sources' {
          Convert-Path /etc/apt/sources.list.d/*
          break
        }
        'moo' {
          'moo'
          break
        }
      }
    }).Where{ $_ -like "$wordToComplete*" }
}
