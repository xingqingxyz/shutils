Register-ArgumentCompleter -Native -CommandName clang-sycl-linker -ScriptBlock {
  param ([string]$wordToComplete, [System.Management.Automation.Language.CommandAst]$commandAst, [int]$cursorPosition)
  @(if ($wordToComplete.StartsWith('-')) {
      '--arch=', '--device-libs=', '--dry-run', '-help-hidden', '-help', '--ocloc-options=', '--opencl-aot-options=', '-o', '--print-linked-module', '--save-temps', '--spirv-dump-device-code=', '--triple=', '--version', '-v'
    }).Where{ $_ -like "$wordToComplete*" }
}
