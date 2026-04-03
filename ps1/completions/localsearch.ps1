using namespace System.Management.Automation.Language

Register-ArgumentCompleter -Native -CommandName localsearch -ScriptBlock {
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

  if ($command.StartsWith('test-sandbox ')) {
    [string]$line = $commandAst
    $commandName = [System.IO.Path]::GetFileNameWithoutExtension($commandAst.CommandElements[2])
    $i = $commandAst.CommandElements[2].Extent.StartOffset
    $line = $line.Substring($i)
    $cursorPosition -= $i
    $commandAst = [Parser]::ParseInput($line, [ref]$null, [ref]$null).EndBlock.Statements[0].PipelineElements[0]
    return & (Get-ArgumentCompleter $commandName) $wordToComplete $commandAst $cursorPosition
  }

  @(switch ($command) {
      { $_ -eq '' -or $_ -ceq 'help' } {
        if ($wordToComplete.StartsWith('-')) {
          '--version', '--help'
          break
        }
        'help', 'extract', 'index', 'info', 'inhibit', 'reset', 'search', 'status', 'tag', 'test-sandbox'
        break
      }
      'extract' {
        if ($wordToComplete.StartsWith('-')) {
          '-h', '--help', '-o', '--output-format=turtle', '--output-format=trig', '--output-format=json-ld'
          break
        }
        '-h', '--help', '-a', '--add', '-d', '--remove', '-r', '--recursive'
        break
      }
      'index' {
        if ($wordToComplete.StartsWith('-')) {
          '-h', '--help', '-a', '--add', '-d', '--remove', '-r', '--recursive'
          break
        }
        break
      }
      'info' {
        if ($wordToComplete.StartsWith('-')) {
          '-h', '--help', '-f', '--full-namespaces', '-c', '--plain-text-content', '-o', '--output-format=turtle', '--output-format=trig', '--output-format=json-ld', '-e', '--eligible'
          break
        }
        break
      }
      'inhibit' {
        if ($wordToComplete.StartsWith('-')) {
          '-h', '--help', '-l', '--list'
          break
        }
        break
      }
      'reset' {
        if ($wordToComplete.StartsWith('-')) {
          '-h', '--help', '-s', '--filesystem', '-f', '--file='
          break
        }
        break
      }
      'search' {
        if ($wordToComplete.StartsWith('-')) {
          '-f', '--files', '-s', '--folders', '--audio', '--music-albums', '--music-artists', '-i', '--images', '-v', '--videos', '-t', '--documents', '--software', '-l', '--limit', '-o', '--offset=0', '-d', '--detailed', '-a', '--all', '-h', '--help'
          break
        }
        break
      }
      'status' {
        if ($wordToComplete.StartsWith('-')) {
          '-h', '--help', '-f', '--follow', '-a', '--stat', '-w', '--watch'
          break
        }
        break
      }
      'tag' {
        if ($wordToComplete.StartsWith('-')) {
          '-h', '--help', '-t', '--list', '-s', '--show-files', '-a', '--add=', '-d', '--delete=', '-e', '--description=', '-l', '--limit=512', '-o', '--offset=0'
          break
        }
        break
      }
      'test-sandbox' {
        if ($wordToComplete.StartsWith('-')) {
          '-h', '-help', '--dbus-config=', '-p', '-prefix=', '--use-session-dirs', '-s', '-store=', '--store-tmpdir', '--index-recursive-directories=', '--index-recursive-tmpdir', '--wait-for-miner=Files', '--wait-for-miner=Extract', '-d', '-dbus-session-bus=', '--debug-dbus', '--debug-sandbox'
          break
        }
        (Get-Command $wordToComplete* -Type Application).Name | Sort-Object -Unique
        break
      }
    }
  ).Where{ $_ -like "$wordToComplete*" }
}
