# editing
Set-PSReadLineOption -EditMode Windows
Set-PSReadLineKeyHandler -Chord Alt+d -Function ForwardDeleteInput
Set-PSReadLineKeyHandler -Chord Ctrl+d -Function DeleteCharOrExit
Set-PSReadLineKeyHandler -Chord Ctrl+Delete -Function DeleteEndOfWord
Set-PSReadLineKeyHandler -Chord Ctrl+e -Function ViEditVisually
Set-PSReadLineKeyHandler -Chord Ctrl+f -Function ForwardWord
Set-PSReadLineKeyHandler -Chord Ctrl+u -Function DeleteLineToFirstChar
Set-PSReadLineKeyHandler -Chord Ctrl+Z -Function Redo
# custom
Set-PSReadLineKeyHandler -Chord Ctrl+o -Description 'Comment inputs and accept' -ScriptBlock {
  [string]$text = $null
  [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$text, [ref]$null)
  [Microsoft.PowerShell.PSConsoleReadLine]::Replace(0, $text.Length, ($text.Split("`n").ForEach{ "# $_" } -join "`n"))
  [Microsoft.PowerShell.PSConsoleReadLine]::AcceptLine()
}
Set-PSReadLineKeyHandler -Chord F1 -Description 'Show powershell command help' -ScriptBlock {
  [int]$cursor = 0
  [System.Management.Automation.Language.Token[]]$tokens = $null
  [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$null, [ref]$tokens, [ref]$null, [ref]$cursor)
  $name = $tokens.Where{ $_.TokenFlags -eq 'CommandName' -and $_.Extent.StartOffset -le $cursor }[-1].Text
  $info = Get-Command $name -ea Ignore
  if ($info.CommandType -eq 'Alias') {
    $info = $info.ResolvedCommand
  }
  [Microsoft.PowerShell.PSConsoleReadLine]::Replace(0, 0, "vw $($info.Name) # ")
  [Microsoft.PowerShell.PSConsoleReadLine]::AcceptLine()
}
Set-PSReadLineKeyHandler -Chord Ctrl+F1 -Description 'Try to open powershell docs in browser about the command' -ScriptBlock {
  [int]$cursor = 0
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
  $items = @(fzf '--walker=file,hidden' -m)
  if ($items) {
    [Microsoft.PowerShell.PSConsoleReadLine]::Insert($items.ForEach{ "'$_'" } -join ' ')
  }
}
Set-PSReadLineKeyHandler -Chord Alt+c -Description 'Fzf select sub directories to cd' -ScriptBlock {
  $dir = fzf '--walker=dir,hidden'
  if (!$dir) {
    return
  }
  Set-Location -LiteralPath $dir
  [Microsoft.PowerShell.PSConsoleReadLine]::InvokePrompt()
}
Set-PSReadLineKeyHandler -Chord Ctrl+r -Description 'Fzf select from history files to replace command line' -ScriptBlock {
  $history = switch ($true) {
    $IsWindows { "${env:APPDATA}/Microsoft/Windows/PowerShell/PSReadLine/$($Host.Name)_history.txt"; break }
    $IsLinux { "${env:HOME}/.local/share/powershell/PSReadLine/$($Host.Name)_history.txt"; break }
    default { throw 'not implemented' }
  }
  $history = Get-Content -Raw $history | fzf --tac --scheme=history
  if (!$history) {
    return
  }
  $line = ''
  [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$line, [ref]$null)
  [Microsoft.PowerShell.PSConsoleReadLine]::Replace(0, $line.Length, $history)
}
Set-PSReadLineKeyHandler -Chord Alt+z -Description 'Fzf select z paths to cd' -ScriptBlock {
  $path = (Invoke-Z -List).Path | fzf --scheme=path
  if ($LASTEXITCODE -eq 0) {
    Set-Location -LiteralPath $path
    [Microsoft.PowerShell.PSConsoleReadLine]::InvokePrompt()
  }
}
Set-PSReadLineKeyHandler -Chord Alt+s -Description 'Add sudo to command line and accept it' -ScriptBlock {
  [System.Management.Automation.Language.Ast]$ast = $null
  [System.Management.Automation.Language.Token[]]$tokens = $null
  [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$ast, [ref]$tokens, [ref]$null, [ref]$null)
  $line = $ast.ToString()
  if (($tokens.Where{ $_.TokenFlags -eq 'CommandName' }).Count -eq 1) {
    [Microsoft.PowerShell.PSConsoleReadLine]::Replace(0, $line.Length, "sudo $line")
  }
  else {
    [Microsoft.PowerShell.PSConsoleReadLine]::Replace(0, $line.Length, "sudo {$line}")
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
        . .venv/bin/Activate.ps1
      }
      [Microsoft.PowerShell.PSConsoleReadLine]::InvokePrompt()
    }
  }
}
Set-PSReadLineKeyHandler -Chord Alt+e -Description 'Eval command line and replace it, except empty results' -ScriptBlock {
  $line = ''
  [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$line, [ref]$null)
  [string]$result = Invoke-Expression $line
  if ([string]::IsNullOrWhiteSpace($result)) {
    return
  }
  [Microsoft.PowerShell.PSConsoleReadLine]::Replace(0, $line.Length, $result)
}
