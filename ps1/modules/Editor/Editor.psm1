function e.i {
  [CmdletBinding()]
  param (
    [Parameter(Mandatory, Position = 0, ValueFromPipeline)]
    [string]
    $Value
  )
  $psEditor.GetEditorContext().CurrentFile.InsertText($Value)
}

function e.info {
  [CmdletBinding()]
  param (
    [Parameter(Mandatory, Position = 0, ValueFromPipeline)]
    [string]
    $Value
  )
  $psEditor.Window.ShowInformationMessage($Value)
}

function e.warn {
  [CmdletBinding()]
  param (
    [Parameter(Mandatory, Position = 0, ValueFromPipeline)]
    [string]
    $Value
  )
  $psEditor.Window.ShowWarningMessage($Value)
}

function e.err {
  [CmdletBinding()]
  param (
    [Parameter(Mandatory, Position = 0, ValueFromPipeline)]
    [string]
    $Value
  )
  $psEditor.Window.ShowErrorMessage($Value)
}

function e.msg {
  [CmdletBinding()]
  param (
    [Parameter(Mandatory, Position = 0, ValueFromPipeline)]
    [string]
    $Value
  )
  $psEditor.Window.SetStatusBarMessage($Value)
}

enum SurroundPair {
  Backtick
  Brace
  Bracket
  Chevron
  Double
  Parenthese
  Single
}

function e.sur {
  [CmdletBinding(DefaultParameterSetName = 'Add')]
  param (
    [Parameter(Mandatory, Position = 0)]
    [SurroundPair]
    $Pair,
    [Parameter(Mandatory, ParameterSetName = 'Delete')]
    [switch]
    $Delete,
    [Parameter(Mandatory, Position = 1, ParameterSetName = 'Change')]
    [SurroundPair]
    $Change
  )
  $strPair = switch ($Pair) {
    Backtick { '`', '`'; break }
    Brace { '{', '}'; break }
    Bracket { '[', ']'; break }
    Chevron { '<', '>' ; break }
    Double { '"', '"'; break }
    Parenthese { '(', ')'; break }
    Single { "'", "'"; break }
  }
  $context = $psEditor.GetEditorContext()
  $text = $context.CurrentFile.GetText($context.SelectedRange)
  switch -CaseSensitive ($PSCmdlet.ParameterSetName) {
    'Add' {
      $context.CurrentFile.InsertText($strPair[1], $context.SelectedRange.End)
      $context.CurrentFile.InsertText($strPair[0], $context.SelectedRange.Start)
      break
    }
    'Delete' {
      break
    }
    'Change' {
      break
    }
  }
}
