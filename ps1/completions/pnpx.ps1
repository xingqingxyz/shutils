Register-ArgumentCompleter -Native -CommandName pnpx -ScriptBlock {
  param([string]$wordToComplete, [System.Management.Automation.Language.CommandAst]$commandAst, [int]$cursorPosition)
  @(if ($wordToComplete.StartsWith('-')) {
      @('--color', '--no-color', '--aggregate-output', '--parallel', '--reporter', '-C', '--dir', '-h', '--help', '--loglevel', '--no-reporter-hide-prefix', '--parallel', '-r', '--recursive', '--report-summary', '--resume-from', '-c', '--shell-mode', '--stream', '--use-stderr', '-w', '--workspace-root', '--changed-files-ignore-pattern', '--filter', '--changed-files-ignore-', '--fail-if-no-match', '--filter', '--filter-prod', '--test-pattern', '--test-pattern')
    }
    else {
      (Get-ChildItem node_modules/.bin -ea Ignore).BaseName | Select-Object -Unique
    }) | Where-Object { $_ -like "$wordToComplete*" }
}
