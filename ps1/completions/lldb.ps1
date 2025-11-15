Register-ArgumentCompleter -Native -CommandName lldb, rust-lldb -ScriptBlock {
  param ([string]$wordToComplete, [System.Management.Automation.Language.CommandAst]$commandAst, [int]$cursorPosition)
  $cursorPosition -= $wordToComplete.Length
  foreach ($i in $commandAst.CommandElements) {
    if ($i.Extent.StartOffset -ge $cursorPosition) {
      break
    }
    $prev = $i
  }
  $prev = $prev -is [System.Management.Automation.Language.StringConstantExpressionAst] ? $prev.Value : $prev.ToString()
  @(switch ($prev) {
      '--arch' {
        'x86_64', 'armv7', 'armv8', 'aarch64'
        break
      }
      default {
        if (!$wordToComplete.StartsWith('-')) {
          '--attach-name', '--attach-pid', '-n', '-p', '--wait-for', '-w', '--batch', '-b', '-K', '-k', '--local-lldbinit', '--no-lldbinit', '--one-line-before-file', '--one-line-on-crash', '--one-line', '-O', '-o', '-Q', '--source-before-file', '--source-on-crash', '--source-quietly', '--source', '-S', '-s', '-x', '--arch', '-a', '--core', '-c', '--debug', '-d', '--editor', '-e', '--file', '-f', '--help', '-h', '--no-use-colors', '--version', '-v', '-X', '-r=', '--repl-language', '--repl=', '--repl', '-R', '-r', '-l', '--print-script-interpreter-info', '--python-path', '-P', '--script-language'
        }
        break
      }
    }).Where{ $_ -like "$wordToComplete*" }
}
