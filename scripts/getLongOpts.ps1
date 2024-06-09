$content = if ($args.Length) {
  Get-Content $args[0]
}
elseif ($MyInvocation.ExpectingInput) {
  $input
}
else {
  throw 'no content'
}

[regex]$reOpts = [regex]::new('^\s*(-\w+)?\W*(--[\w-]+)')
($content | ForEach-Object {
  $reOpts.Match($_).Groups.Values | Select-Object -Skip 1 | ForEach-Object {
    if ($_.Success) {
      "'$($_.Value)'"
    } }
}) -join ', ' | Set-Clipboard
