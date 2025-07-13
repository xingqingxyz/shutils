using namespace System.Security.Principal

function Invoke-ExecutableAlias {
  $cmd, [string[]]$arguments = $_executableAliasMap[$MyInvocation.InvocationName]
  $cmd = (Get-Command -Type Application -TotalCount 1 -ea Stop $cmd).Path
  $arguments += $args
  Write-Debug "$cmd $arguments"
  if ($MyInvocation.ExpectingInput) {
    $input | & $cmd @arguments
  }
  else {
    & $cmd @arguments
  }
}

# utf-8 process
[System.Console]::InputEncoding = [System.Console]::OutputEncoding = [System.Text.Encoding]::UTF8
Set-Alias rsync 'C:\Program Files\Microsoft Visual Studio\2022\Community\Common7\IDE\VC\Linux\bin\rsync\rsync.exe'
$_executableAliasMap = @{
  grep = 'grep', '--color=auto'
}
if ($env:TERM_PROGRAM -notlike 'vscode*') {
  $_executableAliasMap += @{
    fd = 'fd', '--hyperlink=auto'
    rg = 'rg', '--hyperlink-format=default'
  }
}
$_executableAliasMap.Keys.ForEach{ Set-Alias $_ Invoke-ExecutableAlias }
