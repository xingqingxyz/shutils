Register-ArgumentCompleter -Native -CommandName gh, glow, vhs, tstoy -ScriptBlock {
  . $PSScriptRoot/lib/cobra.ps1 gh, glow, vhs, tstoy
  ''
}

Register-ArgumentCompleter -Native -CommandName (Get-Item $PSScriptRoot/completions/*.ps1).BaseName -ScriptBlock {
  param($wordToComplete, $commandAst, $cursorPosition)
  . $PSScriptRoot/completions/$(Split-Path -LeafBase $commandAst.CommandElements[0].Value).ps1
  ''
}

Register-ArgumentCompleter -CommandName vh -ParameterName Command -ScriptBlock {
  param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)
  Get-Command "$wordToComplete*"
}

Register-ArgumentCompleter -CommandName vw -ParameterName Path -ScriptBlock {
  param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)
  if (!(Test-Path "$wordToComplete*")) {
    Get-Command "$wordToComplete*"
  }
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
