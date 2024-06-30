Register-ArgumentCompleter -Native -CommandName pdftoppm -ScriptBlock {
  param([string]$wordToComplete, [System.Management.Automation.Language.CommandAst]$commandAst, [int]$cursorPosition)
  $cursorPosition -= $wordToComplete.Length
  foreach ($key in $commandAst.CommandElements) {
    if ($key.Extent.StartOffset -eq $cursorPosition) {
      break
    }
    $prev = $key
  }
  @(switch ($prev.ToString()) {
      '-thinlinemode' { 'none', 'solid', 'shape' }
      { $_.StartsWith('-aa') -or $_ -eq '-freetype' } { 'yes', 'no' }
      Default { @('-f', '-l', '-o', '-e', '-singlefile', '-scale-dimension-before-rotation', '-r', '-rx', '-ry', '-scale-to', '-scale-to-x', '-scale-to-y', '-x', '-y', '-W', '-H', '-sz', '-cropbox', '-hide-annotations', '-mono', '-gray', '-sep', '-forcenum', '-png', '-jpeg', '-jpegcmyk', '-jpegopt', '-overprint', '-freetype', '-thinlinemode', '-aa', '-aaVector', '-opw', '-upw', '-q', '-progress', '-v', '-h', '-help', '--help') }
    }) | Where-Object { $_ -like "$wordToComplete*" }
}
