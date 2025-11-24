#Requires -Modules PowerShellEditorServices.Commands

Register-EditorCommand -Name 'hello' -DisplayName 'Hello World' -ScriptBlock {
  [CmdletBinding()]
  param (
    [Parameter()]
    [Microsoft.PowerShell.EditorServices.Extensions.EditorContext, Microsoft.PowerShell.EditorServices]
    $Context
  )
  $text = @(if ($IsLinux) {
      xclip -o -selection primary
    }
    else {
      (Get-Clipboard -Raw) -csplit '\r?\n'
    }).ForEach{ $_.Split(',').Trim() } | ConvertTo-Json -Compress
  $Context.CurrentFile.InsertText($text.Substring(1, $text.Length - 2))
}
