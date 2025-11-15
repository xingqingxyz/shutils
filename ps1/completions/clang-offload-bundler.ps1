Register-ArgumentCompleter -Native -CommandName clang-offload-bundler -ScriptBlock {
  param ([string]$wordToComplete, [System.Management.Automation.Language.CommandAst]$commandAst, [int]$cursorPosition)
  @(if ($wordToComplete.StartsWith('-')) {
      '--help', '--help-list', '--version', '--###', '--allow-missing-bundles', '--bundle-align=', '--check-input-archive', '--compress', '--compression-level=', '--hip-openmp-compatible', '--input=', '--inputs=', '--list', '--output=', '--outputs=', '--targets=', '--type=i', '--type=ii', '--type=cui', '--type=hipi', '--type=d', '--type=ll', '--type=bc', '--type=s', '--type=o', '--type=a', '--type=gch', '--type=ast', '--unbundle', '--verbose'
    }).Where{ $_ -like "$wordToComplete*" }
}
