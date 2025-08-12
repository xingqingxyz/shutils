using namespace System.Security.Principal

function Invoke-ExecutableAlias {
  $command = $MyInvocation.InvocationName
  if ($command -eq '&') {
    $command = ($MyInvocation.Statement -split '\s+', 3)[1]
  }
  $command, [string[]]$arguments = $_executableAliasMap.$command
  $command = (Get-Command -Type Application -TotalCount 1 -ea Stop $command).Path
  $arguments += $args
  Write-Debug "$command $arguments"
  if ($MyInvocation.ExpectingInput) {
    $input | & $command $arguments
  }
  else {
    & $command $arguments
  }
}

# utf-8 process
[System.Console]::InputEncoding = [System.Console]::OutputEncoding = [System.Text.Encoding]::UTF8
Set-Alias bat Windows\bat
Set-Alias rsync 'C:\Program Files\Microsoft Visual Studio\2022\Community\Common7\IDE\VC\Linux\bin\rsync\rsync.exe'
Set-Variable -Option ReadOnly -Force _executableAliasMap @{
  grep = 'grep', '--color=auto'
}
if ($env:TERM_PROGRAM -notlike 'vscode*') {
  $_executableAliasMap.fd = 'fd', '--hyperlink=auto'
  $_executableAliasMap.rg = 'rg', '--hyperlink-format=default'
}
$_executableAliasMap.Keys.ForEach{ Set-Alias $_ Invoke-ExecutableAlias }
