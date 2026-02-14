using namespace System.Management.Automation.Language

Register-ArgumentCompleter -Native -CommandName wasm-pack -ScriptBlock {
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
        { $_ -ceq 'adduser' -or $_ -ceq 'add-user' } { 'login'; break }
        default { $_; break }
      }
      continue
    }
    default { break }
  }
  $command = $commands -join ' '

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
          '-v', '--verbose', '-q', '--quiet', '--log-level=info', '--log-level=warn', '--log-level=error', '-h', '--help', '-V', '--version'
          break
        }
        elseif ($prev.StartsWith('wasm-pack')) {
          'build', 'pack', 'new', 'publish', 'login', 'test', 'help', 'adduser', 'add-user'
          break
        }
        break
      }
      'build' {
        if ($wordToComplete.StartsWith('-')) {
          '-s', '--scope', '-m', '--mode=no-install', '--mode=normal', '--mode=force', '--no-typescript', '--weak-refs', '--reference-types', '-t', '--target=bundler', '--target=nodejs', '--target=web', '--target=no-modules', '--target=deno', '--debug', '--dev', '--release', '--profiling', '--profile', '-d', '--out-dir', '--out-name', '--no-pack', '--no-opt', '-h', '--help'
          break
        }
        break
      }
      'pack' {
        if ($wordToComplete.StartsWith('-')) {
          '-d', '--pkg-dir', '-h', '--help'
          break
        }
        break
      }
      'new' {
        if ($wordToComplete.StartsWith('-')) {
          '-m', '--mode=no-install', '--mode=normal', '--mode=force', '--template=https://github.com/drager/wasm-pack-template', '-h', '--help'
          break
        }
        break
      }
      'publish' {
        if ($wordToComplete.StartsWith('-')) {
          '-t', '--target=bundler', '--target=no-modules', '-a', '--access', '--tag', '-d', '--pkg-dir=pkg', '--pkg-dir=', '-h', '--help'
          break
        }
        break
      }
      'login' {
        if ($wordToComplete.StartsWith('-')) {
          '-r', '--registry', '-s', '--scope', '-t', '--auth-type=legacy', '--auth-type=sso', '--auth-type=saml', '--auth-type=oauth', '-h', '--help'
          break
        }
        break
      }
      'test' {
        if ($wordToComplete.StartsWith('-')) {
          '--node', '--firefox', '--geckodriver', '--chrome', '--chromedriver', '--safari', '--safaridriver', '--headless', '-m', '--mode=no-install', '--mode=normal', '-r', '--release', '-h', '--help'
          break
        }
        break
      }
      'help' {
        if ($wordToComplete.StartsWith('-')) {
          break
        }
        'build', 'pack', 'new', 'publish', 'login', 'test', 'help', 'adduser', 'add-user'
        break
      }
    }).Where{ $_ -like "$wordToComplete*" }
}
