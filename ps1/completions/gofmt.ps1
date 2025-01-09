using namespace System.Management.Automation

Register-ArgumentCompleter -Native -CommandName gofmt -ScriptBlock {
  param([string]$wordToComplete)
  @(if ($wordToComplete.StartsWith('-')) {
      [CompletionResult]::new('-cpuprofile', 'cpuprofile', [CompletionResultType]::ParameterValue, 'write cpu profile to this file')
      [CompletionResult]::new('-d', 'd', [CompletionResultType]::ParameterValue, 'display diffs instead of rewriting files')
      [CompletionResult]::new('-e', 'e', [CompletionResultType]::ParameterValue, 'report all errors (not just the first 10 on different lines)')
      [CompletionResult]::new('-l', 'l', [CompletionResultType]::ParameterValue, "list files whose formatting differs from gofmt's")
      [CompletionResult]::new('-r', 'r', [CompletionResultType]::ParameterValue, "rewrite rule (e.g., 'a[b:len(a)] -> a[b:]')")
      [CompletionResult]::new('-s', 's', [CompletionResultType]::ParameterValue, 'simplify code')
      [CompletionResult]::new('-w', 'w', [CompletionResultType]::ParameterValue, 'write result to (source) file instead of stdout')
    }) | Where-Object CompletionText -Like "$wordToComplete*"
}
