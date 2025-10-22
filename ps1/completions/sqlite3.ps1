Register-ArgumentCompleter -Native -CommandName sqlite3 -ScriptBlock {
  param ([string]$wordToComplete, [System.Management.Automation.Language.CommandAst]$commandAst, [int]$cursorPosition)
  @(if ($wordToComplete.StartsWith('-')) {
      '-append', '-ascii', '-bail', '-batch', '-box', '-column', '-cmd', '-csv', '-deserialize', '-echo', '-init', '-header', '-noheader', '-help', '-html', '-interactive', '-json', '-line', '-list', '-lookaside', '-markdown', '-maxsize', '-memtrace', '-mmap', '-newline', '-nofollow', '-nonce', '-no-rowid-in-view', '-nullvalue', '-pagecache', '-pcachetrace', '-quote', '-readonly', '-safe', '-separator', '-stats', '-table', '-tabs', '-unsafe-testing', '-version', '-vfs'
    }).Where{ $_ -like "$wordToComplete*" }
}
