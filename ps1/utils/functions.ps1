function quote([string]$s) {
  if ($s.Length -le 1) {
    return "'$s'"
  }
  $s = switch ($s[0]) {
    "'" { $s; break }
    '"' { "'" + $s.Substring(1); break }
    default { "'" + $s; break }
  }
  switch ($s[-1]) {
    "'" { $s; break }
    '"' { $s.Substring(0, $s.Length - 1) + "'"; break }
    default { $s + "'"; break }
  }
}

function unquote([string]$s) {
  $s -replace "^['`"]|['`"]$", ''
}

function readWrite {
  $logPath = 'test.log'
  $buffer = [char[]]::new(1024)
  while ($true) {
    $length = [uint][System.Console]::ReadLine()
    "[$(Get-Date)] Received Length $length" >> $logPath
    $tuple = [uint]::DivRem($length, 1024)
    $text = @(
      for ([uint]$i = 0; $i -lt $tuple.Item1; $i++) {
        [string]::new($buffer, 0, [System.Console]::In.Read($buffer, 0, 1024))
      }
      [string]::new($buffer, 0, [System.Console]::In.Read($buffer, 0, $tuple.Item2))
    ) -join ''
    "$($text.Length)`n$text"
  }
}
