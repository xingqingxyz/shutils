using namespace System.Management.Automation.Language

Register-ArgumentCompleter -Native -CommandName cmake -ScriptBlock {
  param ([string]$wordToComplete, [CommandAst]$commandAst, [int]$cursorPosition)
  $cursorPosition -= $wordToComplete.Length
  foreach ($i in $commandAst.CommandElements) {
    if ($i.Extent.StartOffset -ge $cursorPosition) {
      break
    }
    $prev = $i
  }
  $prev = $prev -is [System.Management.Automation.Language.StringConstantExpressionAst] ? $prev.Value : $prev.ToString()

  @(switch ($prev) {
      # Create or update a cmake cache entry.
      '-D' { break }
      # Specify toolset name if supported
      '-T' { break }
      # Specify platform name if supported
      '-A' { break }
      '-G' { 'Visual Studio 18 2026', 'Visual Studio 17 2022', 'Visual Studio 16 2019', 'Visual Studio 15 2017', 'Visual Studio 14 2015', 'Borland Makefiles', 'NMake Makefiles', 'NMake Makefiles JOM', 'MSYS Makefiles', 'MinGW Makefiles', 'Green Hills MULTI', 'Unix Makefiles', 'Ninja', 'Ninja Multi-Config', 'Watcom WMake', 'CodeBlocks - MinGW Makefiles', 'CodeBlocks - NMake Makefiles', 'CodeBlocks - NMake Makefiles JOM', 'CodeBlocks - Ninja', 'CodeBlocks - Unix Makefiles', 'CodeLite - MinGW Makefiles', 'CodeLite - NMake Makefiles', 'CodeLite - Ninja', 'CodeLite - Unix Makefiles', 'Eclipse CDT4 - NMake Makefiles', 'Eclipse CDT4 - MinGW Makefiles', 'Eclipse CDT4 - Ninja', 'Eclipse CDT4 - Unix Makefiles', 'Kate - MinGW Makefiles', 'Kate - NMake Makefiles', 'Kate - Ninja', 'Kate - Ninja Multi-Config', 'Kate - Unix Makefiles', 'Sublime Text 2 - MinGW Makefiles', 'Sublime Text 2 - NMake Makefiles', 'Sublime Text 2 - Ninja', 'Sublime Text 2 - Unix Makefiles'; break }
      default {
        if ($wordToComplete.StartsWith('-')) {
          '-S', '-B', '-C', '-D', '-U', '-G', '-T', '-A', '--toolchain', '--install-prefix', '--project-file', '-Wdev', '-Wno-dev', '-Werror=dev', '-Wno-error=dev', '-Wdeprecated', '-Wno-deprecated', '-Werror=deprecated', '-Wno-error=deprecated', '--preset', '--list-presets', '--workflow', '-E', '-L', '-LR', '--fresh', '--build', '--install', '--open', '-N', '-P', '--find-package', '--graphviz=', '--system-information', '--print-config-dir', '--log-level=ERROR', '--log-level=WARNING', '--log-level=NOTICE', '--log-level=STATUS', '--log-level=VERBOSE', '--log-level=DEBUG', '--log-level=TRACE', '--log-context', '--debug-trycompile', '--debug-output', '--debug-find', '--debug-find-pkg=', '--debug-find-var=', '--trace', '--trace-expand', '--trace-format=human', '--trace-format=json-v1', '--trace-source=', '--trace-redirect=', '--warn-uninitialized', '--no-warn-unused-cli', '--check-system-vars', '--compile-no-warning-as-error', '--link-no-warning-as-error', '--profiling-format=google-trace', '--profiling-output=', '-h', '-H', '--help', '-help', '-usage', '/?', '--version', '-version', '/V', '--help', '--help-full', '--help-manual', '--help-manual-list', '--help-command', '--help-command-list', '--help-commands', '--help-module', '--help-module-list', '--help-modules', '--help-policy', '--help-policy-list', '--help-policies', '--help-property', '--help-property-list', '--help-properties', '--help-variable var', '--help-variable-list', '--help-variables'
          break
        }
        break
      }
    }).Where{ $_ -like "$wordToComplete*" }
}
