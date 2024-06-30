Register-ArgumentCompleter -Native -CommandName rga -ScriptBlock {
  param([string]$wordToComplete)
  @('--rga-accurate', '--rga-no-cache', '-h', '--help', '--rga-list-adapters', '--rga-no-prefix-filenames', '--rga-print-config-schema', '--rg-help', '--rg-version', '-V', '--version', '--rga-adapters', '--rga-cache-compression-level', '--rga-config-file', '--rga-max-archive-recursion', '--rga-cache-max-blob-len', '--rga-cache-path') | Where-Object { $_ -like "$wordToComplete*" }
}
