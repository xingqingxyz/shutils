Register-ArgumentCompleter -Native -CommandName rga -ScriptBlock {
  param([string]$wordToComplete)
  @(if ($wordToComplete.StartsWith('-')) {
      @('--rga-accurate', '--rga-no-cache', '-h', '--help', '--rga-list-adapters', '--rga-no-prefix-filenames', '--rga-print-config-schema', '--rg-help', '--rg-version', '-V', '--version', '--rga-adapters', '--rga-cache-compression-level', '--rga-config-file', '--rga-max-archive-recursion', '--rga-cache-max-blob-len', '--rga-cache-path')
    }).Where{ $_ -like "$wordToComplete*" }
}
