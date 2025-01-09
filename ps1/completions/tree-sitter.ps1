using namespace System.Management.Automation
using namespace System.Management.Automation.Language

Register-ArgumentCompleter -Native -CommandName tree-sitter -ScriptBlock {
  param([string]$wordToComplete, [CommandAst]$commandAst, [int]$cursorPosition)

  $subcmd = "$($commandAst.CommandElements[1])"
  @(switch ($subcmd) {
      'init-config' {
        [CompletionResult]::new('-h', 'h', [CompletionResultType]::ParameterValue, 'Print help')
        [CompletionResult]::new('--help', 'help', [CompletionResultType]::ParameterValue, 'Print help')
      }
      'generate' {
        [CompletionResult]::new('-l', 'l', [CompletionResultType]::ParameterValue, 'Show debug log during generation')
        [CompletionResult]::new('--log', 'log', [CompletionResultType]::ParameterValue, 'Show debug log during generation')
        [CompletionResult]::new('--abi', 'abi', [CompletionResultType]::ParameterValue, 'Select the language ABI version to generate (default 14). Use --abi=latest to generate the newest supported version (14).')
        [CompletionResult]::new('--no-bindings', 'no-bindings', [CompletionResultType]::ParameterValue, "Don't generate language bindings")
        [CompletionResult]::new('-b', 'b', [CompletionResultType]::ParameterValue, 'Compile all defined languages in the current dir')
        [CompletionResult]::new('--build', 'build', [CompletionResultType]::ParameterValue, 'Compile all defined languages in the current dir')
        [CompletionResult]::new('-0', '0', [CompletionResultType]::ParameterValue, 'Compile a parser in debug mode')
        [CompletionResult]::new('--debug-build', 'debug-build', [CompletionResultType]::ParameterValue, 'Compile a parser in debug mode')
        [CompletionResult]::new('--libdir', 'libdir', [CompletionResultType]::ParameterValue, 'The path to the directory containing the parser library')
        [CompletionResult]::new('--report-states-for-rule', 'report-states-for-rule', [CompletionResultType]::ParameterValue, 'Produce a report of the states for the given rule, use `-` to report every rule')
        [CompletionResult]::new('--js-runtime', 'js-runtime', [CompletionResultType]::ParameterValue, 'The path to the JavaScript runtime to use for generating parsers [env: TREE_SITTER_JS_RUNTIME=]')
        [CompletionResult]::new('-h', 'h', [CompletionResultType]::ParameterValue, 'Print help')
        [CompletionResult]::new('--help', 'help', [CompletionResultType]::ParameterValue, 'Print help')
      }
      'build' {
        [CompletionResult]::new('-w', 'w', [CompletionResultType]::ParameterValue, 'Build a WASM module instead of a dynamic library')
        [CompletionResult]::new('--wasm', 'wasm', [CompletionResultType]::ParameterValue, 'Build a WASM module instead of a dynamic library')
        [CompletionResult]::new('-d', 'd', [CompletionResultType]::ParameterValue, 'Run emscripten via docker even if it is installed locally (only if building a WASM module with --wasm)')
        [CompletionResult]::new('--docker', 'docker', [CompletionResultType]::ParameterValue, 'Run emscripten via docker even if it is installed locally (only if building a WASM module with --wasm)')
        [CompletionResult]::new('-o', 'o', [CompletionResultType]::ParameterValue, 'The path to output the compiled file')
        [CompletionResult]::new('--output', 'output', [CompletionResultType]::ParameterValue, 'The path to output the compiled file')
        [CompletionResult]::new('--reuse-allocator', 'reuse-allocator', [CompletionResultType]::ParameterValue, 'Make the parser reuse the same allocator as the library')
        [CompletionResult]::new('--internal-build', 'internal-build', [CompletionResultType]::ParameterValue, "Build the parser with `TREE_SITTER_INTERNAL_BUILD` defined")
        [CompletionResult]::new('-h', 'h', [CompletionResultType]::ParameterValue, 'Print help')
        [CompletionResult]::new('--help', 'help', [CompletionResultType]::ParameterValue, 'Print help')
      }
      'build-wasm' {
        [CompletionResult]::new('-d', 'd', [CompletionResultType]::ParameterValue, 'Run emscripten via docker even if it is installed locally')
        [CompletionResult]::new('--docker', 'docker', [CompletionResultType]::ParameterValue, 'Run emscripten via docker even if it is installed locally')
        [CompletionResult]::new('-h', 'h', [CompletionResultType]::ParameterValue, 'Print help')
        [CompletionResult]::new('--help', 'help', [CompletionResultType]::ParameterValue, 'Print help')
      }
      'parse' {
        [CompletionResult]::new('--paths', 'paths', [CompletionResultType]::ParameterValue, 'The path to a file with paths to source file(s)')
        [CompletionResult]::new('--scope', 'scope', [CompletionResultType]::ParameterValue, 'Select a language by the scope instead of a file extension')
        [CompletionResult]::new('-d', 'd', [CompletionResultType]::ParameterValue, 'Show parsing debug log')
        [CompletionResult]::new('--debug', 'debug', [CompletionResultType]::ParameterValue, 'Show parsing debug log')
        [CompletionResult]::new('-0', '0', [CompletionResultType]::ParameterValue, 'Compile a parser in debug mode')
        [CompletionResult]::new('--debug-build', 'debug-build', [CompletionResultType]::ParameterValue, 'Compile a parser in debug mode')
        [CompletionResult]::new('-D', 'D', [CompletionResultType]::ParameterValue, 'Produce the log.html file with debug graphs')
        [CompletionResult]::new('--debug-graph', 'debug-graph', [CompletionResultType]::ParameterValue, 'Produce the log.html file with debug graphs')
        [CompletionResult]::new('--wasm', 'wasm', [CompletionResultType]::ParameterValue, 'Compile parsers to wasm instead of native dynamic libraries')
        [CompletionResult]::new('--dot', 'dot', [CompletionResultType]::ParameterValue, 'Output the parse data with graphviz dot')
        [CompletionResult]::new('-x', 'x', [CompletionResultType]::ParameterValue, 'Output the parse data in XML format')
        [CompletionResult]::new('--xml', 'xml', [CompletionResultType]::ParameterValue, 'Output the parse data in XML format')
        [CompletionResult]::new('-s', 's', [CompletionResultType]::ParameterValue, 'Show parsing statistic')
        [CompletionResult]::new('--stat', 'stat', [CompletionResultType]::ParameterValue, 'Show parsing statistic')
        [CompletionResult]::new('--timeout', 'timeout', [CompletionResultType]::ParameterValue, 'Interrupt the parsing process by timeout (µs)')
        [CompletionResult]::new('-t', 't', [CompletionResultType]::ParameterValue, 'Measure execution time')
        [CompletionResult]::new('--time', 'time', [CompletionResultType]::ParameterValue, 'Measure execution time')
        [CompletionResult]::new('-q', 'q', [CompletionResultType]::ParameterValue, 'Suppress main output')
        [CompletionResult]::new('--quiet', 'quiet', [CompletionResultType]::ParameterValue, 'Suppress main output')
        [CompletionResult]::new('--edits', 'edits', [CompletionResultType]::ParameterValue, 'Apply edits in the format: row,col delcount insert_text')
        [CompletionResult]::new('--encoding', 'encoding', [CompletionResultType]::ParameterValue, 'The encoding of the input files')
        [CompletionResult]::new('--open-log', 'open-log', [CompletionResultType]::ParameterValue, "Open `log.html` in the default browser, if `--debug-graph` is supplied")
        [CompletionResult]::new('--config-path', 'config-path', [CompletionResultType]::ParameterValue, 'The path to an alternative config.json file')
        [CompletionResult]::new('-n', 'n', [CompletionResultType]::ParameterValue, 'Parse the contents of a specific test')
        [CompletionResult]::new('--test-number', 'test-number', [CompletionResultType]::ParameterValue, 'Parse the contents of a specific test')
        [CompletionResult]::new('-h', 'h', [CompletionResultType]::ParameterValue, 'Print help')
        [CompletionResult]::new('--help', 'help', [CompletionResultType]::ParameterValue, 'Print help')
      }
      'test' {
        [CompletionResult]::new('-f', 'f', [CompletionResultType]::ParameterValue, 'Only run corpus test cases whose name includes the given string')
        [CompletionResult]::new('--filter', 'filter', [CompletionResultType]::ParameterValue, 'Only run corpus test cases whose name includes the given string')
        [CompletionResult]::new('-i', 'i', [CompletionResultType]::ParameterValue, 'Only run corpus test cases whose name matches the given regex')
        [CompletionResult]::new('--include', 'include', [CompletionResultType]::ParameterValue, 'Only run corpus test cases whose name matches the given regex')
        [CompletionResult]::new('-e', 'e', [CompletionResultType]::ParameterValue, 'Only run corpus test cases whose name does not match the given regex')
        [CompletionResult]::new('--exclude', 'exclude', [CompletionResultType]::ParameterValue, 'Only run corpus test cases whose name does not match the given regex')
        [CompletionResult]::new('-u', 'u', [CompletionResultType]::ParameterValue, 'Update all syntax trees in corpus files with current parser output')
        [CompletionResult]::new('--update', 'update', [CompletionResultType]::ParameterValue, 'Update all syntax trees in corpus files with current parser output')
        [CompletionResult]::new('-d', 'd', [CompletionResultType]::ParameterValue, 'Show parsing debug log')
        [CompletionResult]::new('--debug', 'debug', [CompletionResultType]::ParameterValue, 'Show parsing debug log')
        [CompletionResult]::new('-0', '0', [CompletionResultType]::ParameterValue, 'Compile a parser in debug mode')
        [CompletionResult]::new('--debug-build', 'debug-build', [CompletionResultType]::ParameterValue, 'Compile a parser in debug mode')
        [CompletionResult]::new('-D', 'D', [CompletionResultType]::ParameterValue, 'Produce the log.html file with debug graphs')
        [CompletionResult]::new('--debug-graph', 'debug-graph', [CompletionResultType]::ParameterValue, 'Produce the log.html file with debug graphs')
        [CompletionResult]::new('--wasm', 'wasm', [CompletionResultType]::ParameterValue, 'Compile parsers to wasm instead of native dynamic libraries')
        [CompletionResult]::new('--open-log', 'open-log', [CompletionResultType]::ParameterValue, "Open `log.html` in the default browser, if `--debug-graph` is supplied")
        [CompletionResult]::new('--config-path', 'config-path', [CompletionResultType]::ParameterValue, 'The path to an alternative config.json file')
        [CompletionResult]::new('-h', 'h', [CompletionResultType]::ParameterValue, 'Print help')
        [CompletionResult]::new('--help', 'help', [CompletionResultType]::ParameterValue, 'Print help')
      }
      'query' {
        [CompletionResult]::new('-t', 't', [CompletionResultType]::ParameterValue, 'Measure execution time')
        [CompletionResult]::new('--time', 'time', [CompletionResultType]::ParameterValue, 'Measure execution time')
        [CompletionResult]::new('-q', 'q', [CompletionResultType]::ParameterValue, 'Suppress main output')
        [CompletionResult]::new('--quiet', 'quiet', [CompletionResultType]::ParameterValue, 'Suppress main output')
        [CompletionResult]::new('--paths', 'paths', [CompletionResultType]::ParameterValue, 'The path to a file with paths to source file(s)')
        [CompletionResult]::new('--byte-range', 'byte-range', [CompletionResultType]::ParameterValue, 'The range of byte offsets in which the query will be executed')
        [CompletionResult]::new('--row-range', 'row-range', [CompletionResultType]::ParameterValue, 'The range of rows in which the query will be executed')
        [CompletionResult]::new('--scope', 'scope', [CompletionResultType]::ParameterValue, 'Select a language by the scope instead of a file extension')
        [CompletionResult]::new('-c', 'c', [CompletionResultType]::ParameterValue, 'Order by captures instead of matches')
        [CompletionResult]::new('--captures', 'captures', [CompletionResultType]::ParameterValue, 'Order by captures instead of matches')
        [CompletionResult]::new('--test', 'test', [CompletionResultType]::ParameterValue, 'Whether to run query tests or not')
        [CompletionResult]::new('--config-path', 'config-path', [CompletionResultType]::ParameterValue, 'The path to an alternative config.json file')
        [CompletionResult]::new('-h', 'h', [CompletionResultType]::ParameterValue, 'Print help')
        [CompletionResult]::new('--help', 'help', [CompletionResultType]::ParameterValue, 'Print help')
      }
      'highlight' {
        [CompletionResult]::new('-H', 'H', [CompletionResultType]::ParameterValue, 'Generate highlighting as an HTML document')
        [CompletionResult]::new('--html', 'html', [CompletionResultType]::ParameterValue, 'Generate highlighting as an HTML document')
        [CompletionResult]::new('--check', 'check', [CompletionResultType]::ParameterValue, 'Check that highlighting captures conform strictly to standards')
        [CompletionResult]::new('--captures-path', 'captures-path', [CompletionResultType]::ParameterValue, 'The path to a file with captures')
        [CompletionResult]::new('--query-paths', 'query-paths', [CompletionResultType]::ParameterValue, 'The paths to files with queries')
        [CompletionResult]::new('--scope', 'scope', [CompletionResultType]::ParameterValue, 'Select a language by the scope instead of a file extension')
        [CompletionResult]::new('-t', 't', [CompletionResultType]::ParameterValue, 'Measure execution time')
        [CompletionResult]::new('--time', 'time', [CompletionResultType]::ParameterValue, 'Measure execution time')
        [CompletionResult]::new('-q', 'q', [CompletionResultType]::ParameterValue, 'Suppress main output')
        [CompletionResult]::new('--quiet', 'quiet', [CompletionResultType]::ParameterValue, 'Suppress main output')
        [CompletionResult]::new('--paths', 'paths', [CompletionResultType]::ParameterValue, 'The path to a file with paths to source file(s)')
        [CompletionResult]::new('--config-path', 'config-path', [CompletionResultType]::ParameterValue, 'The path to an alternative config.json file')
        [CompletionResult]::new('-h', 'h', [CompletionResultType]::ParameterValue, 'Print help')
        [CompletionResult]::new('--help', 'help', [CompletionResultType]::ParameterValue, 'Print help')
      }
      'tags' {
        [CompletionResult]::new('--scope', 'scope', [CompletionResultType]::ParameterValue, 'Select a language by the scope instead of a file extension')
        [CompletionResult]::new('-t', 't', [CompletionResultType]::ParameterValue, 'Measure execution time')
        [CompletionResult]::new('--time', 'time', [CompletionResultType]::ParameterValue, 'Measure execution time')
        [CompletionResult]::new('-q', 'q', [CompletionResultType]::ParameterValue, 'Suppress main output')
        [CompletionResult]::new('--quiet', 'quiet', [CompletionResultType]::ParameterValue, 'Suppress main output')
        [CompletionResult]::new('--paths', 'paths', [CompletionResultType]::ParameterValue, 'The path to a file with paths to source file(s)')
        [CompletionResult]::new('--config-path', 'config-path', [CompletionResultType]::ParameterValue, 'The path to an alternative config.json file')
        [CompletionResult]::new('-h', 'h', [CompletionResultType]::ParameterValue, 'Print help')
        [CompletionResult]::new('--help', 'help', [CompletionResultType]::ParameterValue, 'Print help')
      }
      'playground' {
        [CompletionResult]::new('-q', 'q', [CompletionResultType]::ParameterValue, "Don't open in default browser")
        [CompletionResult]::new('--quiet', 'quiet', [CompletionResultType]::ParameterValue, "Don't open in default browser")
        [CompletionResult]::new('--grammar-path', 'grammar-path', [CompletionResultType]::ParameterValue, 'Path to the directory containing the grammar and wasm files')
        [CompletionResult]::new('-h', 'h', [CompletionResultType]::ParameterValue, 'Print help')
        [CompletionResult]::new('--help', 'help', [CompletionResultType]::ParameterValue, 'Print help')
      }
      'dump-languages' {
        [CompletionResult]::new('--config-path', 'config-path', [CompletionResultType]::ParameterValue, 'The path to an alternative config.json file')
        [CompletionResult]::new('-h', 'h', [CompletionResultType]::ParameterValue, 'Print help')
        [CompletionResult]::new('--help', 'help', [CompletionResultType]::ParameterValue, 'Print help')
      }
      default {
        if ($commandAst.CommandElements.Count -le 2 -and $wordToComplete[0] -ne '-') {
          [CompletionResult]::new('init-config', 'init-config', [CompletionResultType]::ParameterValue, 'Generate a default config file')
          [CompletionResult]::new('generate', 'generate', [CompletionResultType]::ParameterValue, 'Generate a parser')
          [CompletionResult]::new('build', 'build', [CompletionResultType]::ParameterValue, 'Compile a parser')
          [CompletionResult]::new('build-wasm', 'build-wasm', [CompletionResultType]::ParameterValue, 'Compile a parser to WASM')
          [CompletionResult]::new('parse', 'parse', [CompletionResultType]::ParameterValue, 'Parse files')
          [CompletionResult]::new('test', 'test', [CompletionResultType]::ParameterValue, "Run a parser's tests")
          [CompletionResult]::new('query', 'query', [CompletionResultType]::ParameterValue, 'Search files using a syntax tree query')
          [CompletionResult]::new('highlight', 'highlight', [CompletionResultType]::ParameterValue, 'Highlight a file')
          [CompletionResult]::new('tags', 'tags', [CompletionResultType]::ParameterValue, 'Generate a list of tags')
          [CompletionResult]::new('playground', 'playground', [CompletionResultType]::ParameterValue, 'Start local playground for a parser in the browser')
          [CompletionResult]::new('dump-languages', 'dump-languages', [CompletionResultType]::ParameterValue, 'Print info about all known language parsers')
        }
        else {
          [CompletionResult]::new('-h', 'h', [CompletionResultType]::ParameterValue, 'Print help')
          [CompletionResult]::new('--help', 'help', [CompletionResultType]::ParameterValue, 'Print help')
          [CompletionResult]::new('-v', 'v', [CompletionResultType]::ParameterValue, 'Print version')
          [CompletionResult]::new('--version', 'version', [CompletionResultType]::ParameterValue, 'Print version')
        }
      }
    }) | Where-Object CompletionText -Like "$wordToComplete*"
}
