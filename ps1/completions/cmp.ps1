# diffutils
Register-ArgumentCompleter -Native -CommandName cmp, diff, diff3, sdiff -ScriptBlock {
  param ([string]$wordToComplete, [System.Management.Automation.Language.CommandAst]$commandAst, [int]$cursorPosition)
  @(if ($wordToComplete.StartsWith('-')) {
      switch -CaseSensitive (Split-Path -LeafBase $commandAst.GetCommandName()) {
        cmp {
          '-b', '--print-bytes', '-i', '--ignore-initial=', '-i', '--ignore-initial=', '-l', '--verbose', '-n', '--bytes=', '-s', '--quiet', '--silent', '--help', '-v', '--version'
          break
        }
        diff {
          '--normal', '-q', '--brief', '-s', '--report-identical-files', '-c', '-C', '--context', '--context=5', '-u', '-U', '--unified', '--unified=5', '-e', '--ed', '-n', '--rcs', '-y', '--side-by-side', '-W', '--width=', '--left-column', '--suppress-common-lines', '-p', '--show-c-function', '-F', '--show-function-line=', '--label', '-t', '--expand-tabs', '-T', '--initial-tab', '--tabsize=2', '--tabsize=4', '--tabsize=8', '--suppress-blank-empty', '-l', '--paginate', '-r', '--recursive', '--no-dereference', '-N', '--new-file', '--unidirectional-new-file', '--ignore-file-name-case', '--no-ignore-file-name-case', '-x', '--exclude=', '-X', '--exclude-from=', '-S', '--starting-file=', '--from-file=', '--to-file=', '-i', '--ignore-case', '-E', '--ignore-tab-expansion', '-Z', '--ignore-trailing-space', '-b', '--ignore-space-change', '-w', '--ignore-all-space', '-B', '--ignore-blank-lines', '-I', '--ignore-matching-lines=', '-a', '--text', '--strip-trailing-cr', '-D', '--ifdef=', '--old-group-format=', '--new-group-format=', '--unchanged-group-format=', '--line-format=', '--old-line-format=', '--new-line-format=', '--unchanged-line-format=', '-d', '--minimal', '--horizon-lines=', '--speed-large-files', '--color', '--color=always', '--color=auto', '--color=never', '--palette=', '--help', '-v', '--version'
          break
        }
        diff3 {
          '-A', '--show-all', '-e', '--ed', '-E', '--show-overlap', '-3', '--easy-only', '-x', '--overlap-only', '-X', '-i', '-m', '--merge', '-a', '--text', '--strip-trailing-cr', '-T', '--initial-tab', '--diff-program=diff', '--diff-program=delta', '-L', '--label=', '--help', '-v', '--version'
          break
        }
        sdiff {
          '-o', '--output=', '-i', '--ignore-case', '-E', '--ignore-tab-expansion', '-Z', '--ignore-trailing-space', '-b', '--ignore-space-change', '-W', '--ignore-all-space', '-B', '--ignore-blank-lines', '-I', '--ignore-matching-lines=', '--strip-trailing-cr', '-a', '--text', '-W', '--width=130', '--width=100', '-l', '--left-column', '-s', '--suppress-common-lines', '-t', '--expand-tabs', '--tabsize=2', '--tabsize=4', '--tabsize=8', '-d', '--minimal', '-H', '--speed-large-files', '--diff-program=diff', '--diff-program=delta', '--help', '-v', '--version'
          break
        }
      }
    }).Where{ $_ -like "$wordToComplete*" }
}
