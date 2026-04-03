using namespace System.Management.Automation.Language

Register-ArgumentCompleter -Native -CommandName sudo -ScriptBlock {
  param ([string]$wordToComplete, [CommandAst]$commandAst, [int]$cursorPosition)
  for ($i = 1; $i -lt $commandAst.CommandElements.Count; $i++) {
    if (!$commandAst.CommandElements[$i].ToString().StartsWith('-')) {
      break
    }
  }
  switch ($commandAst.CommandElements.Count - $i) {
    { $_ -le 1 } {
      if ($wordToComplete.StartsWith('-')) {
        @(switch ($true) {
            $IsWindows {
              break
            }
            $IsMacOS {
              break
            }
            $IsLinux {
              '-A', '--askpass', '-b', '--background', '-B', '--bell', '-C', '--close-from=', '-D', '--chdir=', '-E', '--preserve-env', '--preserve-env=', '-e', '--edit', '-g', '--group=', '-H', '--set-home', '-h', '--help', '-h', '--host=', '-i', '--login', '-K', '--remove-timestamp', '-k', '--reset-timestamp', '-l', '--list', '-n', '--non-interactive', '-P', '--preserve-groups', '-p', '--prompt=#', '-R', '--chroot=/root', '-r', '--role=', '-S', '--stdin', '-s', '--shell', '-t', '--type=', '-T', '--command-timeout=12000', '-U', '--other-user=', '-u', '--user=', '-V', '--version', '-v', '--validate'
              break
            }
          }).Where{ $_ -like "$wordToComplete*" }
        break
      }
      (Get-Command $wordToComplete* -Type Application).Name | Sort-Object -Unique
      break
    }
    default {
      [string]$line = $commandAst
      $commandName = [System.IO.Path]::GetFileNameWithoutExtension($commandAst.CommandElements[$i])
      $i = $commandAst.CommandElements[$i].Extent.StartOffset
      $line = $line.Substring($i)
      $cursorPosition -= $i
      $commandAst = [Parser]::ParseInput($line, [ref]$null, [ref]$null).EndBlock.Statements[0].PipelineElements[0]
      & (Get-ArgumentCompleter $commandName) $wordToComplete $commandAst $cursorPosition
      break
    }
  }
}
