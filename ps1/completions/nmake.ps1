using namespace System.Management.Automation

Register-ArgumentCompleter -Native -CommandName nmake -ScriptBlock {
  param ([string]$wordToComplete, [System.Management.Automation.Language.CommandAst]$commandAst, [int]$cursorPosition)
  @(if ($wordToComplete.StartsWith('/')) {
      [CompletionResult]::new('/f', '/f', [CompletionResultType]::ParameterName, 'makefile')
      [CompletionResult]::new('/x', '/x', [CompletionResultType]::ParameterName, 'stderrfile')
      [CompletionResult]::new('/A', '/A', [CompletionResultType]::ParameterName, '生成所有已计算的目标')
      [CompletionResult]::new('/B', '/B', [CompletionResultType]::ParameterName, '如果时间戳相等则生成')
      [CompletionResult]::new('/C', '/C', [CompletionResultType]::ParameterName, '取消输出消息')
      [CompletionResult]::new('/D', '/D', [CompletionResultType]::ParameterName, '显示生成消息')
      [CompletionResult]::new('/E', '/E', [CompletionResultType]::ParameterName, '覆盖 env-var 宏')
      [CompletionResult]::new('/ERRORREPORT:NONE', '/ERRORREPORT:NONE', [CompletionResultType]::ParameterName, '向 Microsoft 报告错误')
      [CompletionResult]::new('/ERRORREPORT:PROMPT', '/ERRORREPORT:PROMPT', [CompletionResultType]::ParameterName, '向 Microsoft 报告错误')
      [CompletionResult]::new('/ERRORREPORT:QUEUE', '/ERRORREPORT:QUEUE', [CompletionResultType]::ParameterName, '向 Microsoft 报告错误')
      [CompletionResult]::new('/ERRORREPORT:SEND', '/ERRORREPORT:SEND', [CompletionResultType]::ParameterName, '向 Microsoft 报告错误')
      [CompletionResult]::new('/G', '/G', [CompletionResultType]::ParameterName, '显示 !include 文件名')
      [CompletionResult]::new('/HELP', '/HELP', [CompletionResultType]::ParameterName, '显示简短的用法消息')
      [CompletionResult]::new('/I', '/I', [CompletionResultType]::ParameterName, '忽略命令中的退出代码')
      [CompletionResult]::new('/K', '/K', [CompletionResultType]::ParameterName, '遇到错误时继续生成不相关的目标')
      [CompletionResult]::new('/N', '/N', [CompletionResultType]::ParameterName, '显示命令但不执行')
      [CompletionResult]::new('/NOLOGO', '/NOLOGO', [CompletionResultType]::ParameterName, '取消显示版权信息')
      [CompletionResult]::new('/P', '/P', [CompletionResultType]::ParameterName, '显示 NMAKE 信息')
      [CompletionResult]::new('/Q', '/Q', [CompletionResultType]::ParameterName, '检查时间戳但不生成')
      [CompletionResult]::new('/R', '/R', [CompletionResultType]::ParameterName, '忽略预定义的规则/宏')
      [CompletionResult]::new('/S', '/S', [CompletionResultType]::ParameterName, '取消显示已执行的命令')
      [CompletionResult]::new('/T', '/T', [CompletionResultType]::ParameterName, '更改时间戳但不生成')
      [CompletionResult]::new('/U', '/U', [CompletionResultType]::ParameterName, '转储内联文件')
      [CompletionResult]::new('/Y', '/Y', [CompletionResultType]::ParameterName, '禁用批处理模式')
      [CompletionResult]::new('/W', '/W', [CompletionResultType]::ParameterName, '显示任何失败的子进程的完整命令')
      [CompletionResult]::new('/?', '/?', [CompletionResultType]::ParameterName, '显示简短用法消息')
    }) | Where-Object CompletionText -Like $wordToComplete*
}
