[CmdletBinding()]
param (
  [Parameter()]
  [switch]
  $All,
  [Parameter(Position = 0)]
  [string[]]
  $Path
)

if ($All) {
  $Path = @(
    'C:\Program Files\Git\mingw64\bin\brotli.exe'
    'C:\Program Files\Git\mingw64\bin\bunzip2.exe'
    'C:\Program Files\Git\mingw64\bin\bzip2.exe'
    'C:\Program Files\Git\mingw64\bin\pdftotext.exe'
    'C:\Program Files\Git\mingw64\bin\tclsh.exe'
    'C:\Program Files\Git\mingw64\bin\unxz.exe'
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

$Path | ForEach-Object -Parallel {
  go build -o ~/tools/$([System.IO.Path]::GetFileName($_)) -a -trimpath -ldflags "-s -w -X `"main.execPath=$_`"" $env:SHUTILS_ROOT/go/fork/main.go
} -ThrottleLimit $env:NUMBER_OF_PROCESSORS
