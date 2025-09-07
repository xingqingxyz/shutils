using namespace System.Runtime.InteropServices

$ErrorActionPreference = 'Stop'
$PSNativeCommandUseErrorActionPreference = $true

function goenv {
  if (Get-Command go -Type Application -ea Ignore) {
    $os, $arch = go env GOOS GOARCH
    return [pscustomobject]@{
      os   = $os
      arch = $arch
    }
  }
  $os = switch ($true) {
    $IsWindows { 'windows'; break }
    $IsMacOS { 'darwin'; break }
    $IsLinux {
      if ([RuntimeInformation]::IsOSPlatform([OSPlatform]::FreeBSD)) {
        'freebsd'
        break
      }
      switch (uname -o) {
        'Android' { 'android'; break }
        'GNU/Linux' { 'linux'; break }
        default { $_; break }
      }
      break
    }
  }
  $arch = switch ([string][RuntimeInformation]::OSArchitecture) {
    'X64' { 'amd64'; break }
    'Arm64' { 'arm64'; break }
    'Arm' { 'armv7'; break }
    'LoongArch64' { 'loong64'; break }
    default { throw "not implemented arch $_" }
  }
  [pscustomobject]@{
    os   = $os
    arch = $arch
  }
}

function rustenv {
  $arch = switch ([string][RuntimeInformation]::OSArchitecture) {
    'X64' { 'x86_64'; break }
    'Arm64' { 'aarch64'; break }
    'Arm' { 'armv7'; break }
    'LoongArch64' { 'loongarch64'; break }
    default {
      if ($IsWindows) {
        & 'C:\Program Files\Git\usr\bin\uname.exe' -m
      }
      else {
        uname -m
      }
      break
    }
  }
  $platform = switch ($true) {
    $IsWindows { 'pc'; break }
    $IsLinux { 'unknown'; break }
    $IsMacOS { break }
    default { throw 'unknown platform' }
  }
  $os = switch ($true) {
    $IsWindows { 'windows'; break }
    $IsMacOS { 'darwin'; break }
    $IsLinux {
      if ([RuntimeInformation]::IsOSPlatform([OSPlatform]::FreeBSD)) {
        'freebsd'
        break
      }
      switch (uname -o) {
        'Android' { $platform = 'linux'; 'android'; break }
        'GNU/Linux' { 'linux'; break }
        default { $_; break }
      }
      break
    }
  }
  $clib = switch ($true) {
    $IsWindows { 'msvc'; break }
    $IsLinux { 'gnu'; break }
    $IsMacOS { break }
    ([RuntimeInformation]::IsOSPlatform([OSPlatform]::FreeBSD)) { 'musl'; break }
    default { 'unknown clib'; break }
  }
  $target = if (Get-Command rustc -Type Application -ea Ignore) {
    (rustc -vV | Select-String -Raw host:).Split(' ', 2)[1]
  }
  else {
    @(
      $arch
      $platform
      $os
      $clib
    ) -join '-'
  }
  [pscustomobject]@{
    arch       = $arch
    platform   = $platform
    os         = $os
    clib       = $clib
    osWithClib = @($os; $clib) -join '-'
    target     = $target
  }
}

function execute {
  $cmd, $ags = $args
  Write-Debug "$args"
  & $cmd $ags
}

function New-EmptyDir ([string]$Path) {
  Remove-Item -Recurse -Force $Path
  $null = New-Item -ItemType Directory -Force $Path
}

function updateLocalVersion ($Meta) {
  $Meta.localVersion = try {
    switch ($Meta.name) {
      fzf { (fzf --version).Split(' ', 2)[0]; break }
      pastel { (pastel -V).Split(' ', 3)[1]; break }
      default { (& $_ --version).Split(' ')[-1] -replace '^v', ''; break }
    }
  }
  catch {
    '0.0.0'
  }
}

function updateLatestVersion ($Meta) {
  $extraArgs = @(if (!$Meta.allowPrerelease) {
      '--exclude-pre-releases'
    })
  $tag = execute gh release list -R $Meta.repo -L1 -q '.[].tagName' --json tagName @extraArgs
  $Meta.tag = $tag
  try {
    [version]$version = $Meta.version = switch ($Meta.name) {
      default { $tag -replace '^v', ''; break }
    }
    if ($version -gt $Meta.localVersion) {
      $Meta
    }
    else {
      Write-Debug "pkg $($Meta.name) already newest for $tag"
    }
  }
  catch {
    $Meta
  }
}

function Update-Release {
  [CmdletBinding(SupportsShouldProcess)]
  param (
    [ArgumentCompleter({
        [OutputType([CompletionResult])]
        param (
          [string]$CommandName,
          [string]$ParameterName,
          [string]$WordToComplete
        )
        (Get-Content -Raw "${env:SHUTILS_ROOT}/data/pkgs.yml" | ConvertFrom-Yaml).name |
          Where-Object { $_ -like "$WordToComplete*" }
      })]
    [Parameter(Position = 0)]
    [string[]]
    $Name
  )
  $pkgsFile = "${env:SHUTILS_ROOT}/data/pkgs.yml"
  $pkgMap = @{}
  $pkgs = Get-Content -Raw $pkgsFile | ConvertFrom-Yaml
  $pkgs.ForEach{ $pkgMap[$_.name] = $_ }
  $Name ??= $pkgs.Keys
  $Name.ForEach{
    $pkg = $pkgMap.$_
    if (!$pkg) {
      return Write-Warning "unknown pkg $_"
    }
    updateLocalVersion $pkg
    updateLatestVersion $pkg
  }.ForEach{
    try {
      Install-Release $_
    }
    catch {
      Write-Warning $_
    }
  }
  $pkgs | ConvertTo-Yaml > $pkgsFile
}

