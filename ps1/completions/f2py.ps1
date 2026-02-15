Register-ArgumentCompleter -Native -CommandName f2py -ScriptBlock {
  param ([string]$wordToComplete, [System.Management.Automation.Language.CommandAst]$commandAst, [int]$cursorPosition)
  @(if ($wordToComplete.StartsWith('-')) {
      '-h', '-m', '--lower', '--no-lower', '--build-dir=', '--overwrite-signature', '--latex-doc', '--no-latex-doc', '--short-latex', '--rest-doc', '--no-rest-doc', '--debug-capi', '--wrap-functions', '--no-wrap-functions', '--freethreading-compatible', '--no-freethreading-compatible', '--freethreading-compatible', '--no-freethreading-compatible', '--include-paths=', '--help-link=', '--link-', '--f2cmap=', '--quiet', '--verbose', '--skip-empty-wrappers', '-v', '--fcompiler=', '--compiler=', '--help-fcompiler', '--f77exec=', '--f90exec=', '--f77flags=', '--f90flags=', '--opt=', '--arch=', '--noopt', '--noarch', '--debug', '--dep=', '--backend=meson', '--backend=distutils', '--link-', '-L', '-l', '-D', '-U', '-I', '-DPREPEND_FORTRAN', '-DNO_APPEND_FORTRAN', '-DUPPERCASE_FORTRAN', '-DF2PY_REPORT_ATEXIT'
    }).Where{ $_ -like "$wordToComplete*" }
}
