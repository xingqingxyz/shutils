using namespace System.Management.Automation
using namespace System.Management.Automation.Language


param([string]$wordToComplete, [CommandAst]$commandAst, [int]$cursorPosition)
$cursorPosition -= $wordToComplete.Length
foreach ($i in $commandAst.CommandElements) {
  if ($i.Extent.StartOffset -eq $cursorPosition) {
    break
  }
  $prev = $i
}
@(switch ($prev.Extent.Text) {
    'help' { '#basic', '#advanced', '#http', '#https', '#ftp', '#metalink', '#bittorrent', '#cookie', '#hook', '#file', '#rpc', '#checksum', '#experimental', '#deprecated', '#help', '#all' }
    { @('--check-integrity', '--continue', '--force-sequential', '--show-files', '--enable-dht', '--enable-dht6').Contains($_) } { 'true', 'false' }
    Default {
      @('--icsv', '--itsv', '--ijson', '--ipprint', '--ocsv', '--otsv', '--ojson', '--opprint')
    }
  }) | Where-Object { $_.StartsWith($wordToComplete) } | ForEach-Object {
  [CompletionResult]::new($_)
}
