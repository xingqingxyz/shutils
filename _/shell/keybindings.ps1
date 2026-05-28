# editing
if (!$IsWindows) {
  Set-PSReadLineOption -EditMode Windows
}
Set-PSReadLineKeyHandler -Chord Alt+H -Function WhatIsKey
Set-PSReadLineKeyHandler -Chord Alt+o -Function InsertLineAbove
Set-PSReadLineKeyHandler -Chord Alt+O -Function InsertLineBelow
Set-PSReadLineKeyHandler -Chord Ctrl+b -Function BackwardWord
Set-PSReadLineKeyHandler -Chord Ctrl+d -Function DeleteCharOrExit
Set-PSReadLineKeyHandler -Chord Ctrl+Delete -Function KillWord
Set-PSReadLineKeyHandler -Chord Ctrl+f -Function ForwardWord
Set-PSReadLineKeyHandler -Chord Ctrl+u -Function BackwardKillLine
# custom
Set-PSReadLineKeyHandler -Chord F1 -Description 'Show command help' -ScriptBlock {
  $cursor = 0
  [System.Management.Automation.Language.Token[]]$tokens = $null
  [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$null, [ref]$tokens, [ref]$null, [ref]$cursor)
  [string]$name = $tokens.Where({ $_.TokenFlags -ceq 'CommandName' -and $_.Extent.StartOffset -le $cursor }, 'Last', 1)
  if (!$name) {
    return
  }
  [Microsoft.PowerShell.PSConsoleReadLine]::Replace(0, $name.Length, "Show-CommandInfo -Man $name #")
  [Microsoft.PowerShell.PSConsoleReadLine]::AcceptLine()
}
Set-PSReadLineKeyHandler -Chord Ctrl+F1 -Description 'Try to open powershell docs in browser about the command' -ScriptBlock {
  $cursor = 0
  [System.Management.Automation.Language.Token[]]$tokens = $null
  [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$null, [ref]$tokens, [ref]$null, [ref]$cursor)
  [string]$name = $tokens.Where({ $_.TokenFlags -ceq 'CommandName' -and $_.Extent.StartOffset -le $cursor }, 'Last', 1)
  if (!$name) {
    return
  }
  $info = Get-Command $name -ea Ignore
  if ($info.CommandType -eq 'Alias') {
    $info = $info.ResolvedCommand
  }
  if ($info.HelpUri) {
    Start-Process $info.HelpUri
  }
}
Set-PSReadLineKeyHandler -Chord Ctrl+r -Description 'Fzf select from history files to replace command line' -ScriptBlock {
  $text = ''
  [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$text, [ref]$null)
  try { $history = Get-Content -LiteralPath (Get-PSReadLineOption).HistorySavePath | fzf --tac --scheme=history -q `'$($text.Split(' ',2)[0]) } catch { return }
  [Microsoft.PowerShell.PSConsoleReadLine]::Replace(0, $text.Length, $history)
}
Set-PSReadLineKeyHandler -Chord Ctrl+t -Description 'Fzf select relative files to insert' -ScriptBlock {
  # note: expects "`n" not in path
  try { $items = fzf -m '--walker=file,follow,hidden' '--preview=bat -p --color=always {}' } catch { return }
  [Microsoft.PowerShell.PSConsoleReadLine]::Insert("'$($items -creplace "'", "''" -join "' '")'")
}
Set-PSReadLineKeyHandler -Chord Alt+c -Description 'Fzf select sub directories to cd' -ScriptBlock {
  # note: expects "`n" not in path
  try { $dir = fzf '--walker=dir,hidden' } catch { return }
  Set-Location -LiteralPath $dir
  [Microsoft.PowerShell.PSConsoleReadLine]::InvokePrompt()
}
Set-PSReadLineKeyHandler -Chord Alt+S -Description 'Fzf select stared repo name to insert' -ScriptBlock {
  try { $repo = Get-Content -LiteralPath $env:WISH_ROOT/scripts/data/stars.txt | fzf --scheme=path } catch { return }
  [Microsoft.PowerShell.PSConsoleReadLine]::Insert($repo)
}
Set-PSReadLineKeyHandler -Chord Alt+z -Description 'Fzf select z paths to cd' -ScriptBlock {
  try { $dir = (Invoke-Z -List).Key | fzf --scheme=path } catch { return }
  Invoke-Z $dir
  [Microsoft.PowerShell.PSConsoleReadLine]::InvokePrompt()
}
Set-PSReadLineKeyHandler -Chord Alt+v -Description 'Toggle .venv environment' -ScriptBlock {
  if (Test-Path -LiteralPath Function:\deactivate) {
    deactivate
    [Microsoft.PowerShell.PSConsoleReadLine]::InvokePrompt()
    return
  }
  $root = $ExecutionContext.SessionState.Path.CurrentFileSystemLocation.ProviderPath
  $fsRoot = [System.IO.Path]::GetPathRoot($root)
  do {
    $venvPath = [System.IO.Path]::Join($root, '.venv')
    if ([System.IO.Path]::Exists($venvPath)) {
      if ($IsWindows) {
        & $venvPath\Scripts\Activate.ps1
      }
      else {
        & $venvPath/bin/activate.ps1
      }
      [Microsoft.PowerShell.PSConsoleReadLine]::InvokePrompt()
      break
    }
    $root = [System.IO.Path]::GetDirectoryName($root)
  } while ($root -cne $fsRoot)
}
$cmd = {
  [System.Management.Automation.Language.Ast]$ast = $null
  [System.Management.Automation.Language.Token[]]$tokens = $null
  [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$ast, [ref]$tokens, [ref]$null, [ref]$null)
  $text = if ($tokens.Where({ $_.TokenFlags -ceq 'CommandName' }, 'First', 2).Count -eq 1) {
    $i = $tokens[0].Kind -ceq 'Dot' -or $tokens[0].Kind -ceq 'Ampersand' ? $tokens[1].Extent.StartOffset : 0
    $ast.ToString().Substring($i)
  }
  else {
    "{$ast}"
  }
  $text = $(switch ($args[0].KeyChar) {
      'd' { 'delay 0:12 {0} &'; break }
      's' { 'sudo {0}'; break }
      'x' { 'x {0}'; break }
      default { '& {0}'; break }
    }) -f $text
  [Microsoft.PowerShell.PSConsoleReadLine]::Replace(0, $ast.Extent.EndOffset, $text)
  [Microsoft.PowerShell.PSConsoleReadLine]::AcceptLine()
}
Set-PSReadLineKeyHandler -Chord Alt+d -Description 'Add delay & to command line and accept it' -ScriptBlock $cmd
Set-PSReadLineKeyHandler -Chord Alt+s -Description 'Add sudo to command line and accept it' -ScriptBlock $cmd
Set-PSReadLineKeyHandler -Chord Alt+x -Description 'Add x to command line and accept it' -ScriptBlock $cmd
Remove-Variable cmd
