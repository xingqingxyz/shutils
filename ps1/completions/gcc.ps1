Register-ArgumentCompleter -Native -CommandName gcc, cc, c89, c99, c++, g++ -ScriptBlock {
  param ([string]$wordToComplete, [System.Management.Automation.Language.CommandAst]$commandAst, [int]$cursorPosition)
  @(if ($wordToComplete.StartsWith('-')) {
      '-pass-exit-codes', '--help', '--target-help', '--help=common', '--help=optimizers', '--help=params', '--help=target', '--help=warnings', '--help=joined', '--help=^joined', '--help=separate', '--help=undocumented', '--version', '-dumpspecs', '-dumpversion', '-dumpmachine', '-foffload=', '-print-search-dirs', '-print-libgcc-file-name', '-print-file-name=', '-print-prog-name=', '-print-multiarch', '-print-multi-directory', '-print-multi-lib', '-print-multi-os-directory', '-print-sysroot', '-print-sysroot-headers-suffix', '-Wa', '-Wp', '-Wl', '-Xassembler', '-Xpreprocessor', '-Xlinker', '-save-temps', '-save-temps=', '-no-canonical-prefixes', '-pipe', '-time', '-specs=', '-std=c11', '-std=c17', '-std=c++11', '-std=c++17', '-std=c++21', '--sysroot=', '-B', '-v', '-###', '-E', '-S', '-c', '-o', '-pie', '-shared', '-xc', '-xc++', '-xassembler', '-xnone'
    }).Where{ $_ -like "$wordToComplete*" }
}
