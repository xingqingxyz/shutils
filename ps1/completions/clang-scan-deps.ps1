Register-ArgumentCompleter -Native -CommandName clang-scan-deps -ScriptBlock {
  param ([string]$wordToComplete, [System.Management.Automation.Language.CommandAst]$commandAst, [int]$cursorPosition)
  @(if ($wordToComplete.StartsWith('-')) {
      '-compilation-database=', '-dependency-target=', '-deprecated-driver-command', '-eager-load-pcm', '-emit-visible-modules', '-format=', '-format=YAML', '--help', '-j', '-mode=', '-module-files-dir=', '-module-name=', '-optimize-args=', '-o', '-print-timing', '-resource-dir-recipe=', '-round-trip-args', '-tu-buffer-path=', '--version', '-v'
    }).Where{ $_ -like "$wordToComplete*" }
}
