Register-ArgumentCompleter -Native -CommandName wasm-bindgen-test-runner -ScriptBlock {
  param ([string]$wordToComplete)
  @(if ($wordToComplete.StartsWith('-')) {
      '--include-ignored', '--ignored', '--exact', '--skip', '--list', '--nocapture', '--format=terse', '--format=', '-h', '--help', '-V', '--version'
    }).Where{ $_ -like "$wordToComplete*" }
}
