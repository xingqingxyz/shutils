using namespace System.Management.Automation
using namespace System.Management.Automation.Language

Register-ArgumentCompleter -Native -CommandName go -ScriptBlock {
  param([string]$wordToComplete, [CommandAst]$commandAst, [int]$cursorPosition)
  $subcmd = @(foreach ($key in $commandAst.CommandElements) {
      $key = $key.ToString()
      if ($key -ne 'cargo' -and $key[0] -ne '-') {
        $key
      }
    }) -join '_'

  @(switch ($subcmd) {
      'help' {
        [CompletionResult]::new('buildconstraint', 'buildconstraint', [CompletionResultType]::ParameterValue, 'build constraints')
        [CompletionResult]::new('buildmode', 'buildmode', [CompletionResultType]::ParameterValue, 'build modes')
        [CompletionResult]::new('c', 'c', [CompletionResultType]::ParameterValue, 'calling between Go and C')
        [CompletionResult]::new('cache', 'cache', [CompletionResultType]::ParameterValue, 'build and test caching')
        [CompletionResult]::new('environment', 'environment', [CompletionResultType]::ParameterValue, 'environment variables')
        [CompletionResult]::new('filetype', 'filetype', [CompletionResultType]::ParameterValue, 'file types')
        [CompletionResult]::new('go.mod', 'go.mod', [CompletionResultType]::ParameterValue, 'the go.mod file')
        [CompletionResult]::new('gopath', 'gopath', [CompletionResultType]::ParameterValue, 'GOPATH environment variable')
        [CompletionResult]::new('goproxy', 'goproxy', [CompletionResultType]::ParameterValue, 'module proxy protocol')
        [CompletionResult]::new('importpath', 'importpath', [CompletionResultType]::ParameterValue, 'import path syntax')
        [CompletionResult]::new('modules', 'modules', [CompletionResultType]::ParameterValue, 'modules, module versions, and more')
        [CompletionResult]::new('module-auth', 'module-auth', [CompletionResultType]::ParameterValue, 'module authentication using go.sum')
        [CompletionResult]::new('packages', 'packages', [CompletionResultType]::ParameterValue, 'package lists and patterns')
        [CompletionResult]::new('private', 'private', [CompletionResultType]::ParameterValue, 'configuration for downloading non-public code')
        [CompletionResult]::new('testflag', 'testflag', [CompletionResultType]::ParameterValue, 'testing flags')
        [CompletionResult]::new('testfunc', 'testfunc', [CompletionResultType]::ParameterValue, 'testing functions')
        [CompletionResult]::new('vcs', 'vcs', [CompletionResultType]::ParameterValue, 'controlling version control with GOVCS')
      }
      'build' {
        [CompletionResult]::new('re', 'e', [CompletionResultType]::ParameterValue, @'
        usage: go build [-o output] [build flags] [packages]

        Build compiles the packages named by the import paths,
        along with their dependencies, but it does not install the results.

        If the arguments to build are a list of .go files from a single directory,
        build treats them as a list of source files specifying a single package.

        When compiling packages, build ignores files that end in '_test.go'.

        When compiling a single main package, build writes the resulting
        executable to an output file named after the last non-major-version
        component of the package import path. The '.exe' suffix is added
        when writing a Windows executable.
        So 'go build example/sam' writes 'sam' or 'sam.exe'.
        'go build example.com/foo/v2' writes 'foo' or 'foo.exe', not 'v2.exe'.

        When compiling a package from a list of .go files, the executable
        is named after the first source file.
        'go build ed.go rx.go' writes 'ed' or 'ed.exe'.

        When compiling multiple packages or a single non-main package,
        build compiles the packages but discards the resulting object,
        serving only as a check that the packages can be built.

        The -o flag forces build to write the resulting executable or object
        to the named output file or directory, instead of the default behavior described
        in the last two paragraphs. If the named output is an existing directory or
        ends with a slash or backslash, then any resulting executables
        will be written to that directory.

        The build flags are shared by the build, clean, get, install, list, run,
        and test commands:
'@)
        [CompletionResult]::new('-C', 'C', [CompletionResultType]::ParameterValue, 'Change to dir before running the command.
        Any files named on the command line are interpreted after
        changing directories.
        If used, this flag must be the first one in the command line.
        ')
        [CompletionResult]::new('-a', 'a', [CompletionResultType]::ParameterValue, 'force rebuilding of packages that are already up-to-date.
        ')
        [CompletionResult]::new('-n', 'n', [CompletionResultType]::ParameterValue, 'print the commands but do not run them.
        ')
        [CompletionResult]::new('-p', 'p', [CompletionResultType]::ParameterValue, 'the number of programs, such as build commands or
        test binaries, that can be run in parallel.
        The default is GOMAXPROCS, normally the number of CPUs available.
        ')
        [CompletionResult]::new('-race', 'race', [CompletionResultType]::ParameterValue, 'enable data race detection.
        Supported only on linux/amd64, freebsd/amd64, darwin/amd64, darwin/arm64, windows/amd64,
        linux/ppc64le and linux/arm64 (only for 48-bit VMA).
        ')
        [CompletionResult]::new('-msan', 'msan', [CompletionResultType]::ParameterValue, 'enable interoperation with memory sanitizer.
        Supported only on linux/amd64, linux/arm64, linux/loong64, freebsd/amd64
        and only with Clang/LLVM as the host C compiler.
        PIE build mode will be used on all platforms except linux/amd64.
        ')
        [CompletionResult]::new('-asan', 'asan', [CompletionResultType]::ParameterValue, 'enable interoperation with address sanitizer.
        Supported only on linux/arm64, linux/amd64, linux/loong64.
        Supported on linux/amd64 or linux/arm64 and only with GCC 7 and higher
        or Clang/LLVM 9 and higher.
        And supported on linux/loong64 only with Clang/LLVM 16 and higher.
        ')
        [CompletionResult]::new('-cover', 'cover', [CompletionResultType]::ParameterValue, 'enable code coverage instrumentation.
        ')
        [CompletionResult]::new('-covermode', 'covermode', [CompletionResultType]::ParameterValue, 'set the mode for coverage analysis.
        The default is "set" unless -race is enabled,
        in which case it is "atomic".
        The values:
        set: bool: does this statement run?
        count: int: how many times does this statement run?
        atomic: int: count, but correct in multithreaded tests;
        significantly more expensive.
        Sets -cover.
        ')
        [CompletionResult]::new('-coverpkg', 'coverpkg', [CompletionResultType]::ParameterValue, "For a build that targets package 'main' (e.g. building a Go
        executable), apply coverage analysis to each package matching
        the patterns. The default is to apply coverage analysis to
        packages in the main Go module. See 'go help packages' for a
        description of package patterns.  Sets -cover.
        ")
        [CompletionResult]::new('-v', 'v', [CompletionResultType]::ParameterValue, 'print the names of packages as they are compiled.
        ')
        [CompletionResult]::new('-work', 'work', [CompletionResultType]::ParameterValue, 'print the name of the temporary work directory and
        do not delete it when exiting.
        ')
        [CompletionResult]::new('-x', 'x', [CompletionResultType]::ParameterValue, 'print the commands.
        ')
        [CompletionResult]::new('-asmflags', 'asmflags', [CompletionResultType]::ParameterValue, 'arguments to pass on each go tool asm invocation.
        ')
        [CompletionResult]::new('-buildmode', 'buildmode', [CompletionResultType]::ParameterValue, "build mode to use. See 'go help buildmode' for more.
        ")
        [CompletionResult]::new('-buildvcs', 'buildvcs', [CompletionResultType]::ParameterValue, 'Whether to stamp binaries with version control information
        ("true", "false", or "auto"). By default ("auto"), version control
        information is stamped into a binary if the main package, the main module
        containing it, and the current directory are all in the same repository.
        Use -buildvcs=false to always omit version control information, or
        -buildvcs=true to error out if version control information is available but
        cannot be included due to a missing tool or ambiguous directory structure.
        ')
        [CompletionResult]::new('-compiler', 'compiler', [CompletionResultType]::ParameterValue, 'name of compiler to use, as in runtime.Compiler (gccgo or gc).
        ')
        [CompletionResult]::new('-gccgoflags', 'gccgoflags', [CompletionResultType]::ParameterValue, 'arguments to pass on each gccgo compiler/linker invocation.
        ')
        [CompletionResult]::new('-gcflags', 'gcflags', [CompletionResultType]::ParameterValue, 'arguments to pass on each go tool compile invocation.
        ')
        [CompletionResult]::new('-installsuffix', 'installsuffix', [CompletionResultType]::ParameterValue, 'a suffix to use in the name of the package installation directory,
        in order to keep output separate from default builds.
        If using the -race flag, the install suffix is automatically set to race
        or, if set explicitly, has _race appended to it. Likewise for the -msan
        and -asan flags. Using a -buildmode option that requires non-default compile
        flags has a similar effect.
        ')
        [CompletionResult]::new('-ldflags', 'ldflags', [CompletionResultType]::ParameterValue, 'arguments to pass on each go tool link invocation.
        ')
        [CompletionResult]::new('-linkshared', 'linkshared', [CompletionResultType]::ParameterValue, 'build code that will be linked against shared libraries previously
        created with -buildmode=shared.
        ')
        [CompletionResult]::new('-mod', 'mod', [CompletionResultType]::ParameterValue, 'module download mode to use: readonly, vendor, or mod.
        By default, if a vendor directory is present and the go version in go.mod
        is 1.14 or higher, the go command acts as if -mod=vendor were set.
        Otherwise, the go command acts as if -mod=readonly were set.
        See https://golang.org/ref/mod#build-commands for details.
        ')
        [CompletionResult]::new('-modcacherw', 'modcacherw', [CompletionResultType]::ParameterValue, 'leave newly-created directories in the module cache read-write
        instead of making them read-only.
        ')
        [CompletionResult]::new('-modfile', 'modfile', [CompletionResultType]::ParameterValue, 'in module aware mode, read (and possibly write) an alternate go.mod
        file instead of the one in the module root directory. A file named
        "go.mod" must still be present in order to determine the module root
        directory, but it is not accessed. When -modfile is specified, an
        alternate go.sum file is also used: its path is derived from the
        -modfile flag by trimming the ".mod" extension and appending ".sum".
        ')
        [CompletionResult]::new('-overlay', 'overlay', [CompletionResultType]::ParameterValue, "read a JSON config file that provides an overlay for build operations.
        The file is a JSON struct with a single field, named 'Replace', that
        maps each disk file path (a string) to its backing file path, so that
        a build will run as if the disk file path exists with the contents
        given by the backing file paths, or as if the disk file path does not
        exist if its backing file path is empty. Support for the -overlay flag
        has some limitations: importantly, cgo files included from outside the
        include path must be in the same directory as the Go package they are
        included from, and overlays will not appear when binaries and tests are
        run through go run and go test respectively.
        ")
        [CompletionResult]::new('-pgo', 'pgo', [CompletionResultType]::ParameterValue, "specify the file path of a profile for profile-guided optimization (PGO).
        When the special name `"auto`" is specified, for each main package in the
        build, the go command selects a file named `"default.pgo`" in the package's
        directory if that file exists, and applies it to the (transitive)
        dependencies of the main package (other packages are not affected).
        Special name `"off`" turns off PGO. The default is `"auto`".
        ")
        [CompletionResult]::new('-pkgdir', 'pkgdir', [CompletionResultType]::ParameterValue, 'install and load all packages from dir instead of the usual locations.
        For example, when building with a non-standard configuration,
        use -pkgdir to keep generated packages in a separate location.
        ')
        [CompletionResult]::new('-tags', 'tags', [CompletionResultType]::ParameterValue, "a comma-separated list of additional build tags to consider satisfied
        during the build. For more information about build tags, see
        'go help buildconstraint'. (Earlier versions of Go used a
        space-separated list, and that form is deprecated but still recognized.)
        ")
        [CompletionResult]::new('-trimpath', 'trimpath', [CompletionResultType]::ParameterValue, 'remove all file system paths from the resulting executable.
        Instead of absolute file system paths, the recorded file names
        will begin either a module path@version (when using modules),
        or a plain import path (when using the standard library, or GOPATH).
        ')
      }
      'clean' {
        [CompletionResult]::new('-i', 'i', [CompletionResultType]::ParameterName, 'The -n flag causes clean to print the remove commands it would execute, but not run them.')
        [CompletionResult]::new('-n', 'n', [CompletionResultType]::ParameterName, 'The -n flag causes clean to print the remove commands it would execute, but not run them.')
        [CompletionResult]::new('-r', 'r', [CompletionResultType]::ParameterName, 'The -r flag causes clean to be applied recursively to all the dependencies of the packages named by the import paths.')
        [CompletionResult]::new('-x', 'x', [CompletionResultType]::ParameterName, 'The -x flag causes clean to print remove commands as it executes them.')
        [CompletionResult]::new('-cache', 'cache', [CompletionResultType]::ParameterName, 'The -cache flag causes clean to remove the entire go build cache.')
        [CompletionResult]::new('-testcache', 'testcache', [CompletionResultType]::ParameterName, 'The -testcache flag causes clean to expire all test results in the go build cache.')
        [CompletionResult]::new('-modcache', 'modcache', [CompletionResultType]::ParameterName, 'The -modcache flag causes clean to remove the entire module download cache, including unpacked source code of versioned dependencies.')
        [CompletionResult]::new('-fuzzcache', 'fuzzcache', [CompletionResultType]::ParameterName, 'The -fuzzcache flag causes clean to remove files stored in the Go build cache for fuzz testing. The fuzzing engine caches files that expand code coverage, so removing them may make fuzzing less effective until new inputs are found that provide the same coverage. These files are distinct from those stored in testdata directory; clean does not remove those files.')
      }
      'doc' {
        [CompletionResult]::new('-all', 'all', [CompletionResultType]::ParameterName, 'Show all the documentation for the package.')
        [CompletionResult]::new('-c', 'c', [CompletionResultType]::ParameterName, 'Respect case when matching symbols.')
        [CompletionResult]::new('-cmd', 'cmd', [CompletionResultType]::ParameterName, "Treat a command (package main) like a regular package. Otherwise package main's exported symbols are hidden when showing the package's top-level documentation.")
        [CompletionResult]::new('-short', 'short', [CompletionResultType]::ParameterName, 'One-line representation for each symbol.')
        [CompletionResult]::new('-src', 'src', [CompletionResultType]::ParameterName, 'Show the full source code for the symbol. This will display the full Go source of its declaration and definition, such as a function definition (including the body), type declaration or enclosing const block. The output may therefore include unexported details.')
        [CompletionResult]::new('-u', 'u', [CompletionResultType]::ParameterName, 'Show documentation for unexported as well as exported symbols, methods, and fields.')
      }
      'env' {
        [CompletionResult]::new('-json', 'json', [CompletionResultType]::ParameterName, 'The -json flag prints the environment in JSON format instead of as a shell script.')
        [CompletionResult]::new('-u', 'u', [CompletionResultType]::ParameterName, "The -u flag requires one or more arguments and unsets the default setting for the named environment variables, if one has been set with 'go env -w'.")
        [CompletionResult]::new('-w', 'w', [CompletionResultType]::ParameterName, 'The -w flag requires one or more arguments of the form NAME=VALUE and changes the default settings of the named environment variables to the given values.')
      }
      'fix' {
        [CompletionResult]::new('-fix', 'fix', [CompletionResultType]::ParameterName, "The -fix flag sets a comma-separated list of fixes to run. The default is all known fixes. (Its value is passed to 'go tool fix -r'.)")
      }
      'fmt' {
        [CompletionResult]::new('-n', 'n', [CompletionResultType]::ParameterName, 'The -n flag prints commands that would be executed.')
        [CompletionResult]::new('-x', 'x', [CompletionResultType]::ParameterName, 'The -x flag prints commands as they are executed.')
        [CompletionResult]::new('-mod', 'mod', [CompletionResultType]::ParameterName, "The -mod flag's value sets which module download mode to use: readonly or vendor. See 'go help modules' for more.")
      }
      'generate' {
        [CompletionResult]::new('-v', 'v', [CompletionResultType]::ParameterName, 'The -v flag prints the names of packages and files as they are processed.')
        [CompletionResult]::new('-n', 'n', [CompletionResultType]::ParameterName, 'The -n flag prints commands that would be executed.')
        [CompletionResult]::new('-x', 'x', [CompletionResultType]::ParameterName, 'The -x flag prints commands as they are executed.')
        [CompletionResult]::new('-run', 'run', [CompletionResultType]::ParameterName, 'if non-empty, specifies a regular expression to select directives whose full original source text (excluding any trailing spaces and final newline) matches the expression.')
        [CompletionResult]::new('-skip', 'skip', [CompletionResultType]::ParameterName, 'if non-empty, specifies a regular expression to suppress directives whose full original source text (excluding any trailing spaces and final newline) matches the expression. If a directive matches both the -run and the -skip arguments, it is skipped.')
      }
      'get' {
        [CompletionResult]::new('-t', 't', [CompletionResultType]::ParameterName, 'The -t flag instructs get to consider modules needed to build tests of packages specified on the command line.')
        [CompletionResult]::new('-u', 'u', [CompletionResultType]::ParameterName, 'The -u flag instructs get to update modules providing dependencies of packages named on the command line to use newer minor or patch releases when available.')
        [CompletionResult]::new('-u=patch', 'u=patch', [CompletionResultType]::ParameterName, 'The -u=patch flag (not -u patch) also instructs get to update dependencies, but changes the default to select patch releases.')
        [CompletionResult]::new('-x', 'x', [CompletionResultType]::ParameterName, 'The -x flag prints commands as they are executed. This is useful for debugging version control commands when a module is downloaded directly from a repository.')
      }
      'list' {
        [CompletionResult]::new('-f', 'f', [CompletionResultType]::ParameterName, "The -f flag specifies an alternate format for the list, using the syntax of package template. The default output is equivalent to -f '{{.ImportPath}}'.")
        [CompletionResult]::new('-json', 'json', [CompletionResultType]::ParameterName, 'The -json flag causes the package data to be printed in JSON format instead of using the template format. The JSON flag can optionally be provided with a set of comma-separated required field names to be output. If so, those required fields will always appear in JSON output, but others may be omitted to save work in computing the JSON struct.')
        [CompletionResult]::new('-compile', 'compile', [CompletionResultType]::ParameterName, 'The -compiled flag causes list to set CompiledGoFiles to the Go source files presented to the compiler. Typically this means that it repeats the files listed in GoFiles and then also adds the Go code generated by processing CgoFiles and SwigFiles. The Imports list contains the union of all imports from both GoFiles and CompiledGoFiles.')
        [CompletionResult]::new('-deps', 'deps', [CompletionResultType]::ParameterName, 'The -deps flag causes list to iterate over not just the named packages but also all their dependencies. It visits them in a depth-first post-order traversal, so that a package is listed only after all its dependencies. Packages not explicitly listed on the command line will have the DepOnly field set to true.')
        [CompletionResult]::new('-e', 'e', [CompletionResultType]::ParameterName, 'The -e flag changes the handling of erroneous packages, those that cannot be found or are malformed. By default, the list command prints an error to standard error for each erroneous package and omits the packages from consideration during the usual printing. With the -e flag, the list command never prints errors to standard error and instead processes the erroneous packages with the usual printing. Erroneous packages will have a non-empty ImportPath and a non-nil Error field; other information may or may not be missing (zeroed).')
        [CompletionResult]::new('-export', 'export', [CompletionResultType]::ParameterName, 'The -export flag causes list to set the Export field to the name of a file containing up-to-date export information for the given package, and the BuildID field to the build ID of the compiled package.')
        [CompletionResult]::new('-find', 'find', [CompletionResultType]::ParameterName, 'The -find flag causes list to identify the named packages but not resolve their dependencies: the Imports and Deps lists will be empty. With the -find flag, the -deps, -test and -export commands cannot be used.')
        [CompletionResult]::new('-test', 'test', [CompletionResultType]::ParameterName, @'
The -test flag causes list to report not only the named packages
but also their test binaries (for packages with tests), to convey to
source code analysis tools exactly how test binaries are constructed.
The reported import path for a test binary is the import path of
the package followed by a ".test" suffix, as in "math/rand.test".
When building a test, it is sometimes necessary to rebuild certain
dependencies specially for that test (most commonly the tested
package itself). The reported import path of a package recompiled
for a particular test binary is followed by a space and the name of
the test binary in brackets, as in "math/rand [math/rand.test]"
or "regexp [sort.test]". The ForTest field is also set to the name
of the package being tested ("math/rand" or "sort" in the previous
examples).
'@)
        [CompletionResult]::new('-m', 'm', [CompletionResultType]::ParameterName, 'The -m flag causes list to list modules instead of packages.')
        [CompletionResult]::new('-u', 'u', [CompletionResultType]::ParameterName, 'The -u flag adds information about available upgrades.')
        [CompletionResult]::new('-versions', 'versions', [CompletionResultType]::ParameterName, "The -versions flag causes list to set the Module's Versions field to a list of all known versions of that module, ordered according to semantic versioning, earliest to latest. The flag also changes the default output format to display the module path followed by the space-separated version list.")
        [CompletionResult]::new('-retracted', 'retracted', [CompletionResultType]::ParameterName, 'The -retracted flag causes list to report information about retracted module versions.')
      }
      'mod' {
        [CompletionResult]::new('download', 'download', [CompletionResultType]::ParameterValue, 'download modules to local cache')
        [CompletionResult]::new('edit', 'edit', [CompletionResultType]::ParameterValue, 'edit go.mod from tools or scripts')
        [CompletionResult]::new('graph', 'graph', [CompletionResultType]::ParameterValue, 'print module requirement graph')
        [CompletionResult]::new('init', 'init', [CompletionResultType]::ParameterValue, 'initialize new module in current directory')
        [CompletionResult]::new('tidy', 'tidy', [CompletionResultType]::ParameterValue, 'add missing and remove unused modules')
        [CompletionResult]::new('vendor', 'vendor', [CompletionResultType]::ParameterValue, 'make vendored copy of dependencies')
        [CompletionResult]::new('verify', 'verify', [CompletionResultType]::ParameterValue, 'verify dependencies have expected content')
        [CompletionResult]::new('why', 'why', [CompletionResultType]::ParameterValue, 'explain why packages or modules are needed')
      }
      'mod_download' {
        [CompletionResult]::new('-json', 'json', [CompletionResultType]::ParameterName, 'The -json flag causes download to print a sequence of JSON objects to standard output, describing each downloaded module (or failure)')
        [CompletionResult]::new('-reuse', 'reuse', [CompletionResultType]::ParameterName, "The -reuse flag accepts the name of file containing the JSON output of a previous 'go mod download -json' invocation.")
        [CompletionResult]::new('-x', 'x', [CompletionResultType]::ParameterName, 'The -x flag causes download to print the commands download executes.')
      }
      'mod_edit' {
        [CompletionResult]::new('-fmt', 'fmt', [CompletionResultType]::ParameterName, 'The -fmt flag reformats the go.mod file without making other changes.')
        [CompletionResult]::new('-module', 'module', [CompletionResultType]::ParameterName, "The -module flag changes the module's path (the go.mod file's module line).")
        [CompletionResult]::new('-require', 'require', [CompletionResultType]::ParameterName, 'The -require=path@version and -droprequire=path flags add and drop a requirement on the given module path and version.')
        [CompletionResult]::new('-droprequire', 'droprequire', [CompletionResultType]::ParameterName, 'The -require=path@version and -droprequire=path flags add and drop a requirement on the given module path and version.')
        [CompletionResult]::new('-exclude', 'exclude', [CompletionResultType]::ParameterName, 'The -exclude=path@version and -dropexclude=path@version flags add and drop an exclusion for the given module path and version.')
        [CompletionResult]::new('-dropexclude', 'dropexclude', [CompletionResultType]::ParameterName, 'The -exclude=path@version and -dropexclude=path@version flags add and drop an exclusion for the given module path and version.')
        [CompletionResult]::new('-replace', 'replace', [CompletionResultType]::ParameterName, 'The -replace=old[@v]=new[@v] flag adds a replacement of the given module path and version pair.')
        [CompletionResult]::new('-dropreplace', 'dropreplace', [CompletionResultType]::ParameterName, 'The -dropreplace=old[@v] flag drops a replacement of the given module path and version pair.')
        [CompletionResult]::new('-retract', 'retract', [CompletionResultType]::ParameterName, 'The -retract=version and -dropretract=version flags add and drop a retraction on the given version.')
        [CompletionResult]::new('-dropretract', 'dropretract', [CompletionResultType]::ParameterName, 'The -retract=version and -dropretract=version flags add and drop a retraction on the given version.')
        [CompletionResult]::new('-go', 'go', [CompletionResultType]::ParameterValue, 'The -go=version flag sets the expected Go language version.')
        [CompletionResult]::new('-toolchain', 'toolchain', [CompletionResultType]::ParameterValue, 'The -toolchain=name flag sets the Go toolchain to use.')
        [CompletionResult]::new('-print', 'print', [CompletionResultType]::ParameterValue, 'The -print flag prints the final go.work in its text format instead of writing it back to go.mod.')
        [CompletionResult]::new('-json', 'json', [CompletionResultType]::ParameterValue, 'The -json flag prints the final go.work file in JSON format instead of writing it back to go.mod.')
      }
      'mod_graph' {
        [CompletionResult]::new('-go', 'go', [CompletionResultType]::ParameterValue, ”The -go flag causes graph to report the module graph as loaded by the given Go version, instead of the version indicated by the 'go' directive in the go.mod file.")
        [CompletionResult]::new('-x', 'x', [CompletionResultType]::ParameterValue, 'The -x flag causes graph to print the commands graph executes.')
      }
      'mod_tidy' {
        [CompletionResult]::new('-v', 'v', [CompletionResultType]::ParameterValue, 'The -v flag causes tidy to print information about removed modules to standard error.')
        [CompletionResult]::new('-e', 'e', [CompletionResultType]::ParameterValue, 'The -e flag causes tidy to attempt to proceed despite errors encountered while loading packages.')
        [CompletionResult]::new('-go', 'go', [CompletionResultType]::ParameterValue, "The -go flag causes tidy to update the 'go' directive in the go.mod file to the given version, which may change which module dependencies are retained as explicit requirements in the go.mod file.")
        [CompletionResult]::new('-compat', 'compat', [CompletionResultType]::ParameterValue, "The -compat flag preserves any additional checksums needed for the 'go' command from the indicated major Go release to successfully load the module graph, and causes tidy to error out if that version of the 'go' command would load any imported package from a different module version.")
        [CompletionResult]::new('-x', 'x', [CompletionResultType]::ParameterValue, 'The -x flag causes tidy to print the commands download executes.')
      }
      'mod_vendor' {
        [CompletionResult]::new('-v', 'v', [CompletionResultType]::ParameterValue, 'The -v flag causes vendor to print the names of vendored modules and packages to standard error.')
        [CompletionResult]::new('-e', 'e', [CompletionResultType]::ParameterValue, 'The -e flag causes vendor to attempt to proceed despite errors encountered while loading packages.')
        [CompletionResult]::new('-o', 'o', [CompletionResultType]::ParameterValue, 'The -o flag causes vendor to create the vendor directory at the given path instead of "vendor".')
      }
      'mod_why' {
        @('-m', '--vendor') | ForEach-Object { [CompletionResult]::new($_) }
      }
      'run' {
        [CompletionResult]::new('-exec', 'exec', [CompletionResultType]::ParameterName, "If the -exec flag is given, 'go run' invokes the binary using xprog: 'xprog a.out arguments...'.")
      }
      'tool' {
        [CompletionResult]::new('-n', 'n', [CompletionResultType]::ParameterName, 'The -n flag causes tool to print the command that would be executed but not execute it.')
      }
      'version' {
        [CompletionResult]::new('-m', 'm', [CompletionResultType]::ParameterName, "The -m flag causes go version to print each file's embedded module version information, when available.")
        [CompletionResult]::new('-v', 'v', [CompletionResultType]::ParameterName, 'The -v flag causes it to report unrecognized files.')
      }
      'vet' {
        [CompletionResult]::new('-vettool=prog', 'vettool=prog', [CompletionResultType]::ParameterName, 'The -vettool=prog flag selects a different analysis tool with alternative or additional checks.')
        @('-C', '-n', '-x', '-v', '-tags', '-toolexec') | ForEach-Object { [CompletionResult]::new($_) }
      }
      'work' {
        [CompletionResult]::new('edit', 'edit', [CompletionResultType]::ParameterValue, 'edit go.work from tools or scripts')
        [CompletionResult]::new('init', 'init', [CompletionResultType]::ParameterValue, 'initialize workspace file')
        [CompletionResult]::new('sync', 'sync', [CompletionResultType]::ParameterValue, 'sync workspace build list to modules')
        [CompletionResult]::new('use', 'use', [CompletionResultType]::ParameterValue, 'add modules to workspace file')
        [CompletionResult]::new('vendor', 'vendor', [CompletionResultType]::ParameterValue, 'make vendored copy of dependencies')
      }
      'work_edit' {
        [CompletionResult]::new('-fmt', 'fmt', [CompletionResultType]::ParameterValue, "The -fmt flag reformats the go.work file without making other changes. This reformatting is also implied by any other modifications that use or rewrite the go.mod file. The only time this flag is needed is if no other flags are specified, as in 'go work edit -fmt'.")
        [CompletionResult]::new('-use', 'use', [CompletionResultType]::ParameterValue, "The -use=path and -dropuse=path flags add and drop a use directive from the go.work file's set of module directories.")
        [CompletionResult]::new('-dropuse', 'dropuse', [CompletionResultType]::ParameterValue, "The -use=path and -dropuse=path flags add and drop a use directive from the go.work file's set of module directories.")
        [CompletionResult]::new('-replace', 'replace', [CompletionResultType]::ParameterValue, 'The -replace=old[@v]=new[@v] flag adds a replacement of the given module path and version pair.')
        [CompletionResult]::new('-dropreplace', 'dropreplace', [CompletionResultType]::ParameterValue, 'The -dropreplace=old[@v] flag drops a replacement of the given module path and version pair.')
        [CompletionResult]::new('-go', 'go', [CompletionResultType]::ParameterValue, 'The -go=version flag sets the expected Go language version.')
        [CompletionResult]::new('-toolchain', 'toolchain', [CompletionResultType]::ParameterValue, 'The -toolchain=name flag sets the Go toolchain to use.')
        [CompletionResult]::new('-print', 'print', [CompletionResultType]::ParameterValue, 'The -print flag prints the final go.work in its text format instead of writing it back to go.mod.')
        [CompletionResult]::new('-json', 'json', [CompletionResultType]::ParameterValue, 'The -json flag prints the final go.work file in JSON format instead of writing it back to go.mod.')
      }
      'work_use' {
        [CompletionResult]::new('-r', 'r', [CompletionResultType]::ParameterValue, 'The -r flag searches recursively for modules in the argument directories, and the use command operates as if each of the directories were specified as arguments: namely, use directives will be added for directories that exist, and removed for directories that do not exist.')
      }
      'work_vendor' {
        [CompletionResult]::new('-v', 'v', [CompletionResultType]::ParameterValue, 'The -v flag causes vendor to print the names of vendored modules and packages to standard error.')
        [CompletionResult]::new('-e', 'e', [CompletionResultType]::ParameterValue, 'The -e flag causes vendor to attempt to proceed despite errors encountered while loading packages.')
        [CompletionResult]::new('-o', 'o', [CompletionResultType]::ParameterValue, 'The -o flag causes vendor to create the vendor directory at the given path instead of "vendor".')
      }
      Default {
        if ($wordToComplete[0] -ne '-') {
          [CompletionResult]::new('bug', 'bug', [CompletionResultType]::ParameterValue, 'start a bug report')
          [CompletionResult]::new('build', 'build', [CompletionResultType]::ParameterValue, 'compile packages and dependencies')
          [CompletionResult]::new('clean', 'clean', [CompletionResultType]::ParameterValue, 'remove object files and cached files')
          [CompletionResult]::new('doc', 'doc', [CompletionResultType]::ParameterValue, 'show documentation for package or symbol')
          [CompletionResult]::new('env', 'env', [CompletionResultType]::ParameterValue, 'print Go environment information')
          [CompletionResult]::new('fix', 'fix', [CompletionResultType]::ParameterValue, 'update packages to use new APIs')
          [CompletionResult]::new('fmt', 'fmt', [CompletionResultType]::ParameterValue, 'gofmt (reformat) package sources')
          [CompletionResult]::new('generate', 'generate', [CompletionResultType]::ParameterValue, 'generate Go files by processing source')
          [CompletionResult]::new('get', 'get', [CompletionResultType]::ParameterValue, 'add dependencies to current module and install them')
          [CompletionResult]::new('install', 'install', [CompletionResultType]::ParameterValue, 'compile and install packages and dependencies')
          [CompletionResult]::new('list', 'list', [CompletionResultType]::ParameterValue, 'list packages or modules')
          [CompletionResult]::new('mod', 'mod', [CompletionResultType]::ParameterValue, 'module maintenance')
          [CompletionResult]::new('work', 'work', [CompletionResultType]::ParameterValue, 'workspace maintenance')
          [CompletionResult]::new('run', 'run', [CompletionResultType]::ParameterValue, 'compile and run Go program')
          [CompletionResult]::new('test', 'test', [CompletionResultType]::ParameterValue, 'test packages')
          [CompletionResult]::new('tool', 'tool', [CompletionResultType]::ParameterValue, 'run specified go tool')
          [CompletionResult]::new('version', 'version', [CompletionResultType]::ParameterValue, 'print Go version')
          [CompletionResult]::new('vet', 'vet', [CompletionResultType]::ParameterValue, 'report likely mistakes in packages')
        }
      }
    }) | Where-Object { $_.CompletionText -like "$wordToComplete*" }
}
