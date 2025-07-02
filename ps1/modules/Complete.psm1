<#
.FORWARDHELPTARGETNAME Register-ArgumentCompleter
.FORWARDHELPCATEGORY Cmdlet
#>
function Register-ArgumentCompleter {
  [CmdletBinding()]
  [OutputType([scriptblock])]
  param(
    [Parameter()]
    [string[]]
    $CommandName,
    [Parameter(ParameterSetName = 'Native')]
    [switch]
    $Native,
    [Parameter(Mandatory, ParameterSetName = 'PS')]
    [string]
    $ParameterName,
    [Parameter(Mandatory)]
    [scriptblock]
    $ScriptBlock
  )
  end {
    if ($ParameterName) {
      Write-Debug "Reload PS command parameter completion: $CommandName -$ParameterName"
      Microsoft.PowerShell.Core\Register-ArgumentCompleter @PSBoundParameters
    }
    else {
      $CommandName.ForEach{ $completionFuncMap.$_ = $ScriptBlock }
    }
  }
}

function Get-ArgumentCompleter ([string]$CommandName) {
  if (!$completionFuncMap.Contains($CommandName)) {
    try {
      . ${env:SHUTILS_ROOT}/ps1/completions/$CommandName.ps1
    }
    catch { }
  }
  $completionFuncMap.$CommandName ?? {}
}

$completionFuncMap = @{}
Microsoft.PowerShell.Core\Register-ArgumentCompleter -CommandName (Get-ChildItem -LiteralPath ${env:SHUTILS_ROOT}/ps1/completions).BaseName -Native -ScriptBlock {
  param([string]$wordToComplete, [System.Management.Automation.Language.CommandAst]$commandAst, [int]$cursorPosition)
  $commandName = Split-Path -LeafBase $commandAst.GetCommandName()
  & (Get-ArgumentCompleter $commandName) @PSBoundParameters
}
