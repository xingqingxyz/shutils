Register-ArgumentCompleter -Native -CommandName hexyl -ScriptBlock {
  param([string]$wordToComplete)
  if ($wordToComplete.StartsWith('-')) {
    @('-n', '--length', '-c', '--bytes', '-s', '--skip', '--block-size', '-v', '--no-squeezing', '--color', '--border', '-p', '--plain', '--border', '--no-characters', '-C', '--characters', '--character-table', '-P', '--no-position', '-o', '--display-offset', '--panels', '--panels', '-g', '--group-size', '--endianness', '--group-size', '-b', '--base', '--terminal-width', '-h', '--help', '-V', '--version').Where{ $_ -like "$wordToComplete*" }
  }
}
