Register-ArgumentCompleter -Native -CommandName mkcert -ScriptBlock {
  param ([string]$wordToComplete, [System.Management.Automation.Language.CommandAst]$commandAst, [int]$cursorPosition)
  @(if ($wordToComplete.StartsWith('-')) {
      '-install', '-uninstall', '-cert-file', '-key-file', '-p12-file', '-client', '-ecdsa', '-pkcs12', '-csr', '-CAROOT'
    }).Where{ $_ -like "$wordToComplete*" }
}
