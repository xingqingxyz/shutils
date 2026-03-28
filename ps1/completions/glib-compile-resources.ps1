Register-ArgumentCompleter -Native -CommandName glib-compile-resources -ScriptBlock {
  param ([string]$wordToComplete, [System.Management.Automation.Language.CommandAst]$commandAst, [int]$cursorPosition)
  @(if ($wordToComplete.StartsWith('-')) {
      '-h', '--help', '--version', '--target=', '--sourcedir=', '--generate', '--generate-header', '--generate-source', '--generate-dependencies', '--dependency-file=', '--generate-phony-targets', '--manual-register', '--internal', '--external-data', '--c-name=', '-C', '--compiler='
    }).Where{ $_ -like "$wordToComplete*" }
}
