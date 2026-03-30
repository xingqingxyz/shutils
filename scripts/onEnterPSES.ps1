#Requires -Modules PowerShellEditorServices.Commands

# preferences
$DebugPreference = 'Continue'
$ErrorActionPreference = 'Stop'
$VerbosePreference = 'Continue'

#region defs
function e.i {
  [CmdletBinding()]
  param (
    [Parameter(Mandatory, Position = 0, ValueFromPipeline)]
    [string]
    $Value
  )
  $psEditor.GetEditorContext().CurrentFile.InsertText($Value)
}
#endregion

# commands
Register-EditorCommand -Name 'hello' -DisplayName 'Hello World' -ScriptBlock {
  [CmdletBinding()]
  param (
    [Parameter()]
    [Microsoft.PowerShell.EditorServices.Extensions.EditorContext, Microsoft.PowerShell.EditorServices]
    $Context
  )
  $text = @(if ($IsLinux) {
      if ($env:XDG_SESSION_TYPE -ceq 'wayland') {
        wl-paste -p
      }
      else {
        xclip -o -selection primary
      }
    }
    else {
      (Get-Clipboard -Raw).Split("`n")
    }).Trim().Replace("'", "''") -join "', '"
  $Context.CurrentFile.InsertText("'$text'")
}
