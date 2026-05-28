[CmdletBinding(DefaultParameterSetName = 'Path')]
param (
  [Parameter()]
  [switch]
  $Install,
  [Parameter()]
  [switch]
  $Uninstall,
  [Parameter()]
  [switch]
  $Gpg,
  [Parameter(Position = 0, ParameterSetName = 'Path')]
  [SupportsWildcards()]
  [string[]]
  $Path,
  [Parameter(Position = 0, ParameterSetName = 'LiteralPath')]
  [Alias('LP')]
  [string[]]
  $LiteralPath
)

$root = [System.IO.Path]::GetDirectoryName($PSScriptRoot)
$dotRoot = [System.IO.Path]::Join($root, '_', $(switch ($true) {
      $IsMacOS { 'macos'; break }
      $IsWindows { 'windows'; break }
      default { 'linux'; break }
    }))
if ($Gpg) {
  [string[]]$gpgLines = Get-Region gpg $root/.gitattributes
}
if ($Path) {
  $LiteralPath = Convert-Path $Path
}

if ($Install) {
  $LiteralPath.ForEach{
    $target = $_.Replace($HOME, $dotRoot)
    if ($target.Length -eq $_.Length) {
      return Write-Warning "$_ is not a relative path to HOME, skip"
    }
    $content = Get-Content -LiteralPath $_ -Raw -Force
    Remove-Item -LiteralPath $target -Force -ea Ignore
    New-Item $target -Value $content -Force
    New-Item -ItemType SymbolicLink -Force -Target $target $_
    if ($Gpg) {
      $gpgLines += $target.Substring($root.Length).Replace('\', '/') + ' diff=gpg filter=gpg'
    }
  }
  if ($Gpg) {
    $gpgLines = $gpgLines | Sort-Object -Unique
    Set-Region gpg $gpgLines $root/.gitattributes
  }
}
elseif ($Uninstall) {
  $pathSet = [System.Collections.Generic.HashSet[string]]::new($LiteralPath.Length)
  $LiteralPath.ForEach{
    $target = $_.Replace($HOME, $dotRoot)
    if ($target.Length -eq $_.Length) {
      return Write-Warning "$_ is not a relative path to HOME, skip"
    }
    $content = Get-Content -LiteralPath $target -Raw -Force -ea Ignore
    Remove-Item -LiteralPath $_, $target -Force -ea Ignore
    $content > $_
    if ($Gpg) {
      $null = $pathSet.Add($target.Substring($root.Length).Replace('\', '/') + ' diff=gpg filter=gpg')
    }
  }
  if ($Gpg) {
    $gpgLines = $gpgLines.Where{ !$pathSet.Contains($_) }
    Set-Region gpg $gpgLines $root/.gitattributes
  }
}
else {
  fd -HIa -tf -tl --base-directory=$dotRoot | ForEach-Object {
    $file = $_.Replace($dotRoot, $HOME)
    $target = (Get-Item -LiteralPath $_ -Force).ResolvedTarget
    if ($null -eq $target) {
      throw "Failed to resolve target for $_"
    }
    if ((Get-Item -LiteralPath $file -Force -ea Ignore).Target -cne $target) {
      New-Item -ItemType SymbolicLink -Force -Target $target $file
    }
  }
}
