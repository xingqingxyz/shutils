$_completionLoadSet = [System.Collections.Generic.HashSet[string]]::new([string[]](Get-ChildItem $PSScriptRoot/completions).BaseName)

function TabExpansion2 {
  <# Options include:
     RelativeFilePaths - [bool]
         Always resolve file paths using Resolve-Path -Relative.
         The default is to use some heuristics to guess if relative or absolute is better.

   To customize your own custom options, pass a hashtable to CompleteInput, e.g.
         return [System.Management.Automation.CommandCompletion]::CompleteInput($inputScript, $cursorColumn,
             @{ RelativeFilePaths=$false }
  #>

  [CmdletBinding(DefaultParameterSetName = 'ScriptInputSet')]
  [OutputType([System.Management.Automation.CommandCompletion])]
  Param(
    [Parameter(ParameterSetName = 'ScriptInputSet', Mandatory = $true, Position = 0)]
    [AllowEmptyString()]
    [string] $inputScript,

    [Parameter(ParameterSetName = 'ScriptInputSet', Position = 1)]
    [int] $cursorColumn = $inputScript.Length,

    [Parameter(ParameterSetName = 'AstInputSet', Mandatory = $true, Position = 0)]
    [System.Management.Automation.Language.Ast] $ast,

    [Parameter(ParameterSetName = 'AstInputSet', Mandatory = $true, Position = 1)]
    [System.Management.Automation.Language.Token[]] $tokens,

    [Parameter(ParameterSetName = 'AstInputSet', Mandatory = $true, Position = 2)]
    [System.Management.Automation.Language.IScriptPosition] $positionOfCursor,

    [Parameter(ParameterSetName = 'ScriptInputSet', Position = 2)]
    [Parameter(ParameterSetName = 'AstInputSet', Position = 3)]
    [Hashtable] $options = $null
  )

  End {
    if ($PSCmdlet.ParameterSetName -eq 'ScriptInputSet') {
      $tuple = [System.Management.Automation.CommandCompletion]::MapStringInputToParsedInput($inputScript, $cursorColumn)
      $ast, $tokens, $positionOfCursor = $tuple.Item1, $tuple.Item2, $tuple.Item3
    }
    $commandAst = $ast.EndBlock.Find({ param($ast) $ast -is [System.Management.Automation.Language.CommandAst] }, $false)
    if ($commandAst) {
      $commandName = Split-Path -LeafBase $commandAst.GetCommandName()
      if ($_completionLoadSet.Contains($commandName)) {
        . $PSScriptRoot/completions/$commandName.ps1
        $_completionLoadSet.Remove($commandName)
      }
    }
    try {
      return [System.Management.Automation.CommandCompletion]::CompleteInput(
        <#ast#>              $ast,
        <#tokens#>           $tokens,
        <#positionOfCursor#> $positionOfCursor,
        <#options#>          $options)
    }
    catch {}
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
