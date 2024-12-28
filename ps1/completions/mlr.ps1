Register-ArgumentCompleter -Native -CommandName mlr -ScriptBlock {
  param([string]$wordToComplete, [System.Management.Automation.Language.CommandAst]$commandAst, [int]$cursorPosition)
  $cursorPosition -= $wordToComplete.Length
  foreach ($i in $commandAst.CommandElements) {
    if ($i.Extent.StartOffset -ge $cursorPosition) {
      break
    }
    $prev = $i
  }
  $prev = $prev.ToString()

  @(switch ($prev) {
      'help' { '#basic', '#advanced', '#http', '#https', '#ftp', '#metalink', '#bittorrent', '#cookie', '#hook', '#file', '#rpc', '#checksum', '#experimental', '#deprecated', '#help', '#all' }
      { @('--check-integrity', '--continue', '--force-sequential', '--show-files', '--enable-dht', '--enable-dht6').Contains($_) } { 'true', 'false' }
      Default {
        @('--icsv', '--itsv', '--ijson', '--ipprint', '--ocsv', '--otsv', '--ojson', '--opprint')
      }
    }) | Where-Object { $_ -like "$wordToComplete*" }
}
