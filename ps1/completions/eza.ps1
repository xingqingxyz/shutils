Register-ArgumentCompleter -Native -CommandName eza -ScriptBlock {
  param([string]$wordToComplete, [System.Management.Automation.Language.CommandAst]$commandAst, [int]$cursorPosition)
  $cursorPosition -= $wordToComplete.Length
  foreach ($key in $commandAst.CommandElements) {
    if ($key.Extent.StartOffset -eq $cursorPosition) {
      break
    }
    $prev = $key
  }
  @(switch ($prev.ToString()) {
      '--color-scale' { @('all', 'age', 'size') }
      '--color-scale-mode' { @('fixed', 'gradient') }
      '--absolue' { 'on', 'follow', 'off' }
      '--time-style' { @('default', 'iso', 'long-iso', 'full-iso', 'relative', "'+%Y-%m-%d %H:%M'") }
      { @('-F', '--classify', '--color', '--icons').Contains($_) } { @('auto', 'always', 'never') }
      { @('-t', '--time').Contains($_) } { @('modified', 'accessed', 'created') }
      Default { @('--help', '-v', '--version', '-1', '--oneline', '-l', '--long', '-G', '--grid', '-x', '--across', '-R', '--recurse', '-T', '--tree', '-X', '--dereference', '-F', '--classify', '--color', '--color-scale', '--color-scale-mode', '--icons', '--no-quotes', '--hyperlink', '--absolute', '-w', '--width', '-a', '--all', '-A', '--almost-all', '-d', '--list-dirs', '-L', '--level', '-r', '--reverse', '-s', '--sort', '--group-directories-first', '-D', '--only-dirs', '-f', '--only-files', '-I', '--ignore-glob', '--git-ignore', '-b', '--binary', '-B', '--bytes', '-g', '--group', '--smart-group', '-h', '--header', '-H', '--links', '-i', '--inode', '-m', '--modified', '-M', '--mounts', '-n', '--numeric', '-O', '--flags', '-S', '--blocksize', '-t', '--time', '-u', '--accessed', '-U', '--created', '--changed', '--time-style', '--total-size', '--no-permissions', '-o', '--octal-permissions', '--no-filesize', '--no-user', '--no-time', '--stdin', '--git', '--no-git', '--git-repos', '--git-repos-no-status') }
    }) | Where-Object { $_ -like "$wordToComplete*" }
}
