$content = if ($args.Length) {
  Get-Content $args[0]
}
elseif ($MyInvocation.ExpectingInput) {
  $input
}
else {
  throw 'no content'
}

[regex]$reOpts = [regex]::new('^\s*(-[\w-]+)')
($content | ForEach-Object {
  $group = $reOpts.Match($_).Groups.Values | Select-Object -Skip 1
  if ($group.Success) {
    "'$($group.Value)'"
  }
}) -join ', ' | Set-Clipboard
