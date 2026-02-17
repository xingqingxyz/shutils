using namespace System.Management.Automation.Language

Register-ArgumentCompleter -Native -CommandName cpupower -ScriptBlock {
  param ([string]$wordToComplete, [CommandAst]$commandAst, [int]$cursorPosition)
  $command = @(foreach ($i in $commandAst.CommandElements) {
      if ($i.Extent.StartOffset -eq $commandAst.Extent.StartOffset -or $i.Extent.EndOffset -eq $cursorPosition) {
        continue
      }
      if ($i -isnot [StringConstantExpressionAst] -or
        $i.StringConstantType -ne [StringConstantType]::BareWord -or
        $i.Value.StartsWith('-')) {
        break
      }
      $i.Value
    }) -join ' '

  @(switch ($command) {
      '' {
        if ($wordToComplete.StartsWith('-')) {
          '--help', '--version'
          break
        }
        'frequency-info', 'frequency-set', 'idle-info', 'idle-set', 'powercap-info', 'set', 'info', 'monitor', 'help'
        break
      }
      'help' {
        if ($wordToComplete.StartsWith('-')) {
          break
        }
        'frequency-info', 'frequency-set', 'idle-info', 'idle-set', 'powercap-info', 'set', 'info', 'monitor'
        break
      }
      'frequency-info' {
        if ($wordToComplete.StartsWith('-')) {
          '-l', '--hwlimits', '-d', '--driver', '-p', '--policy', '-g', '--governors', '-r', '--related-cpus', '-a', '--affected-cpus', '-s', '--stats', '-y', '--latency', '-o', '--proc'
          break
        }
        break
      }
      'frequency-set' {
        if ($wordToComplete.StartsWith('-')) {
          '-d', '--min=', '-u', '--max=', '-g', '--governor=', '-f', '--freq=', '-r', '--related'
          break
        }
        break
      }
      'idle-info' {
        if ($wordToComplete.StartsWith('-')) {
          '-c', '-f', '--silent', '-e', '--proc'
          break
        }
        break
      }
      'idle-set' {
        if ($wordToComplete.StartsWith('-')) {
          '-c', '-d', '--disable=', '-e', '--enable=', '-D', '--disable-by-latency=', '-E', '--enable-all='
          break
        }
        break
      }
      'set' {
        if ($wordToComplete.StartsWith('-')) {
          '--perf-bias', '-b', '--epp', '-e', '--amd-pstate-mode=active', '--amd-pstate-mode=guided', '--amd-pstate-mode=passive', '-m', '--turbo-boost=0', '--turbo-boost=1', '--boost=0', '--boost=1', '-t'
          break
        }
        break
      }
      'info' {
        if ($wordToComplete.StartsWith('-')) {
          '-b'
          break
        }
        break
      }
      'monitor' {
        if ($wordToComplete.StartsWith('-')) {
          '-c', '-m', '-i'
          break
        }
        break
      }
    }).Where{ $_ -like "$wordToComplete*" }
}
