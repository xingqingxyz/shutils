using namespace System.Management.Automation.Language

Register-ArgumentCompleter -Native -CommandName ipython, ipython3 -ScriptBlock {
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
          '-c', '-m', '--debug', '--show-config', '--show-config-json', '--quiet', '--init', '--autoindent', '--no-autoindent', '--automagic', '--no-automagic', '--pdb', '--no-pdb', '--pprint', '--no-pprint', '--color-info', '--no-color-info', '--ignore-cwd', '--no-ignore-cwd', '--nosep', '--pylab', '--matplotlib', '--autoedit-syntax', '--no-autoedit-syntax', '--simple-prompt', '--no-simple-prompt', '--banner', '--no-banner', '--confirm-exit', '--no-confirm-exit', '--tip', '--no-tip', '--term-title', '--no-term-title', '--classic', '--quick', '-i', '--log-level=DEBUG', '--log-level=INFO', '--log-level=WARN', '--log-level=ERROR', '--log-level=CRITICAL', '--profile-dir=', '--profile=default', '--profile=', '--ipython-dir=', '--config=', '--autocall=', '--colors=nocolor', '--colors=neutral', '--colors=linux', '--colors=lightbg', '--theme=nocolor', '--theme=neutral', '--theme=linux', '--theme=lightbg', '--logfile=', '--logappend=', '-c=', '-m=', '--ext=', '--gui=asyncio', '--gui=glut', '--gui=gtk', '--gui=', '--gui=gtk3', '--gui=gtk4', '--gui=osx', '--gui=pyglet', '--gui=qt', '--gui=qt5', '--gui=qt6', '--gui=tk', '--gui=wx', '--gui=', '--gui=qt4', '--matplotlib=agg', '--matplotlib=auto', '--matplotlib=gtk', '--matplotlib=gtk3', '--matplotlib=gtk4', '--matplotlib=inline', '--matplotlib=ipympl', '--matplotlib=nbagg', '--matplotlib=notebook', '--matplotlib=osx', '--matplotlib=pdf', '--matplotlib=ps', '--matplotlib=qt', '--matplotlib=qt4', '--matplotlib=qt5', '--matplotlib=qt6', '--matplotlib=svg', '--matplotlib=tk', '--matplotlib=webagg', '--matplotlib=widget', '--matplotlib=wx', '--pylab=agg', '--pylab=auto', '--pylab=gtk', '--pylab=gtk3', '--pylab=gtk4', '--pylab=inline', '--pylab=ipympl', '--pylab=nbagg', '--pylab=notebook', '--pylab=osx', '--pylab=pdf', '--pylab=ps', '--pylab=qt', '--pylab=qt4', '--pylab=qt5', '--pylab=qt6', '--pylab=svg', '--pylab=tk', '--pylab=webagg', '--pylab=widget', '--pylab=wx', '--cache-size=1000', '--cache-size=0', '--cache-size=3'
          break
        }
        'profile', 'kernel', 'locate', 'history'
        break
      }
      'profile' {
        if ($wordToComplete.StartsWith('-')) {
          '--debug', '--show-config', '--show-config-json', '--log-level=DEBUG', '--log-level=INFO', '--log-level=WARN', '--log-level=ERROR', '--log-level=CRITICAL'
          break
        }
        'create', 'list', 'locate'
        break
      }
      'profile create' {
        if ($wordToComplete.StartsWith('-')) {
          '--debug', '--show-config', '--show-config-json', '--quiet', '--reset', '--parallel', '--log-level=DEBUG', '--log-level=INFO', '--log-level=WARN', '--log-level=ERROR', '--log-level=CRITICAL', '--profile-dir=', '--profile=', '--ipython-dir=', '--config='
          break
        }
        break
      }
      'profile list' {
        if ($wordToComplete.StartsWith('-')) {
          '--debug', '--ipython-dir=', '--log-level=DEBUG', '--log-level=INFO', '--log-level=WARN', '--log-level=ERROR', '--log-level=CRITICAL'
          break
        }
        break
      }
      'profile locate' {
        if ($wordToComplete.StartsWith('-')) {
          '--debug', '--show-config', '--show-config-json', '--quiet', '--init', '--log-level=DEBUG', '--log-level=INFO', '--log-level=WARN', '--log-level=ERROR', '--log-level=CRITICAL', '--profile-dir=', '--profile=default', '--profile=', '--ipython-dir=', '--config='
          break
        }
        break
      }
      'kernel' {
        if ($wordToComplete.StartsWith('-')) {
          '-c', '-m', '--debug', '--show-config', '--show-config-json', '--quiet', '--init', '--autoindent', '--no-autoindent', '--automagic', '--no-automagic', '--pdb', '--no-pdb', '--pprint', '--no-pprint', '--color-info', '--no-color-info', '--ignore-cwd', '--no-ignore-cwd', '--nosep', '--pylab', '--matplotlib', '--autoedit-syntax', '--no-autoedit-syntax', '--simple-prompt', '--no-simple-prompt', '--banner', '--no-banner', '--confirm-exit', '--no-confirm-exit', '--tip', '--no-tip', '--term-title', '--no-term-title', '--classic', '--quick', '-i', '--log-level=DEBUG', '--log-level=INFO', '--log-level=WARN', '--log-level=ERROR', '--log-level=CRITICAL', '--profile-dir=', '--profile=default', '--profile=', '--ipython-dir=', '--config=', '--autocall=', '--colors=nocolor', '--colors=neutral', '--colors=linux', '--colors=lightbg', '--theme=nocolor', '--theme=neutral', '--theme=linux', '--theme=lightbg', '--logfile=', '--logappend=', '-c=', '-m=', '--ext=', '--gui=asyncio', '--gui=glut', '--gui=gtk', '--gui=', '--gui=gtk3', '--gui=gtk4', '--gui=osx', '--gui=pyglet', '--gui=qt', '--gui=qt5', '--gui=qt6', '--gui=tk', '--gui=wx', '--gui=', '--gui=qt4', '--matplotlib=agg', '--matplotlib=auto', '--matplotlib=gtk', '--matplotlib=gtk3', '--matplotlib=gtk4', '--matplotlib=inline', '--matplotlib=ipympl', '--matplotlib=nbagg', '--matplotlib=notebook', '--matplotlib=osx', '--matplotlib=pdf', '--matplotlib=ps', '--matplotlib=qt', '--matplotlib=qt4', '--matplotlib=qt5', '--matplotlib=qt6', '--matplotlib=svg', '--matplotlib=tk', '--matplotlib=webagg', '--matplotlib=widget', '--matplotlib=wx', '--pylab=agg', '--pylab=auto', '--pylab=gtk', '--pylab=gtk3', '--pylab=gtk4', '--pylab=inline', '--pylab=ipympl', '--pylab=nbagg', '--pylab=notebook', '--pylab=osx', '--pylab=pdf', '--pylab=ps', '--pylab=qt', '--pylab=qt4', '--pylab=qt5', '--pylab=qt6', '--pylab=svg', '--pylab=tk', '--pylab=webagg', '--pylab=widget', '--pylab=wx', '--cache-size=1000', '--cache-size=0', '--cache-size=3'
          break
        }
        'install'
        break
      }
      'kernel install' {
        if ($wordToComplete.StartsWith('-')) {
          '-h', '--help', '--user', '--name=', '--display-name=', '--profile=', '--prefix=', '--sys-prefix', '--env=', '--frozen_modules'
          break
        }
        break
      }
      'locate' {
        if ($wordToComplete.StartsWith('-')) {
          '--debug', '--show-config', '--show-config-json', '--quiet', '--init', '--log-level=DEBUG', '--log-level=INFO', '--log-level=WARN', '--log-level=ERROR', '--log-level=CRITICAL', '--profile-dir=', '--profile=default', '--profile=', '--ipython-dir=', '--config='
          break
        }
        break
      }
      'history' {
        if ($wordToComplete.StartsWith('-')) {
          '--debug', '--show-config', '--show-config-json', '--log-level=DEBUG', '--log-level=INFO', '--log-level=WARN', '--log-level=ERROR', '--log-level=CRITICAL'
          break
        }
        break
      }
    }).Where{ $_ -like "$wordToComplete*" }
}
