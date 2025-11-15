Register-ArgumentCompleter -Native -CommandName clang-linker-wrapper -ScriptBlock {
  param ([string]$wordToComplete, [System.Management.Automation.Language.CommandAst]$commandAst, [int]$cursorPosition)
  @(if ($wordToComplete.StartsWith('-')) {
      '--compression-level=', '--compress', '--cuda-path=', '--device-compiler=', '--device-linker=', '--dry-run', '--embed-bitcode', '--help-hidden', '--help', '--host-triple=', '--linker-path=', '-L', '-l', '-mllvm', '-o', '--print-wrapped-module', '--relocatable', '--save-temps', '--should-extract=', '--sysroot=', '--v', '--wrapper-jobs=', '--wrapper-time-trace-granularity=', '--wrapper-time-trace=', '--wrapper-verbose'
    }).Where{ $_ -like "$wordToComplete*" }
}
