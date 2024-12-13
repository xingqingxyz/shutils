Register-ArgumentCompleter -Native -CommandName dust -ScriptBlock {
  param([string]$wordToComplete)
  if ($wordToComplete.StartsWith('-')) {
    @('-d', '--depth', '-n', '--number-of-lines', '-p', '--full-paths', '-X', '--ignore-directory', '-I', '--ignore-all-in-file', '-L', '--dereference-links', '-x', '--limit-filesystem', '-s', '--apparent-size', '-r', '--reverse', '-c', '--no-colors', '-b', '--no-percent-bars', '-B', '--bars-on-right', '-z', '--min-size', '-R', '--screen-reader', '--skip-total', '-f', '--filecount', '-i', '--ignore_hidden', '-v', '--invert-filter', '-e', '--filter', '-t', '--file_types', '-w', '--terminal_width', '-H', '--si', '-P', '--no-progress', '-D', '--only-dir', '-F', '--only-file', '-S', '--stack-size', '-h', '--help', '-V', '--version') | Where-Object { $_ -like "$wordToComplete*" }
  }
}
