using namespace System.Management.Automation
using namespace System.Management.Automation.Language

Register-ArgumentCompleter -Native -CommandName dnf, dnf5, yum -ScriptBlock {
  param([string]$wordToComplete, [CommandAst]$commandAst, [int]$cursorPosition)
  $words = @(
    $iter = $commandAst.CommandElements.GetEnumerator()
    $null = $iter.MoveNext()
    $iter.Current
    $index = 0
    $endOffset = 0
    foreach ($el in $iter) {
      if ($el.Extent.StartOffset -le $cursorPosition) {
        $index++
        $endOffset = $el.Extent.EndOffset
      }
      elseif ($endOffset -lt $cursorPosition) {
        $index++
      }

      if ($el -is [StringConstantExpressionAst]) {
        $el.Value
      }
      else {
        $el.ToString()
      }
    }
    if ($endOffset -eq 0) {
      $index = 1
      ''
    }
  )
  $words = @(dnf --complete="$index" @words)
  if ($words.Length -le 1) {
    return $words
  }
  $re = [regex]::new('^(\S+)\s+\((.+)\)$')
  $words | ForEach-Object {
    $g = $re.Match($_).Groups
    [CompletionResult]::new($g[1], $g[1], [CompletionResultType]::ParameterValue, $g[2])
  }
}
