Register-ArgumentCompleter -Native -CommandName aria2c -ScriptBlock {
  param([string]$wordToComplete, [System.Management.Automation.Language.CommandAst]$commandAst, [int]$cursorPosition)
  $cursorPosition -= $wordToComplete.Length
  foreach ($i in $commandAst.CommandElements) {
    if ($i.Extent.StartOffset -ge $cursorPosition) {
      break
    }
    $prev = $i
  }
  $prev = $prev -is [System.Management.Automation.Language.StringConstantExpressionAst] ? $prev.Value : $prev.ToString()

  @(switch ($prev) {
      '--help' {
        @('#basic', '#advanced', '#http', '#https', '#ftp', '#metalink', '#bittorrent', '#cookie', '#hook', '#file', '#rpc', '#checksum', '#experimental', '#deprecated', '#help', '#all')
        break
      }
      '--file-allocation' {
        @('prealloc', 'falloc', 'none', 'trunc')
        break
      }
      { @('--check-integrity', '--continue', '--force-sequential', '--show-files', '--enable-dht', '--enable-dht6').Contains($_) } {
        @('true', 'false')
        break
      }
      Default {
        if ($wordToComplete.StartsWith('-')) {
          @('-v', '--version', '-h', '--help', '-l', '--log', '-d', '--dir', '-o', '--out', '-s', '--split', '--max-connection-per-server', '--min-split-size', '--file-allocation', '-V', '--check-integrity', '--checksum', '-c', '--continue', '-i', '--input-file', '-j', '--max-concurrent-downloads', '-Z', '--force-sequential', '-x', '--max-connection-per-server', '-k', '--min-split-size', '--ftp-user', '--ftp-passwd', '--http-user', '--http-passwd', '--load-cookies', '-S', '--show-files', '--max-overall-upload-limit', '--max-upload-limit', '-u', '--max-upload-limit', '--max-overall-upload-limit', '-T', '--torrent-file', '--listen-port', '--enable-dht', '--dht-listen-port', '--enable-dht6', '--dht-listen-addr6', '-M', '--metalink-file', '--max-connection-per-server')
        }
        break
      }
    }).Where{ $_ -like "$wordToComplete*" }
}
