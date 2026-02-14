Register-ArgumentCompleter -Native -CommandName wasm-bindgen -ScriptBlock {
  param ([string]$wordToComplete)
  @(if ($wordToComplete.StartsWith('-')) {
      '--target=bundler', '--target=web', '--target=nodejs', '--target=no-modules', '--target=deno', '--target=experimental-nodejs-module', '--target=module', '--out-dir', '--browser', '--no-typescript', '--omit-imports', '--out-name', '--debug', '--no-demangle', '--no-modules-global', '--remove-name-section', '--remove-producers-section', '--keep-lld-exports', '--keep-debug', '--encode-into=test', '--encode-into=always', '--encode-into=never', '--omit-default-module-path', '--split-linked-modules', '--experimental-reset-state-function', '-h', '--help', '-V', '--version'
    }).Where{ $_ -like "$wordToComplete*" }
}
