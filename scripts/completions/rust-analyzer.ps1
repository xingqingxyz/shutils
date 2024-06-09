using namespace System.Management.Automation
using namespace System.Management.Automation.Language


param([string]$wordToComplete, [CommandAst]$commandAst, [int]$cursorPosition)
@('-v', '--verbose', '-q', '--quiet', '--log-file', '--no-log-buffering', '--wait-dbg', '-h', '--help', '-V', '--version', '--print-config-schema', '--no-dump', '--rainbow', '--output', '--randomize', '--parallel', '--source-stats', '-o', '--only', '--with-deps', '--no-sysroot', '--query-sysroot-metadata', '--disable-build-scripts', '--disable-proc-macros', '--skip-lowering', '--skip-inference', '--skip-mir-stats', '--skip-data-layout', '--skip-const-eval', '--run-all-ide-things', '--run-term-search', '--validate-term-search', '--filter', '--disable-build-scripts', '--disable-proc-macros', '--proc-macro-srv', '--debug', '--output', '--config-path') | Where-Object { $_.StartsWith($wordToComplete) } | ForEach-Object {
  [CompletionResult]::new($_)
}
