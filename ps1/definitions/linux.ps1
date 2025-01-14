# alias from interactive bash
$__alias_arguments_map = @{}
function _handleAlias {
  /usr/bin/env $__alias_arguments_map[$MyInvocation.InvocationName] @args
}
bash -ic alias 2>$null | ForEach-Object {
  $first, $second = $_.Split(' ', 2)[1].Split('=', 2)
  $__alias_arguments_map[$first] = $second.SubString(1, $second.Length - 2).Split(' ')
  Set-Alias $first _handleAlias
}
# remove can't use aliases
Set-Alias ls Get-ChildItem
Remove-Alias l., which -ErrorAction Ignore
