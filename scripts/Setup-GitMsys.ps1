[CmdletBinding()]
param (
  [Parameter()]
  [switch]
  $All,
  [Parameter()]
  [switch]
  $Go,
  [Parameter(Position = 0)]
  [string[]]
  $Path
)

if ($All) {
  $Path += @(
    'C:\Program Files\Git\mingw64\bin\brotli.exe'
    'C:\Program Files\Git\mingw64\bin\bunzip2.exe'
    'C:\Program Files\Git\mingw64\bin\bzip2.exe'
    'C:\Program Files\Git\mingw64\bin\pdftotext.exe'
    'C:\Program Files\Git\mingw64\bin\tclsh.exe'
    'C:\Program Files\Git\mingw64\bin\unxz.exe'
    'C:\Program Files\Git\mingw64\bin\wish.exe'
    'C:\Program Files\Git\mingw64\bin\xz.exe'
    'C:\Program Files\Git\usr\bin\awk.exe'
    'C:\Program Files\Git\usr\bin\bash.exe'
    'C:\Program Files\Git\usr\bin\env.exe'
    'C:\Program Files\Git\usr\bin\file.exe'
    'C:\Program Files\Git\usr\bin\gpg.exe'
    'C:\Program Files\Git\usr\bin\grep.exe'
    'C:\Program Files\Git\usr\bin\gzip.exe'
    'C:\Program Files\Git\usr\bin\less.exe'
    'C:\Program Files\Git\usr\bin\mintty.exe'
    'C:\Program Files\Git\usr\bin\openssl.exe'
    'C:\Program Files\Git\usr\bin\perl.exe'
    'C:\Program Files\Git\usr\bin\printf.exe'
    'C:\Program Files\Git\usr\bin\sed.exe'
    'C:\Program Files\Git\usr\bin\sh.exe'
    'C:\Program Files\Git\usr\bin\ssp.exe'
    'C:\Program Files\Git\usr\bin\uname.exe'
    "$env:ANDROID_HOME\emulator\emulator.exe"
  )
}

$Path | ForEach-Object {
  if (![System.IO.Path]::IsPathFullyQualified($_)) {
    throw "path must be absolute: $_"
  }
}

if ($Go) {
  return $Path | ForEach-Object -Parallel {
    go build -o ~/tools/$([System.IO.Path]::GetFileName($_)) -a -trimpath -ldflags "-s -w -X `"main.execPath=$_`"" $env:SHUTILS_ROOT/fork/main.go
  } -ThrottleLimit $env:NUMBER_OF_PROCESSORS
}

$Path | ForEach-Object -Parallel {
  $execPath = 'L"\"' + $_.Replace('\', '\\') + '\""'
  $base = [System.IO.Path]::GetFileNameWithoutExtension($_)
  cl /O1 /Oi /Os /GF /Gy /GL /GA /GS- /Zl /favor:AMD64 /std:c17 /utf-8 /nologo /DEXEC_PATH=$execPath /Fa$env:TEMP\$base /Fo$env:TEMP\$base /Fe$HOME\tools\$base $env:SHUTILS_ROOT\fork\main.c /link /LTCG /OPT:REF /OPT:ICF /MERGE:.rdata=.text kernel32.lib msvcrt.lib
} -ThrottleLimit $env:NUMBER_OF_PROCESSORS
