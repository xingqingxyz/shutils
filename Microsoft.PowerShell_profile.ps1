# utf-8 process
[System.Console]::OutputEncoding = [System.Text.Encoding]::UTF8
# shutils
Get-Item $PSScriptRoot/ps1/*.ps1 -ErrorAction Ignore | ForEach-Object { . $_.FullName }
# editing
Set-PSReadLineOption -EditMode Windows
Set-PSReadLineKeyHandler -Chord Ctrl+u -Function DeleteLineToFirstChar
Set-PSReadLineKeyHandler -Chord Ctrl+k -Function ForwardDeleteLine
Set-PSReadLineKeyHandler -Chord Ctrl+K -Function DeleteLine
Set-PSReadLineKeyHandler -Chord Ctrl+Z -Function Redo
Set-PSReadLineKeyHandler -Chord Ctrl+e -Function ViEditVisually
Set-PSReadLineKeyHandler -Chord Ctrl+f -Function ForwardWord
Set-PSReadLineKeyHandler -Chord Ctrl+d -Function DeleteCharOrExit
Set-PSReadLineKeyHandler -Chord Ctrl+S -Function CaptureScreen
Set-PSReadLineKeyHandler -Chord Ctrl+n -Function NextSuggestion
Set-PSReadLineKeyHandler -Chord Ctrl+p -Function PreviousSuggestion
Set-PSReadLineKeyHandler -Chord Ctrl+F1 -ScriptBlock {
  [int]$cursor = 0
  [System.Management.Automation.Language.Token[]]$tokens = $null
  [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$null, [ref]$tokens, [ref]$null, [ref]$cursor)
  $name = $tokens.Where{ $_.TokenFlags -eq 'CommandName' -and $_.Extent.StartOffset -le $cursor }[-1].Text
  Get-Help -Online $name
}
Set-PSReadLineKeyHandler -Chord Ctrl+t -ScriptBlock {
  $items = fzf '--walker=file,hidden' -m
  if ($items) {
    [Microsoft.PowerShell.PSConsoleReadLine]::Insert("'$($items -join "' '")'")
  }
}
Set-PSReadLineKeyHandler -Chord Alt+c -ScriptBlock {
  $dir = fzf '--walker=dir,hidden'
  if (!$dir) {
    return
  }
  Set-Location $dir
  [Microsoft.PowerShell.PSConsoleReadLine]::InvokePrompt()
}
Set-PSReadLineKeyHandler -Chord Ctrl+r -ScriptBlock {
  $history = if ($IsWindows) { "${env:APPDATA}/Microsoft/Windows/PowerShell/PSReadLine/$($Host.Name)_history.txt" } elseif ($IsLinux) { "${env:HOME}/.local/share/pwsh/PSReadLine/$($Host.Name)_history.txt" }
  elseif ($IsMacOS) { throw 'not implemented' }
  $history = Get-Content $history | Select-Object -Unique | fzf --scheme=history
  if (!$history) {
    return
  }
  $line = ''
  [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$line, [ref]$null)
  [Microsoft.PowerShell.PSConsoleReadLine]::Replace(0, $line.Length, $history)
}
Set-PSReadLineKeyHandler -Chord Alt+z -ScriptBlock {
  $path = $_zItemsMap.Keys | fzf --scheme=path
  if ($LASTEXITCODE -eq 0) {
    Set-Location $path
    [Microsoft.PowerShell.PSConsoleReadLine]::InvokePrompt()
  }
}
if (!$IsWindows) {
  Set-Alias ls Get-ChildItem
}
