using namespace System.Management.Automation.Language

Register-ArgumentCompleter -Native -CommandName gum -ScriptBlock {
  param ([string]$wordToComplete, [System.Management.Automation.Language.CommandAst]$commandAst, [int]$cursorPosition)
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
          '-h', '--help', '-v', '--version'
          break
        }
        'choose', 'confirm', 'file', 'filter', 'format', 'input', 'join', 'pager', 'spin', 'style', 'table', 'write', 'log', 'version-check'
        break
      }
      'choose' {
        if ($wordToComplete.StartsWith('-')) {
          '-h', '--help', '-v', '--version', '--ordered', '--height=10', '--cursor=>', '--show-help', '--no-show-help', '--timeout=0s', '--header=Choose:', '--cursor-prefix=•', '--selected-prefix=✓', '--unselected-prefix=•', '--selected=', '--input-delimiter=', '--output-delimiter=', '--label-delimiter=', '--strip-ansi', '--no-strip-ansi', '--limit=1', '--no-limit', '--select-if-one', '--padding=', '--cursor.foreground=', '--cursor.background=', '--header.foreground=', '--header.background=', '--item.foreground=', '--item.background=', '--selected.foreground=', '--selected.background='
          break
        }
        break
      }
      'confirm' {
        if ($wordToComplete.StartsWith('-')) {
          '-h', '--help', '-v', '--version', '--default', '--show-output', '--affirmative=Yes', '--negative=No', '--show-help', '--no-show-help', '--timeout=0s', '--prompt.foreground=#7571F9', '--prompt.background=', '--selected.foreground=230', '--selected.background=212', '--unselected.foreground=254', '--unselected.background=235', '--padding='
          break
        }
        break
      }
      'file' {
        if ($wordToComplete.StartsWith('-')) {
          '-h', '--help', '-v', '--version', '-c', '--cursor=>', '-a', '--all', '-p', '--permissions', '--no-permissions', '-s', '--size', '--no-size', '--file', '--directory', '--show-help', '--no-show-help', '--timeout=0s', '--header=', '--height=10', '--cursor.foreground=212', '--cursor.background=', '--symlink.foreground=36', '--symlink.background=', '--directory.foreground=99', '--directory.background=', '--file.foreground=', '--file.background=', '--permissions.foreground=244', '--permissions.background=', '--selected.foreground=212', '--selected.background=', '--file-size.foreground=240', '--file-size.background=', '--header.foreground=99', '--header.background=', '--padding='
          break
        }
        break
      }
      'filter' {
        if ($wordToComplete.StartsWith('-')) {
          '-h', '--help', '-v', '--version', '--indicator=•', '--selected=', '--show-help', '--no-show-help', '--selected-prefix=◉', '--unselected-prefix=○', '--header=', '--placeholder=Filter...', '--prompt=>', '--width=0', '--height=0', '--value=', '--reverse', '--fuzzy', '--no-fuzzy', '--fuzzy-sort', '--no-fuzzy-sort', '--timeout=0s', '--input-delimiter=', '--output-delimiter=', '--strip-ansi', '--no-strip-ansi', '--indicator.foreground=212', '--indicator.background=', '--selected-indicator.foreground=212', '--selected-indicator.background=', '--unselected-prefix.foreground=240', '--unselected-prefix.background=', '--header.foreground=99', '--header.background=', '--text.foreground=', '--text.background=', '--cursor-text.foreground=', '--cursor-text.background=', '--match.foreground=212', '--match.background=', '--prompt.foreground=240', '--prompt.background=', '--placeholder.foreground=240', '--placeholder.background=', '--padding=', '--limit=1', '--no-limit', '--select-if-one', '--strict', '--no-strict'
          break
        }
        break
      }
      'format' {
        if ($wordToComplete.StartsWith('-')) {
          '-h', '--help', '-v', '--version', '--theme=', '--theme=ascii', '--theme=auto', '--theme=dark', '--theme=dracula', '--theme=light', '--theme=notty', '--theme=pink', '--theme=tokyo-night', '-l', '--language=', '--strip-ansi', '--no-strip-ansi', '-t', '-tmarkdown', '-ttemplate', '-tcode', '-temoji', '--type=markdown', '--type=template', '--type=code', '--type=emoji'
          break
        }
        break
      }
      'input' {
        if ($wordToComplete.StartsWith('-')) {
          '-h', '--help', '-v', '--version', '--placeholder=Type', '--prompt=>', '--cursor.mode=blink', '--value=', '--char-limit=400', '--width=0', '--password', '--show-help', '--no-show-help', '--header=', '--timeout=0s', '--strip-ansi', '--no-strip-ansi', '--prompt.foreground=', '--prompt.background=', '--placeholder.foreground=240', '--placeholder.background=', '--cursor.foreground=212', '--cursor.background=', '--header.foreground=240', '--header.background=', '--padding='
          break
        }
        break
      }
      'join' {
        if ($wordToComplete.StartsWith('-')) {
          '-h', '--help', '-v', '--version', '--align=left', '--horizontal', '--vertical'
          break
        }
        break
      }
      'pager' {
        if ($wordToComplete.StartsWith('-')) {
          '-h', '--help', '-v', '--version', '--show-line-numbers', '--soft-wrap', '--no-soft-wrap', '--timeout=0s', '--foreground=', '--background=', '--line-number.foreground=237', '--line-number.background=', '--match.foreground=212', '--match.background=', '--match-highlight.foreground=235', '--match-highlight.background=225', '--help.foreground=241', '--help.background='
          break
        }
        break
      }
      'spin' {
        if ($wordToComplete.StartsWith('-')) {
          '-h', '--help', '-v', '--version', '--show-output', '--show-error', '--show-stdout', '--show-stderr', '-s', '--spinner=dot', '--title=Loading...', '-a', '--align=left', '--timeout=0s', '--spinner.foreground=212', '--spinner.background=', '--title.foreground=', '--title.background=', '--padding='
          break
        }
        break
      }
      'style' {
        if ($wordToComplete.StartsWith('-')) {
          '-h', '--help', '-v', '--version', '--trim', '--strip-ansi', '--no-strip-ansi', '--foreground=', '--background=', '--border=none', '--border-background=', '--border-foreground=', '--align=left', '--height=0', '--width=0', '--margin=', '--padding=', '--bold', '--faint', '--italic', '--strikethrough', '--underline'
          break
        }
        break
      }
      'table' {
        if ($wordToComplete.StartsWith('-')) {
          '-h', '--help', '-v', '--version', '-s', '--separator=', '-c', '--columns=', '-w', '--widths=', '--height=0', '-p', '--print', '-f', '--file=', '-b', '--border=rounded', '--show-help', '--no-show-help', '--hide-count', '--no-hide-count', '--lazy-quotes', '--fields-per-record=0', '-r', '--return-column=0', '--timeout=0s', '--border.foreground=', '--border.background=', '--cell.foreground=', '--cell.background=', '--header.foreground=', '--header.background=', '--selected.foreground=212', '--selected.background=', '--padding='
          break
        }
        break
      }
      'write' {
        if ($wordToComplete.StartsWith('-')) {
          '-h', '--help', '-v', '--version', '--width=0', '--height=5', '--header=', '--placeholder=Write', '--prompt=┃', '--show-cursor-line', '--show-line-numbers', '--value=', '--char-limit=0', '--max-lines=0', '--show-help', '--no-show-help', '--cursor.mode=blink', '--timeout=0s', '--strip-ansi', '--no-strip-ansi', '--base.foreground=', '--base.background=', '--cursor-line-number.foreground=7', '--cursor-line-number.background=', '--cursor-line.foreground=', '--cursor-line.background=', '--cursor.foreground=212', '--cursor.background=', '--end-of-buffer.foreground=0', '--end-of-buffer.background=', '--line-number.foreground=7', '--line-number.background=', '--header.foreground=240', '--header.background=', '--placeholder.foreground=240', '--placeholder.background=', '--prompt.foreground=7', '--prompt.background=', '--padding='
          break
        }
        break
      }
      'log' {
        if ($wordToComplete.StartsWith('-')) {
          '-h', '--help', '-v', '--version', '-o', '--file=', '-f', '--format', '--formatter=text', '-l', '--level=none', '--prefix=', '-s', '--structured', '-t', '--time=', '--min-level=', '--level.foreground=', '--level.background=', '--time.foreground=', '--time.background=', '--prefix.foreground=', '--prefix.background=', '--message.foreground=', '--message.background=', '--key.foreground=', '--key.background=', '--value.foreground=', '--value.background=', '--separator.foreground=', '--separator.background='
          break
        }
        break
      }
      'version-check' {
        if ($wordToComplete.StartsWith('-')) {
          '-h', '--help', '-v', '--version'
          break
        }
        break
      }
    }).Where{ $_ -like "$wordToComplete*" }
}
