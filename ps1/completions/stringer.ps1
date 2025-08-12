Register-ArgumentCompleter -Native -CommandName stringer -ScriptBlock {
  param([string]$wordToComplete)
  if ($wordToComplete.StartsWith('-')) {
    @('-linecomment', '-output', '-tags', '-trimprefix', '-type').Where{ $_ -like "$wordToComplete*" }
  }
}
