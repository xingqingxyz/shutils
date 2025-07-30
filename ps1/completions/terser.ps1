Register-ArgumentCompleter -Native -CommandName terser -ScriptBlock {
  param([string]$wordToComplete)
  @(if ($wordToComplete.StartsWith('-')) {
      '--version', '--parse', '--compress', '--mangle', '--mangle-props', '--format', '--beautify', '--output', '--comments', '--config-file', '--define', '--ecma', '--enclose', '--ie8', '--keep-classnames', '--keep-fnames', '--module', '--name-cache', '--rename', '--no-rename', '--safari10', '--source-map', '--timings', '--toplevel', '--wrap', '--help'
    }).Where{ $_ -like "$wordToComplete*" }
}
