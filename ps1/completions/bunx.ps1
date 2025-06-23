Register-ArgumentCompleter -Native -CommandName bunx -ScriptBlock {
  param([string]$wordToComplete, [System.Management.Automation.Language.CommandAst]$commandAst, [int]$cursorPosition)
  @(if ($wordToComplete.StartsWith('-')) {
      @('--bun')
    }
    else {
      (Get-ChildItem -LiteralPath node_modules/.bin -ea Ignore).BaseName | Select-Object -Unique
    }).Where{ $_ -like "$wordToComplete*" }
}
