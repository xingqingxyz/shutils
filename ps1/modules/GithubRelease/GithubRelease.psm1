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
  $cmd = (Get-Command $cmd -Type Application -TotalCount 1 -ea Stop).Source
  Write-Debug "$args"
  if ($MyInvocation.ExpectingInput) {
    $input | & $cmd $ags
  }
  else {
    & $cmd $ags
  }
}

function getLocalVersion ($Meta) {
  try {
    switch ($Meta.name) {
      fzf { (execute fzf --version).Split(' ', 2)[0]; break }
      go { (execute go version).Split(' ', 4)[2]; break }
      pastel { (execute pastel -V).Split(' ', 3)[1]; break }
      mold { (execute mold -v).Split(' ', 3)[1]; break }
      jq { (execute jq -V).Split('-', 2)[1]; break }
      plantuml {
        (execute java -jar $binDir/plantuml.jar -version | Select-Object -First 1).Split(' ', 4)[2]
        break
      }
      default { (execute $_ --version).Split(' ')[-1] -replace '^v', ''; break }
    }
  }
  catch {
    Write-Warning "cannot detect local version for $($Meta.name)"
    '0.0.0'
  }
}

function updateLatestVersion ($Meta) {
  $extraArgs = @(if (!$Meta.allowPrerelease) {
      '--exclude-pre-releases'
    }) + @(switch ($Meta.name) {
      node { '-L5', '--json', 'tagName,isLatest', '-q', '.[] | select(.isLatest) | .tagName'; break }
      default { '-L1', '--json', 'tagName', '-q', '.[0].tagName'; break }
    })
  $tag = $Meta.tag = execute gh release list -R $Meta.repo --exclude-drafts @extraArgs
  try {
    [version]$version = $Meta.version = switch ($Meta.name) {
      jq { $tag.Split('-', 2)[1]; break }
      default { $tag -replace '^v', ''; break }
    }
    if ($version -gt (getLocalVersion $Meta)) {
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

function downloadFile ([string]$Url, [string]$Path) {
  if ($Path) {
    $dir = Split-Path $Path
    $file = Split-Path -Leaf $Path
  }
  else {
    $dir = $buildDir
    $file = Split-Path -Leaf $Url
    $Path = "$dir/$file"
  }
  $null = New-Item -Type Directory -Force $dir
  Remove-Item -LiteralPath $Path -Force -ea Ignore
  execute aria2c $Url -d $dir -o $file -l $buildDir/aria2c.log
}

function New-EmptyDir ([string]$Path) {
  Remove-Item -Recurse -Force -ea Ignore -LiteralPath $Path
  New-Item -ItemType Directory -Force $Path
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
      tar -xf $buildDir/$base$ext -C $binDir
      break
    }
    yq {
      $base = 'yq_{0}_{1}' -f $go.os, $go.arch
      downloadRelease $base$ext
      tar -xf $buildDir/$base$ext -C $buildDir
      Move-Item -LiteralPath $buildDir/$base$exe $binDir/yq$exe -Force
      Move-Item -LiteralPath $buildDir/yq.1 $dataDir/man/man1 -Force
      break
    }
    jq {
      $os = switch ($true) {
        $IsLinux { 'linux'; break }
        $IsWindows { 'windows'; break }
        $IsMacOS { 'macos'; break }
        default { throw 'unknown os' }
      }
      $file = 'jq-{0}-{1}{2}' -f $os, $go.arch, $exe
      downloadRelease $file
      Move-Item -LiteralPath $buildDir/$file $binDir/jq$exe -Force
      if (!$IsWindows) {
        chmod +x $binDir/jq$exe
      }
      downloadFile https://github.com/$($Meta.repo)/raw/HEAD/jq.1.prebuilt $dataDir/man/man1/jq.1
      break
    }
    nerdfonts {
      downloadRelease 0xProto.zip
      if ($IsLinux) {
        Expand-Archive -LiteralPath $buildDir/0xProto.zip -Force $dataDir/fonts/truetype
        sudo fc-cache -v
      }
      elseif ($IsWindows) {
        sudo tar -xf $buildDir/0xProto.zip -C C:\Windows\Fonts
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
      tar -xf $buildDir/$base$ext -C (New-EmptyDir $prefixDir/dsc)
      $null = New-Item -ItemType SymbolicLink -Force -Target $prefixDir/dsc/dsc $binDir/dsc
      break
    }
    node {
      $arch = switch ([RuntimeInformation]::OSArchitecture) {
        'X64' { 'x64'; break }
        'Arm64' { 'arm64'; break }
        default { throw "not supported arch $_" }
      }
      $file = switch ($true) {
        $IsWindows { "node-$($Meta.tag)-$arch.msi"; break }
        $IsLinux { "node-$($Meta.tag)-linux-$arch.tar.xz"; break }
        $IsMacOS { "node-$($Meta.tag).pkg"; break }
        default { throw 'not implemented'; break }
      }
      downloadFile https://nodejs.org/dist/$($Meta.tag)/$file
      if ($IsLinux) {
        $root = "$prefixDir/nodejs/$($Meta.tag)"
        tar -xf $buildDir/$file -C (New-EmptyDir $root) --strip-components=1
        $null = New-Item -ItemType SymbolicLink -Force -Target $root/bin/node $binDir/node
        $null = New-Item -ItemType SymbolicLink -Force -Target $root/bin/npm $binDir/npm
      }
      else {
        Invoke-Item -LiteralPath $buildDir/$file
      }
      break
    }
    pwsh {
      switch -CaseSensitive -Wildcard ($PSVersionTable.OS) {
        'Fedora Linux*' {
          $file = 'powershell-{0}-1.rh.{1}.rpm' -f $Meta.version, $go.arch
          downloadRelease $file
          sudo dnf install -y $buildDir/$file
          break
        }
        'Ubuntu *' {
          $file = 'powershell-{0}.{1}.deb' -f $Meta.version, $go.arch
          downloadRelease $file
          sudo dpkg -i $buildDir/$file
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
      tar -xf $buildDir/$base$ext -C $binDir
      break
    }
    tracexec {
      if (!$IsLinux) {
        throw 'not implemented'
      }
      $base = 'tracexec-{0}' -f $rust.target
      downloadRelease $base$ext
      tar -xf $buildDir/$base$ext -C $buildDir
      Move-Item -LiteralPath $buildDir/tracexec$exe $binDir -Force
      break
    }
    rga {
      $base = 'ripgrep_all-{0}-{1}' -f $Meta.tag, ($rust.target -creplace '-gnu$', '-musl')
      downloadRelease $base$ext
      tar -xf $buildDir/$base$ext -C $buildDir
      $files = 'rga rga-fzf rga-fzf-open rga-preproc'.Split(' ').ForEach{ "$buildDir/$_$exe" }
      Move-Item -LiteralPath $files $binDir -Force
      break
    }
    binocle {
      $base = 'binocle-{0}-{1}' -f $Meta.tag, $rust.target
      downloadRelease $base$ext
      tar -xf $buildDir/$base$ext -C $buildDir --strip-components=1
      Move-Item -LiteralPath $buildDir/binocle$exe $binDir -Force
      break
    }
    diskus {
      $base = 'diskus-{0}-{1}' -f $Meta.tag, $rust.target
      downloadRelease $base$ext
      tar -xf $buildDir/$base$ext -C $buildDir --strip-components=1
      Move-Item -LiteralPath $buildDir/diskus$exe $binDir -Force
      Move-Item -LiteralPath $buildDir/diskus.1 $dataDir/man/man1 -Force
      break
    }
    hexyl {
      $base = 'hexyl-{0}-{1}' -f $Meta.tag, ($rust.target -creplace '-gnu$', '-musl')
      downloadRelease $base$ext
      tar -xf $buildDir/$base$ext -C $buildDir
      Move-Item -LiteralPath $buildDir/$base/hexyl$exe $binDir -Force
      Move-Item -LiteralPath $buildDir/$base/hexyl.1 $dataDir/man/man1 -Force
      break
    }
    mdbook {
      $base = 'mdbook-{0}-{1}' -f $Meta.tag, $rust.target
      downloadRelease $base$ext
      tar -xf $buildDir/$base$ext -C $binDir
      break
    }
    mold {
      if (!$IsLinux) {
        throw 'not implemented'
      }
      $base = 'mold-{0}-{1}-{2}' -f $Meta.version, $rust.arch, $rust.os
      downloadRelease $base$ext
      sudo tar -xf $buildDir/$base$ext -C $sudoPrefixDir --no-same-owner --strip-components=1
      break
    }
    plantuml {
      $file = 'plantuml-gplv2-{0}.jar' -f $Meta.version
      downloadRelease $file
      Move-Item -LiteralPath $buildDir/$file $binDir/plantuml.jar -Force
      break
    }
    numbat {
      $base = 'numbat-{0}-{1}' -f $Meta.tag, $rust.target
      downloadRelease $base$ext
      tar -xf $buildDir/$base$ext -C (New-EmptyDir $prefixDir/numbat) --strip-components=1
      $null = New-Item -ItemType SymbolicLink -Force -Target $prefixDir/numbat/numbat $binDir/numbat
      break
    }
    pastel {
      $base = 'pastel-{0}-{1}' -f $Meta.tag, $rust.target
      downloadRelease $base$ext
      tar -xf $buildDir/$base$ext -C $binDir --strip-components=2
      break
    }
    localsend {
      if (!$IsLinux) {
        throw 'not implemented'
      }
      $base = 'LocalSend-{0}-{1}-x86-64' -f $Meta.version, $rust.os
      downloadRelease $base$ext
      tar -xf $buildDir/$base$ext -C (New-EmptyDir $prefixDir/localsend)
      @"
[Desktop Entry]
Icon=$prefixDir/localsend/data/flutter_assets/assets/img/logo-512.png
Exec=$prefixDir/localsend/localsend_app %u
Version=1.0
Type=Application
Categories=Network
Name=LocalSend
Terminal=false
Comment=A open-source, cross-platform alternative to AirDrop
StartupNotify=true
StartupWMClass=localsend_app
"@ > $dataDir/applications/localsend.desktop
      update-desktop-database
      break
    }
    default {
      throw "install method for $_ not implemented"
      break
    }
  }
}

function Update-Release {
  [CmdletBinding(SupportsShouldProcess)]
  param (
    [ArgumentCompleter({
        param (
          [string]$CommandName,
          [string]$ParameterName,
          [string]$WordToComplete
        )
        (Get-Content -Raw $PSScriptRoot/pkgs.yml | ConvertFrom-Yaml).name |
          Where-Object { $_ -like "$WordToComplete*" }
      })]
    [Parameter(Position = 0)]
    [string[]]
    $Name
  )
  $pkgsFile = "$PSScriptRoot/pkgs.yml"
  $pkgMap = @{}
  $pkgs = Get-Content -Raw $pkgsFile | ConvertFrom-Yaml
  $pkgs.ForEach{ $pkgMap[$_.name] = $_ }
  $Name ??= $pkgs.Keys
  $Name.ForEach{
    $pkg = $pkgMap.$_
    if (!$pkg) {
      return Write-Warning "unknown pkg $_"
    }
    updateLatestVersion $pkg
  }.ForEach{
    try {
      Install-Release $_
    }
    catch {
      Write-Error $_
    }
  }
  $pkgs | ConvertTo-Yaml > $pkgsFile
}

function Install-Golang ([version]$Version) {
  if (!$IsLinux) {
    throw 'not implemented'
  }
  $file = 'go{0}.{1}-{2}.tar.gz' -f $Version, $go.os, $go.arch
  downloadFile https://golang.google.cn/dl/$file
  sudo rm -rf $sudoPrefixDir/go
  sudo tar -xf $buildDir/$file -C $sudoPrefixDir --no-same-owner
  sudo ln -sf $sudoPrefixDir/go/bin/go $sudoPrefixDir/go/bin/gofmt $sudoBinDir
}

$go = goenv
$rust = rustenv
$buildDir = [System.IO.Path]::TrimEndingDirectorySeparator([System.IO.Path]::GetTempPath())
$prefixDir = $IsWindows ? "$env:LOCALAPPDATA/Programs" : "$HOME/.local"
$binDir = $IsWindows ? "$HOME/tools" : "$prefixDir/bin"
$dataDir = $IsWindows ? $env:APPDATA : "$prefixDir/share"

$sudoPrefixDir = $IsWindows ? $env:ProgramData : '/usr/local'
$sudoBinDir = $IsWindows ? 'C:/tools' : "$sudoPrefixDir/bin"
# $sudoDataDir = $IsWindows ? $env:ProgramData : "$sudoPrefixDir/share"
