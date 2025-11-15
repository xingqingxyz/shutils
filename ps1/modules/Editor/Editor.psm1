function e.i {
  [CmdletBinding()]
  param (
    [Parameter(Mandatory, Position = 0)]
    [string]
    $Value
  )
  $psEditor.GetEditorContext().CurrentFile.InsertText($Value)
}

function e.info {
  [CmdletBinding()]
  param (
    [Parameter(Mandatory, Position = 0)]
    [string]
    $Value
  )
  $psEditor.Window.ShowInformationMessage($Value)
}

function e.warn {
  [CmdletBinding()]
  param (
    [Parameter(Mandatory, Position = 0)]
    [string]
    $Value
  )
  $psEditor.Window.ShowWarningMessage($Value)
}

function e.err {
  [CmdletBinding()]
  param (
    [Parameter(Mandatory, Position = 0)]
    [string]
    $Value
  )
  $psEditor.Window.ShowErrorMessage($Value)
}

function e.msg {
  [CmdletBinding()]
  param (
    [Parameter(Mandatory, Position = 0)]
    [string]
    $Value
  )
  $psEditor.Window.SetStatusBarMessage($Value)
}
