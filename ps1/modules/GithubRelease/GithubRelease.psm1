using namespace System.Runtime.InteropServices

$ErrorActionPreference = 'Stop'
$PSNativeCommandUseErrorActionPreference = $true

function goenv {
  if (Get-Command go -Type Application -ea Ignore) {
    $os, $arch = go env GOOS GOARCH
    return [psobject]@{
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
    default { throw [System.NotImplementedException]::new("arch $_") }
  }
  [psobject]@{
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
    (rustc -vV | Select-String -Raw -SimpleMatch host:).Split(' ', 2)[1]
  }
  else {
    @(
      $arch
      $platform
      $os
      $clib
    ) -join '-'
  }
  [psobject]@{
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
  Write-CommandDebug $cmd $ags
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
      dsc { (dsc -V).Split([char[]]' -', 3)[1]; break }
      fzf { (fzf --version).Split(' ', 2)[0]; break }
      flutter { (flutter --version)[0].Split(' ', 3)[1]; break }
      dotnet { (dotnet --version).Split('-', 2)[0]; break }
      go { (go version).Split(' ', 4)[2].Substring(2); break }
      goreleaser { (goreleaser -v | Select-String -Raw -SimpleMatch GitVersion).Split(':', 2)[1].TrimStart(); break }
      pastel { (pastel -V).Split(' ', 3)[1]; break }
      mold { (mold -v).Split(' ', 3)[1]; break }
      jq { (jq -V).Split('-', 2)[1]; break }
      plantuml {
        (java -jar $binDir/plantuml.jar -version | Select-Object -First 1).Split(' ', 4)[2]
        break
      }
      default { (& $_ --version).Split(' ')[-1] -replace '^v', ''; break }
    }
  }
  catch {
    Write-Warning "cannot detect local version for $($Meta.name)"
    '0.0.0'
  }
}

