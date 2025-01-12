Set-Alias ls Get-ChildItem
# aliases from ~/.bashrc
if (Test-Path ~/.bashrc) {
  $__alias_arguments_map = @{}
  function _handleAlias {
    /usr/bin/env $__alias_arguments_map[$MyInvocation.InvocationName] @args
  }
  function alias {
    foreach ($arg in $args) {
      $cmd, $rest = $arg.Split('=', 2)
      $__alias_arguments_map[$cmd] = if ($rest.Contains(' ')) { $rest -split '\s+' } else { $rest }
      Set-Alias $cmd _handleAlias
    }
  }
  (Get-Content -Raw ~/.bashrc | Select-String '^alias ').Line | Out-String | Invoke-Expression
  Remove-Item Function:alias
}
