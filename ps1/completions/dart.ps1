using namespace System.Management.Automation.Language

Register-ArgumentCompleter -Native -CommandName dart -ScriptBlock {
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
  $command = $commands -join ' '
  @(
    if ($commands.Count -gt 1 -and $commands[0] -ceq 'pub' -and !'bump unpack workspace'.Contains($commands[1])) {
      [string[]]$words = $commandAst.CommandElements
      for ($i = 0; $i -lt $commandAst.CommandElements.Count; $i++) {
        $extent = $commandAst.CommandElements[$i].Extent
        if ($extent.StartOffset -le $cursorPosition -and $cursorPosition -le $extent.EndOffset) {
          $cursorPosition = ($words[0..$i] | Measure-Object -Sum Length).Sum - $extent.EndOffset + $cursorPosition
          break
        }
      }
      $words[0] = 'flutter'
      $env:COMP_LINE = $words -join ' '
      if ($commandAst.CommandElements[-1].Extent.EndOffset -lt $cursorPosition) {
        $words += ''
        $env:COMP_LINE += ' '
        $cursorPosition = $env:COMP_LINE.Length
      }
      $env:COMP_POINT = $cursorPosition
      flutter completion `-- $words
      Remove-Item -LiteralPath Env:/COMP_LINE, Env:/COMP_POINT
    }
    elseif ($wordToComplete.StartsWith('-')) {
      '-v', '--verbose', '--version', '--enable-analytics', '--disable-analytics', '--suppress-analytics', '-h', '--help'
      switch ($command) {
        'analyze' {
          '--fatal-infos', '--fatal-warnings', '--no-fatal-warnings'
          break
        }
        'create' {
          '-t', '--template=cli', '--template=console', '--template=package', '--template=server-shelf', '--template=web', '--pub', '--no-pub', '--force'
          break
        }
        'devtools' {
          '--version', '-v', '--verbose', '--host=localhost', '--port=9100', '--dtd-uri=', '--dtd-exposed-uri=', '--launch-browser', '--no-launch-browser', '--machine', '--record-memory-profile=', '--app-size-base=', '--disable-cors', '--no-disable-cors', '-h', '--help'
          break
        }
        'doc' {
          '-o', '--output=', '--validate-links', '--dry-run'
          break
        }
        'fix' {
          '-n', '--dry-run', '--apply', '--code='
          break
        }
        'format' {
          '-v', '--verbose', '-o', '--output=write', '--output=show', '--output=json', '--output=none', '--set-exit-if-changed'
          break
        }
        'info' {
          '--remove-file-paths', '--no-remove-file-paths'
          break
        }
        'pub' {
          '-v', '--verbose', '--color', '--no-color', '-C', '--directory=.'
          break
        }
        'pub unpack' {
          '-f', '--force', '--no-force', '-o', '--output=.'
          break
        }
        'pub workspace list' {
          '--json'
          break
        }
        'run' {
          '--observe=', '--enable-asserts', '--no-enable-asserts', '--verbosity=error', '--verbosity=warning', '--verbosity=info', '--verbosity=all'
          break
        }
        { $_ -ceq 'compile aot-snapshot' -or $_ -ceq 'compile exe' } {
          '-o', '--output', '--verbosity=error', '--verbosity=warning', '--verbosity=info', '--verbosity=all', '-D', '--define=', '--enable-asserts', '-p', '--packages=', '-S', '--save-debugging-info=', '--depfile=', '--target-os=android', '--target-os=fuchsia', '--target-os=ios', '--target-os=linux', '--target-os=macos', '--target-os=windows', '--target-arch', '--target-arch=arm', '--target-arch=arm64', '--target-arch=ia32', '--target-arch=riscv32', '--target-arch=riscv64', '--target-arch=x64'
          break
        }
        'compile jit-snapshot' {
          '-o', '--output', '--verbosity=error', '--verbosity=warning', '--verbosity=info', '--verbosity=all', '-D', '--define=', '--enable-asserts', '-p', '--packages='
          break
        }
        'compile js' {
          '-v', '/h', '/?', '-o', '--output=', '-m', '--minify', '--enable-asserts', '-v', '--verbose', '-D', '--define=', '--version', '--packages=', '--suppress-warnings', '--fatal-warnings', '--suppress-hints', '--enable-diagnostic-colors', '--terse', '--show-package-warnings', '--csp', '--no-source-maps', '--omit-late-names', '--native-null-assertions', '--disable-inlining', '--disable-type-inference', '--disable-rti-optimizations', '--minify', '--lax-runtime-type-to-string', '--omit-late-names', '--omit-implicit-checks', '--trust-primitives', '--omit-implicit-checks', '--trust-primitives', '--lax-runtime-type-to-string', '--throw-on-error', '--libraries-spec=', '--disable-native-live-type-analysis', '--server-mode', '--categories=Server', '--deferred-map=', '--dump-info', '--dump-info=json', '--dump-info=binary', '--generate-code-with-compile-time-errors', '--no-frequency-based-minification'
          break
        }
        'compile kernel' {
          '-o', '--output', '--verbosity=error', '--verbosity=warning', '--verbosity=info', '--verbosity=all', '-p', '--packages=', '--link-platform', '--no-link-platform', '--embed-sources', '--no-embed-sources', '-D', '--define=', '--depfile='
          break
        }
        'compile wasm' {
          '-o', '--output', '-v', '--verbose', '--enable-asserts', '--source-maps', '--no-source-maps', '-D', '--define='
          break
        }
      }
    }
    else {
      switch ($command) {
        '' {
          'analyze', 'create', 'devtools', 'doc', 'fix', 'format', 'info', 'pub', 'run', 'test', 'compile'
          break
        }
        'pub' {
          'add', 'bump', 'cache', 'deps', 'downgrade', 'get', 'global', 'login', 'logout', 'outdated', 'publish', 'remove', 'token', 'unpack', 'upgrade', 'workspace'
          break
        }
        'pub bump' {
          'breaking', 'major', 'minor', 'patch'
          break
        }
        'pub workspace' {
          'list'
          break
        }
      }
    }
  ).Where{ $_ -like "$wordToComplete*" }
}
