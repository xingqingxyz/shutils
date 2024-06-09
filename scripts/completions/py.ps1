using namespace System.Management.Automation
using namespace System.Management.Automation.Language


param([string]$wordToComplete, [CommandAst]$commandAst, [int]$cursorPosition)
$cursorPosition -= $wordToComplete.Length
foreach ($i in $commandAst.CommandElements) {
  if ($i.Extent.StartOffset -eq $cursorPosition) {
    break
  }
  $prev = $i
}
@(switch ($prev.Extent.Text) {
    '-m' {
      fd --base-directory $env:LOCALAPPDATA\Programs\Python\Python312\Lib\ -tf -epy -E site-packages | ForEach-Object {
        $_.Replace(’\’, '.').Substring(0, $_.Length - 3)
      }
    }
    Default { @('-0', '--list', '-0p', '--list-paths', '--check-hash-based-pycs', '--help-env', '--help-xoptions', '--help-all', '-2', '-3', '-X', '-0p', '-b', '-B', '-c', '-d', '-E', '-h', '-i', '-I', '-m', '-O', '-OO', '-P', '-q', '-s', '-S', '-u', '-v', '-V', '-W', '-x', '-X', '--check-hash-based-pycs', '--help-env', '--help-xoptions', '--help-all') }
  }) | Where-Object { $_.StartsWith($wordToComplete) } | ForEach-Object {
  [CompletionResult]::new($_)
}
