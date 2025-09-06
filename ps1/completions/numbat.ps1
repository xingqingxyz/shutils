Register-ArgumentCompleter -Native -CommandName numbat -ScriptBlock {
  param ([string]$wordToComplete)
  @(if ($wordToComplete.StartsWith('-')) {
      @('-e', '--expression', '-i', '--inspect-interactively', '--no-config', '--no-prelude', '--no-init', '--pretty-print', '--intro-banner', '--generate-config', '-h', '--help', '-V', '--version')
    }).Where{ $_ -like "$wordToComplete*" }
}
