[CmdletBinding(DefaultParameterSetName = 'Path')]
[Alias('icf')]
[OutputType([string[]])]
param (
  [Parameter(Mandatory, Position = 0, ParameterSetName = 'Path')]
  [ValidateNotNullOrEmpty()]
  [SupportsWildcards()]
  [string[]]
  $Path,
  [Parameter(Mandatory, ParameterSetName = 'LiteralPath')]
  [Alias('LP')]
  [ValidateNotNullOrEmpty()]
  [string[]]
  $LiteralPath,
  [Parameter(Mandatory, Position = 0, ParameterSetName = 'Stdin')]
  [ValidateNotNullOrEmpty()]
  [string]
  $FileName,
  [Parameter(ParameterSetName = 'Path')]
  [Parameter(ParameterSetName = 'LiteralPath')]
  [switch]
  $Inplace,
  [Parameter()]
  [switch]
  $Force,
  [Parameter(Mandatory, ValueFromPipeline, ParameterSetName = 'Stdin')]
  [System.Object]
  $InputObject
)

function Get-ParserName ([string]$Path) {
  switch -CaseSensitive -Regex ([System.IO.Path]::GetExtension($Path)) {
    '^\.(?:asciipb|c|c\+\+|cc|cp|cpp|cs|cxx|h|h\+\+|hh|hpp|hxx|inl|ipp|java|m|mm|proto|protodevel|sv|svh|td|textpb|textproto|txtpb|v|vh)$' { 'clang-format'; break }
    '^\.(?:cs|fs|xml)$' { 'csharpier'; break }
    '^\.(?:dart)$' { 'dart'; break }
    '^\.(?:go)$' { 'goimports'; break }
    '^\.(?:js|cjs|mjs|jsx|tsx|ts|cts|mts|json|jsonc|json5|yml|yaml|htm|html|xhtml|shtml|vue|gql|graphql|css|scss|sass|less|hbs|handlebars|md|markdown|toml)$' { 'oxfmt'; break }
    '^\.(?:ps1|psd1|psm1)$' { 'PSScriptAnalyzer'; break }
    '^\.(?:py|pyi|pyw|pyx|pxd|gyp|gypi|ipynb)$' { 'ruff'; break }
    '^\.(?:rs)$' { 'rustfmt'; break }
    '^\.(?:sh|bash|zsh|ash)$' { 'shfmt'; break }
    '^\.(?:lua)$' { 'stylua'; break }
    '^\.(?:zig)$' { 'zig'; break }
    default { 'none'; break }
  }
}

