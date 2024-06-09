using namespace System.Management.Automation
using namespace System.Management.Automation.Language


param([string]$wordToComplete, [CommandAst]$commandAst, [int]$cursorPosition)
@('-a', '--allow-hidden', '-c', '--check', '--color', '-f', '--config-path', '-g', '--glob', '-h', '--help', '--no-editorconfig', '--num-threads', '--output-format', '--range-end', '--range-start', '--respect-ignores', '-s', '--search-parent-directories', '--stdin-filepath', '-v', '--verbose', '-V', '--version', '--verify', '--call-parentheses', '--collapse-simple-statement', '--column-width', '--indent-type', '--indent-width', '--line-endings', '--quote-style', '--sort-requires') | Where-Object { $_.StartsWith($wordToComplete) } | ForEach-Object {
  [CompletionResult]::new($_)
}
