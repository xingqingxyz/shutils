Register-ArgumentCompleter -Native -CommandName bc, dc -ScriptBlock {
  param ([string]$wordToComplete, [System.Management.Automation.Language.CommandAst]$commandAst, [int]$cursorPosition)
  @(if ($wordToComplete.StartsWith('-')) {
      switch -CaseSensitive (Split-Path -LeafBase $commandAst.GetCommandName()) {
        bc { '-h', '--help', '-i', '--interactive', '-l', '--mathlib', '-q', '--quiet', '-s', '--standard', '-w', '--warn', '-v', '--version'; break }
        dc { '-e', '--expression=', '-f', '--file=', '-i', '--interactive', '--max-recursion=', '-h', '--help', '-V', '--version'; break }
      }
    }).Where{ $_ -like "$wordToComplete*" }
}
