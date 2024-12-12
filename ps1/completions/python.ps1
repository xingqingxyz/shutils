Register-ArgumentCompleter -Native -CommandName python, py -ScriptBlock {
  param([string]$wordToComplete, [System.Management.Automation.Language.CommandAst]$commandAst, [int]$cursorPosition)
  $cursorPosition -= $wordToComplete.Length
  foreach ($key in $commandAst.CommandElements) {
    if ($key.Extent.StartOffset -eq $cursorPosition) {
      break
    }
    $prev = $key
  }
  @(switch ($prev.ToString()) {
      '-m' {
        fd --base-directory $env:LOCALAPPDATA\Programs\Python\Python312\Lib\ -tf -epy -E site-packages | ForEach-Object {
          $_.Replace(’\’, '.').Substring(0, $_.Length - 3)
        }
      }
      Default { 
        if (!$commandAst.CommandElements[0].Value.StartsWith('python')) {
          @('-0', '-2', '-3', '-V:', '--list', '-0p', '--list-paths')
        }
        @('--check-hash-based-pycs', '--help-env', '--help-xoptions', '--help-all', '-X', '-b', '-B', '-c', '-d', '-E', '-h', '-i', '-I', '-m', '-O', '-OO', '-P', '-q', '-s', '-S', '-u', '-v', '-V', '-W', '-x', '-X', '--check-hash-based-pycs', '--help-env', '--help-xoptions', '--help-all') 
      }
    }) | Where-Object { $_ -like "$wordToComplete*" }
}
