# aliases from ~/.bashrc
if ($IsLinux -and (Test-Path ~/.bashrc)) {
  $__alias_handle_arguments = @{}
  function _handleAlias {
    /usr/bin/env $__alias_handle_arguments[$MyInvocation.InvocationName] $args
  }
  function alias {
    foreach ($arg in $args) {
      $cmd, $rest = $arg.Split('=', 2)
      Write-Output $rest.gettype()
      $__alias_handle_arguments[$cmd] = if ($rest.Contains(' ')) {
        $rest -split '\s+'
      }
      else { $rest }
      Set-Alias $cmd _handleAlias
    }
  }
  Get-Content ~/.bashrc | Where-Object {
    $_.StartsWith('alias ')
  } | Invoke-Expression
  Remove-Item Function:alias
}