function Install-Release {
  [CmdletBinding(SupportsShouldProcess)]
  param (
    [Parameter(Mandatory, Position = 0)]
    $Meta
  )
  $ext = $IsWindows ? '.zip' : '.tar.gz'
  $exe = $IsWindows ? '.exe' : ''
  if (!$PSCmdlet.ShouldProcess("$($Meta.name)@$($Meta.version)", 'install')) {
    return
  }
  Write-Information "Installing $($Meta.name)@$($Meta.version) by tag $($Meta.tag)"
  function downloadRelease ([string]$Pattern) {
    execute gh release download -R $Meta.repo -p $Pattern -D $buildDir --skip-existing $Meta.tag
  }
  switch ($Meta.name) {
    fzf {
      $base = 'fzf-{0}-{1}_{2}' -f $Meta.version, $go.os, $go.arch
      downloadRelease $base$ext
      execute tar -xf $buildDir/$base$ext -C $binDir
      break
    }
    yq {
      $base = 'yq_{0}_{1}' -f $go.os, $go.arch
      downloadRelease $base$ext
      execute tar -xf $buildDir/$base$ext -C $buildDir
      Copy-Item -LiteralPath $buildDir/$base $binDir/yq
      Copy-Item -LiteralPath $buildDir/yq.1 $manDir/man1
      break
    }
    nerdfonts {
      downloadRelease 0xProto.zip
      if ($IsLinux) {
        execute tar -xf $buildDir/0xProto.zip -C $dataDir/fonts/truetype
        execute sudo fc-cache -v
      }
      elseif ($IsWindows) {
        execute sudo tar -xf $buildDir/0xProto.zip -C C:\Windows\Fonts
      }
      else {
        throw 'not implemented'
      }
      break
    }
    dsc {
      $base = if ($IsLinux) {
        'DSC-{0}-{1}-linux' -f $Meta.version, $rust.arch
      }
      else {
        'DSC-{0}-{1}' -f $Meta.version, $rust.target
      }
      downloadRelease $base$ext
      New-EmptyDir $dataDir/dsc
      execute tar -xf $buildDir/$base$ext -C $dataDir/dsc
      break
    }
    node {
      $file = switch ($true) {
        $IsWindows { "node-$($Meta.tag)-x64.msi"; break }
        $IsLinux { "node-$($Meta.tag)-linux-x64.tar.xz"; break }
        $IsMacOS { "node-$($Meta.tag).pkg"; break }
        default { throw 'not implemented'; break }
      }
      execute aria2c https://nodejs.org/dist/$($Meta.tag)/$file -d $buildDir
      if ($IsLinux) {
        New-EmptyDir $dataDir/nodejs
        execute tar -xf $buildDir/$file -C $dataDir/nodejs
        $null = New-Item -ItemType SymbolicLink -Force -Target $dataDir/nodejs/node $binDir/node
        $null = New-Item -ItemType SymbolicLink -Force -Target $dataDir/nodejs/npm $binDir/npm
      }
      else {
        Invoke-Item -LiteralPath $buildDir/$file
      }
      break
    }
    pwsh {
      switch -CaseSensitive -Wildcard ($PSVersionTable.OS) {
        'Fedora Linux*' {
          execute sudo dnf install https://github.com/PowerShell/PowerShell/pkgs/download/$($Meta.tag)/powershell-$($Meta.version)-1.rh.$($go.arch).rpm
          break
        }
        'Ubuntu *' {
          $file = 'powershell-{0}.{1}.deb' -f $Meta.version, $go.arch
          downloadRelease $file
          execute sudo dpkg -i $buildDir/$file
          break
        }
      }
      break
    }
    grex {
      $clib = switch ($true) {
        $IsWindows { 'msvc'; break }
        $IsLinux { 'musl'; break }
      }
      $base = 'grex-{0}-{1}-{2}-{3}' -f $Meta.tag, $rust.arch, $rust.platform, (@($rust.os; $clib) -join '-')
      downloadRelease $base$ext
      execute tar -xf $buildDir/$base$ext -C $binDir
      break
    }
    tracexec {
      $base = 'tracexec-{0}' -f $rust.target
      downloadRelease $base$ext
      execute tar -xf $buildDir/$base$ext -C $buildDir
      Copy-Item -LiteralPath $buildDir/tracexec$exe $binDir
      break
    }
    numbat {
      $base = 'numbat-{0}-{1}' -f $Meta.tag, $rust.target
      downloadRelease $base$ext
      execute tar -xf $buildDir/$base$ext -C $buildDir
      New-EmptyDir $dataDir/numbat
      Move-Item $buildDir/$base $dataDir/numbat
      break
    }
    pastel {
      $base = 'pastel-{0}-{1}' -f $Meta.tag, $rust.target
      downloadRelease $base$ext
      execute tar -xf $buildDir/$base$ext -C $buildDir
      Copy-Item -LiteralPath $buildDir/$base/$base/pastel$exe $binDir
      break
    }
    default {
      throw "install method for $_ not implemented"
    }
  }
}

$go = goenv
$rust = rustenv
$buildDir = (Get-PSDrive Temp).Root
$binDir = $IsWindows ? "$HOME/tools" : "$HOME/.local/bin"
$manDir = $IsWindows ? "${env:LOCALAPPDATA}/man" : "$HOME/.local/share/man"
$dataDir = $IsWindows ? "${env:LOCALAPPDATA}/Programs" : "$HOME/.local/share"
