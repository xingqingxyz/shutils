#Requires -Modules PowerShellEditorServices.Commands

function hello ([Microsoft.PowerShell.EditorServices.Extensions.EditorContext, Microsoft.PowerShell.EditorServices]$context) {
  $text = @(if ($IsLinux) {
      xclip -o -selection primary
    }
    else {
      (Get-Clipboard -Raw) -csplit '\r?\n'
    }).ForEach{ $_.Split(',').Trim() } | ConvertTo-Json -Compress
  $context.CurrentFile.InsertText($text.Substring(1, $text.Length - 2))
}

Register-EditorCommand -Name 'hello' -DisplayName 'Hello World' -Function hello
