using namespace System.Management.Automation
using namespace System.Management.Automation.Language


param([string]$wordToComplete, [CommandAst]$commandAst, [int]$cursorPosition)
@('-n', '--null-input', '-R', '--raw-input', '-s', '--slurp', '-c', '--compact-output', '-r', '--raw-output', '--raw-output0', '-j', '--join-output', '-a', '--ascii-output', '-S', '--sort-keys', '-C', '--color-output', '-M', '--monochrome-output', '--tab', '--indent', '--unbuffered', '--stream', '--stream-errors', '--seq', '-f', '--from-file', '--arg', '--argjson', '--slurpfile', '--rawfile', '--args', '--jsonargs', '-e', '--exit-status', '-b', '--binary', '-V', '--version', '--build-configuration', '-h', '--help') |
  Where-Object { $_.StartsWith($wordToComplete) } | ForEach-Object {
    [CompletionResult]::new($_)
  }
