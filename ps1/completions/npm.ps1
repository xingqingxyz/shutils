using namespace System.Management.Automation.Language

function npmConfigKeys {
  @('_auth', 'access', 'all', 'allow-same-version', 'audit', 'audit-level', 'auth-type', 'before', 'bin-links', 'browser', 'ca', 'cache', 'cafile', 'call', 'cidr', 'color', 'commit-hooks', 'cpu', 'depth', 'description', 'diff', 'diff-dst-prefix', 'diff-ignore-all-space', 'diff-name-only', 'diff-no-prefix', 'diff-src-prefix', 'diff-text', 'diff-unified', 'dry-run', 'editor', 'engine-strict', 'expect-result-count', 'expect-results', 'fetch-retries', 'fetch-retry-factor', 'fetch-retry-maxtimeout', 'fetch-retry-mintimeout', 'fetch-timeout', 'force', 'foreground-scripts', 'format-package-lock', 'fund', 'git', 'git-tag-version', 'global', 'globalconfig', 'heading', 'https-proxy', 'if-present', 'ignore-scripts', 'include', 'include-staged', 'include-workspace-root', 'init-author-email', 'init-author-name', 'init-author-url', 'init-license', 'init-module', 'init-version', 'install-links', 'install-strategy', 'json', 'legacy-peer-deps', 'libc', 'link', 'local-address', 'location', 'lockfile-version', 'loglevel', 'logs-dir', 'logs-max', 'long', 'maxsockets', 'message', 'node-options', 'noproxy', 'offline', 'omit', 'omit-lockfile-registry-resolved', 'os', 'otp', 'pack-destination', 'package', 'package-lock', 'package-lock-only', 'parseable', 'prefer-dedupe', 'prefer-offline', 'prefer-online', 'prefix', 'preid', 'progress', 'provenance', 'provenance-file', 'proxy', 'read-only', 'rebuild-bundle', 'registry', 'replace-registry-host', 'save', 'save-bundle', 'save-dev', 'save-exact', 'save-optional', 'save-peer', 'save-prefix', 'save-prod', 'sbom-format', 'sbom-type', 'scope', 'script-shell', 'searchexclude', 'searchlimit', 'searchopts', 'searchstaleness', 'shell', 'sign-git-commit', 'sign-git-tag', 'strict-peer-deps', 'strict-ssl', 'tag', 'tag-version-prefix', 'timing', 'umask', 'unicode', 'update-notifier', 'usage', 'user-agent', 'userconfig', 'version', 'versions', 'viewer', 'which', 'workspace', 'workspaces', 'workspaces-update', 'yes', 'also', 'cache-max', 'cache-min', 'cert', 'dev', 'global-style', 'init.author.email', 'init.author.name', 'init.author.url', 'init.license', 'init.module', 'init.version', 'key', 'legacy-bundling', 'only', 'optional', 'production', 'shrinkwrap')
}

