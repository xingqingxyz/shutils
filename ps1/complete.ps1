<#
.FORWARDHELPTARGETNAME Register-ArgumentCompleter
.FORWARDHELPCATEGORY Cmdlet
#>
function Register-ArgumentCompleter {
  [CmdletBinding()]
  [OutputType([scriptblock])]
  param (
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
  if ($ParameterName) {
    Write-Debug "Reload PS command parameter completion: $CommandName -$ParameterName"
    Microsoft.PowerShell.Core\Register-ArgumentCompleter @PSBoundParameters
  }
  else {
    $CommandName.ForEach{ $_completionFuncMap.$_ = $ScriptBlock }
    $ScriptBlock
  }
}

function Get-ArgumentCompleter ([string]$CommandName) {
  $_completionFuncMap.$CommandName ?? $(if (Test-Path -LiteralPath "$PSScriptRoot/completions/$CommandName.ps1") {
      . $PSScriptRoot/completions/$CommandName.ps1
    }
    else {
      {}
    })
}

Set-Variable -Option ReadOnly -Force _completionFuncMap @{}
Microsoft.PowerShell.Core\Register-ArgumentCompleter -CommandName (Get-ChildItem -LiteralPath $PSScriptRoot/completions).BaseName -Native -ScriptBlock {
  param ([string]$wordToComplete, [System.Management.Automation.Language.CommandAst]$commandAst, [int]$cursorPosition)
  $commandName = Split-Path -LeafBase $commandAst.GetCommandName()
  & (Get-ArgumentCompleter $commandName) @PSBoundParameters
}
