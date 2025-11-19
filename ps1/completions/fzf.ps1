Register-ArgumentCompleter -Native -CommandName fzf -ScriptBlock {
  param ([string]$wordToComplete, [System.Management.Automation.Language.CommandAst]$commandAst, [int]$cursorPosition)
  $cursorPosition -= $wordToComplete.Length
  foreach ($i in $commandAst.CommandElements) {
    if ($i.Extent.StartOffset -ge $cursorPosition) {
      if ($i -is [System.Management.Automation.Language.StringConstantExpressionAst]) {
        $wordToComplete = $i.Value
      }
      break
    }
  }
  if ($wordToComplete.StartsWith('--bind=')) {
    [int]$pos = $wordToComplete.Split(':').Count - 1
    [string]$prefix = $wordToComplete.Substring(0, $wordToComplete.LastIndexOfAny('=,:+'.ToCharArray()) + 1)
  }
  else {
    [int]$pos = $wordToComplete.Split(',').Count - 1
    if ($pos -gt 0) {
      [string]$prefix = $wordToComplete.Substring(0, $wordToComplete.LastIndexOfAny('=,'.ToCharArray()) + 1)
    }
  }
  [string]$word = $wordToComplete.Substring($prefix.Length)
  [string[]]$items = switch -CaseSensitive -Wildcard ($wordToComplete) {
    '--bind=*' {
      switch ($pos) {
        0 {
          'ctrl-space', 'ctrl-delete', 'ctrl-\\', 'ctrl-]', 'ctrl-^', 'ctrl-6', 'ctrl-/', 'ctrl-_', 'enter', 'return', 'ctrl-m', 'space', 'backspace', 'bspace', 'bs', 'alt-up', 'alt-down', 'alt-left', 'alt-right', 'alt-home', 'alt-end', 'alt-backspace', 'alt-bspace', 'alt-bs', 'alt-delete', 'alt-page-up', 'alt-page-down', 'alt-enter', 'alt-space', 'tab', 'shift-tab', 'btab', 'esc', 'delete', 'del', 'up', 'down', 'left', 'right', 'home', 'end', 'insert', 'page-up', 'pgup', 'page-down', 'pgdn', 'ctrl-up', 'ctrl-down', 'ctrl-left', 'ctrl-right', 'ctrl-home', 'ctrl-end', 'ctrl-backspace', 'ctrl-bspace', 'ctrl-bs', 'ctrl-delete', 'ctrl-page-up', 'ctrl-page-down', 'shift-up', 'shift-down', 'shift-left', 'shift-right', 'shift-home', 'shift-end', 'shift-delete', 'shift-page-up', 'shift-page-down', 'alt-shift-up', 'alt-shift-down', 'alt-shift-left', 'alt-shift-right', 'alt-shift-home', 'alt-shift-end', 'alt-shift-delete', 'alt-shift-page-up', 'alt-shift-page-down', 'ctrl-alt-up', 'ctrl-alt-down', 'ctrl-alt-left', 'ctrl-alt-right', 'ctrl-alt-home', 'ctrl-alt-end', 'ctrl-alt-backspace', 'ctrl-alt-bspace', 'ctrl-alt-bs', 'ctrl-alt-delete', 'ctrl-alt-page-up', 'ctrl-alt-page-down', 'ctrl-shift-up', 'ctrl-shift-down', 'ctrl-shift-left', 'ctrl-shift-right', 'ctrl-shift-home', 'ctrl-shift-end', 'ctrl-shift-delete', 'ctrl-shift-page-up', 'ctrl-shift-page-down', 'ctrl-alt-shift-up', 'ctrl-alt-shift-down', 'ctrl-alt-shift-left', 'ctrl-alt-shift-right', 'ctrl-alt-shift-home', 'ctrl-alt-shift-end', 'ctrl-alt-shift-delete', 'ctrl-alt-shift-page-up', 'ctrl-alt-shift-page-down', 'left-click', 'right-click', 'double-click', 'scroll-up', 'scroll-down', 'preview-scroll-up', 'preview-scroll-down', 'shift-left-click', 'shift-right-click', 'shift-scroll-up', 'shift-scroll-down'
          'start', 'load', 'resize', 'result', 'change', 'focus', 'multi', 'one', 'zero', 'backward-eof', 'jump', 'jump-cancel', 'click-header', 'click-footer'
          break
        }
        default {
          'abort', 'accept', 'accept-non-empty', 'accept-or-print-query', 'backward-char', 'backward-delete-char', 'backward-delete-eof', 'backward-kill-subword', 'backward-kill-word', 'backward-subword', 'backward-word', 'become:', 'beginning-of-line', 'bell', 'best', 'bg-cancel', 'cancel', 'abort', 'change-border-label:', 'change-ghost:', 'change-header:', 'change-header-label:', 'change-input-label:', 'change-list-label:', 'change-multi', 'change-multi:', 'change-nth:', 'change-pointer:', 'change-preview:', 'change-preview-label:', 'change-preview-window:', 'change-prompt:', 'change-query:', 'clear-screen', 'clear-multi', 'close', 'abort', 'clear-query', 'delete-char', 'delete-eof', 'delete-eof', 'deselect', 'deselect-all', 'disable-raw', 'disable-search', 'down', 'down-match', 'down-selected', 'enable-raw', 'enable-search', 'end-of-line', 'exclude', 'exclude-multi', 'execute:', 'execute-silent:', 'first', 'forward-char', 'forward-subword', 'forward-word', 'ignore', 'jump', 'kill-line', 'kill-subword', 'kill-word', 'last', 'next-history', 'next-selected', 'page-down', 'page-up', 'half-page-down', 'half-page-up', 'hide-header', 'hide-input', 'hide-preview', 'offset-down', 'offset-up', 'offset-middle', 'pos:', 'prev-history', 'prev-selected', 'preview:', 'preview-down', 'preview-up', 'preview-page-down', 'preview-page-up', 'preview-half-page-down', 'preview-half-page-up', 'preview-bottom', 'preview-top', 'print:', 'put', 'put:', 'refresh-preview', 'rebind:', 'reload:', 'reload-sync:', 'replace-query', 'search:', 'select', 'select-all', 'show-header', 'show-input', 'show-preview', 'toggle', 'toggle-all', 'toggle-in', 'toggle-out', 'toggle-bind', 'toggle-header', 'toggle-hscroll', 'toggle-input', 'toggle-multi-line', 'toggle-preview', 'toggle-preview-wrap', 'toggle-raw', 'toggle-search', 'toggle-sort', 'toggle-track', 'toggle-track-current', 'toggle-wrap', 'toggle+down', 'toggle+up', 'track-current', 'transform:', 'transform-border-label:', 'transform-ghost:', 'transform-header:', 'transform-header-label:', 'transform-input-label:', 'transform-list-label:', 'transform-nth:', 'transform-pointer:', 'transform-preview-label:', 'transform-prompt:', 'transform-query:', 'transform-search:', 'trigger:', 'unbind:', 'unix-line-discard', 'unix-word-rubout', 'untrack-current', 'up', 'up-match', 'up-selected', 'yank'
          break
        }
      }
      break
    }
    '--color=*' {
      switch ($pos) {
        0 { 'dark', 'light', '16', 'bw'; break }
        1 { 'black', 'red', 'green', 'yellow', 'blue', 'magenta', 'cyan', 'white', 'bright-black', 'gray', 'grey', 'bright-red', 'bright-green', 'bright-yellow', 'bright-blue', 'bright-magenta', 'bright-cyan', 'bright-white'; break }
        2 { 'regular', 'strip', 'bold', 'underline', 'reverse', 'dim', 'italic', 'strikethrough'; break }
      }
      break
    }
    '--tmux=*' {
      if ($pos -eq 0) {
        'left', 'right', 'down', 'up'
      }
      elseif ($pos -lt 4) {
        '10%', '20%', '25%', '30%', '40%', '50%', '60%', '70%', '75%', '80%', '90%', '100%'
        'border-native'
      }
      break
    }
    '--walker-skip=*' {
      if ($pos -lt 2) {
        'file', 'dir', 'follow', 'hidden'
      }
      elseif ($pos -lt 4) {
        'follow', 'hidden'
      }
      break
    }
    '--preview-window=*' {
      switch ($pos) {
        0 { 'left', 'right', 'down', 'up'; break }
        1 { 'border-block', 'border-bold', 'border-bottom', 'border-double', 'border-horizontal', 'border-left', 'border-none', 'border-right', 'border-rounded', 'border-sharp', 'border-thinblock', 'border-top', 'border-vertical', 'cycle', 'default', 'follow', 'hidden', 'info', 'nocycle', 'nofollow', 'nohidden', 'noinfo', 'nowrap', 'wrap'; break }
        2 { '10%', '20%', '25%', '30%', '40%', '50%', '60%', '70%', '75%', '80%', '90%', '100%'; break }
      }
      break
    }
    { $_.StartsWith('--margin=') -or $_.StartsWith('--padding=') } {
      if ($pos -lt 4) {
        '10%', '20%', '25%', '30%', '40%', '50%', '60%', '70%', '75%', '80%', '90%', '100%'
      }
      break
    }
    default {
      if ($wordToComplete.StartsWith('-')) {
        return '-x', '--extended', '-e', '--exact', '-i', '--ignore-case', '--no-ignore-case', '--smart-case', '--literal', '--scheme=default', '--scheme=path', '--scheme=history', '--algo=v1', '--algo=v2', '-n', '--nth=', '--with-nth=', '--accept-nth=', '--no-sort', '-d', '--delimiter=', '--tail=', '--disabled', '--tiebreak=length', '--tiebreak=chunk', '--tiebreak=pathname', '--tiebreak=begin', '--tiebreak=end', '--tiebreak=index', '--read0', '--print0', '--ansi', '--sync', '--no-tty-default', '--style=default', '--style=minimal', '--style=full', '--style=full:', '--color=dark', '--color=light', '--color=base16', '--color=bw', '--color=fg:', '--color=list-fg:', '--color=selected-fg:', '--color=preview-fg:', '--color=bg:', '--color=list-bg:', '--color=selected-bg:', '--color=preview-bg:', '--color=input-bg:', '--color=header-bg:', '--color=footer-bg:', '--color=hl:', '--color=selected-hl:', '--color=current-fg:', '--color=fg', '--color=current-bg:', '--color=bg', '--color=gutter:', '--color=current-hl:', '--color=hl', '--color=alt-bg:', '--color=query:', '--color=input-fg:', '--color=ghost:', '--color=dim:', '--color=disabled:', '--color=info:', '--color=border:', '--color=list-border:', '--color=scrollbar:', '--color=separator:', '--color=gap-line:', '--color=preview-border:', '--color=preview-scrollbar:', '--color=input-border:', '--color=header-border:', '--color=footer-border:', '--color=list-label:', '--color=preview-label:', '--color=input-label:', '--color=header-label:', '--color=footer-label:', '--color=prompt:', '--color=pointer:', '--color=marker:', '--color=spinner:', '--color=header:', '--color=header-fg:', '--color=footer:', '--color=footer-fg:', '--color=nth:', '--color=nomatch:', '--no-color', '--no-bold', '--black', '--height=', '--height=~', '--min-height=', '--tmux', '--tmux=center', '--tmux=top', '--tmux=bottom', '--tmux=left', '--tmux=right', '--layout=default', '--layout=reverse', '--layout=reverse-list', '--reverse', '--margin=', '--padding=', '--border', '--border=rounded', '--border=sharp', '--border=bold', '--border=double', '--border=block', '--border=thinblock', '--border=horizontal', '--border=vertical', '--border=line', '--border=top', '--border=bottom', '--border=left', '--border=right', '--border=none', '--border-label=', '--border-label-pos=0:top', '--border-label-pos=0:bottom', '-m', '--multi', '--multi=', '--no-multi', '--highlight-line', '--cycle', '--wrap', '--wrap-sign=↳', '--wrap-sign=>', '--no-multi-line', '--raw', '--track', '--tac', '--gap', '--gap=', '--gap-line', '--gap-line=', '--keep-right', '--scroll-off=3', '--no-hscroll', '--hscroll-off=10', '--jump-labels=', '--gutter=▌', '--pointer=▌', '--pointer=>', '--marker=┃', '--marker=>', '--marker-multi-line=.', '--tabstop=8', '--scrollbar=│', '--scrollbar=:', '--no-scrollbar', '--list-border', '--list-border=rounded', '--list-border=sharp', '--list-border=bold', '--list-border=double', '--list-border=block', '--list-border=thinblock', '--list-border=horizontal', '--list-border=vertical', '--list-border=line', '--list-border=top', '--list-border=bottom', '--list-border=left', '--list-border=right', '--list-border=none', '--list-label=', '--list-label-pos=0:top', '--list-label-pos=0:bottom', '--no-input', '--prompt=>', '--info=default', '--info=right', '--info=hidden', '--info=inline', '--info=inline:', '--info=inline-right', '--info=inline-right:', '--info-command=', '--no-info', '--separator=─', '--separator=-', '--no-separator', '--ghost=', '--filepath-word', '--input-border', '--input-border=sharp', '--input-border=bold', '--input-border=double', '--input-border=block', '--input-border=thinblock', '--input-border=horizontal', '--input-border=vertical', '--input-border=line', '--input-border=top', '--input-border=bottom', '--input-border=left', '--input-border=right', '--input-border=none', '--input-label=', '--input-label-pos=0:top', '--input-label-pos=0:bottom', '--preview=', '--preview-border', '--preview-border=sharp', '--preview-border=bold', '--preview-border=double', '--preview-border=block', '--preview-border=thinblock', '--preview-border=horizontal', '--preview-border=vertical', '--preview-border=line', '--preview-border=top', '--preview-border=bottom', '--preview-border=left', '--preview-border=right', '--preview-border=none', '--preview-label=', '--preview-label-pos=0:top', '--preview-label-pos=0:bottom', '--preview-window=up', '--preview-window=down', '--preview-window=left', '--preview-window=right', '--preview', '--preview-window', '--header=', '--header-lines=', '--header-first', '--header-border', '--header-border=sharp', '--header-border=bold', '--header-border=double', '--header-border=block', '--header-border=thinblock', '--header-border=horizontal', '--header-border=vertical', '--header-border=line', '--header-border=top', '--header-border=bottom', '--header-border=left', '--header-border=right', '--header-border=none', '--header-label=', '--header-label-pos=0:top', '--header-label-pos=0:bottom', '--header-lines-border', '--header-lines-border=sharp', '--header-lines-border=bold', '--header-lines-border=double', '--header-lines-border=block', '--header-lines-border=thinblock', '--header-lines-border=horizontal', '--header-lines-border=vertical', '--header-lines-border=line', '--header-lines-border=top', '--header-lines-border=bottom', '--header-lines-border=left', '--header-lines-border=right', '--header-lines-border=none', '--no-header-lines-border.', '--footer=', '--footer-border', '--footer-border=sharp', '--footer-border=bold', '--footer-border=double', '--footer-border=block', '--footer-border=thinblock', '--footer-border=horizontal', '--footer-border=vertical', '--footer-border=line', '--footer-border=top', '--footer-border=bottom', '--footer-border=left', '--footer-border=right', '--footer-border=none', '--footer-label=', '--footer-label-pos=0:top', '--footer-label-pos=0:bottom', '-q', '--query=', '-1', '--select-1', '-0', '--exit-0', '-f', '--filter=', '--print-query', '--expect=', '--no-clear', '--bind=', '--with-shell="pwsh -nop"', '--with-shell=bash', '--with-shell=zsh', '--with-shell=fish', '--with-shell=sh', '--with-shell=python', '--listen', '--listen=', '--listen-unsafe', '--listen-unsafe=', '--walker=', '--walker-root=', '--walker-skip=.git', '--walker-skip=node_modules', '--history=', '--history-size=', '--bash', '--zsh', '--fish', '--no-mouse', '--no-unicode', '--ambidouble', '--version', '--help', '--man' | Where-Object { $_ -like "$wordToComplete*" }
        break
      }
      break
    }
  }
  $items.ForEach{
    if (!$_.StartsWith($word)) {
      return
    }
    "'" + ($prefix + $_).Replace("'", "''")
  }
}
