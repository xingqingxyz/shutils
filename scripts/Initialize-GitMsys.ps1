[CmdletBinding()]
param (
  [Parameter(Position = 0)]
  [Alias('LP')]
  [ValidateNotNullOrEmpty()]
  [string[]]
  $LiteralPath,
  [Parameter()]
  [switch]
  $All,
  [Parameter()]
  [switch]
  $Go
)

$ErrorActionPreference = 'Stop'

if ($All) {
  $LiteralPath += @(
    'C:\Program Files\Git\mingw64\bin\brotli.exe'
    'C:\Program Files\Git\mingw64\bin\bunzip2.exe'
    'C:\Program Files\Git\mingw64\bin\bzip2.exe'
    'C:\Program Files\Git\mingw64\bin\pdftotext.exe'
    'C:\Program Files\Git\mingw64\bin\tclsh.exe'
    'C:\Program Files\Git\mingw64\bin\unxz.exe'
    'C:\Program Files\Git\mingw64\bin\xz.exe'
    'C:\Program Files\Git\usr\bin\awk.exe'
    'C:\Program Files\Git\usr\bin\bash.exe'
    'C:\Program Files\Git\usr\bin\PSystem.IO.Path.exe'
    'C:\Program Files\Git\usr\bin\gpg.exe'
    'C:\Program Files\Git\usr\bin\grep.exe'
    'C:\Program Files\Git\usr\bin\gzip.exe'
    'C:\Program Files\Git\usr\bin\openssl.exe'
    'C:\Program Files\Git\usr\bin\perl.exe'
    'C:\Program Files\Git\usr\bin\printf.exe'
    'C:\Program Files\Git\usr\bin\sed.exe'
    'C:\Program Files\Git\usr\bin\sh.exe'
    'C:\Program Files\Git\usr\bin\ssp.exe'
    'C:\Program Files\Git\usr\bin\uname.exe'
  )
}

$LiteralPath.ForEach{
  if (![System.IO.Path]::IsPathFullyQualified($_)) {
    throw "Literalpath must be absolute: $_"
  }
}

$binDir = $IsWindows ? "$env:LOCALAPPDATA\prefix\bin" : "$HOME/.local/bin"
$buildDir = [System.IO.Path]::GetTempPath()

if ($Go) {
  return $LiteralPath | ForEach-Object -Parallel {
    go build -o $binDir\$$([System.IO.Path]::GetFileName($_)) -a -trimpath -ldflags "-s -w -X `"main.execPath=$_`"" 'github.com/xingqingxyz/wish/cmd/fork'
  } -ThrottleLimit ($env:NUMBER_OF_PROCESSORS ?? 8)
}

if (!$IsWindows) {
  throw [System.NotImplementedException]::new()
}

if (!(Get-Command cl -Type Application -TotalCount 1 -ea Ignore)) {
  Use-DevelopmentEnvironment VisualStudio
  # clang-format, clang-tidy
  if ($All -and ($info = Get-Command clang-format, clang-tidy -CommandType Application -TotalCount 1 -ea Ignore)) {
    $LiteralPath += $info.Source
  }
}

$LiteralPath | ForEach-Object -Parallel {
  $execPath = 'L"\"' + $_.Replace('\', '\\') + '\""'
  $base = [System.IO.Path]::GetFileNameWithoutExtension($_)
  [string[]]$favor = if ([System.Runtime.InteropServices.RuntimeInformation]::OSArchitecture -ceq 'X64') { '/favor:INTEL64' }
  cl /O1 /Oi /Os /GF /Gy /GL /GA /GS- $favor /std:c17 /utf-8 /nologo /DEXEC_PATH=$execPath /Fa$buildDir\$base /Fo$buildDir\$base /Fe$binDir\$base $PSScriptRoot\..\cmd\fork.c /MD /link /LTCG /OPT:REF /OPT:ICF /MERGE:.rdata=.text
} -ThrottleLimit ($env:NUMBER_OF_PROCESSORS ?? 8)
