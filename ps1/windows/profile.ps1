using namespace System.Security.Principal

function winget {
  if ($args.Length -gt 1 -and
    @('install', 'upgrade', 'update', 'import', 'uninstall').Contains($args[0]) -and
    ![WindowsPrincipal]::new([WindowsIdentity]::GetCurrent()).IsInRole([WindowsBuiltInRole]::Administrator)) {
    throw 'needs to be run as administrator'
  }
  winget.exe @args
}

function Invoke-ExecutableAlias {
  $cmd, $ags = $_executableAliasMap[$MyInvocation.InvocationName]
  $cmd = (Get-Command -Type Application -TotalCount 1 -ea Stop $cmd).Path
  Write-Debug "$cmd $ags $args"
  if ($MyInvocation.ExpectingInput) {
    $input | & $cmd @ags @args
  }
  else {
    & $cmd @ags @args
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
