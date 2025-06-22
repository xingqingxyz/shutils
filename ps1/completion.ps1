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
      $CommandName.ForEach{ $_completionFuncMap.Add($_, $ScriptBlock) }
    }
  }
}

function quote([string]$s) {
  if ($s.Length -le 1) {
    return "'$s'"
  }
  $s = switch ($s[0]) {
    "'" { $s; break }
    '"' { "'" + $s.Substring(1); break }
    Default { "'" + $s; break }
  }
  switch ($s[-1]) {
    "'" { $s; break }
    '"' { $s.Substring(0, $s.Length - 1) + "'"; break }
    Default { $s + "'"; break }
  }
}

function unquote([string]$s) {
  $s -replace "^['`"]|['`"]$", ''
}

$_completionFuncMap = @{}
Microsoft.PowerShell.Core\Register-ArgumentCompleter -CommandName (Get-ChildItem -LiteralPath $PSScriptRoot/completions).BaseName -Native -ScriptBlock {
  param([string]$wordToComplete, [System.Management.Automation.Language.CommandAst]$commandAst, [int]$cursorPosition)
  $commandName = Split-Path -LeafBase $commandAst.GetCommandName()
  if (!$_completionFuncMap.Contains($commandName)) {
    . $PSScriptRoot/completions/$commandName.ps1
    if (!$_completionFuncMap.Contains($commandName)) {
      return
    }
  }
  & $_completionFuncMap.$commandName @PSBoundParameters
}
