using namespace System.Management.Automation.Language

Register-ArgumentCompleter -Native -CommandName repo -ScriptBlock {
  param ([string]$wordToComplete, [CommandAst]$commandAst, [int]$cursorPosition)
  $commands = @(foreach ($i in $commandAst.CommandElements) {
      if ($i.Extent.StartOffset -eq $commandAst.Extent.StartOffset -or $i.Extent.EndOffset -eq $cursorPosition) {
        continue
      }
      if ($i -isnot [StringConstantExpressionAst] -or
        $i.StringConstantType -ne [StringConstantType]::BareWord -or
        $i.Value.StartsWith('-')) {
        break
      }
      $i.Value
    })
  @(switch -CaseSensitive ($commands -join ' ') {
      '' {
        if ($wordToComplete.StartsWith('-')) {
          '-h', '--help', '--help-all', '-p', '--paginate', '--no-pager', '--color=auto', '--color=always', '--color=never', '--trace', '--trace-to-stderr', '--trace-python', '--time', '--version', '--show-toplevel', '--event-log=', '--git-trace2-event-log=', '--submanifest-path='
          break
        }
        'abandon', 'branch', 'branches', 'checkout', 'cherry-pick', 'diff', 'diffmanifests', 'download', 'forall', 'gc', 'grep', 'help', 'info', 'current', 'init', 'list', 'manifest', 'overview', 'prune', 'rebase', 'selfupdate', 'smartsync', 'stage', 'start', 'status', 'sync', 'upload', 'version', 'wipe'
        break
      }
      default {
        if ($wordToComplete.StartsWith('-')) {
          '-h', '--help', '-j', '--jobs=', '--all', '-v', '--verbose', '-q', '--quiet', '--outer-manifest', '--no-outer-manifest', '--this-manifest-only', '--no-this-manifest-only', '--all-manifests'
          break
        }
        break
      }
    }).Where{ $_ -like "$wordToComplete*" }
}
