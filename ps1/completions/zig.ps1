using namespace System.Management.Automation.Language

Register-ArgumentCompleter -Native -CommandName zig -ScriptBlock {
  param ([string]$wordToComplete, [CommandAst]$commandAst, [int]$cursorPosition)
  $command = @(foreach ($i in $commandAst.CommandElements) {
      if ($i.Extent.StartOffset -eq $commandAst.Extent.StartOffset -or $i.Extent.EndOffset -eq $cursorPosition) {
        continue
      }
      if ($i -isnot [StringConstantExpressionAst] -or
        $i.StringConstantType -ne [StringConstantType]::BareWord -or
        $i.Value -clike '[-/]*') {
        break
      }
      $i.Value
    }) -join ' '

  if ($command -ceq 'cc' -or $command -ceq 'c++') {
    $astList = $commandAst.CommandElements | Select-Object -Skip 2
    $cursorPosition -= $astList[0].Extent.StartOffset - 6
    $commandAst = [Parser]::ParseInput("clang $astList", [ref]$null, [ref]$null).EndBlock.Statements[0].PipelineElements[0]
    return & (Get-ArgumentCompleter clang) $wordToComplete $commandAst $cursorPosition
  }

  $cursorPosition -= $wordToComplete.Length
  foreach ($i in $commandAst.CommandElements) {
    if ($i.Extent.StartOffset -ge $cursorPosition) {
      break
    }
    $prev = $i
  }
  $prev = $prev -is [System.Management.Automation.Language.StringConstantExpressionAst] ? $prev.Value : $prev.ToString()

  @(if ($wordToComplete.StartsWith('-')) {
      '-h', '--help'
    }
    switch ($command) {
      '' {
        if ($wordToComplete.StartsWith('-')) {
          break
        }
        'build', 'fetch', 'init', 'build-exe', 'build-lib', 'build-obj', 'test', 'test-obj', 'run', 'ast-check', 'fmt', 'reduce', 'translate-c', 'ar', 'cc', 'c++', 'dlltool', 'lib', 'ranlib', 'objcopy', 'rc', 'env', 'help', 'std', 'libc', 'targets', 'version', 'zen'
        break
      }
      'fetch' {
        if ($wordToComplete.StartsWith('-')) {
          '-h', '--help', '--global-cache-dir', '--debug-hash', '--save', '--save=', '--save-exact', '--save-exact='
          break
        }
        break
      }
      'init' {
        if ($wordToComplete.StartsWith('-')) {
          '-m', '--minimal', '-h', '--help'
          break
        }
        break
      }
      'ast-check' {
        if ($wordToComplete.StartsWith('-')) {
          '-h', '--help', '--color', '--zon', '-t'
          break
        }
        switch ($prev) {
          '--color' { 'auto', 'off', 'on'; break }
        }
        break
      }
      'fmt' {
        if ($wordToComplete.StartsWith('-')) {
          '-h', '--help', '--color', '--stdin', '--check', '--ast-check', '--exclude', '--zon'
          break
        }
        switch ($prev) {
          '--color' { 'auto', 'off', 'on'; break }
        }
        break
      }
      'reduce' {
        if ($wordToComplete.StartsWith('-')) {
          '-h,', '--help', '--color', '--stdin', '--check', '', '--ast-check', '--exclude', '--zon'
          break
        }
        break
      }
      'ar' {
        if ($wordToComplete.StartsWith('-')) {
          '-M', '--format=default', '--format=gnu', '--format=darwin', '--format=bsd', '--format=bigarchive', '--format=coff', '--plugin=', '-h', '--help', '--output', '--rsp-quoting', '--thin', '--version', '-X32', '-X64', '-X32_64', '-Xany'
          break
        }
        break
      }
      'dlltool' {
        if ($wordToComplete.StartsWith('-')) {
          '-D', '-d', '-f', '--identify-strict', '-I', '-k', '-l', '-m', '--no-leading-underscore', '-N', '-S', '-t'
          break
        }
        switch ($prev) {
          '-m' { 'i386', 'i386:x86-64', 'arm', 'arm64', 'arm64ec', 'r4000'; break }
        }
        break
      }
      'lib' {
        if ($wordToComplete.StartsWith('/')) {
          '/def:', '/defArm64Native:', '/ignore:', '/libpath:', '/list', '/llvmlibempty', '/llvmlibindex:no', '/llvmlibindex', '/llvmlibthin', '/machine:i386', '/machine:i386:x86-64', '/machine:arm', '/machine:arm64', '/machine:arm64ec', '/machine:r4000', '/out:', '/WX:no', '/WX', '/?'
          break
        }
        break
      }
      'ranlib' {
        if ($wordToComplete.StartsWith('-')) {
          '-h', '--help', '-V', '--version', '-D', '-U', '-X32', '-X64', '-X32_64', '-Xany'
          break
        }
        break
      }
      'objcopy' {
        if ($wordToComplete.StartsWith('-')) {
          '-h', '--help', '--output-target=', '-O', '--only-section=', '-j', '--pad-to', '--strip-debug', '-g', '--strip-all', '-S', '--only-keep-debug', '--add-gnu-debuglink=', '--extract-to', '--compress-debug-sections', '--set-section-alignment', '--set-section-flags', '--add-section'
          break
        }
        break
      }
      'rc' {
        if ($wordToComplete.StartsWith('/')) {
          '/?', '/h', '/v', '/d', '/u', '/fo', '/l', '/ln', '/i', '/x', '/c', '/w', '/y', '/n', '/sl', '/p', '/nologo', '/a', '/r', '/:no-preprocess', '/:debug', '/:auto-includes', '/:depfile', '/:depfile-fmt', '/:input-format', '/:output-format', '/:target'
          break
        }
        switch ($prev) {
          '/:auto-includes' { 'any', 'msvc', 'gnu', 'none'; break }
          '/:depfile-format' { 'json'; break }
          '/:input-format' { 'rc', 'res', 'rcpp'; break }
          '/:output-format' { 'res', 'coff', 'rcpp'; break }
        }
        break
      }
      'std' {
        if ($wordToComplete.StartsWith('-')) {
          '-h', '--help', '-p', '--port', '--open-browser', '--no-open-browser'
          break
        }
        break
      }
      'libc' {
        if ($wordToComplete.StartsWith('-')) {
          '-h', '--help', '-target', '-includes'
          break
        }
        switch ($prev) {
          '-target' { 'i386', 'i386:x86-64', 'arm', 'arm64', 'arm64ec', 'r4000'; break }
        }
        break
      }
      { $_ -cmatch '^(build-exe|build-lib|build-obj|test|test-obj|run|translate-c)$' } {
        if ($wordToComplete.StartsWith('-')) {
          '-h', '--help', '--color', '-j', '-fincremental', '-fno-incremental', '-femit-bin', '-femit-bin=', '-fno-emit-bin', '-femit-asm', '-femit-asm=', '-fno-emit-asm', '-femit-llvm-ir', '-femit-llvm-ir=', '-fno-emit-llvm-ir', '-femit-llvm-bc', '-femit-llvm-bc=', '-fno-emit-llvm-bc', '-femit-h', '-femit-h=', '-fno-emit-h', '-femit-docs', '-femit-docs=', '-fno-emit-docs', '-femit-implib', '-femit-implib=', '-fno-emit-implib', '--show-builtin', '--cache-dir', '--global-cache-dir', '--zig-lib-dir', '--name', '--libc', '-x', '--dep', '-M', '-M', '--error-limit', '-fllvm', '-fno-llvm', '-flibllvm', '-fno-libllvm', '-fclang', '-fno-clang', '-fPIE', '-fno-PIE', '-flto', '-fno-lto', '-fdll-export-fns', '-fno-dll-export-fns', '-freference-trace', '-freference-trace=', '-fno-reference-trace', '-ffunction-sections', '-fno-function-sections', '-fdata-sections', '-fno-data-sections', '-fformatted-panics', '-fno-formatted-panics', '-fstructured-cfg', '-fno-structured-cfg', '-mexec-model=', '-municode', '--time-report', '-target', '-O', '-ofmt=elf', '-ofmt=c', '-ofmt=wasm', '-ofmt=coff', '-ofmt=macho', '-ofmt=spirv', '-ofmt=plan9', '-ofmt=hex', '-ofmt=raw', '-mcpu', '-mcmodel=default', '-mcmodel=extreme', '-mcmodel=kernel', '-mcmodel=large', '-mcmodel=medany', '-mcmodel=medium', '-mcmodel=medlow', '-mcmodel=medmid', '-mcmodel=normal', '-mcmodel=small', '-mcmodel=tiny', '-mred-zone', '-mno-red-zone', '-fomit-frame-pointer', '-fno-omit-frame-pointer', '-fPIC', '-fno-PIC', '-fstack-check', '-fno-stack-check', '-fstack-protector', '-fno-stack-protector', '-fvalgrind', '-fno-valgrind', '-fsanitize-c', '-fsanitize-c=trap', '-fsanitize-c=full', '-fno-sanitize-c', '-fsanitize-thread', '-fno-sanitize-thread', '-ffuzz', '-fno-fuzz', '-fbuiltin', '-fno-builtin', '-funwind-tables', '-fasync-unwind-tables', '-fno-unwind-tables', '-ferror-tracing', '-fno-error-tracing', '-fsingle-threaded', '-fno-single-threaded', '-fstrip', '-fno-strip', '-idirafter', '-isystem', '-I', '--embed-dir=', '-D', '-cflags', '-rcflags', '-rcincludes=any', '-rcincludes=msvc', '-rcincludes=gnu', '-rcincludes=none', '-T', '--version-script', '--undefined-version', '--no-undefined-version', '--enable-new-dtags', '--disable-new-dtags', '--dynamic-linker', '--sysroot', '--version', '-fentry', '-fentry=', '-fno-entry', '--force_undefined', '-fsoname', '-fsoname=', '-fno-soname', '-flld', '-fno-lld', '-fcompiler-rt', '-fno-compiler-rt', '-fubsan-rt', '-fno-ubsan-rt', '-rdynamic', '-feach-lib-rpath', '-fno-each-lib-rpath', '-fallow-shlib-undefined', '-fno-allow-shlib-undefined', '-fallow-so-scripts', '-fno-allow-so-scripts', '--build-id', '--build-id=fast', '--build-id=sha1', '--build-id=tree', '--build-id=md5', '--build-id=uuid', '--build-id=0x', '--build-id=none', '--eh-frame-hdr', '--no-eh-frame-hdr', '--emit-relocs', '-z', '-dynamic', '-static', '-Bsymbolic', '--compress-debug-sections=none', '--compress-debug-sections=zlib', '--compress-debug-sections=zstd', '--gc-sections', '--no-gc-sections', '--sort-section=', '--subsystem', '--stack', '--image-base', '-install_name=', '--entitlements', '-pagezero_size', '-headerpad', '-headerpad_max_install_names', '-dead_strip', '-dead_strip_dylibs', '-ObjC', '--import-memory', '--export-memory', '--import-symbols', '--import-table', '--export-table', '--initial-memory=', '--max-memory=', '--shared-memory', '--global-base=', '-l', '--library', '-needed-l', '--needed-library', '-weak-l', '-weak_library', '-L', '--library-directory', '-search_paths_first', '-search_paths_first_static', '-search_dylibs_first', '-search_static_first', '-search_dylibs_only', '-search_static_only', '-rpath', '-framework', '-needed_framework', '-needed_library', '-weak_framework', '-F', '--export=', '--test-filter', '--test-name-prefix', '--test-cmd', '--test-cmd-bin', '--test-evented-io', '--test-no-exec', '--test-runner', '-fopt-bisect-limit=', '-fstack-report', '--verbose-link', '--verbose-cc', '--verbose-air', '--verbose-intern-pool', '--verbose-generic-instances', '--verbose-llvm-ir', '--verbose-llvm-ir=', '--verbose-llvm-bc=', '--verbose-cimport', '--verbose-llvm-cpu-features', '--debug-log', '--debug-compile-errors', '--debug-link-snapshot', '--debug-rt', '--debug-incremental'
          break
        }
        switch ($prev) {
          '--color' { 'auto', 'off', 'on'; break }
          '-O' { 'Debug', 'ReleaseFast', 'ReleaseSafe', 'ReleaseSmall'; break }
          '-target' { '<arch><sub>-<os>-<abi>'; break }
          '-x' { '.zig', '.o', '.o', '.o', '.obj', '.lib', '.a', '.a', '.a', '.so', '.dll', '.dylib', '.tbd', '.s', '.S', '.c', '.cxx', '.cc', '.C', '.cpp', '.c++', '.m', '.mm', '.bc'; break }
          '-z' { 'nodelete', 'notext', 'defs', 'undefs', 'origin', 'nocopyreloc', 'now', 'lazy', 'relro', 'norelro', 'common-page-size=', 'max-page-size='; break }
        }
        break
      }
    }).Where{ $_ -like "$wordToComplete*" }
}
