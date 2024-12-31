Register-ArgumentCompleter -Native -CommandName bunx -ScriptBlock {
  param([string]$wordToComplete, [System.Management.Automation.Language.CommandAst]$commandAst, [int]$cursorPosition)
  @(if ($wordToComplete.StartsWith('-')) {
      @('--bun')
    }
    else {
    (Get-ChildItem node_modules/.bin -ErrorAction Ignore).BaseName | Select-Object -Unique
    }) | Where-Object { $_ -like "$wordToComplete*" }
}
