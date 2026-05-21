[CmdletBinding()]
param (
  [Parameter()]
  [switch]
  $Init,
  [Parameter()]
  [switch]
  $PreCommit,
  [Parameter()]
  [switch]
  $PostMerge,
  [Parameter()]
  [switch]
  $PostUpdate
)

$ErrorActionPreference = 'Stop'
$PSNativeCommandUseErrorActionPreference = $true
Push-Location -LiteralPath $PSScriptRoot
trap { Pop-Location }

if ($Init) {
  "pwsh -nop $($MyInvocation.MyCommand.Name) -PreCommit" > ./.git/hooks/pre-commit
  "pwsh -nop $($MyInvocation.MyCommand.Name) -PostMerge" > ./.git/hooks/post-update
  "pwsh -nop $($MyInvocation.MyCommand.Name) -PostUpdate" > ./.git/hooks/post-merge
  if (!$IsWindows) {
    chmod +x ./.git/hooks/pre-commit ./.git/hooks/post-update ./.git/hooks/post-merge
  }
  git submodule update --init --recursive --remote
  cargo build --release
  dotnet build -c Release
  go mod tidy
  pnpm self-update
  pnpm up -r --latest
  uv sync --upgrade
  $binDir = $IsWindows ? "$env:LOCALAPPDATA\prefix\bin" : "$HOME/.local/bin"
  $exe = go env GOEXE
  Split-Path -Resolve -Leaf cmd/* | ForEach-Object -Parallel {
    go build -trimpath -ldflags '-w -s' -o $Using:binDir/$($_.Name)$exe ./cmd/$_
  } -ThrottleLimit ($env:NUMBER_OF_PROCESSORS ?? 8)
  return
}
$PSStyle.OutputRendering = 'PlainText'
Write-Host "$PSCommandPath -$($PSBoundParameters.Keys)"
if ($PreCommit) {
  cargo check
  golangci-lint run
  $files = git diff --cached --name-only --diff-filter=ACMRT
  ./scripts/Invoke-CodeFormatter.ps1 -LiteralPath $files -Inplace
  git add $files
}
else {
  switch -CaseSensitive -Regex (git diff --name-only HEAD^..HEAD) {
    '^scripts/(Export-EnvrionmentVariables|Initialize-Dotfiles|Initialize-Tasks)\.ps1$' {
      Write-Host ". $_"
      . $_
      continue
    }
  }
  switch -CaseSensitive -Regex (git diff --name-only --diff-filter=AD HEAD^..HEAD) {
    '^scripts/tasks/.+$' {
      Write-Host '. ./scripts/Initialize-Tasks.ps1'
      . ./scripts/Initialize-Tasks.ps1
      continue
    }
  }
  if ($PostMerge) {
  }
  elseif ($PostUpdate) {
  }
  else {
    throw [System.NotImplementedException]::new()
  }
}
Pop-Location
