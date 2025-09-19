# utf-8 process
[System.Console]::InputEncoding = [System.Console]::OutputEncoding = [System.Text.Encoding]::UTF8
Set-Alias bash 'C:\Program Files\Git\usr\bin\bash.exe'
Set-Alias rsync 'C:\Program Files\Microsoft Visual Studio\2022\Community\Common7\IDE\VC\Linux\bin\rsync\rsync.exe'
Set-Variable -Option ReadOnly -Force _executableAliasMap @{
  grep     = 'grep', '--color=auto'
  plantuml = 'java', '-jar', "$HOME/tools/plantuml.jar"
}
if ($env:TERM_PROGRAM -notlike 'vscode*') {
  $_executableAliasMap.fd = 'fd', '--hyperlink=auto'
  $_executableAliasMap.rg = 'rg', '--hyperlink-format=default'
}
Set-Item -LiteralPath $_executableAliasMap.Keys.ForEach{ "Function:$_" } {
  # prevent . invoke variable add
  if ($MyInvocation.InvocationName -eq '.') {
    return & $MyInvocation.MyCommand $args
  }
  $cmd = $MyInvocation.MyCommand.Name
  if (!$_executableAliasMap.Contains($cmd)) {
    return Write-Error "alias not set $cmd"
  }
  # flat iterator args for native passing
  $cmd, $ags = @($_executableAliasMap.$cmd; $args.ForEach{ $_ })
  $cmd = Get-Command $cmd -Type Application -TotalCount 1 -ea Stop
  Write-Debug "$($cmd.Source) $ags"
  if ($MyInvocation.ExpectingInput) {
    $input | & $cmd $ags
  }
  else {
    & $cmd $ags
  }
}
