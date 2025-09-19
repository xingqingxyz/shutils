Register-ArgumentCompleter -Native -CommandName 'binocle diskus'.Split(' ') -ScriptBlock {
  param ([string]$wordToComplete, [System.Management.Automation.Language.CommandAst]$commandAst, [int]$cursorPosition)
  @(if ($wordToComplete.StartsWith('-')) {
      switch -CaseSensitive (Split-Path -LeafBase $commandAst.GetCommandName()) {
        binocle { '--backing=file', '--backing=mmap', '-h', '--help', '-V', '--version'; break }
        diskus { '-j', '--threads=72', '--size-format=decimal', '--size-format=binary', '-v', '--verbose', '-h', '--help', '-V', '--version'; break }
      }
    }
    else {
      switch -CaseSensitive (Split-Path -LeafBase $commandAst.GetCommandName()) {
        default { break }
      }
    }).Where{ $_ -like "$wordToComplete*" }
}
