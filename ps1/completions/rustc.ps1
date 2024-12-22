Register-ArgumentCompleter -Native -CommandName rustc -ScriptBlock {
  param([string]$wordToComplete)
  if ($wordToComplete.StartsWith('-')) {
    @('-h', '--help', '--cfg', '--crate-type', '--crate-name', '--edition', '--emit', '--print', '--out-dir', '--explain', '--test', '--target', '-A', '--allow', '-W', '--warn', '--force-warn', '-D', '--deny', '-F', '--forbid', '--cap-lints', '-C', '--codegen', '-V', '--version', '-v', '--verbose', '--help') | Where-Object { $_ -like "$wordToComplete*" }
  }
}
