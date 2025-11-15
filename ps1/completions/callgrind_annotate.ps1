# valgrind-scripts
Register-ArgumentCompleter -Native -CommandName callgrind_annotate, callgrind_control, cg_annotate, cg_diff, cg_merge, ms_print -ScriptBlock {
  param ([string]$wordToComplete, [System.Management.Automation.Language.CommandAst]$commandAst, [int]$cursorPosition)
  @(if ($wordToComplete.StartsWith('-')) {
      switch -CaseSensitive (Split-Path -LeafBase $commandAst.GetCommandName()) {
        callgrind_annotate {
          '-h', '--help', '--version', '--show=', '--show=all', '--threshold=', '--sort=', '--show-percs=yes', '--show-percs=no', '--auto=yes', '--auto=no', '--context=', '--inclusive=yes', '--tree=none', '--tree=caller', '--tree=calling', '--tree=both', '-I', '--include='
          break
        }
        callgrind_control {
          '-h', '--help', '--version', '-s', '--stat', '-b', '--back', '-e', '--dump', '--dump=', '-z', '--zero', '-k', '--kill', '-i', '--instr=on', '--instr=off', '--vgdb-prefix='
          break
        }
        cg_annotate {
          '-h', '--help', '--version', '--diff', '--mod-filename', '--mod-funcname', '--show', '--sort', '--threshold', '--show-percs', '--no-show-percs', '--show-percs=yes', '--show-percs=no', '--annotate', '--no-annotate', '--auto=yes', '--auto=no', '--context'
          break
        }
        cg_diff {
          '-h', '--help', '--version', '--mod-filename', '--mod-funcname'
          break
        }
        cg_merge {
          '-h', '--help', '--version', '-o'
          break
        }
        ms_print {
          '-h', '--help', '--version', '--threshold=', '--x=', '--y='
          break
        }
      }
    }).Where{ $_ -like "$wordToComplete*" }
}
