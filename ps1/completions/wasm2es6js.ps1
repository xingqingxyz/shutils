Register-ArgumentCompleter -Native -CommandName wasm2es6js -ScriptBlock {
  param ([string]$wordToComplete)
  @(if ($wordToComplete.StartsWith('-')) {
      '-o', '--output', '--out-dir', '--typescript', '--base64', '--fetch', '-h', '--help', '-V', '--version'
    }).Where{ $_ -like "$wordToComplete*" }
}
