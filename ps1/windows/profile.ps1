function Invoke-ExecutableAlias {
  $cmd, [string[]]$ags = $_executableAliasMap[$MyInvocation.InvocationName]
  if (!$cmd) {
    return Write-Error "command not found $($MyInvocation.InvocationName)"
  }
  $cmd = (Get-Command -CommandType Application -TotalCount 1 -ea Stop $cmd).Source
  $ags += $args
  Write-Debug "$cmd $ags"
  if ($MyInvocation.ExpectingInput) {
    $input | & $cmd $ags
  }
  else {
    & $cmd $ags
  }
}

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
$_executableAliasMap.Keys.ForEach{ Set-Alias $_ Invoke-ExecutableAlias }
