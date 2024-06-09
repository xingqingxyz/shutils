using namespace System.Management.Automation
using namespace System.Management.Automation.Language


param([string]$wordToComplete, [CommandAst]$commandAst, [int]$cursorPosition)
@('-n', '--length', '-c', '--bytes', '-s', '--skip', '--block-size', '-v', '--no-squeezing', '--color', '--border', '-p', '--plain', '--border', '--no-characters', '-C', '--characters', '--character-table', '-P', '--no-position', '-o', '--display-offset', '--panels', '--panels', '-g', '--group-size', '--endianness', '--group-size', '-b', '--base', '--terminal-width', '-h', '--help', '-V', '--version') | Where-Object { $_.StartsWith($wordToComplete) } | ForEach-Object {
  [CompletionResult]::new($_)
}
