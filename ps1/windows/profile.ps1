Set-Variable -Option ReadOnly -Force _executableAliasMap @{
  grep     = 'grep', '--color=auto'
  plantuml = 'java', '-jar', "$HOME\tools\plantuml.jar"
  rg       = 'rg', '--hyperlink-format=vscode'
}
if ($env:TERM_PROGRAM -cnotlike 'vscode*') {
  $_executableAliasMap.fd = 'fd', '--hyperlink=auto'
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
  $cmd = (Get-Command $cmd -Type Application -TotalCount 1 -ea Stop).Source
  Write-CommandDebug $cmd $ags
  if ($MyInvocation.ExpectingInput) {
    $input | & $cmd $ags
  }
  else {
    & $cmd $ags
  }
}
