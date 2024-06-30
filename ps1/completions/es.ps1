Register-ArgumentCompleter -Native -CommandName es -ScriptBlock {
  param([string]$wordToComplete, [System.Management.Automation.Language.CommandAst]$commandAst, [int]$cursorPosition)
  $cursorPosition -= $wordToComplete.Length
  foreach ($key in $commandAst.CommandElements) {
    if ($key.Extent.StartOffset -eq $cursorPosition) {
      break
    }
    $prev = $key
  }
  @(switch ($prev.ToString()) {
      '-sort' { 'name', 'path', 'size', 'extension', 'date-created', 'date-modified', 'date-accessed', 'attributes', 'file-list-file-name', 'run-count', 'date-recently-changed', 'date-run' }
      '/a' { 'R', 'H', ’S', 'D', 'A', 'V', 'N', 'T', ‘P', 'L', 'C', 'O', 'I', 'E', '-' }
      Default { @('-r', '-i', '-case', '-w', '-p', '-a', '-o', '-n', '-path', '-parent-path', '-parent', '-s', '-sort', '-sort-ascending', '-sort-descending', '-name', '-path-column', '-full-path-and-name', '-extension', '-size', '-date-created', '-date-modified', '-date-accessed', '-attributes', '-file-list-file-name', '-run-count', '-date-run', '-date-recently-changed', '-highlight', '-highlight-color', '-csv', '-efu', '-txt', '-m3u', '-m3u8', '-tsv', '-size-format', '-date-format', '-filename-color', '-name-color', '-path-color', '-extension-color', '-size-color', '-date-created-color', '-date-modified-color', '-date-accessed-color', '-attributes-color', '-file-list-filename-color', '-run-count-color', '-date-run-color', '-date-recently-changed-color', '-filename-width', '-name-width', '-path-width', '-extension-width', '-size-width', '-date-created-width', '-date-modified-width', '-date-accessed-width', '-attributes-width', '-file-list-filename-width', '-run-count-width', '-date-run-width', '-date-recently-changed-width', '-no-digit-grouping', '-size-leading-zero', '-run-count-leading-zero', '-double-quote', '-export-csv', '-export-efu', '-export-txt', '-export-m3u', '-export-m3u8', '-export-tsv', '-no-header', '-utf8-bom', '-h', '-instance', '-ipc1', '-ipc2', '-pause', '-more', '-hide-empty-search-results', '-empty-search-help', '-timeout', '-set-run-count', '-inc-run-count', '-get-run-count', '-get-result-count', '-get-total-size', '-save-settings', '-clear-settings', '-version', '-get-everything-version', '-exit', '-save-db', '-reindex', '-no-result-error', '/ad', '/a-d', '/a') }
    }) | Where-Object { $_ -like "$wordToComplete*" }
}