Register-ArgumentCompleter -Native -CommandName npm -ScriptBlock {
  param([string]$wordToComplete, [CommandAst]$commandAst, [int]$cursorPosition)
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

  if ($npm -ne 'npm' -and $commandAst.CommandElements[0].ToString() -eq 'npm') {
    $line = "$($commandAst.CommandElements)"
    [Microsoft.PowerShell.PSConsoleReadLine]::Replace($commandAst.CommandElements[0].Extent.StartOffset, $line.Length, [regex]::Replace($line, '^\S+', $npm))
    return ''
  }

  $cursorPosition -= $wordToComplete.Length
  foreach ($i in $commandAst.CommandElements) {
    if ($i.Extent.StartOffset -ge $cursorPosition) {
      break
    }
    $prev = $i
  }
  $prev = $prev.ToString()

  $commands[0] = switch ($commands[0]) {
    'c' { 'config'; break }
    'ln' { 'link'; break }
    { @('add', 'i', 'in', 'ins', 'inst', 'insta', 'instal', 'isnt', 'isnta', 'isntal', 'isntall', 'up', 'update', 'upgrade').Contains($_) } { 'install'; break }
    { @('rm', 'r', 'un', 'unlink', 'remove').Contains($_) } { 'uninstall'; break }
    Default { $_ }
  }
  switch ($commands[0]) {
    'config' {
      $commands[1] = switch ($commands[1]) {
        'ls' { 'list'; break }
        Default { $_ }
      }
    }
  }
  $command = $commands -join ';'
  @(switch ($command) {
      '' {
        if ($wordToComplete.StartsWith('-')) {
          @('-l', '-h', '--help', '--version', '--json', '--parseable', '--long', '--short', '--silent', '--global', '--depth', '--shrinkwrap', '--link', '--dry-run', '--force', '--global-style', '--legacy-bundling', '--strict-ssl', '--userconfig', '--tag', '--access', '--otp', '--scope', '--auth-type', '--always-auth', '--auth', '--registry', '--cache', '--tmp', '--shell', '--bin-links', '--global-style', '--no-global-style', '--no-bin-links', '--no-optional', '--no-shrinkwrap', '--no-package-lock')
        }
        else {
          @('access', 'adduser', 'audit', 'bugs', 'cache', 'ci', 'completion', 'config', 'dedupe', 'deprecate', 'diff', 'dist-tag', 'docs', 'doctor', 'edit', 'exec', 'explain', 'explore', 'find-dupes', 'fund', 'get', 'help-search', 'help,', 'hook', 'init', 'install', 'install-ci-test', 'install-test', 'link', 'll', 'login', 'logout', 'ls', 'org', 'outdated', 'owner', 'pack', 'ping', 'pkg', 'prefix', 'profile', 'prune', 'publish', 'query', 'rebuild', 'repo', 'restart', 'root', 'run-script', 'sbom,', 'search', 'set', 'shrinkwrap', 'star', 'stars', 'start', 'stop', 'team', 'test', 'token', 'uninstall', 'unpublish', 'unstar', 'update', 'version,', 'view', 'whoami')
        }
      }
      'install' {
        if ($wordToComplete.StartsWith('-')) {
          @('-S', '--save', '--no-save', '--save-prod', '--save-dev', '--save-optional', '--save-peer', '--save-bundle', '-E', '--save-exact', '-g', '--global', '--install-strategy', 'nested', 'shallow', '--legacy-bundling', '--global-style', '--omit', '--include', '--include', '--strict-peer-deps', '--prefer-dedupe', '--no-package-lock', '--package-lock-only', '--foreground-scripts', '--ignore-scripts', '--no-audit', '--no-bin-links', '--no-fund', '--dry-run', '--cpu', '--os', '--libc', '-w', '--workspace', '-ws', '--workspaces', '--include-workspace-root', '--install-links')
          break
        }
        if ($prev.startsWith('-')) {
          $prev = switch ($prev) {
            '-g' { '--global'; break }
            '-w' { '--workspace'; break }
            '-ws' { '--workspaces'; break }
            '-S' { '--save'; break }
            '-D' { '--save-dev'; break }
            '-P' { '--save-prod'; break }
            '-O' { '--save-optional'; break }
            '-E' { '--save-exact'; break }
            '-E' { '--save-bundle'; break }
            '--include' { '--omit'; break }
            Default { $prev }
          }
          switch ($prev) {
            '--cpu' { @('arm', 'arm64', 'ia32', 'loong64', 'mips', 'mipsel', 'ppc', 'ppc64', 'riscv64', 's390', 's390x', 'x64'); break }
            '--os' { @('aix' , 'darwin' , 'freebsd' , 'linux' , 'openbsd', 'sunos' , 'win32'); break }
            '--workspace' { @(); break }
            '--omit' { @('prod', 'dev', 'optional', 'peer'); break }
            '--install-strategy' { @('hoisted', 'nested', 'shallow', 'linked'); break }
          }
        }
      }
      'uninstall' {
        if ($wordToComplete.StartsWith('-')) {
          @('-S', '--save', '--no-save', '--save-prod', '--save-dev', '--save-optional', '--save-peer', '--save-bundle', '-g', '--global', '-w', '--workspace', '-ws', '--workspaces', '--include-workspace-root', '--install-links')
          break
        }
        switch ($prev) {
          '--workspace' { @(); break }
        }
      }
      'config' {
        if ($wordToComplete.StartsWith('-')) {
          @('-h', '--help', '-g', '--global', '--json', '-L', '--location', '-l', '--long', '--editor')
        }
        elseif ($prev -eq 'config') {
          @('get', 'set', 'delete', 'ls', 'list', 'edit', 'fix')
        }
        elseif ($prev.StartsWith('-')) {
          $prev = switch ($prev) {
            '-a' { '--all'; break }
            '--enjoy-by' { '--before'; break }
            '-c' { '--call'; break }
            '--desc' { '--description'; break }
            '-f' { '--force'; break }
            '-g' { '--global'; break }
            '--iwr' { '--include-workspace-root'; break }
            '-L' { '--location'; break }
            '-d' { '--loglevel info'; break }
            '-s' { '--loglevel silent'; break }
            '--silent' { '--loglevel silent'; break }
            '--ddd' { '--loglevel silly'; break }
            '--dd' { '--loglevel verbose'; break }
            '--verbose' { '--loglevel verbose'; break }
            '-q' { '--loglevel warn'; break }
            '--quiet' { '--loglevel warn'; break }
            '-l' { '--long'; break }
            '-m' { '--message'; break }
            '--local' { '--no-global'; break }
            '-n' { '--no-yes'; break }
            '--no' { '--no-yes'; break }
            '-p' { '--parseable'; break }
            '--porcelain' { '--parseable'; break }
            '-C' { '--prefix'; break }
            '--readonly' { '--read-only'; break }
            '--reg' { '--registry'; break }
            '-S' { '--save'; break }
            '-B' { '--save-bundle'; break }
            '-D' { '--save-dev'; break }
            '-E' { '--save-exact'; break }
            '-O' { '--save-optional'; break }
            '-P' { '--save-prod'; break }
            '-?' { '--usage'; break }
            '-h' { '--usage'; break }
            '-H' { '--usage'; break }
            '--help' { '--usage'; break }
            '-v' { '--version'; break }
            '-w' { '--workspace'; break }
            '--ws' { '--workspaces'; break }
            '-y' { '--yes'; break }
            Default { $prev }
          }
          switch ($prev) {
            '--loglevel' { @('silent', 'warn', 'error', 'info', 'verbose', 'silly') }
            '--location' { @('global', 'user', 'project') }
          }
        }
        break
      }
      'config;get' {
        if ($wordToComplete.StartsWith('-')) {
          @('-h', '--help', '-g', '--global', '--json', '-L', '--location', '-l', '--long', '--editor')
          break
        }
        npmConfigKeys
      }
      'config;set' {
        if ($wordToComplete.StartsWith('-')) {
          @('-h', '--help', '-g', '--global', '--json', '-L', '--location', '-l', '--long', '--editor')
          break
        }
        elseif ($wordToComplete.Contains('=')) {
          ''
          break
        }
        npmConfigKeys
      }
      'config;delete' {
        if ($wordToComplete.StartsWith('-')) {
          @('-h', '--help', '-g', '--global', '--json', '-L', '--location', '-l', '--long', '--editor')
          break
        }
        npmConfigKeys
      }
      'config;list' {
        if ($wordToComplete.StartsWith('-')) {
          @('-h', '--help', '-g', '--global', '--json', '-L', '--location', '-l', '--long', '--editor')
        }
      }
      'config;edit' {
        if ($wordToComplete.StartsWith('-')) {
          @('-h', '--help', '-g', '--global', '--json', '-L', '--location', '-l', '--long', '--editor')
        }
      }
      'config;fix' {
        if ($wordToComplete.StartsWith('-')) {
          @('-h', '--help', '-g', '--global', '--json', '-L', '--location', '-l', '--long', '--editor')
        }
      }
    }) | Where-Object { $_ -like "$wordToComplete*" }
}
