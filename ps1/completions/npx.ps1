Register-ArgumentCompleter -Native -CommandName npx -ScriptBlock {
  param([string]$wordToComplete, [System.Management.Automation.Language.CommandAst]$commandAst, [int]$cursorPosition)
  @(if ($wordToComplete.StartsWith('-')) {
      @('--package', '-c', '--call', '-w', '--workspace', '-ws', '--workspaces', '--include-workspace-root')
    }
    else {
      (Get-ChildItem node_modules/.bin -ErrorAction Ignore).BaseName | Select-Object -Unique
    }) | Where-Object { $_ -like "$wordToComplete*" }
}
