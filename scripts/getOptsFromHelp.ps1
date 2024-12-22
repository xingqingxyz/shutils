$contents = @(if ($args.Length) {
    Invoke-Expression "$args --help"
  }
  elseif ($MyInvocation.ExpectingInput) {
    $input
  }
  else {
    throw 'no contents'
  }) | Tee-Object help.log

[regex]$reOpts = [regex]::new('^\s*(-\w+)?\W*(--[\w-]+)')
$contents | ForEach-Object {
  $reOpts.Match($_).Groups.Values | Select-Object -Skip 1 | ForEach-Object {
    if ($_.Success) {
      "'$($_.Value)'"
    } }
} | Join-String -Separator ', ' | Set-Clipboard
