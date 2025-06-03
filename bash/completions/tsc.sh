_tsc() {
  if [[ $2 == -* ]]; then
    mapfile -t COMPREPLY < <(compgen -W '--all --build -b --help -h --help -? --init --listFilesOnly --locale --project -p --showConfig --version -v --watch -w --allowArbitraryExtensions --allowImportingTsExtensions --allowUmdGlobalAccess --baseUrl --customConditions --module -m --moduleResolution --moduleSuffixes --noResolve --paths --resolveJsonModule --resolvePackageJsonExports --resolvePackageJsonImports --rootDir --rootDirs --typeRoots --types --allowJs --checkJs --maxNodeModuleJsDepth --allowSyntheticDefaultImports --esModuleInterop --forceConsistentCasingInFileNames --isolatedModules --preserveSymlinks --verbatimModuleSyntax --allowUnreachableCode --allowUnusedLabels --alwaysStrict --exactOptionalPropertyTypes --noFallthroughCasesInSwitch --noImplicitAny --noImplicitOverride --noImplicitReturns --noImplicitThis --noPropertyAccessFromIndexSignature --noUncheckedIndexedAccess --noUnusedLocals --noUnusedParameters --strict --strictBindCallApply --strictFunctionTypes --strictNullChecks --strictPropertyInitialization --useUnknownInCatchVariables --assumeChangesOnlyAffectDirectDependencies --charset --keyofStringsOnly --noImplicitUseStrict --noStrictGenericChecks --out --suppressExcessPropertyErrors --suppressImplicitAnyIndexErrors --composite --disableReferencedProjectLoad --disableSolutionSearching --disableSourceOfProjectReferenceRedirect --incremental -i --tsBuildInfoFile --declaration -d --declarationDir --declarationMap --downlevelIteration --emitBOM --emitDeclarationOnly --importHelpers --importsNotUsedAsValues --inlineSourceMap --inlineSources --mapRoot --newLine --noEmit --noEmitHelpers --noEmitOnError --outDir --outFile --preserveConstEnums --preserveValueImports --removeComments --sourceMap --sourceRoot --stripInternal --diagnostics --explainFiles --extendedDiagnostics --generateCpuProfile --generateTrace --listEmittedFiles --listFiles --traceResolution --disableSizeLimit --plugins --emitDecoratorMetadata --experimentalDecorators --jsx --jsxFactory --jsxFragmentFactory --jsxImportSource --lib --moduleDetection --noLib --reactNamespace --target -t --useDefineForClassFields --noErrorTruncation --preserveWatchOutput --pretty --skipDefaultLibCheck --skipLibCheck --watchFile --watchDirectory --fallbackPolling --synchronousWatchDirectory --excludeDirectories --excludeFiles --verbose -v --dry -d --force -f --clean' -- "$2")
    return
  fi
  case "$3" in
    --charset)
      mapfile -t COMPREPLY < <(compgen -W 'utf8 utf-16 utf-32 iso8859-1 ascii gb2312 gbk' -- "$2")
      ;;
    --generateCpuProfile)
      mapfile -t COMPREPLY < <(compgen -W 'profile.cpuprofile' -- "$2")
      ;;
    --jsx)
      mapfile -t COMPREPLY < <(compgen -W 'preserve react react-native react-jsx react-jsxdev' -- "$2")
      ;;
    --jsxFactory)
      mapfile -t COMPREPLY < <(compgen -W 'React.createElement h' -- "$2")
      ;;
    --jsxFragmentFactory)
      mapfile -t COMPREPLY < <(compgen -W 'React.Fragment Fragment' -- "$2")
      ;;
    --jsxImportSource)
      mapfile -t COMPREPLY < <(compgen -W 'react react-jsx vue emotion' -- "$2")
      ;;
    --reactNamespace)
      mapfile -t COMPREPLY < <(compgen -W 'React' -- "$2")
      ;;
    --moduleDetection)
      mapfile -t COMPREPLY < <(compgen -W 'legacy auto force' -- "$2")
      ;;
    --newLine)
      mapfile -t COMPREPLY < <(compgen -W 'crlf lf' -- "$2")
      ;;
    --importsNotUsedAsValues)
      mapfile -t COMPREPLY < <(compgen -W 'remove preserve error' -- "$2")
      ;;
    --locale)
      mapfile -t COMPREPLY < <(compgen -W 'zh-CN zh-TW en-US' -- "$2")
      ;;
    -m | --module)
      mapfile -t COMPREPLY < <(compgen -W 'none commonjs amd umd system es6 es2015 es2020 es2022 esnext node16 nodenext preserve' -- "$2")
      ;;
    --moduleResolution)
      mapfile -t COMPREPLY < <(compgen -W 'classic node10 node16 nodenext bundler' -- "$2")
      ;;
    --moduleSuffixes)
      mapfile -t COMPREPLY < <(compgen -W 'js,ts,json js,ts,json,jsx,tsx js,ts,json,jsx,tsx,module.css,module.scss' -- "$2")
      ;;
    --watchFile)
      mapfile -t COMPREPLY < <(compgen -W 'fixedpollinginterval prioritypollinginterval dynamicprioritypolling fixedchunksizepolling usefsevents usefseventsonparentdirectory' -- "$2")
      ;;
    --watchDirectory)
      mapfile -t COMPREPLY < <(compgen -W 'usefsevents fixedpollinginterval dynamicprioritypolling fixedchunksizepolling' -- "$2")
      ;;
    --fallbackPolling)
      mapfile -t COMPREPLY < <(compgen -W 'fixedinterval priorityinterval dynamicpriority fixedchunksize' -- "$2")
      ;;
    -t | --target)
      mapfile -t COMPREPLY < <(compgen -W 'es5 es6 es2015 es2016 es2017 es2018 es2019 es2020 es2021 es2022 esnext' -- "$2")
      ;;
    --lib)
      mapfile -t COMPREPLY < <(compgen -W 'es5 es6 es2015 es7 es2016 es2017 es2018 es2019 es2020 es2021 es2022 es2023 esnext dom dom.iterable dom.asynciterable webworker webworker.importscripts webworker.iterable webworker.asynciterable scripthost es2015.core es2015.collection es2015.generator es2015.iterable es2015.promise es2015.proxy es2015.reflect es2015.symbol es2015.symbol.wellknown es2016.array.include es2016.intl es2017.date es2017.object es2017.sharedmemory es2017.string es2017.intl es2017.typedarrays es2018.asyncgenerator es2018.asynciterable esnext.asynciterable es2018.intl es2018.promise es2018.regexp es2019.array es2019.object es2019.string es2019.symbol esnext.symbol es2019.intl es2020.bigint esnext.bigint es2020.date es2020.promise es2020.sharedmemory es2020.string es2020.symbol.wellknown es2020.intl es2020.number es2021.promise es2021.string es2021.weakref esnext.weakref es2021.intl es2022.array es2022.error es2022.intl es2022.object es2022.sharedmemory es2022.string esnext.string es2022.regexp es2023.array esnext.array es2023.collection esnext.collection esnext.intl esnext.disposable esnext.promise esnext.decorators esnext.object decorators decorators.legacy' -- "$2")
      ;;
    -i | -d | --@(allowArbitraryExtensions|allowImportingTsExtensions|allowUmdGlobalAccess|allowJs|allowSyntheticDefaultImports|allowUnreachableCode|allowUnusedLabels|resolveJsonModule|resolvePackageJsonExports|resolvePackageJsonImports|checkJS|esModuleInterop|forceConsistentCasingInFileNames|isolatedModules|preserveSymlinks|verbatimModuleSyntax|alwaysStrict|exactOptionalPropertyTypes|noFallthroughCasesInSwitch|noImplicitAny|noImplicitOverride|noImplicitReturns|noImplicitThis|noPropertyAccessFromIndexSignature|noUncheckedIndexedAccess|noUnusedLocals|noUnusedParameters|strict|strictBindCallApply|strictFunctionTypes|strictNullChecks|strictPropertyInitialization|useUnknownInCatchVariables|assumeChangesOnlyAffectDirectDependencies|keyofStringsOnly|noImplicitUseStrict|noStrictGenericChecks|suppressExcessPropertyErrors|suppressImplicitAnyIndexErrors|composite|disableReferencedProjectLoad|disableSolutionSearching|disableSourceOfProjectReferenceRedirect|incremental|declaration|declarationMap|downlevelIteration|emitBOM|emitDeclarationOnly|importHelpers|inlineSourceMap|inlineSources|noEmit|noEmitHelpers|noEmitOnError|preserveConstEnums|preserveValueImports|removeComments|sourceMap|stripInternal|diagnostics|explainFiles|extendedDiagnostics|listEmittedFiles|listFiles|traceResolution|disableSizeLimit|emitDecoratorMetadata|experimentalDecorators|noLib|useDefineForClassFields|noErrorTruncation|preserveWatchOutput|pretty|skipDefaultLibCheck|skipLibCheck|synchronousWatchDirectory))
      mapfile -t COMPREPLY < <(compgen -W 'true false' -- "$2")
      ;;
  esac
}

complete -o default -F _tsc tsc