function Get-Parser ([string]$Name, [switch]$Inplace, [switch]$Stdin) {
  switch -CaseSensitive ($Name) {
    'clang-format' {
      if ($Inplace) {
        { clang-format -i --style=LLVM `-- $args }
      }
      elseif ($Stdin) {
        { $input | clang-format --style=LLVM --assume-filename=$args }
      }
      else {
        { clang-format --style=LLVM `-- $args }
      }
      break
    }
    'csharpier' {
      if ($Inplace) {
        { csharpier format --ignore-path= `-- $args }
      }
      elseif ($Stdin) {
        { $input | csharpier format --ignore-path= --stdin-path=$args }
      }
      else {
        { csharpier format --ignore-path= --write-stdout `-- $args }
      }
      break
    }
    'dart' {
      if ($Inplace) {
        { dart format `-- $args }
      }
      elseif ($Stdin) {
        { $input | dart format }
      }
      else {
        { dart format -o show --show none --summary none `-- $args }
      }
      break
    }
    'goimports' {
      if ($Inplace) {
        { goimports -w `-- $args }
      }
      elseif ($Stdin) {
        { $input | goimports }
      }
      else {
        { goimports `-- $args }
      }
      break
    }
    'oxfmt' {
      $ags = ($Force -or !$Inplace) ? '--ignore-path=', '--with-node-modules' : @()
      if ($Inplace) {
        { try { oxfmt --write $ags `-- $args } catch { return } }
      }
      elseif ($Stdin) {
        { $input | oxfmt $ags --stdin-filepath=$args }
      }
      else {
        { oxfmt $ags `-- $args }
      }
      break
    }
    'PSScriptAnalyzer' {
      if ($Inplace) {
        { $args.ForEach{
            $text = Get-Content -Raw -LiteralPath $_
            PSScriptAnalyzer\Invoke-Formatter $text -Settings $env:WISH_ROOT/CodeFormatting.psd1 | Out-File -LiteralPath $_ -NoNewline
          } }
      }
      elseif ($Stdin) {
        { PSScriptAnalyzer\Invoke-Formatter (@($input) -join "`n") -Settings $env:WISH_ROOT/CodeFormatting.psd1 }
      }
      else {
        { Get-Content -Raw -LiteralPath $args | ForEach-Object { PSScriptAnalyzer\Invoke-Formatter $_ -Settings $env:WISH_ROOT/CodeFormatting.psd1 } }
      }
      break
    }
    'ruff' {
      if ($Inplace) {
        { ruff format -n `-- $args }
      }
      elseif ($Stdin) {
        { $input | ruff format -n --stdin-filename $args }
      }
      else {
        { $args.ForEach{ Get-Content -Raw -LiteralPath $_ | ruff format -n --stdin-filename $_ } }
      }
      break
    }
    'rustfmt' {
      if ($Inplace) {
        { rustfmt `-- $args }
      }
      elseif ($Stdin) {
        { $input | rustfmt --emit stdout }
      }
      else {
        { rustfmt --emit stdout `-- $args }
      }
      break
    }
    'shfmt' {
      if ($Inplace) {
        $ags = @(if ($Force) { '--apply-ignore' })
        { shfmt -i 2 -bn -ci -sr -s -w $ags `-- $args }
      }
      elseif ($Stdin) {
        { $input | shfmt -i 2 -bn -ci -sr -s --filename $args }
      }
      else {
        { shfmt -i 2 -bn -ci -sr -s `-- $args }
      }
      break
    }
    'stylua' {
      if ($Inplace) {
        { stylua `-- $args }
      }
      elseif ($Stdin) {
        { $input | stylua }
      }
      else {
        { $args.ForEach{ Get-Content -Raw -LiteralPath $_ | stylua } }
      }
      break
    }
    'zig' {
      if ($Inplace) {
        { zig fmt $args }
      }
      elseif ($Stdin) {
        { $input | zig fmt --stdin }
      }
      else {
        { $args.ForEach{ Get-Content -Raw -LiteralPath $_ | zig fmt --stdin } }
      }
      break
    }
    default {
      if ($Inplace) {
        {}
      }
      elseif ($Stdin) {
        { $input }
      }
      else {
        { Get-Content -Raw -LiteralPath $args }
      }
      break
    }
  }
}

if ($MyInvocation.ExpectingInput) {
  if ($MyInvocation.PipelinePosition -lt $MyInvocation.PipelineLength) {
    return $input | & Get-Parser (Get-ParserName $FileName -Stdin)
  }
  return $input | & Get-Parser (Get-ParserName $FileName -Stdin) | bat -p --file-name=$FileName
}
if ($Path) {
  $LiteralPath = Convert-Path $Path -Force
}
[System.Collections.Generic.Dictionary[string, string[]]]$fileMap = @{}
$LiteralPath.ForEach{ $fileMap[(Get-ParserName $_)] += $_ }
if ($Inplace) {
  return $fileMap.GetEnumerator().ForEach{
    $files = $_.Value
    & (Get-Parser $_.Key -Inplace) @files
  }
}
if ($MyInvocation.PipelinePosition -lt $MyInvocation.PipelineLength) {
  return $fileMap.GetEnumerator().ForEach{
    $files = $_.Value
    & (Get-Parser $_.Key) @files
  }
}
$fileMap.GetEnumerator().ForEach{
  $files = $_.Value
  & (Get-Parser $_.Key) @files
} | bat -p --file-name $LiteralPath[0]
