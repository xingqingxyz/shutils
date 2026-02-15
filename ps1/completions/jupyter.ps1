using namespace System.Management.Automation.Language

Register-ArgumentCompleter -Native -CommandName jupyter -ScriptBlock {
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

  $cursorPosition -= $wordToComplete.Length
  foreach ($i in $commandAst.CommandElements) {
    if ($i.Extent.StartOffset -ge $cursorPosition) {
      break
    }
    $prev = $i
  }
  $prev = $prev -is [System.Management.Automation.Language.StringConstantExpressionAst] ? $prev.Value : $prev.ToString()

  @(switch ($command) {
      '' {
        if ($wordToComplete.StartsWith('-')) {
          '-h', '--help', '--version', '--config-dir', '--data-dir', '--runtime-dir', '--paths', '', '--json', '--debug'
          break
        }
        'kernel', 'kernelspec', 'migrate', 'run', 'troubleshoot'
        break
      }
      'kernel' {
        if ($wordToComplete.StartsWith('-')) {
          '--debug', '--kernel=python3', '--kernel=deno', '--ip='
          break
        }
        break
      }
      'kernelspec' {
        if ($wordToComplete.StartsWith('-')) {
          break
        }
        'list', 'install', 'uninstall', 'remove', 'install-self', 'provisioners'
        break
      }
      'kernelspec list' {
        if ($wordToComplete.StartsWith('-')) {
          '--json', '--missing', '--debug', '--log-level=DEBUG', '--log-level=INFO', '--log-level=WARN', '--log-level=ERROR', '--log-level=CRITICAL', '--config='
          break
        }
        break
      }
      'kernelspec install' {
        if ($wordToComplete.StartsWith('-')) {
          '--user', '--replace', '--sys-prefix', '--debug', '--name=', '--prefix=', '--log-level=DEBUG', '--log-level=INFO', '--log-level=WARN', '--log-level=ERROR', '--log-level=CRITICAL', '--config='
          break
        }
        break
      }
      'kernelspec uninstall' {
        if ($wordToComplete.StartsWith('-')) {
          '--user', '--replace', '--sys-prefix', '--debug', '--name=', '--prefix=', '--log-level=DEBUG', '--log-level=INFO', '--log-level=WARN', '--log-level=ERROR', '--log-level=CRITICAL', '--config='
          break
        }
        break
      }
      'kernelspec remove' {
        if ($wordToComplete.StartsWith('-')) {
          '-f', '--missing', '--debug', '--show-config', '--show-config-json', '--generate-config', '-y', '--log-level=DEBUG', '--log-level=INFO', '--log-level=WARN', '--log-level=ERROR', '--log-level=CRITICAL', '--config='
          break
        }
        break
      }
      'kernelspec install-self' {
        if ($wordToComplete.StartsWith('-')) {
          '--user', '--debug', '--log-level=DEBUG', '--log-level=INFO', '--log-level=WARN', '--log-level=ERROR', '--log-level=CRITICAL', '--config='
          break
        }
        break
      }
      'migrate' {
        if ($wordToComplete.StartsWith('-')) {
          '--debug', '--show-config', '--show-config-json', '--generate-config', '-y', '--log-level=DEBUG', '--log-level=INFO', '--log-level=WARN', '--log-level=ERROR', '--log-level=CRITICAL', '--config='
          break
        }
        break
      }
      'run' {
        if ($wordToComplete.StartsWith('-')) {
          '--debug', '--show-config', '--show-config-json', '--generate-config', '-y', '--existing', '--confirm-exit', '--no-confirm-exit', '--log-level=DEBUG', '--log-level=INFO', '--log-level=WARN', '--log-level=ERROR', '--log-level=CRITICAL', '--config=', '--ip=', '--transport=tcp', '--transport=ipc', '--hb=0', '--shell=0', '--iopub=0', '--stdin=0', '--control=0', '--existing=', '-f=', '--kernel=python3', '--kernel=deno', '--ssh=', '--sshkey='
          break
        }
        break
      }
    }).Where{ $_ -like "$wordToComplete*" }
}
