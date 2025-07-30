function o {
  [regex]$reOption = [regex]::new('--[\w:=-]+')
  [string[]]$options = Get-Content test.log | ForEach-Object { $reOption.Match($_).Value } | Where-Object Length -GT 0
  $optionsSet = [System.Collections.Generic.HashSet[string]]::new($options)
  $optionsSet | Join-String -OutputPrefix "'" -OutputSuffix "'" -Separator "', '" -OutVariable GLobal:a
}

function jo {
  $input | Join-String -OutputPrefix "'" -OutputSuffix "'," -Separator "', '" -OutVariable GLobal:b
}

function a {
  $a
}

function b {
  $b
}
