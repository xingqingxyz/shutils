Register-ArgumentCompleter -Native -CommandName gh, glow, vhs, tstoy -ScriptBlock {
  . $PSScriptRoot/lib/cobra.ps1 gh, glow, vhs, tstoy
  ''
}

Register-ArgumentCompleter -Native -CommandName (Get-Item $PSScriptRoot/completions/*.ps1).BaseName -ScriptBlock {
  param($wordToComplete, $commandAst, $cursorPosition)
  . $PSScriptRoot/completions/$($commandAst.CommandElements[0].Value)
  ''
}

function quote([string]$s) {
  if ($s.Length -le 1) {
    return "'$s'"
  }
  $s = switch ($s[0]) {
    "'" { $s; break }
    '"' { "'" + $s.Substring(1); break }
    Default { "'" + $s; break }
  }
  switch ($s[-1]) {
    "'" { $s; break }
    '"' { $s.Substring(0, $s.Length - 1) + "'"; break }
    Default { $s + "'"; break }
  }
}

function unquote([string]$s) {
  $s -replace "^['`"]|['`"]$", ''
}
