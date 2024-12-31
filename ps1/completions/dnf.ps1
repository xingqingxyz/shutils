using namespace System.Management.Automation
using namespace System.Management.Automation.Language

Register-ArgumentCompleter -Native -CommandName dnf, dnf5, yum -ScriptBlock {
  param([string]$wordToComplete, [CommandAst]$commandAst, [int]$cursorPosition)

  $words = @($commandAst.CommandElements | ForEach-Object { $_.ToString() })
  if ($wordToComplete -eq '') {
    $words += ''
  }
  $re = [regex]::new('^(\S+)\s+\((.+?)\)$')
  dnf --complete=$($words.IndexOf($wordToComplete)) $words | ForEach-Object {
    $g = $re.Match($_).Groups
    [CompletionResult]::new($g[1], $g[1], [CompletionResultType]::ParameterValue, $g[2])
  }
}
