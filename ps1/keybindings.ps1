# editing
if (!$IsWindows) {
  Set-PSReadLineOption -EditMode Windows
  Set-PSReadLineKeyHandler -Chord Ctrl+c -Function CancelLine
}
Set-PSReadLineKeyHandler -Chord Alt+H -Function WhatIsKey
Set-PSReadLineKeyHandler -Chord Alt+o -Function InsertLineAbove
Set-PSReadLineKeyHandler -Chord Alt+O -Function InsertLineBelow
Set-PSReadLineKeyHandler -Chord Ctrl+d -Function DeleteCharOrExit
Set-PSReadLineKeyHandler -Chord Ctrl+Delete -Function KillWord
Set-PSReadLineKeyHandler -Chord Ctrl+e -Function ViEditVisually
Set-PSReadLineKeyHandler -Chord Ctrl+f -Function ForwardWord
Set-PSReadLineKeyHandler -Chord Ctrl+g -Function GotoBrace
Set-PSReadLineKeyHandler -Chord Ctrl+k -Function DeleteLine
Set-PSReadLineKeyHandler -Chord Ctrl+u -Function BackwardKillLine
# custom
Set-PSReadLineKeyHandler -Chord Alt+A -Description 'Comment inputs and accept' -ScriptBlock {
  $text = ''
  [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$text, [ref]$null)
  [Microsoft.PowerShell.PSConsoleReadLine]::Replace(0, $text.Length, ($text.Split("`n").ForEach{ "# $_" } -join "`n"))
  [Microsoft.PowerShell.PSConsoleReadLine]::AcceptLine()
}
Set-PSReadLineKeyHandler -Chord F1 -Description 'Show powershell command help' -ScriptBlock {
  $cursor = 0
  [System.Management.Automation.Language.Token[]]$tokens = $null
  [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$null, [ref]$tokens, [ref]$null, [ref]$cursor)
  $name = $tokens.Where{ $_.TokenFlags -eq 'CommandName' -and $_.Extent.StartOffset -le $cursor }[-1].Text
  $info = Get-Command $name -ea Ignore
  if ($info.CommandType -eq 'Alias') {
    $info = $info.ResolvedCommand
  }
  if (!$info) {
    return
  }
  [Microsoft.PowerShell.PSConsoleReadLine]::Replace(0, 0, "Show-CommandSource $info # ")
  [Microsoft.PowerShell.PSConsoleReadLine]::AcceptLine()
}
Set-PSReadLineKeyHandler -Chord Ctrl+F1 -Description 'Try to open powershell docs in browser about the command' -ScriptBlock {
  $cursor = 0
  [System.Management.Automation.Language.Token[]]$tokens = $null
  [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$null, [ref]$tokens, [ref]$null, [ref]$cursor)
  $name = $tokens.Where{ $_.TokenFlags -eq 'CommandName' -and $_.Extent.StartOffset -le $cursor }[-1].Text
  $info = Get-Command $name -ea Ignore
  if ($info.CommandType -eq 'Alias') {
    $info = $info.ResolvedCommand
  }
  if ($info.HelpUri) {
    Start-Process $info.HelpUri
  }
}
Set-PSReadLineKeyHandler -Chord Ctrl+t -Description 'Fzf select relative files to insert' -ScriptBlock {
  # note: expects "`n" not in path
  $items = fzf '--walker=file,hidden' -m
  if (!$items) {
    return
  }
  [Microsoft.PowerShell.PSConsoleReadLine]::Insert($items.ForEach{
      "'$([System.Management.Automation.Language.CodeGeneration]::EscapeSingleQuotedStringContent($_))'"
    } -join ' ')
}
Set-PSReadLineKeyHandler -Chord Alt+c -Description 'Fzf select sub directories to cd' -ScriptBlock {
  # note: expects "`n" not in path
  $dir = fzf '--walker=dir,hidden'
  if (!$dir) {
    return
  }
  Set-Location -LiteralPath $dir
  [Microsoft.PowerShell.PSConsoleReadLine]::InvokePrompt()
}
Set-PSReadLineKeyHandler -Chord Ctrl+r -Description 'Fzf select from history files to replace command line' -ScriptBlock {
  $history = switch ($true) {
    $IsWindows { "$env:APPDATA/Microsoft/Windows/PowerShell/PSReadLine/$($Host.Name)_history.txt"; break }
    $IsLinux { "$HOME/.local/share/powershell/PSReadLine/$($Host.Name)_history.txt"; break }
    default { throw [System.NotImplementedException]::new() }
  }
  $text = ''
  [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$text, [ref]$null)
  $history = Get-Content -AsByteStream -LiteralPath $history | fzf --tac --scheme=history -q `'$($text.Split(' ',2)[0])
  if (!$history) {
    return
  }
  [Microsoft.PowerShell.PSConsoleReadLine]::Replace(0, $text.Length, $history)
}
Set-PSReadLineKeyHandler -Chord Alt+z -Description 'Fzf select z paths to cd' -ScriptBlock {
  $dir = (Invoke-Z -List).Path | fzf --scheme=path
  if (!$dir) {
    return
  }
  Set-Location -LiteralPath $dir
  [Microsoft.PowerShell.PSConsoleReadLine]::InvokePrompt()
}
Set-PSReadLineKeyHandler -Chord Alt+s -Description 'Add sudo to command line and accept it' -ScriptBlock {
  [System.Management.Automation.Language.Ast]$ast = $null
  [System.Management.Automation.Language.Token[]]$tokens = $null
  [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$ast, [ref]$tokens, [ref]$null, [ref]$null)
  $text = $ast.ToString()
  if (@($tokens.Where{ $_.TokenFlags -eq 'CommandName' }).Count -eq 1) {
    [Microsoft.PowerShell.PSConsoleReadLine]::Replace(0, $text.Length, "sudo $text")
  }
  else {
    [Microsoft.PowerShell.PSConsoleReadLine]::Replace(0, $text.Length, "sudo {$text}")
  }
  [Microsoft.PowerShell.PSConsoleReadLine]::AcceptLine()
}
Set-PSReadLineKeyHandler -Chord Alt+v -Description 'Toggle .venv environment' -ScriptBlock {
  $pythonVenvActivate = Test-Path -LiteralPath .venv/
  if (Test-Path -LiteralPath Function:\deactivate) {
    if ([System.IO.Path]::Join($ExecutionContext.SessionState.Path.CurrentFileSystemLocation, '.venv') -eq $env:VIRTUAL_ENV) {
      $pythonVenvActivate = $false
    }
    else {
      $pythonVenvDeactivate = $true
    }
  }
  switch ($true) {
    $pythonVenvDeactivate {
      deactivate
      [Microsoft.PowerShell.PSConsoleReadLine]::InvokePrompt()
    }
    $pythonVenvActivate {
      if ($IsWindows) {
        . .venv/Scripts/Activate.ps1
      }
      else {
        . .venv/bin/activate.ps1
      }
      [Microsoft.PowerShell.PSConsoleReadLine]::InvokePrompt()
    }
  }
}
Set-PSReadLineKeyHandler -Chord Alt+e -Description 'Eval command line and replace it, except empty results' -ScriptBlock {
  $text = ''
  [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$text, [ref]$null)
  [string]$result = Invoke-Expression $text
  if ([string]::IsNullOrWhiteSpace($result)) {
    return
  }
  [Microsoft.PowerShell.PSConsoleReadLine]::Replace(0, $text.Length, $result)
}
