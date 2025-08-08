#Requires -Modules PowerShellEditorServices

function hello {
  $text = Get-Clipboard | ForEach-Object { $_.Trim().Split(', ') } | ConvertTo-Json -Compress
  $psEditor.GetEditorContext().CurrentFile.InsertText($text.Substring(1, $text.Length - 2))
}

Register-EditorCommand -Name 'hello' -DisplayName 'Hello World' -Function hello
