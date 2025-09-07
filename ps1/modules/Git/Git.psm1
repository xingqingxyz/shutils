function Repair-GitSymlinks {
  git ls-files -s | ForEach-Object {
    [int]$mode, $item = $_ -split '\s+', 4
    if ($mode -ne 120000) {
      return
    }
    $item = $item[2].TrimStart()
    try {
      $item = Get-Item -LiteralPath $item -Force -ea Stop
    }
    catch {
      return Write-Warning "staged symlink not found: $item"
    }
    if ($item.LinkType -ne 'SymbolicLink') {
      $target = Get-Content -LiteralPath $item -TotalCount 1
      Write-Information "$item -> $target"
      $null = New-Item -Force -ItemType SymbolicLink -Target $target $item
    }
  }
}

<#
.SYNOPSIS
Clear outdated modules.
 #>
function Clear-Module {
  [CmdletBinding(SupportsShouldProcess)]
  param (
    [Parameter(Mandatory, Position = 0, ValueFromPipeline)]
    $InputObject
  )
  begin {
    # use PSBoundParameters to forward -Confirm and -WhatIf
    $null = $PSBoundParameters.Remove('InputObject')
  }
  process {
    Get-InstalledModule $InputObject.Name -AllVersions |
      Where-Object Version -LT $InputObject.Version |
      ForEach-Object {
        Uninstall-Module $_.Name -MaximumVersion $_.Version @PSBoundParameters
      }
  }
}
