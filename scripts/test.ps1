using namespace System.Management.Automation
using namespace System.Management.Automation.Language

Register-ArgumentCompleter -Native -CommandName t -ScriptBlock {
  param([string]$wordToComplete, [CommandAst]$commandAst, [int]$cursorPosition)
  $prev, $cur = '', ''
  $commands, $words = @(), @()
  foreach ($i in $commandAst.CommandElements) {
    $words += $i
    if ($i.Extent.StartOffset -le $cursorPosition) {
      $prev = $cur
      $cur = $i
      if ($prev -is [StringConstantExpressionAst] -and
        $prev.StringConstantType -eq [StringConstantType]::BareWord -and
        !$prev.ToString().StartsWith('-')) {
        $commands += $i
      }
    }
  }
  if ($cur.ToString() -eq $wordToComplete) {
    $commands = $commands | Select-Object -SkipLast 1
  }
  $command = $commands -join ';'
}
