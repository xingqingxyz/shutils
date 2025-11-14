#Requires -Version 7.6

function Register-ArgumentCompleter {
  <#
  .FORWARDHELPTARGETNAME Register-ArgumentCompleter
  .FORWARDHELPCATEGORY Cmdlet
  #>
  [CmdletBinding()]
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
  }
  else {
    $CommandName.ForEach{ $_completionFuncMap[$_] = $ScriptBlock }
  }
  Microsoft.PowerShell.Core\Register-ArgumentCompleter @PSBoundParameters
}

function Get-ArgumentCompleter ([string]$CommandName) {
  if (!$_completionFuncMap.Contains($CommandName) -and
    (Test-Path -LiteralPath "$PSScriptRoot/completions/$CommandName.ps1")) {
    & $PSScriptRoot/completions/$CommandName.ps1
  }
  $_completionFuncMap[$CommandName] ?? {}
}

Set-Variable -Option ReadOnly -Force _completionFuncMap @{}
Microsoft.PowerShell.Core\Register-ArgumentCompleter -NativeFallback -ScriptBlock {
  param ([string]$wordToComplete, [System.Management.Automation.Language.CommandAst]$commandAst, [int]$cursorPosition)
  $commandName = Split-Path -LeafBase $commandAst.GetCommandName()
  & (Get-ArgumentCompleter $commandName) @PSBoundParameters
}
