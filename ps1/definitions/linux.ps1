Set-PSReadLineKeyHandler -Chord Alt+s -ScriptBlock {
  $line = ''
  [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$line, [ref]$null)
  [Microsoft.PowerShell.PSConsoleReadLine]::Replace(0, $line.Length, "sudo $line")
}
Set-Alias ls Get-ChildItem
