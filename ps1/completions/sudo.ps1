Register-ArgumentCompleter -Native -CommandName sudo -ScriptBlock {
  param ([string]$wordToComplete, [System.Management.Automation.Language.CommandAst]$commandAst, [int]$cursorPosition)
  if ($commandAst.CommandElements?[1] -like '-*' -and $wordToComplete.StartsWith('-')) {
    return @(switch ($true) {
        $IsLinux {
          '-A', '--askpass', '-b', '--background', '-B', '--bell', '-C', '--close-from=', '-D', '--chdir=', '-E', '--preserve-env', '--preserve-env=', '-e', '--edit', '-g', '--group=', '-H', '--set-home', '-h', '--help', '-h', '--host=', '-i', '--login', '-K', '--remove-timestamp', '-k', '--reset-timestamp', '-l', '--list', '-n', '--non-interactive', '-P', '--preserve-groups', '-p', '--prompt=#', '-R', '--chroot=/root', '-r', '--role=', '-S', '--stdin', '-s', '--shell', '-t', '--type=', '-T', '--command-timeout=12000', '-U', '--other-user=', '-u', '--user=', '-V', '--version', '-v', '--validate'
          break
        }
        $IsWindows {
          break
        }
        $IsMacOS {
          break
        }
      }
    ).Where{ $_ -like "$wordToComplete*" }
  }
  if ($commandAst.CommandElements.Count -le 2 -and
    $cursorPosition -le $commandAst.CommandElements[-1].Extent.EndOffset) {
    return $([System.Management.Automation.CompletionCompleters]::CompleteCommand($wordToComplete)) ??
    [System.Management.Automation.CompletionCompleters]::CompleteFilename($wordToComplete)
  }
  $astList = $commandAst.CommandElements | Select-Object -Skip 1
  $commandName = Split-Path -LeafBase $astList[0].Value
  $cursorPosition -= $astList[0].Extent.StartOffset
  $tuple = [System.Management.Automation.CommandCompletion]::MapStringInputToParsedInput("$astList", $cursorPosition)
  $commandAst = $tuple.Item1.EndBlock.Statements[0].PipelineElements[0]
  & (Get-ArgumentCompleter $commandName) $wordToComplete $commandAst $cursorPosition
}
