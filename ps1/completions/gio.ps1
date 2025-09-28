using namespace System.Management.Automation.Language

Register-ArgumentCompleter -Native -CommandName gio -ScriptBlock {
  param ([string]$wordToComplete, [CommandAst]$commandAst, [int]$cursorPosition)
  if (!$IsLinux) {
    return
  }
  $command = @(foreach ($i in $commandAst.CommandElements) {
      if ($i.Extent.StartOffset -eq $commandAst.Extent.StartOffset) {
        continue
      }
      if ($i.Extent.EndOffset -ge $cursorPosition -or
        $i -isnot [StringConstantExpressionAst] -or
        $i.StringConstantType -ne [StringConstantType]::BareWord -or
        $i.Value.StartsWith('-')) {
        break
      }
      $i.Value
    }) -join ' '
  $command = switch ($command) {
    'help' { ''; break }
    default { $_; break }
  }

  $cursorPosition -= $wordToComplete.Length
  foreach ($i in $commandAst.CommandElements) {
    if ($i.Extent.StartOffset -ge $cursorPosition) {
      break
    }
    $prev = $i
  }
  $prev = $prev -is [StringConstantExpressionAst] ? $prev.Value : $prev.ToString()

  @(
    if ($wordToComplete.StartsWith('-')) {
      switch ($command) {
        copy {
          '-T', '--no-target-directory', '-p', '--progress', '-i', '--interactive', '--preserve', '-b', '--backup', '-P', '--no-dereference', '--default-permissions', '--default-modified-time'
          break
        }
        info {
          '-w', '--query-writable', '-f', '--filesystem', '-a', '--attributes=', '-n', '--nofollow-symlinks'
          break
        }
        list {
          '-a', '--attributes=', '-h', '--hidden', '-l', '--long', '-n', '--nofollow-symlinks', '-d', '--print-display-names', '-u', '--print-uris'
          break
        }
        mkdir {
          '-p', '--parent'
          break
        }
        monitor {
          '-d', '--dir=', '-f', '--file=', '-D', '--direct=', '-s', '--silent=', '-n', '--no-moves', '-m', '--mounts'
          break
        }
        mount {
          '-m', '--mountable', '-d', '--device=', '-u', '--unmount', '-e', '--eject', '-t', '--stop=', '-s', '--unmount-scheme=', '-f', '--force', '-a', '--anonymous', '-l', '--list', '-o', '--monitor', '-i', '--detail', '--tcrypt-pim=', '--tcrypt-hidden', '--tcrypt-system'
          break
        }
        move {
          '-T', '--no-target-directory', '-p', '--progress', '-i', '--interactive', '-b', '--backup', '-C', '--no-copy-fallback'
          break
        }
        remove {
          '-f', '--force'
          break
        }
        save {
          '-b', '--backup', '-c', '--create', '-a', '--append', '-p', '--private', '-u', '--unlink', '-v', '--print-etag', '-e', '--etag='
          break
        }
        set {
          '-t', '--type=', '-n', '--nofollow-symlinks', '-d', '--delete'
          break
        }
        trash {
          '-f', '--force', '--empty', '--list', '--restore'
          break
        }
        tree {
          '-h', '--hidden', '-l', '--follow-symlinks'
          break
        }
      }
    }
    else {
      switch ($command) {
        '' {
          'help', 'version', 'cat', 'copy', 'info', 'launch', 'list', 'mime', 'mkdir', 'monitor', 'mount', 'move', 'open', 'rename', 'remove', 'save', 'set', 'trash', 'tree'
          break
        }
        launch {
          Convert-Path ~/.local/share/applications/$wordToComplete*.desktop, /usr/local/share/applications/$wordToComplete*.desktop, /usr/share/applications/$wordToComplete*.desktop
          $wordToComplete = ''
          break
        }
        mime {
          Get-Content -LiteralPath /usr/share/applications/mimeapps.list -ea Stop | ForEach-Object { $_.Split('=', 2)[0] }
          break
        }
        { $_.StartsWith('mime ') } {
          if ($_.IndexOf(' ', 5) -eq -1) {
            Split-Path -Resolve -Leaf ~/.local/share/applications/*.desktop, /usr/local/share/applications/*.desktop, /usr/share/applications/*.desktop
          }
          break
        }
        default {
          if (!$wordToComplete.Contains(':///')) {
            'file:///', 'trash:///', 'dav:///', 'smb:///', 'ssh:///'
            break
          }
          (gio list -lhu $wordToComplete || gio list -lhu ($wordToComplete -replace '[^/]*$', '')) | ForEach-Object {
            $uri, $len, $type = $_.Split("`t")
            $uri + ($type -ceq '(directory)' ? '/' : '')
          }
          break
        }
      }
    }).Where{ $_ -like "$wordToComplete*" }
}
