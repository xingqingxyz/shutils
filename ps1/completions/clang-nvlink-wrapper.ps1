Register-ArgumentCompleter -Native -CommandName clang-nvlink-wrapper -ScriptBlock {
  param ([string]$wordToComplete, [System.Management.Automation.Language.CommandAst]$commandAst, [int]$cursorPosition)
  @(if ($wordToComplete.StartsWith('-')) {
      '--arch=', '--cuda-path=', '--dry-run', '-g', '-help-hidden', '-help', '--lto-debug-pass-manager', '--lto-emit-asm', '--lto-emit-llvm', '--lto-newpm-passes=', '-L', '-l', '-mllvm', '-o', '--plugin-opt=jobs=', '--plugin-opt=lto-partitions=', '--plugin-opt=opt-remarks-filename=', '--plugin-opt=opt-remarks-filter=', '--plugin-opt=opt-remarks-format=', '--plugin-opt=opt-remarks-format=YAML', '--plugin-opt=opt-remarks-with-hotness', '--plugin-opt=O0', '--plugin-opt=O1', '--plugin-opt=O2', '--plugin-opt=O3', '--plugin-opt=thinlto', '--plugin-opt=', '--ptxas-path=', '--relocatable', '--save-temps', '-u', '--version', '-v'
    }).Where{ $_ -like "$wordToComplete*" }
}
