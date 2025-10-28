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
    default { throw [System.NotImplementedException]::new("arch $_") }
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
  $cmd = (Get-Command $cmd -Type Application -TotalCount 1).Source
  Write-CommandDebug $cmd $ags
  if ($MyInvocation.ExpectingInput) {
    $input | & $cmd $ags
  }
  else {
    & $cmd $ags
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
  if ((Get-FileHash -LiteralPath $Path -Algorithm SHA256).Hash -ne $Sha256) {
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

function getLocalVersion ($Meta) {
  try {
    switch ($Meta.name) {
      bash { (bash --version)[0].Split(' ', 3)[2].Split('(', 2)[0]; break }
      dsc { (dsc -V).Split([char[]]' -', 3)[1]; break }
      fzf { (fzf --version).Split(' ', 2)[0]; break }
      flutter { (flutter --version)[0].Split(' ', 3)[1]; break }
      dotnet { (dotnet --version).Split('-', 2)[0]; break }
      gh { (gh version)[0].Split(' ', 4)[2]; break }
      go { (go version).Split(' ', 4)[2].Substring(2); break }
      goreleaser { (goreleaser -v | Select-String -Raw -SimpleMatch GitVersion).Split(':', 2)[1].TrimStart(); break }
      pastel { (pastel -V).Split(' ', 3)[1]; break }
      less { (less --version 2>$null)[0].Split(' ', 3)[1]; break }
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
    bash { $Meta.version = '5.3'; break }
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
        less { $tag.Substring(6); break }
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
  function downloadRelease ([string[]]$Pattern) {
    execute gh release download -R $Meta.repo $Pattern.ForEach{ "-p$_" } -D $buildDir --skip-existing $Meta.tag
  }
  switch ($Meta.name) {
    alacritty {
      if (!$IsLinux) {
        throw [System.NotImplementedException]::new()
      }
      cargo install alacritty@$($Meta.version)
      downloadRelease 'Alacritty.svg', 'alacritty.1.gz', 'alacritty-msg.1.gz', 'alacritty.5.gz', 'alacritty-bindings.5.gz', 'alacritty.bash', 'Alacritty.desktop'
      Move-Item -LiteralPath $buildDir/alacritty.1.gz, $buildDir/alacritty-msg.1.gz, $buildDir/alacritty.5.gz, $buildDir/alacritty-bindings.5.gz $dataDir/man/man1
      Move-Item -LiteralPath $buildDir/alacritty.bash $dataDir/bash-completion/completions
      Move-Item -LiteralPath $buildDir/Alacritty.desktop $dataDir/applications
      update-desktop-database $dataDir/applications
      sudo mv $buildDir/Alacritty.svg /usr/share/pixmaps
      break
    }
    balenaEtcher {
      switch ($true) {
        $IsFedora {
          $file = "balena-etcher-$($Meta.version)-1.x86_64.rpm"
          downloadRelease $file
          sudo dnf install -y $buildDir/$file
          break
        }
        $IsUbuntu {
          $file = "balena-etcher_$($Meta.version)_amd64.deb"
          downloadRelease $file
          sudo dpkg -i $buildDir/$file
          break
        }
        default { throw [System.NotImplementedException]::new() }
      }
      break
    }
    bash {
      $base = 'bash-{0}' -f $Meta.version
      $file = "$base.tar.gz"
      downloadFile "https://mirrors.ustc.edu.cn/gnu/bash/$file"
      downloadFile "https://mirrors.ustc.edu.cn/gnu/bash/$file.sig"
      gpg --verify $buildDir/$file`.sig $buildDir/$file
      tar -xf $buildDir/$file -C $buildDir
      Push-Location -LiteralPath $buildDir/$base
      try {
        ./configure
        make
        sudo make install
      }
      finally {
        Pop-Location
      }
      break
    }
    bat {
      $base = 'bat-{0}-{1}' -f $Meta.tag, $rust.target
      downloadRelease $base$ext
      tar -xf $buildDir/$base$ext -C $buildDir --strip-components=1
      Move-Item -LiteralPath $buildDir/bat$exe $binDir -Force
      break
    }
    bun {
      if (!$IsLinux) {
        throw [System.NotImplementedException]::new()
      }
      if (Get-Command bun -CommandType Application -TotalCount 1 -ea Ignore) {
        bun upgrade
        break
      }
      $arch = switch ([RuntimeInformation]::OSArchitecture) {
        'Arm64' { 'aarch64'; break }
        'X64' { 'x64'; break }
        default { throw [System.NotImplementedException]::new() }
      }
      $file = 'bun-{0}-{1}.zip' -f $go.os, $arch
      downloadRelease $file, SHASUMS256.txt
      checkFileHash $buildDir/$file (Get-Content -LiteralPath $buildDir/SHASUMS256.txt | Select-String -Raw -SimpleMatch $file).Split(' ', 2)[0]
      Expand-Archive -LiteralPath $buildDir/$file $buildDir
      Move-Item -LiteralPath $buildDir/$(Split-Path -LeafBase $file) $binDir
      break
    }
    code {
      switch ($true) {
        $IsFedora {
          sudo dnf install -y 'https://update.code.visualstudio.com/latest/linux-rpm-x64/stable'
          break
        }
        $IsUbuntu {
          downloadFile 'https://update.code.visualstudio.com/latest/linux-deb-x64/stable'
          $file = Split-Path -Resolve -Leaf $buildDir/code_$($Meta.version)-*.deb
          sudo dpkg -i $buildDir/$file
          break
        }
        default { throw [System.NotImplementedException]::new() }
      }
      break
    }
    deno {
      if (!$IsLinux) {
        throw [System.NotImplementedException]::new()
      }
      if (Get-Command deno -CommandType Application -TotalCount 1 -ea Ignore) {
        deno upgrade
        break
      }
      $file = 'deno-{0}.zip' -f $rust.target
      downloadRelease $file, $file`.sha256sum
      checkFileHash $buildDir/$file (Get-Content -Raw -LiteralPath $buildDir/$file`.sha256sum).Split(' ', 2)[0]
      Expand-Archive $buildDir/$file $binDir
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
    edit {
      switch ($true) {
        $IsLinux {
          $base = 'edit-{0}-{1}-linux-gnu' -f $Meta.version, $rust.arch
          downloadRelease $base`.tar.zst
          tar -xf $buildDir/$base`.tar.zst --zstd -C $buildDir
          break
        }
        $IsWindows {
          $base = 'edit-{0}-{1}-windows' -f $Meta.version, $rust.arch
          downloadRelease $base`.zip
          Expand-Archive -LiteralPath $buildDir/$base`.zip -DestinationPath $buildDir
          break
        }
        default { throw [System.NotImplementedException]::new() }
      }
      Move-Item -LiteralPath $buildDir/edit$exe $binDir
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
    gh {
      if (!$IsLinux) {
        throw [System.NotImplementedException]::new()
      }
      $file = 'gh_{0}_{1}_{2}.{3}' -f $Meta.version, $go.os, $go.arch, $pkgType
      downloadRelease $file
      sudo $pkgManager install -y $buildDir/$file
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
      $os = $go.os.Substring(0, 1).ToUpperInvariant() + $go.os.Substring(1)
      $base = 'goreleaser_{0}_{1}' -f $os, $rust.arch
      downloadRelease $base$ext
      tar -xf $buildDir/$base$ext -C $buildDir
      Move-Item -LiteralPath $buildDir/goreleaser$exe $binDir -Force
      Move-Item -LiteralPath $buildDir/manpages/goreleaser.1.gz $dataDir/man/man1 -Force
      Move-Item -LiteralPath $buildDir/completions/goreleaser.bash $dataDir/bash-completion/completions -Force
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
    less {
      if (!$IsLinux) {
        throw [System.NotImplementedException]::new()
      }
      $base = 'less-{0}' -f $Meta.version
      downloadFile "http://www.greenwoodsoftware.com/less/$base.tar.gz"
      downloadFile "http://www.greenwoodsoftware.com/less/$base.sig"
      gpg --verify $buildDir/$base`.sig $buildDir/$base`.tar.gz
      tar -xf $buildDir/$base`.tar.gz -C $buildDir
      Push-Location -LiteralPath $buildDir/$base
      try {
        ./configure --with-editor=vim --with-regex=pcre2
        make
        sudo make install
      }
      finally {
        Pop-Location
      }
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
      update-desktop-database $dataDir/applications
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
        Remove-Item -LiteralPath $dataDir/fonts/truetype/README.md, $dataDir/fonts/truetype/LICENSE
        fc-cache -v
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
      installBinary $root/bin/node, $root/bin/npm
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
      $id = $Meta.tag.Substring(1)
      if ($Meta.prerelease) {
        $id = 'preview-' + $id.Replace('-', '_')
      }
      switch ($true) {
        $IsFedora {
          $file = 'powershell-{0}-1.rh.{1}.rpm' -f $id, $rust.arch
          downloadRelease $file
          if ($Meta.prerelease) {
            sudo dnf remove -y powershell
          }
          else {
            sudo dnf remove -y powershell-preview
          }
          sudo dnf install -y $buildDir/$file
          break
        }
        $IsUbuntu {
          $file = 'powershell-{0}.{1}.deb'
          downloadRelease $file
          if ($Meta.prerelease) {
            sudo apt uninstall -y powershell
          }
          else {
            sudo apt uninstall -y powershell-preview
          }
          sudo dpkg -i $buildDir/$file
          break
        }
        default { throw [System.NotImplementedException]::new() }
      }
      break
    }
    rg {
      $base = 'ripgrep-{0}-{1}' -f $Meta.tag, ($rust.target -creplace '-gnu$', '-musl')
      downloadRelease $base$ext, $base$ext`.sha256
      checkFileHash $buildDir/$base$ext (Get-Content -Raw -LiteralPath $buildDir/$base$ext`.sha256).Split(' ', 2)[0]
      tar -xf $buildDir/$base$ext -C $buildDir
      Move-Item -LiteralPath $buildDir/$base/rg$exe $binDir -Force
      Move-Item -LiteralPath $buildDir/$base/doc/rg.1 $dataDir/man/man1 -Force
      Move-Item -LiteralPath $buildDir/$base/complete/rg.bash $dataDir/bash-completion/completions -Force
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
    rustup {
      if ($IsWindows) {
        throw [System.NotImplementedException]::new()
      }
      curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
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
        (Get-Content -Raw -LiteralPath $env:SHUTILS_ROOT/data/releases.yml | ConvertFrom-Yaml | Where-Object name -Like $WordToComplete*).name
      })]
    [Parameter(Position = 0)]
    [string[]]
    $Name
  )
  $pkgMap = [ordered]@{}
  Get-Content -Raw -LiteralPath $env:SHUTILS_ROOT/data/releases.yml | ConvertFrom-Yaml | ForEach-Object { $pkgMap[$_.name] = $_ }
  $Name ??= $pkgMap.Keys
  $Name | ForEach-Object {
    if (!$pkgMap.Contains($_)) {
      throw "unknown pkg $_"
    }
    updateLatestVersion $pkgMap[$_]
  } | ForEach-Object { Install-Release $_ } -ea 'Continue'
  $pkgMap.Values | ConvertTo-Yaml > $env:SHUTILS_ROOT/data/releases.yml
}

$go = goenv
$rust = rustenv
$buildDir = [System.IO.Path]::TrimEndingDirectorySeparator([System.IO.Path]::GetTempPath())
$ps1CompletionDir = "$env:SHUTILS_ROOT/ps1/completions"
if ($IsLinux) {
  $IsUbuntu = (Get-Content -Raw -LiteralPath /etc/os-release).Contains('ID=ubuntu')
  $IsFedora = (Get-Content -Raw -LiteralPath /etc/os-release).Contains('REDHAT_BUGZILLA_PRODUCT=')
}

$prefixDir = $IsWindows ? "$env:LOCALAPPDATA\Programs" : "$HOME/.local"
$binDir = $IsWindows ? "$HOME\tools" : "$prefixDir/bin"
$dataDir = Join-Path $prefixDir share

$sudoPrefixDir = $IsWindows ? $env:ProgramData : '/usr/local'
$sudoBinDir = $IsWindows ? 'C:\tools' : "$sudoPrefixDir/bin"
$sudoDataDir = Join-Path $sudoPrefixDir share
