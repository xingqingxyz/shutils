Register-ArgumentCompleter -Native -CommandName rollup -ScriptBlock {
  param ([string]$wordToComplete, [System.Management.Automation.Language.CommandAst]$commandAst, [int]$cursorPosition)
  $cursorPosition -= $wordToComplete.Length
  foreach ($key in $commandAst.CommandElements) {
    if ($key.Extent.StartOffset -eq $cursorPosition) {
      break
    }
    $prev = $key
  }
  @(switch ($prev.ToString()) {
      '--exports' {
        @('auto', 'default', 'named', 'none')
      }
      { $_ -eq '-f' -or $_ -eq '--format' } {
        @('amd', 'cjs', 'es', 'iife', 'umd', 'system')
      }
      Default {
        @('-c', '--config', '-d', '--dir', '-e', '--external', '-f', '--format', '-g', '--globals', '-h', '--help', '-i', '--input', '-m', '--sourcemap', '-n', '--name', '-o', '--file', '-p', '--plugin', '-v', '--version', '-w', '--watch', '--amd.autoId', '--amd.basePath', '--amd.define', '--amd.forceJsExtensionForImports', '--amd.id', '--assetFileNames', '--banner', '--chunkFileNames', '--compact', '--context', '--no-dynamicImportInCjs', '--entryFileNames', '--environment', '--no-esModule', '--exports', '--extend', '--no-externalImportAttributes', '--no-externalLiveBindings', '--failAfterWarnings', '--filterLogs', '--footer', '--forceExit', '--no-freeze', '--generatedCode', '--generatedCode.arrowFunctions', '--generatedCode.constBindings', '--generatedCode.objectShorthand', '--no-generatedCode.reservedNamesAsProps', '--generatedCode.symbols', '--hashCharacters', '--no-hoistTransitiveImports', '--importAttributesKey', '--no-indent', '--inlineDynamicImports', '--no-interop', '--intro', '--logLevel', '--no-makeAbsoluteExternalsRelative', '--maxParallelFileOps', '--minifyInternalExports', '--noConflict', '--outro', '--perf', '--no-preserveEntrySignatures', '--preserveModules', '--preserveModulesRoot', '--preserveSymlinks', '--no-reexportProtoFromExternal', '--no-sanitizeFileName', '--shimMissingExports', '--silent', '--sourcemapBaseUrl', '--sourcemapExcludeSources', '--sourcemapFile', '--sourcemapFileNames', '--stdin', '--no-stdin', '--no-strict', '--strictDeprecations', '--no-systemNullSetters', '--no-treeshake', '--no-treeshake.annotations', '--treeshake.correctVarValueBeforeDeclaration', '--treeshake.manualPureFunctions', '--no-treeshake.moduleSideEffects', '--no-treeshake.propertyReadSideEffects', '--no-treeshake.tryCatchDeoptimization', '--no-treeshake.unknownGlobalSideEffects', '--validate', '--waitForBundleInput', '--watch.buildDelay', '--no-watch.clearScreen', '--watch.exclude', '--watch.include', '--watch.onBundleEnd', '--watch.onBundleStart', '--watch.onEnd', '--watch.onError', '--watch.onStart', '--watch.skipWrite')
      }
    }).Where{ $_ -like "$wordToComplete*" }
}