function updateLatestVersion ($Meta) {
  switch ($Meta.name) {
    dotnet { $Meta.version = '99.0.0'; break }
    go {
      if (!$IsLinux) {
        throw [System.NotImplementedException]::new()
      }
      $data = Invoke-RestMethod 'https://golang.google.cn/dl/?mode=json'
      $Meta.tag = $data[0].version
      $Meta.version = $Meta.tag.Substring(2)
      $Meta.sha256 = ($data[0].files | Where-Object filename -CEQ ('{0}.{1}-{2}.tar.gz' -f $Meta.tag, $go.os, $go.arch)).sha256
      break
    }
    flutter {
      $os = switch ($true) {
        $IsWindows { 'windows'; break }
        $IsLinux { 'linux'; break }
        $IsMacOS { 'macos'; break }
      }
      $data = Invoke-RestMethod "https://storage.flutter-io.cn/flutter_infra_release/releases/releases_$os.json"
      $release = $data.releases | Where-Object hash -CEQ $data.current_release.($Meta.prerelease ? 'beta' : 'stable')
      $Meta.file = 'https://storage.flutter-io.cn/flutter_infra_release/releases/' + $release.archive
      $Meta.version = $release.version
      $Meta.sha256 = $release.sha256
      break
    }
    default {
      [string[]]$extraArgs = if ($Meta.prerelease) {
        switch ($Meta.name) {
          default { '-L5', '--json', 'tagName,isPrerelease', '-q', 'first(.[] | select(.isPrerelease)) | .tagName'; break }
        }
      }
      else {
        '--exclude-pre-releases'
        switch ($Meta.name) {
          node { '-L5', '--json', 'tagName,isLatest', '-q', 'first(.[] | select(.isLatest)) | .tagName'; break }
          pwsh { '-L5', '--json', 'tagName,isPrerelease', '-q', 'first(.[] | select(.isPrerelease)) | .tagName'; break }
          zed { '-L5', '--json', 'tagName', '-q', 'first(.[].tagName | select(startswith("v")))'; break }
          default { '-L1', '--json', 'tagName', '-q', '.[0].tagName'; break }
        }
      }
      $tag = $Meta.tag = execute gh release list -R $Meta.repo --exclude-drafts @extraArgs
      $Meta.version = switch ($Meta.name) {
        bun { $tag.Substring(5); break }
        dsc { $tag.Split('-', 2)[0]; break }
        jq { $tag.Split('-', 2)[1]; break }
        default { $tag -replace '^v', ''; break }
      }
      break
    }
  }
  try {
    if ([version]$Meta.version -gt (getLocalVersion $Meta)) {
      $Meta
    }
    else {
      Write-Warning "pkg $($Meta.name) is already newer than $($Meta.tag)"
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
  execute aria2c $Url -d $dir -o $file >> $buildDir/aria2c.log
}

function checkFileHash ([string]$Path, [string]$Sha256) {
  if ((Get-FileHash -LiteralPath $Path -Algorithm SHA256) -cne $Sha256) {
    throw "file hash not match ($Path): $Sha256"
  }
}

function New-EmptyDir ([string]$Path) {
  Remove-Item -Recurse -Force -ea Ignore -LiteralPath $Path
  New-Item -ItemType Directory -Force $Path
}

function installBinary ([string[]]$Path) {
  if ($IsWindows) {
    $Path.ForEach{ "@`"$_`" %*" > $binDir\$(Split-Path -LeafBase $_).cmd }
    return
  }
  ln -sf $Path $binDir
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
  Write-Debug "Installing $($Meta.name)@$($Meta.version) by tag $($Meta.tag)"
  function downloadRelease ([string]$Pattern) {
    execute gh release download -R $Meta.repo -p $Pattern -D $buildDir --skip-existing $Meta.tag
  }
  switch ($Meta.name) {
    binocle {
      $base = 'binocle-{0}-{1}' -f $Meta.tag, $rust.target
      downloadRelease $base$ext
      tar -xf $buildDir/$base$ext -C $buildDir --strip-components=1
      Move-Item -LiteralPath $buildDir/binocle$exe $binDir -Force
      break
    }
    bun {
      if ($IsWindows) {
        throw [System.NotImplementedException]::new()
      }
      if (Get-Command bun -CommandType Application -TotalCount 1 -ea Ignore) {
        bun upgrade
        break
      }
      curl -fsSL 'https://bun.sh/install' | bash
      break
    }
    code {
      if (!$IsLinux) {
        throw [System.NotImplementedException]::new()
      }
      $pkgManager = $pkgType -ceq 'rpm' ? 'dnf' : 'apt'
      sudo $pkgManager install -y "https://update.code.visualstudio.com/latest/linux-$pkgType-x64/stable"
      break
    }
    deno {
      if ($IsWindows) {
        throw [System.NotImplementedException]::new()
      }
      if (Get-Command deno -CommandType Application -TotalCount 1 -ea Ignore) {
        deno upgrade
        break
      }
      curl -fsSL 'https://deno.land/install.sh' | sh; break
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
    dotnet {
      $ChannelQuality = $Meta.prerelease ? '10.0/preview' : 'STS'
      $os, $fileExt = switch ($true) {
        $IsWindows { 'win', '.exe'; break }
        $IsLinux { 'linux', '.tar.gz'; break }
        $IsMacOS { 'osx', '.pkg'; break }
      }
      $file = 'dotnet-sdk-{0}-{1}{2}' -f $os, [RuntimeInformation]::OSArchitecture.ToString().ToLowerInvariant(), $fileExt
      downloadFile "https://aka.ms/dotnet/$ChannelQuality/$file"
      if (!$IsLinux) {
        Invoke-Item $buildDir/$file
        break
      }
      sudo rm -rf $sudoDataDir/dotnet
      sudo mkdir -p $sudoDataDir/dotnet
      sudo tar -xf $buildDir/$file -C $sudoDataDir/dotnet --no-same-owner
      sudo ln -sf $sudoDataDir/dotnet/dotnet $sudoDataDir/dotnet/dnx $sudoBinDir
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
      installBinary $prefixDir/dsc/dsc$exe
      break
    }
    flutter {
      downloadFile $Meta.file
      $file = Split-Path -Leaf $Meta.file
      checkFileHash $buildDir/$file $Meta.sha256
      Remove-Item -LiteralPath $prefixDir/flutter
      tar -xf $buildDir/$file -C $prefixDir
      $bat = $IsWindows ? '.bat' : ''
      installBinary @('flutter', 'flutter-dev', 'dart').ForEach{ "$prefixDir/flutter/bin/$_$bat" }
      break
    }
    fzf {
      $base = 'fzf-{0}-{1}_{2}' -f $Meta.version, $go.os, $go.arch
      downloadRelease $base$ext
      tar -xf $buildDir/$base$ext -C $binDir
      break
    }
    go {
      if (!$IsLinux) {
        throw [System.NotImplementedException]::new()
      }
      $file = '{0}.{1}-{2}.tar.gz' -f $Meta.tag, $go.os, $go.arch
      downloadFile "https://golang.google.cn/dl/$file"
      checkFileHash $buildDir/$file $Meta.sha256
      sudo rm -rf $sudoPrefixDir/go
      sudo tar -xf $buildDir/$file -C $sudoPrefixDir --no-same-owner
      sudo ln -sf $sudoPrefixDir/go/bin/go $sudoPrefixDir/go/bin/gofmt $sudoBinDir
      break
    }
    goreleaser {
      $os = switch ($true) {
        $IsWindows { 'Windows'; break }
        $IsLinux { 'Linux'; break }
        $IsMacOS { 'Darwin'; break }
        default { throw [System.NotImplementedException]::new() }
      }
      $base = 'goreleaser_{0}_{1}' -f $os, $rust.arch
      downloadRelease $base$ext
      tar -xf $buildDir/$base$ext -C $buildDir
      Move-Item -LiteralPath $buildDir/goreleaser$exe $binDir -Force
      Move-Item -LiteralPath $buildDir/manpages/goreleaser.1.gz $dataDir/man/man1 -Force
      Move-Item -LiteralPath $buildDir/completions/goreleaser.bash $dataDir/bash-completion/completions -Force
      break
    }
    grex {
      $clib = switch ($true) {
        $IsWindows { 'msvc'; break }
        $IsLinux { 'musl'; break }
      }
      $base = 'grex-{0}-{1}-{2}-{3}' -f $Meta.tag, $rust.arch, $rust.platform, ($rust.os + '-' + $clib)
      downloadRelease $base$ext
      tar -xf $buildDir/$base$ext -C $binDir
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
        chmod +x $binDir/jq
      }
      downloadFile https://github.com/$($Meta.repo)/raw/HEAD/jq.1.prebuilt $dataDir/man/man1/jq.1
      break
    }
    localsend {
      if (!$IsLinux) {
        throw [System.NotImplementedException]::new()
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
    mdbook {
      $base = 'mdbook-{0}-{1}' -f $Meta.tag, $rust.target
      downloadRelease $base$ext
      tar -xf $buildDir/$base$ext -C $binDir
      break
    }
    mold {
      if (!$IsLinux) {
        throw [System.NotImplementedException]::new()
      }
      $base = 'mold-{0}-{1}-{2}' -f $Meta.version, $rust.arch, $rust.os
      downloadRelease $base$ext
      sudo tar -xf $buildDir/$base$ext -C $sudoPrefixDir --no-same-owner --strip-components=1
      break
    }
    nerdfonts {
      downloadRelease 0xProto.zip
      if ($IsLinux) {
        Expand-Archive -LiteralPath $buildDir/0xProto.zip $dataDir/fonts/truetype -Force
        sudo fc-cache -v
      }
      elseif ($IsWindows) {
        sudo tar -xf $buildDir/0xProto.zip -C C:\Windows\Fonts
      }
      else {
        throw [System.NotImplementedException]::new()
      }
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
        default { throw [System.NotImplementedException]::new(); break }
      }
      downloadFile "https://nodejs.org/dist/$($Meta.tag)/$file"
      if (!$IsLinux) {
        Invoke-Item $buildDir/$file
        break
      }
      $root = "$prefixDir/nodejs/$($Meta.tag)"
      tar -xf $buildDir/$file -C (New-EmptyDir $root) --strip-components=1
      installBinary $root/bin/node $root/bin/npm
      break
    }
    numbat {
      $base = 'numbat-{0}-{1}' -f $Meta.tag, $rust.target
      downloadRelease $base$ext
      tar -xf $buildDir/$base$ext -C (New-EmptyDir $prefixDir/numbat) --strip-components=1
      installBinary $prefixDir/numbat/numbat$exe
      break
    }
    pastel {
      $base = 'pastel-{0}-{1}' -f $Meta.tag, $rust.target
      downloadRelease $base$ext
      tar -xf $buildDir/$base$ext -C $buildDir
      Move-Item -LiteralPath $buildDir/$base/pastel$exe $binDir -Force
      Move-Item -LiteralPath $buildDir/$base/autocomplete/pastel.bash $dataDir/bash-completion/completions -Force
      Move-Item -LiteralPath $buildDir/$base/autocomplete/_pastel.ps1 $ps1CompletionDir -Force
      Move-Item $buildDir/$base/man/* $dataDir/man/man1 -Force
      break
    }
    plantuml {
      $file = 'plantuml-gplv2-{0}.jar' -f $Meta.version
      downloadRelease $file
      Move-Item -LiteralPath $buildDir/$file $binDir/plantuml.jar -Force
      break
    }
    pwsh {
      if (!$IsLinux) {
        throw [System.NotImplementedException]::new()
      }
      switch ($pkgType) {
        'rpm' {
          $file = 'powershell-{0}-1.rh.{1}.rpm' -f $Meta.tag.Substring(1), $go.arch
          downloadRelease $file
          sudo dnf install -y $buildDir/$file
          break
        }
        'deb' {
          $file = 'powershell-{0}.{1}.deb' -f $Meta.tag.Substring(1), $go.arch
          downloadRelease $file
          sudo dpkg -i $buildDir/$file
          break
        }
      }
      break
    }
    rga {
      $base = 'ripgrep_all-{0}-{1}' -f $Meta.tag, ($rust.target -creplace '-gnu$', '-musl')
      downloadRelease $base$ext
      tar -xf $buildDir/$base$ext -C $buildDir
      [string[]]$files = 'rga', 'rga-fzf', 'rga-fzf-open', 'rga-preproc'
      $files = $files.ForEach{ "$buildDir/$_$exe" }
      Move-Item -LiteralPath $files $binDir -Force
      break
    }
    tracexec {
      if (!$IsLinux) {
        throw [System.NotImplementedException]::new()
      }
      $base = 'tracexec-{0}' -f $rust.target
      downloadRelease $base$ext
      tar -xf $buildDir/$base$ext -C $buildDir
      Move-Item -LiteralPath $buildDir/tracexec$exe $binDir -Force
      break
    }
    uv {
      if ($IsWindows) {
        throw [System.NotImplementedException]::new()
      }
      if (Get-Command uv -CommandType Application -TotalCount 1 -ea Ignore) {
        uv self update
        break
      }
      curl -LsSf 'https://astral.sh/uv/install.sh' | sh
      break
    }
    xh {
      $base = 'xh-{0}-{1}' -f $Meta.tag, ($rust.target -creplace '-gnu$', '-musl')
      downloadRelease $base$ext
      tar -xf $buildDir/$base$ext -C $buildDir
      Move-Item -LiteralPath $buildDir/$base/xh$exe $binDir/http$exe -Force
      Move-Item -LiteralPath $buildDir/$base/doc/xh.1 $dataDir/man/man1 -Force
      $null = New-Item -ItemType SymbolicLink -Force -Target http$exe $binDir/https$exe
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
    zed {
      if ($IsWindows) {
        throw [System.NotImplementedException]::new()
      }
      curl -f 'https://zed.dev/install.sh' | sh
      break
    }
    default { throw "no install method for $_" }
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
        (Get-Content -Raw -LiteralPath $PSScriptRoot/pkgs.yml | ConvertFrom-Yaml | Where-Object name -Like $WordToComplete*).name
      })]
    [Parameter(Position = 0)]
    [string[]]
    $Name
  )
  $pkgMap = @{}
  Get-Content -Raw -LiteralPath $PSScriptRoot/pkgs.yml | ConvertFrom-Yaml | ForEach-Object { $pkgMap[$_.name] = $_ }
  $Name ??= $pkgMap.Keys
  $Name | ForEach-Object {
    if (!$pkgMap.Contains($_)) {
      throw "unknown pkg $_"
    }
    updateLatestVersion $pkgMap[$_]
  } | ForEach-Object { Install-Release $_ } -ea 'Continue'
  $pkgMap.Values | ConvertTo-Yaml > $PSScriptRoot/pkgs.yml
}

$go = goenv
$rust = rustenv
$buildDir = [System.IO.Path]::TrimEndingDirectorySeparator([System.IO.Path]::GetTempPath())
$ps1CompletionDir = "$env:SHUTILS_ROOT/ps1/completions"
if ($IsLinux) {
  $pkgType = (Get-Content -Raw -LiteralPath /etc/os-release).Contains('REDHAT_BUGZILLA_PRODUCT=') ? 'rpm' : 'deb'
}

$prefixDir = $IsWindows ? "$env:LOCALAPPDATA\Programs" : "$HOME/.local"
$binDir = $IsWindows ? "$HOME\tools" : "$prefixDir/bin"
$dataDir = Join-Path $prefixDir share

$sudoPrefixDir = $IsWindows ? $env:ProgramData : '/usr/local'
$sudoBinDir = $IsWindows ? 'C:\tools' : "$sudoPrefixDir/bin"
$sudoDataDir = Join-Path $sudoPrefixDir share
