using namespace System.Management.Automation.Language

Register-ArgumentCompleter -Native -CommandName kitten -ScriptBlock {
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
  if ($commands[0] -ceq 'hyperlinked-grep') {
    $astList = $commandAst.CommandElements | Select-Object -Skip 2
    $cursorPosition -= $astList[0].Extent.StartOffset - 3
    $commandAst = [Parser]::ParseInput("rg $astList", [ref]$null, [ref]$null).EndBlock.Statements[0].PipelineElements[0]
    return & (Get-ArgumentCompleter rg) $wordToComplete $commandAst $cursorPosition
  }
  @(switch ($commands -join ' ') {
      '' {
        if ($wordToComplete.StartsWith('-')) {
          '--version', '--help', '-h'
          break
        }
        'update-self', 'edit-in-kitty', 'clipboard', 'icat', 'ssh', 'transfer', 'panel', 'quick-access-terminal', 'unicode-input', 'show-key', 'desktop-ui', 'mouse-demo', 'hyperlinked-grep', 'ask', 'hints', 'diff', 'notify', 'themes', 'run-shell', 'choose-fonts', 'choose-files', 'query-terminal'
        break
      }
      'update-self' {
        if ($wordToComplete.StartsWith('-')) {
          '--fetch-version=latest', '--fetch-version=nightly', '--help', '-h'
          break
        }
        break
      }
      'edit-in-kitty' {
        if ($wordToComplete.StartsWith('-')) {
          '--title', '--window-title', '--source-window', '--tab-title', '--type=window', '--type=background', '--type=clipboard', '--type=os-panel', '--type=os-window', '--type=overlay', '--type=overlay-main', '--type=primary', '--type=tab', '--dont-take-focus', '--keep-focus', '--keep-focus=no', '--cwd', '--env', '--var', '--hold', '--hold=no', '--next-to', '--location=default', '--location=after', '--location=before', '--location=first', '--location=hsplit', '--location=last', '--location=neighbor', '--location=split', '--location=vsplit', '--next-to', '--os-window-class', '--os-window-name', '--type', '--os-window-title', '--os-window-statenormal', '--os-window-statefullscreen', '--os-window-statemaximized', '--os-window-stateminimized', '--logo', '--logo-position', '--logo-alpha=', '--logo-alpha=-1', '--color', '--spacing', '--hold-after-ssh', '--hold-after-ssh=no', '--max-file-size=', '--help', '-h'
        }
        break
      }
      'clipboard' {
        if ($wordToComplete.StartsWith('-')) {
          '--get-clipboard', '-g', '-g=no', '--use-primary', '-p', '-p=no', '--mime', '-m', '--alias', '-a', '--wait-for-completion', '--wait-for-completion=no', '--password', '--human-name', '--help', '-h', '-h=no'
          break
        }
        break
      }
      'icat' {
        if ($wordToComplete.StartsWith('-')) {
          '--align=center', '--align=left', '--align=right', '--place', '--scale-up', '--scale-up=no', '--background', '--background=none', '--mirror', '--mirror=none', '--clear', '--clear=no', '--transfer-mode=detect', '--transfer-mode=file', '--transfer-mode=memory', '--transfer-mode=stream', '--detect-support', '--detect-support=no', '--transfer-mode', '--detection-timeout=', '--detection-timeout=10', '--use-window-size', '--print-window-size', '--print-window-size=no', '--stdin=detect', '--stdin=yes', '--stdin=no', '--silent', '--silent=no', '--engine=auto', '--engine=builtin', '--engine=magick', '--z-index=0', '-z', '--1', '--loop=-1', '-l', '--hold', '--hold=no', '--unicode-placeholder', '--unicode-placeholder=no', '--passthrough=detect', '--passthrough=none', '--passthrough=tmux', '--image-id=0', '--no-trailing-newline', '-n', '--help', '-h'
          break
        }
        break
      }
      'ssh' {
        if ($wordToComplete.StartsWith('-')) {
          '--help', '-h'
          break
        }
        break
      }
      'transfer' {
        if ($wordToComplete.StartsWith('-')) {
          '-d', '--direction=download', '--direction=receive', '--direction=send', '--direction=upload', '-m', '--mode=normal', '--mode=mirror', '--compress=auto', '--compress=always', '--compress=never', '--permissions-bypass', '-p', '--confirm-paths', '-c', '--transmit-deltas', '-x', '--help', '-h'
          break
        }
        break
      }
      'panel' {
        if ($wordToComplete.StartsWith('-')) {
          '--lines=1', '--columns=1', '--margin-top=0', '--margin-left=0', '--margin-bottom=0', '--margin-right=0', '--edge=top', '--edge=background', '--edge=bottom', '--edge=center', '--edge=center-sized', '--edge=left', '--edge=none', '--edge=right', '--layer=bottom', '--layer=background', '--layer=overlay', '--layer=top', '--config', '-c', '--override', '-o', '--output-name', '--app-id', '--class=kitty-panel', '--name', '--os-window-tag', '--focus-policy=not-allowed', '--focus-policy=exclusive', '--focus-policy=on-demand', '--hide-on-focus-loss=no', '--grab-keyboard=no', '--exclusive-zone=-1', '--edge', '--override-exclusive-zone=no', '--single-instance', '-1=no', '--instance-group', '--wait-for-single-instance-window-close=no', '--listen-on', '--listen-on=unix', '--toggle-visibility=no', '--move-to-active-monitor=no', '--start-as-hidden=no', '--detach=no', '--detached-log', '--debug-rendering=no', '--debug-input=no', '--help', '-h=no'
          break
        }
        break
      }
      'quick-access' {
        if ($wordToComplete.StartsWith('-')) {
          '--config', '-c', '--override', '-o', '--detach', '--detach=no', '--detached-log', '--instance-group', '--instance-group=quick-access', '--debug-rendering', '--debug-rendering=no', '--debug-input', '--debug-input=no', '--help', '-h', '-h=no'
          break
        }
        break
      }
      'unicode-input' {
        if ($wordToComplete.StartsWith('-')) {
          '--emoji-variation=none', '--emoji-variation=graphic', '--emoji-variation=text', '--tab=previous', '--tab=code', '--tab=emoticons', '--tab=favorites', '--tab=name', '--help', '-h', '-h=no'
          break
        }
        break
      }
      'show-key' {
        if ($wordToComplete.StartsWith('-')) {
          '-m', '--key-mode=normal', '--key-mode=application', '--key-mode=kitty', '--key-mode=unchanged', '--help', '-h', '-h=no'
          break
        }
        break
      }
      'desktop-ui' {
        if ($wordToComplete.StartsWith('-')) {
          '--help', '-h'
          break
        }
        'run-server', 'enable-portal', 'set-color-scheme', 'set-accent-color', 'set-contrast', 'set-setting', 'show-settings'
        break
      }
      'desktop-ui run-server' {
        if ($wordToComplete.StartsWith('-')) {
          '--override', '-o', '--config', '-c', '--help', '-h'
          break
        }
        break
      }
      'desktop-ui show-settings' {
        if ($wordToComplete.StartsWith('-')) {
          '--as-json', '--as-json=no', '--in-namespace', '--allow-other-backends=no', '--help', '-h=no'
          break
        }
        break
      }
      { $_.StartsWith('desktop-ui ') -or $_ -ceq 'mouse-demo' } {
        if ($wordToComplete.StartsWith('-')) {
          '--help', '-h'
          break
        }
        break
      }
      'ask' {
        if ($wordToComplete.StartsWith('-')) {
          '-t', '--type=line', '--type=choices', '--type=file', '--type=password', '--type=yesno', '--message', '-m', '--name', '-n', '--title', '--window-title', '--choice', '-c', '--default', '-d', '--prompt', '-p', '--unhide-key=u', '--hidden-text-placeholder', '--help', '-h'
          break
        }
        break
      }
      'hints' {
        if ($wordToComplete.StartsWith('-')) {
          '--program', '--program', '--linenum-action', '--type=url', '--type=hash', '--type=hyperlink', '--type=ip', '--type=line', '--type=linenum', '--type=path', '--type=regex', '--type=word', '--regex=', '--linenum-action=self', '--linenum-action=background', '--linenum-action=os_window', '--linenum-action=remote-control', '--linenum-action=tab', '--linenum-action=window', '--url-prefixes=default', '--url-excluded-characters=default', '--word-characters', '--minimum-match-length=3', '--multiple', '--multiple=no', '--multiple-joiner=', '--multiple-joiner=space', '--multiple-joiner=character', '--multiple-joiner=newline', '--multiple-joiner=empty', '--multiple-joiner=json', '--multiple-joiner=serialized', '--multiple-joiner=auto', '--add-trailing-space=auto', '--add-trailing-space=always', '--add-trailing-space=never', '--hints-offset=1', '--alphabet', '--ascending', '--ascending=no', '--hints-foreground-color=black', '--hints-background-color=green', '--hints-text-color=auto', '--customize-processing', '--window-title', '--help', '-h=no'
          break
        }
        break
      }
      'diff' {
        if ($wordToComplete.StartsWith('-')) {
          '--context=-1', '--config', '--override', '-o', '--help', '-h=no'
          break
        }
        break
      }
      'notify' {
        if ($wordToComplete.StartsWith('-')) {
          '-n', '--icon=error', '--icon=file-manager', '--icon=help', '--icon=info', '--icon=question', '--icon=system-monitor', '--icon=text-editor', '--icon=warn', '--icon=warning', '--icon-path', '-p', '-a', '--app-name=kitten-notify', '--button', '-b', '-u', '--urgency=normal', '--urgency=critical', '--urgency=low', '--expire-after', '-e', '--sound-name=system', '-s', '--type', '-t', '--identifier', '-i', '--print-identifier', '--print-identifier=no', '-P', '--wait-for-completion', '--wait-for-completion=no', '--wait-till-closed', '--wait-till-closed=no', '-w', '--only-print-escape-code', '--only-print-escape-code=no', '--icon-cache-id', '-g', '--icon-path', '--help', '-h'
          break
        }
        break
      }
      'themes' {
        if ($wordToComplete.StartsWith('-')) {
          '--cache-age=1', '--reload-in=parent', '--reload-in=all', '--reload-in=none', '--dump-theme', '--dump-theme=no', '--config-file-name', '--config-file-name=kitty', '--help', '-h'
          break
        }
        break
      }
      'run-shell' {
        if ($wordToComplete.StartsWith('-')) {
          '--shell-integration', '--shell=', '--shell=bash', '--shell=pwsh', '--shell=node', '--shell=python', '--env', '--cwd', '--inject-self-onto-path=always', '--inject-self-onto-path=never', '--inject-self-onto-path=unless-root', '--help', '-h'
          break
        }
        break
      }
      'choose-fonts' {
        if ($wordToComplete.StartsWith('-')) {
          '--reload-in=parent', '--reload-in=all', '--reload-in=none', '--config-file-name=kitty.conf', '--help', '-h'
          break
        }
        break
      }
      'choose-files' {
        if ($wordToComplete.StartsWith('-')) {
          '--mode=file', '--mode=dir', '--mode=dirs', '--mode=files', '--mode=save-dir', '--mode=save-file', '--mode=save-files', '--file-filter', '--suggested-save-file-name', '--suggested-save-file-path', '--title', '--display-title', '--display-title=no', '--override', '-o', '--config', '--write-output-to', '--output-format=text', '--output-format=json', '--write-pid-to', '--help', '-h'
          break
        }
        break
      }
      'query-terminal' {
        if ($wordToComplete.StartsWith('-')) {
          '--wait-for=10', '--help', '-h'
          break
        }
        break
      }
    }).Where{ $_ -like "$wordToComplete*" }
}
