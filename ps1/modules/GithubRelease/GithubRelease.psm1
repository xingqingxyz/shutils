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

function checkFileHash ([string]$Path, [string]$Sha256) {
  Write-Debug "checking file hash: $Path"
  if ((Get-FileHash -LiteralPath $Path -Algorithm SHA256).Hash -ne $Sha256) {
    throw "file hash not match ($Path): $Sha256"
  }
}

function New-EmptyDir ([string[]]$Path) {
  Remove-Item -LiteralPath $Path -Recurse -Force -ea Ignore
  New-Item -ItemType Directory -Force $Path
}

function installBinary ([string[]]$Path) {
  $Path.ForEach{
    $name = [System.IO.Path]::GetFileNameWithoutExtension($_)
    $fullName = [System.IO.Path]::GetFullPath($_)
    $cmd = '"' + $fullName.Replace('"', ($IsWindows ? '""' : '\"')) + '"'
    switch ([System.IO.Path]::GetExtension($_)) {
      '.jar' {
        if ($IsWindows) {
          "@java -jar $cmd %*" > $binDir/$name`.cmd
        }
        else {
          # exec -a requires bash
          "#!/bin/bash`nexec -a $name java -jar $cmd `"$@`"" > $binDir/$name
          chmod +x $binDir/$name
        }
        break
      }
      default {
        if ($IsWindows) {
          "@$cmd %*" > $binDir/$name`.cmd
        }
        else {
          chmod +x $fullName
          ln -sf $fullName $binDir/$name
        }
        break
      }
    }
  }
}

function getLocalVersion ([string]$Name) {
  try {
    switch ($Name) {
      bash { (bash --version)[0].Split(' ', 3)[2].Split('(', 2)[0]; break }
      bat { (bat -V).Split(' ', 3)[1]; break }
      binaryen { (wasm2js --version).Split(' ', 4)[2]; break }
      code { (code --version)[0]; break }
      copilot { (copilot -v)[0].Split(' ')[-1].TrimEnd('.'); break }
      deno { (deno -v).Split(' ', 2)[1].Split('+', 2)[0]; break }
      dsc { (dsc -V).Split([char[]]' -', 3)[1]; break }
      fzf { (fzf --version).Split(' ', 2)[0].Split('-', 2)[0]; break }
      flutter { (flutter --version)[0].Split(' ', 3)[1]; break }
      dotnet { (dotnet --version).Split('-', 2)[0]; break }
      gh { (gh version)[0].Split(' ', 4)[2]; break }
      ghostty { (ghostty --version)[0].Split(' ', 2)[1]; break }
      glow { (glow -v).Split(' ', 4)[2]; break }
      go { (go version).Split(' ', 4)[2].Substring(2); break }
      golangci-lint { (golangci-lint --version).Split(' ', 5)[3]; break }
      goreleaser { (goreleaser -v | Select-String -Raw -SimpleMatch GitVersion).Split(':', 2)[1].TrimStart(); break }
      pastel { (pastel -V).Split(' ', 3)[1]; break }
      less { (less --version 2>$null)[0].Split(' ', 3)[1] + '.0'; break }
      magick { (magick -version)[0].Split(' ', 4)[2].Replace('-', '.'); break }
      mold { (mold -v).Split(' ', 3)[1]; break }
      java { (java --version)[0].Split(' ', 3)[1]; break }
      jq { (jq -V).Split('-', 2)[1]; break }
      plantuml { (plantuml --version)[0].Split(' ', 4)[2]; break }
      pwsh { (pwsh -v).Split(' ', 2)[1].Split('-', 2)[0]; break }
      rg { (rg -V).Split(' ', 3)[1]; break }
      rustup { (rustup -V 2>$null).Split(' ', 3)[1]; break }
      tmux { (tmux -V).Split(' ', 2)[1] -creplace '\D+$', ''; break }
      ty { (ty -V).Split(' ', 3)[1]; break }
      uv { (uv -V).Split(' ', 3)[1]; break }
      vncviewer {
        if (Test-Path -LiteralPath $dataDir/jar/vncviewer.jar) {
          (java -jar $dataDir/jar/vncviewer.jar --version 2>&1)[1].ToString().Split(' ', 5)[3].Substring(1)
        }
        else {
          (vncviewer --version 2>&1)[1].ToString().Split(' ', 2)[1].Substring(1)
        }
        break
      }
      wabt { wat2wasm --version; break }
      wechat {
        if ($IsFedora) {
          (dnf list --installed wechat)[1].Split(' ')[1] -creplace '\.[^.]+$', ''
          break
        }
        break
      }
      xh { (https -V).Split(' ', 2)[1]; break }
      yq { (yq -V).Split(' ')[-1].Substring(1); break }
      { $_ -ceq 'localsend' -or
        $_ -ceq 'nerd-fonts' } {
        (Get-Content -Raw -LiteralPath $PSScriptRoot/releases.yml | ConvertFrom-Yaml | Where-Object name -CEQ $_).version
        break
      }
      default { (& $_ --version).Split(' ')[-1] -replace '^v', ''; break }
    }
  }
  catch {
    Write-Warning "cannot detect local version for $($Name)"
    '0.0.0'
  }
}

function updateLatestVersion ($Meta, [switch]$Force) {
  switch ($Meta.name) {
    bash {
      $html = Invoke-RestMethod 'https://tiswww.case.edu/php/chet/bash/bashtop.html'
      $Meta.version = [regex]::new('<a href="ftp://ftp.cwru.edu/pub/bash/bash-([\d.]+)\.tar\.gz">bash-\1</a>').Match($html).Groups[1].Value
      break
    }
    go {
      $data = Invoke-RestMethod 'https://golang.google.cn/dl/?mode=json'
      $Meta.tag = $data[0].version
      $Meta.version = $Meta.tag.Substring(2)
      $ext = switch ($true) {
        $IsWindows { '.msi'; break }
        $IsLinux { '.tar.gz'; break }
        $IsMacOS { '.pkg'; break }
        default { throw [System.NotImplementedException]::new() }
      }
      $Meta.file = '{0}.{1}-{2}{3}' -f $Meta.tag, $go.os, $go.arch, $ext
      $Meta.sha256 = ($data[0].files | Where-Object filename -CEQ $Meta.file).sha256
      break
    }
    flutter {
      $os = switch ($true) {
        $IsWindows { 'windows'; break }
        $IsLinux { 'linux'; break }
        $IsMacOS { 'macos'; break }
        default { throw [System.NotImplementedException]::new() }
      }
      $data = Invoke-RestMethod "https://storage.flutter-io.cn/flutter_infra_release/releases/releases_$os.json"
      $release = $data.releases | Where-Object hash -CEQ $data.current_release.($Meta.prerelease ? 'beta' : 'stable')
      $Meta.file = 'https://storage.flutter-io.cn/flutter_infra_release/releases/' + $release.archive
      $Meta.version = $release.version
      $Meta.sha256 = $release.sha256
      break
    }
    java {
      $os = switch ($true) {
        $IsWindows { 'windows'; break }
        $IsLinux { 'linux'; break }
        $IsMacOS { 'macos'; break }
        default { throw [System.NotImplementedException]::new() }
      }
      $arch = switch ([RuntimeInformation]::OSArchitecture) {
        'X64' { 'x64'; break }
        'Arm64' { 'aarch64'; break }
        default { throw [System.NotImplementedException]::new() }
      }
      $version = (Invoke-WebRequest 'https://jdk.java.net').Links[0].href
      $url = ((Invoke-WebRequest "https://jdk.java.net$version").Links | Where-Object href -CLike "https://download.java.net/java/GA/*/openjdk-*_$os-$arch*").href
      $Meta.url = $url[0]
      $Meta.sha256 = Invoke-RestMethod $url[1]
      $Meta.version = $url[0].Split('/', 7)[5].Substring(3)
      break
    }
    rustup {
      $prefix = $env:RUSTUP_UPDATE_ROOT ?? 'https://static.rust-lang.org/rustup'
      $Meta.version = (Invoke-RestMethod $prefix/release-stable.toml | ConvertFrom-Toml).version
      break
    }
    wechat {
      $html = Invoke-RestMethod 'https://linux.weixin.qq.com'
      $Meta.version = [regex]::new('<div class="main-section__bd-version" data-v-1556f5f1>([\d.]+)</div>').Match($html).Groups[1].Value
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
        binaryen { $tag.Split('_', 2)[1] + '.0'; break }
        bun { $tag.Substring(5); break }
        dsc { $tag.Split('-', 2)[0]; break }
        gswin64c { $tag.Substring(2, 2) + '.' + $tag.Substring(4, 2) + '.' + $tag.Substring(6); break }
        jq { $tag.Split('-', 2)[1]; break }
        less { $tag.Substring(6) + '.0'; break }
        magick { $tag.Replace('-', '.'); break }
        pwsh { $tag.Substring(1).Split('-', 2)[0]; break }
        tmux { $tag.Substring(1) -creplace '\D+$', ''; break }
        default { $tag -replace '^v', ''; break }
      }
      break
    }
  }
  if ($Force) {
    return $Meta
  }
  $version = getLocalVersion $Meta.name
  if ([version]$Meta.version -gt $version) {
    $Meta
    Write-Information "Upgrading $($Meta.name) from $version to $($Meta.version)"
  }
  else {
    Write-Warning "pkg $($Meta.name)@$version is already newer than $($Meta.version)"
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
  execute aria2c $Url -x2 -j32 "--file-allocation=$($IsWindows ? 'prealloc' : 'falloc')" -d $dir -o $file >> $buildDir/aria2c.log
}

function downloadRelease ($Meta, [string[]]$Name) {
  $Name.ForEach{
    if (Test-Path -LiteralPath $buildDir/$_) {
      execute aria2c "http://github.com/$($Meta.repo)/releases/download/$($Meta.tag)/$_" -c -x2 -j32 "--file-allocation=$($IsWindows ? 'prealloc' : 'falloc')" -d $buildDir >> $buildDir/aria2c.log
      return
    }
    execute gh release download -R $Meta.repo -p $_ -D $buildDir $Meta.tag
  }
}

function Install-Release {
  [CmdletBinding(SupportsShouldProcess)]
  param (
    [Parameter(Mandatory, Position = 0)]
    $Meta
  )
  if (!$PSCmdlet.ShouldProcess("$($Meta.name)@$($Meta.version)", 'install')) {
    return
  }
  Write-Debug "Installing $($Meta.name)@$($Meta.version) by tag $($Meta.tag)"
  $ext = $IsWindows ? '.zip' : '.tar.gz'
  $exe = $IsWindows ? '.exe' : ''
  switch ($Meta.name) {
    alacritty {
      if (!$IsLinux) {
        throw [System.NotImplementedException]::new()
      }
      cargo install alacritty@$($Meta.version)
      downloadRelease $Meta 'Alacritty.svg', 'alacritty.1.gz', 'alacritty-msg.1.gz', 'alacritty.5.gz', 'alacritty-bindings.5.gz', 'alacritty.bash', 'Alacritty.desktop'
      Move-Item -LiteralPath $buildDir/alacritty.1.gz, $buildDir/alacritty-msg.1.gz $dataDir/man/man1 -Force
      Move-Item -LiteralPath $buildDir/alacritty.5.gz, $buildDir/alacritty-bindings.5.gz $dataDir/man/man5 -Force
      Move-Item -LiteralPath $buildDir/alacritty.bash $dataDir/bash-completion/completions -Force
      Move-Item -LiteralPath $buildDir/Alacritty.desktop $dataDir/applications -Force
      update-desktop-database $dataDir/applications
      sudo mv $buildDir/Alacritty.svg /usr/share/pixmaps
      break
    }
    balenaEtcher {
      switch ($true) {
        $IsFedora {
          $file = "balena-etcher-$($Meta.version)-1.x86_64.rpm"
          downloadRelease $Meta $file
          sudo dnf install -y $buildDir/$file
          break
        }
        $IsUbuntu {
          $file = "balena-etcher_$($Meta.version)_amd64.deb"
          downloadRelease $Meta $file
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
      downloadFile "https://mirrors.tuna.tsinghua.edu.cn/gnu/bash/$file"
      downloadFile "https://mirrors.tuna.tsinghua.edu.cn/gnu/bash/$file.sig"
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
      downloadRelease $Meta $base$ext
      tar -xf $buildDir/$base$ext -C $buildDir --strip-components=1
      Move-Item -LiteralPath $buildDir/bat$exe $binDir -Force
      Move-Item -LiteralPath $buildDir/bat.1 $dataDir/man/man1 -Force
      break
    }
    binaryen {
      $os = switch ($true) {
        $IsLinux { 'linux'; break }
        $IsWindows { 'windows'; break }
        $IsMacOS { 'macos'; break }
        default { throw 'unknown os' }
      }
      $file = 'binaryen-{0}-{1}-{2}.tar.gz' -f $Meta.tag, $rust.arch, $os
      downloadRelease $Meta $file, $file`.sha256
      checkFileHash $buildDir/$file (Get-Content -Raw -LiteralPath $buildDir/$file`.sha256).Split(' ', 2)[0]
      tar -xf $buildDir/$file -C $prefixDir --strip-components=1
      break
    }
    bun {
      if (!$IsLinux) {
        throw [System.NotImplementedException]::new()
      }
      $arch = switch ([RuntimeInformation]::OSArchitecture) {
        'Arm64' { 'aarch64'; break }
        'X64' { 'x64'; break }
        default { throw [System.NotImplementedException]::new() }
      }
      $file = 'bun-{0}-{1}.zip' -f $go.os, $arch
      downloadRelease $Meta $file, SHASUMS256.txt
      checkFileHash $buildDir/$file (Get-Content -LiteralPath $buildDir/SHASUMS256.txt | Select-String -Raw -SimpleMatch $file).Split(' ', 2)[0]
      Expand-Archive -LiteralPath $buildDir/$file $buildDir -Force
      Move-Item -LiteralPath $buildDir/$(Split-Path -LeafBase $file)/bun $binDir -Force
      $null = New-Item -ItemType SymbolicLink -Force -Target bun $binDir/bunx
      break
    }
    cargo-generate {
      $file = 'cargo-generate-{0}-{1}.tar.gz' -f $Meta.tag, $rust.target
      downloadRelease $Meta $file
      tar -xf $buildDir/$file -C $binDir
      break
    }
    code {
      switch ($true) {
        $IsFedora {
          sudo dnf install -y 'https://update.code.visualstudio.com/latest/linux-rpm-x64/stable'
          break
        }
        ($IsUbuntu -or $IsRaspi) {
          $arch = [RuntimeInformation]::OSArchitecture.ToString().ToLowerInvariant()
          downloadFile "https://update.code.visualstudio.com/latest/linux-deb-$arch/stable" $buildDir/code.deb
          sudo dpkg -i $buildDir/code.deb
          break
        }
        default { throw [System.NotImplementedException]::new() }
      }
      break
    }
    copilot {
      $arch = [RuntimeInformation]::OSArchitecture.ToString().ToLowerInvariant()
      $file = if ($IsWindows) {
        'copilot-{0}.exe' -f $arch
      }
      else {
        'copilot-{0}-{1}.tar.gz' -f $rust.os, $arch
      }
      downloadRelease $Meta $file, SHA256SUMS.txt
      checkFileHash $buildDir/$file (Get-Content -LiteralPath $buildDir/SHA256SUMS.txt | Select-String -Raw -SimpleMatch $file).Split(' ', 2)[0]
      if ($IsWindows) {
        Invoke-Sudo Install-MSIProduct -LiteralPath $buildDir/$file
        break
      }
      tar -xf $buildDir/$file -C $binDir
      break
    }
    crush {
      $file = switch ($true) {
        $IsWindows { 'crush_{0}_Windows_{1}.zip' -f $Meta.version, [RuntimeInformation]::OSArchitecture.ToString().ToLowerInvariant(); break }
        $IsMacOS { 'crush_{0}_Darwin_{1}.tar.gz' -f $Meta.version, [RuntimeInformation]::OSArchitecture.ToString().ToLowerInvariant(); break }
        $IsFedora { 'crush-{0}-{1}-1.rpm' -f $Meta.version, $rust.arch; break }
        ($IsUbuntu -or $IsRaspi) { 'crush_{0}_{1}.deb' -f $Meta.version, $go.arch; break }
        default { throw [System.NotImplementedException]::new() }
      }
      downloadRelease $Meta $file, checksums.txt
      checkFileHash $buildDir/$file (Get-Content -LiteralPath $buildDir/checksums.txt | Select-String -Raw -SimpleMatch $file).Split(' ', 2)[0]
      switch ($true) {
        $IsWindows { Expand-Archive -LiteralPath $buildDir/$file $binDir -Force; break }
        $IsMacOS { tar -xf $buildDir/$file -C $binDir; chmod +x $binDir/crush; break }
        $IsFedora { sudo dnf install -y $buildDir/$file; break }
        ($IsUbuntu -or $IsRaspi) { sudo dpkg -i $buildDir/$file; break }
      }
      break
    }
    deno {
      if ($IsWindows) {
        throw [System.NotImplementedException]::new()
      }
      $file = 'deno-{0}.zip' -f $rust.target
      downloadRelease $Meta $file, $file`.sha256sum
      checkFileHash $buildDir/$file (Get-Content -Raw -LiteralPath $buildDir/$file`.sha256sum).Split(' ', 2)[0]
      Expand-Archive -LiteralPath $buildDir/$file $binDir -Force
      break
    }
    diskus {
      $base = 'diskus-{0}-{1}' -f $Meta.tag, $rust.target
      downloadRelease $Meta $base$ext
      tar -xf $buildDir/$base$ext -C $buildDir --strip-components=1
      Move-Item -LiteralPath $buildDir/diskus$exe $binDir -Force
      Move-Item -LiteralPath $buildDir/diskus.1 $dataDir/man/man1 -Force
      break
    }
    dotnet {
      $ChannelQuality = $Meta.prerelease ? '11.0/preview' : '10.0'
      $os, $ext = switch ($true) {
        $IsWindows { 'win', '.exe'; break }
        $IsMacOS { 'osx', '.pkg'; break }
        $IsLinux { 'linux', '.tar.gz'; break }
        default { throw [System.NotImplementedException]::new() }
      }
      $file = 'dotnet-sdk-{0}-{1}{2}' -f $os, [RuntimeInformation]::OSArchitecture.ToString().ToLowerInvariant(), $ext
      downloadFile "https://aka.ms/dotnet/$ChannelQuality/$file"
      switch ($true) {
        $IsWindows { sudo $buildDir/$file; break }
        $IsMacOS { sudo installer -pkg $buildDir/$file -dumplog > Temp:/$file`.log; break }
        $IsLinux {
          sudo rm -rf $sudoPrefixDir/dotnet
          sudo mkdir -p $sudoPrefixDir/dotnet
          sudo tar -xf $buildDir/$file -C $sudoPrefixDir/dotnet
          sudo ln -sf $sudoPrefixDir/dotnet/dotnet $sudoPrefixDir/dotnet/dnx $sudoBinDir
          sudo mkdir -p /etc/dotnet
          $null = "$sudoPrefixDir/dotnet" | sudo tee /etc/dotnet/install_location_x64
          break
        }
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
      downloadRelease $Meta $base$ext
      tar -xf $buildDir/$base$ext -C (New-EmptyDir $prefixDir/dsc)
      installBinary $prefixDir/dsc/dsc$exe
      break
    }
    edit {
      switch ($true) {
        $IsWindows {
          $base = 'edit-{0}-{1}-windows' -f $Meta.version, $rust.arch
          downloadRelease $Meta $base`.zip
          Expand-Archive -LiteralPath $buildDir/$base`.zip $buildDir -Force
          break
        }
        $IsLinux {
          break # FIXME: after edit-1.2.1
          $base = 'edit-{0}-{1}-linux-gnu' -f $Meta.version, $rust.arch
          downloadRelease $Meta $base`.tar.zst
          tar -xf $buildDir/$base`.tar.zst --zstd -C $buildDir
          break
        }
        default { throw [System.NotImplementedException]::new() }
      }
      Move-Item -LiteralPath $buildDir/edit$exe $binDir -Force
      break
    }
    fd {
      $base = 'fd-{0}-{1}' -f $Meta.tag, $rust.target
      downloadRelease $Meta $base$ext
      tar -xf $buildDir/$base$ext -C $buildDir
      Move-Item -LiteralPath $buildDir/$base/fd$exe $binDir -Force
      Move-Item -LiteralPath $buildDir/$base/fd.1 $dataDir/man/man1 -Force
      Move-Item -LiteralPath $buildDir/$base/autocomplete/fd.bash $dataDir/bash-completion/completions -Force
      break
    }
    flutter {
      if (Get-Command flutter -CommandType Application -TotalCount 1 -ea Ignore) {
        flutter upgrade --force
        break
      }
      downloadFile $Meta.file
      $file = [System.IO.Path]::GetFileName($Meta.file)
      checkFileHash $buildDir/$file $Meta.sha256
      Remove-Item -LiteralPath $prefixDir/flutter -Recurse -Force -ea Ignore
      tar -xf $buildDir/$file -C $prefixDir
      $baseDir = "$prefixDir/flutter/bin"
      $exe = $IsWindows ? '.bat' : ''
      installBinary $baseDir/flutter$exe, $baseDir/flutter-dev$exe, $baseDir/dart$exe
      break
    }
    fzf {
      $base = 'fzf-{0}-{1}_{2}' -f $Meta.version, $go.os, $go.arch
      downloadRelease $Meta $base$ext
      tar -xf $buildDir/$base$ext -C $binDir
      break
    }
    gh {
      if (!$IsLinux) {
        throw [System.NotImplementedException]::new()
      }
      $file = 'gh_{0}_{1}_{2}' -f $Meta.version, $go.os, $go.arch
      if ($IsFedora) {
        $file += '.rpm'
        downloadRelease $Meta $file
        sudo dnf install -y $buildDir/$file
      }
      elseif ($IsUbuntu -or $IsRaspi) {
        $file += '.deb'
        downloadRelease $Meta $file
        sudo apt install -y $buildDir/$file
      }
      break
    }
    ghostty {
      switch ($true) {
        $IsMacOS {
          downloadFile "https://release.files.ghostty.org/$($Meta.version)/Ghostty.dmg"
          sudo installer -pkg $buildDir/Ghostty.dmg -dumplog > Temp:/$file`.log
          break
        }
        $IsFedora {
          sudo dnf copr enable scottames/ghostty
          sudo dnf install -y ghostty
          break
        }
        $IsLinux {
          $file = 'Ghostty-{0}-{1}.AppImage' -f $Meta.version, $rust.arch
          downloadRelease $file
          Move-Item -LiteralPath $buildDir/$file $binDir/ghostty -Force
          chmod +x $binDir/ghostty
          break
        }
        default { throw [System.NotImplementedException]::new() }
      }
    }
    glow {
      $os = switch ($true) {
        $IsWindows { 'Windows'; break }
        $IsLinux { 'Linux'; break }
        $IsMacOS { 'Darwin'; break }
        default { throw [System.NotImplementedException]::new() }
      }
      $arch = switch ([RuntimeInformation]::OSArchitecture) {
        'Arm64' { 'arm64'; break }
        'X64' { 'x86_64'; break }
        default { throw [System.NotImplementedException]::new() }
      }
      $base = 'glow_{0}_{1}_{2}' -f $Meta.version, $os, $arch
      downloadRelease $Meta $base$ext
      tar -xf $buildDir/$base$ext -C $buildDir --strip-components=1
      Move-Item -LiteralPath $buildDir/glow$exe $binDir -Force
      Move-Item -LiteralPath $buildDir/manpages/glow.1.gz $dataDir/man/man1 -Force
      Move-Item -LiteralPath $buildDir/completions/glow.bash $dataDir/bash-completion/completions -Force
      break
    }
    go {
      $file = $Meta.file
      downloadFile "https://golang.google.cn/dl/$file"
      checkFileHash $buildDir/$file $Meta.sha256
      switch ($true) {
        $IsWindows {
          Invoke-Sudo Install-MSIProduct -LiteralPath $buildDir/$file
          break
        }
        $IsLinux {
          sudo rm -rf $sudoPrefixDir/go
          sudo tar -xf $buildDir/$file -C $sudoPrefixDir
          sudo ln -sf $sudoPrefixDir/go/bin/go $sudoPrefixDir/go/bin/gofmt $sudoBinDir
          break
        }
        $IsMacOS {
          sudo installer -pkg $buildDir/$file -dumplog > Temp:/$file`.log
          break
        }
        default { throw [System.NotImplementedException]::new() }
      }
      break
    }
    golangci-lint {
      $base = 'golangci-lint-{0}-{1}-{2}' -f $Meta.version, $go.os, $go.arch
      $ext = switch ($true) {
        $IsWindows { '.zip'; break }
        $IsFedora { '.rpm'; break }
        ($IsUbuntu -or $IsRaspi) { '.deb'; break }
        default { '.tar.gz'; break }
      }
      downloadRelease $Meta $base$ext, "golangci-lint-$($Meta.version)-checksums.txt"
      checkFileHash $buildDir/$base$ext (Get-Content -LiteralPath $buildDir/"golangci-lint-$($Meta.version)-checksums.txt" | Select-String -Raw -SimpleMatch $base$ext).Split(' ', 2)[0]
      switch ($true) {
        $IsFedora { sudo dnf install -y $buildDir/$base$ext; break }
        ($IsUbuntu -or $IsRaspi) { sudo dpkg -i $buildDir/$base$ext; break }
        default {
          tar -xf $buildDir/$base$ext -C $buildDir
          Move-Item -LiteralPath $buildDir/$base/golangci-lint$exe $binDir -Force
          break
        }
      }
      break
    }
    goreleaser {
      $os = $go.os.Substring(0, 1).ToUpperInvariant() + $go.os.Substring(1)
      $base = 'goreleaser_{0}_{1}' -f $os, $rust.arch
      downloadRelease $Meta $base$ext
      tar -xf $buildDir/$base$ext -C $buildDir
      Move-Item -LiteralPath $buildDir/goreleaser$exe $binDir -Force
      Move-Item -LiteralPath $buildDir/manpages/goreleaser.1.gz $dataDir/man/man1 -Force
      Move-Item -LiteralPath $buildDir/completions/goreleaser.bash $dataDir/bash-completion/completions -Force
      break
    }
    gswin64c {
      if (!$IsWindows -or [RuntimeInformation]::OSArchitecture -cne 'X64') {
        throw [System.NotImplementedException]::new()
      }
      $file = '{0}w64.exe' -f $Meta.tag
      downloadRelease $Meta $file
      sudo $buildDir/$file
      break
    }
    hexyl {
      $base = 'hexyl-{0}-{1}' -f $Meta.tag, $rust.target
      downloadRelease $Meta $base$ext
      tar -xf $buildDir/$base$ext -C $buildDir
      Move-Item -LiteralPath $buildDir/$base/hexyl$exe $binDir -Force
      Move-Item -LiteralPath $buildDir/$base/hexyl.1 $dataDir/man/man1 -Force
      break
    }
    hyperfine {
      $base = 'hyperfine-{0}-{1}' -f $Meta.tag, $rust.target
      downloadRelease $Meta $base$ext
      tar -xf $buildDir/$base$ext -C $buildDir
      Move-Item -LiteralPath $buildDir/$base/hyperfine$exe $binDir -Force
      Move-Item -LiteralPath $buildDir/$base/hyperfine.1 $dataDir/man/man1 -Force
      break
    }
    java {
      if (!$IsLinux) {
        throw [System.NotImplementedException]::new()
      }
      downloadFile $Meta.url
      $file = Split-Path -Leaf $Meta.url
      checkFileHash $buildDir/$file $Meta.sha256
      sudo tar -xf $buildDir/$file -C $sudoPrefixDir
      sudo ln -sf $sudoPrefixDir/jdk-$($Meta.version)/bin/java $binDir
      sudo ln -sf $sudoPrefixDir/jdk-$($Meta.version)/bin/javac $binDir
      break
    }
    jq {
      $os = switch ($true) {
        $IsLinux { 'linux'; break }
        $IsWindows { 'windows'; break }
        $IsMacOS { 'macos'; break }
        default { throw [System.NotImplementedException]::new() }
      }
      $file = 'jq-{0}-{1}{2}' -f $os, $go.arch, $exe
      downloadRelease $Meta $file
      Move-Item -LiteralPath $buildDir/$file $binDir/jq$exe -Force
      if (!$IsWindows) {
        chmod +x $binDir/jq
      }
      downloadFile "https://github.com/$($Meta.repo)/raw/HEAD/jq.1.prebuilt" $dataDir/man/man1/jq.1
      break
    }
    less {
      if (!$IsLinux) {
        throw [System.NotImplementedException]::new()
      }
      $base = 'less-{0}' -f $Meta.version.Split('.', 2)[0]
      downloadFile "http://www.greenwoodsoftware.com/less/$base.tar.gz"
      downloadFile "http://www.greenwoodsoftware.com/less/$base.sig"
      gpg --verify $buildDir/$base`.sig $buildDir/$base`.tar.gz
      tar -xf $buildDir/$base`.tar.gz -C $buildDir
      Push-Location -LiteralPath $buildDir/$base
      try {
        ./configure --with-editor=edit --with-regex=pcre2
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
      downloadRelease $Meta $base$ext
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
    magick {
      if (!$IsLinux -or [RuntimeInformation]::OSArchitecture -cne 'X64') {
        throw [System.NotImplementedException]::new()
      }
      $pattern = 'ImageMagick-*-gcc-x86_64.AppImage'
      downloadRelease $Meta $pattern
      Move-Item $buildDir/$pattern $binDir/magick -Force
      chmod +x $binDir/magick
      break
    }
    mdbook {
      $base = 'mdbook-{0}-{1}' -f $Meta.tag, $rust.target
      downloadRelease $Meta $base$ext
      tar -xf $buildDir/$base$ext -C $binDir
      break
    }
    mkcert {
      $file = 'mkcert-{0}-{1}-{2}{3}' -f $Meta.tag, $go.os, $go.arch, $exe
      downloadRelease $Meta $file
      Move-Item -LiteralPath $buildDir/$file $binDir/mkcert$exe
      if (!$IsWindows) {
        chmod +x $binDir/mkcert
      }
      break
    }
    mold {
      if (!$IsLinux) {
        throw [System.NotImplementedException]::new()
      }
      $base = 'mold-{0}-{1}-{2}' -f $Meta.version, $rust.arch, $rust.os
      downloadRelease $Meta $base$ext
      sudo tar -xf $buildDir/$base$ext -C $sudoPrefixDir --strip-components=1
      break
    }
    nerd-fonts {
      downloadRelease $Meta 0xProto.zip
      Expand-Archive -LiteralPath $buildDir/0xProto.zip $buildDir -Force
      switch ($true) {
        $IsWindows {
          $shellApp = New-Object -ComObject shell.application
          $fonts = $shellApp.NameSpace(0x14)
          Convert-Path $buildDir/0xProtoNerdFont*.ttf | ForEach-Object { $fonts.MoveHere($_) }
          break
        }
        $IsLinux {
          sudo mv $buildDir/0xProtoNerdFont*.ttf /usr/share/fonts/truetype/
          sudo fc-cache -v
          break
        }
        default { throw [System.NotImplementedException]::new() }
      }
      break
    }
    node {
      $arch = switch ([RuntimeInformation]::OSArchitecture) {
        'X64' { 'x64'; break }
        'Arm64' { 'arm64'; break }
        default { throw [System.NotImplementedException]::new() }
      }
      $file = switch ($true) {
        $IsWindows { "node-$($Meta.tag)-$arch.msi"; break }
        $IsLinux { "node-$($Meta.tag)-linux-$arch.tar.xz"; break }
        $IsMacOS { "node-$($Meta.tag).pkg"; break }
        default { throw [System.NotImplementedException]::new() }
      }
      downloadFile "https://nodejs.org/dist/$($Meta.tag)/$file"
      switch ($true) {
        $IsWindows { Invoke-Sudo Install-MSIProduct -LiteralPath $buildDir/$file; break }
        $IsMacOS { sudo installer -pkg $buildDir/$file -dumplog > Temp:/$file`.log; break }
        $IsLinux {
          $root = "$prefixDir/nodejs/$($Meta.tag)"
          tar -xf $buildDir/$file -C (New-EmptyDir $root) --strip-components=1
          installBinary $root/bin/node, $root/bin/npm
          break
        }
      }
    }
    numbat {
      $base = 'numbat-{0}-{1}' -f $Meta.tag, $rust.target
      downloadRelease $Meta $base$ext
      tar -xf $buildDir/$base$ext -C (New-EmptyDir $prefixDir/numbat) --strip-components=1
      installBinary $prefixDir/numbat/numbat$exe
      break
    }
    pastel {
      $base = 'pastel-{0}-{1}' -f $Meta.tag, $rust.target
      downloadRelease $Meta $base$ext
      tar -xf $buildDir/$base$ext -C $buildDir
      Move-Item -LiteralPath $buildDir/$base/pastel$exe $binDir -Force
      Move-Item -LiteralPath $buildDir/$base/autocomplete/pastel.bash $dataDir/bash-completion/completions -Force
      Move-Item $buildDir/$base/man/* $dataDir/man/man1 -Force
      break
    }
    plantuml {
      $file = 'plantuml-gplv2-{0}.jar' -f $Meta.version
      downloadRelease $Meta $file
      Move-Item -LiteralPath $buildDir/$file $dataDir/jar/plantuml.jar -Force
      installBinary $dataDir/jar/plantuml.jar
      break
    }
    pwsh {
      $id = $Meta.tag.Substring(1)
      $arch = [RuntimeInformation]::OSArchitecture.ToString().ToLowerInvariant()
      switch ($true) {
        $IsWindows {
          $file = 'PowerShell-{0}-win-{1}.msi' -f $id, $arch
          downloadRelease $Meta $file
          Invoke-Sudo Install-MSIProduct -LiteralPath $buildDir/$file
          break
        }
        $IsMacOS {
          $file = 'powershell-{0}-osx-{1}.pkg' -f $id, $arch
          downloadRelease $Meta $file
          sudo installer -pkg $buildDir/$file -dumplog > Temp:/$file`.log
          break
        }
        $IsLinux {
          $file = 'powershell-{0}-linux-{1}.tar.gz' -f $id, $arch
          downloadRelease $Meta $file
          $baseDir = '/opt/microsoft/powershell/7'
          sudo rm -rf $baseDir
          sudo mkdir -p $baseDir
          sudo tar -xf $buildDir/$file -C $baseDir
          sudo chmod +x $baseDir/pwsh
          sudo ln -sf $baseDir/pwsh $binDir
          break
        }
        default { throw [System.NotImplementedException]::new() }
      }
      break
    }
    rg {
      $target = $rust.target
      if ($rust.arch -ceq 'x86_64') {
        $target = $target -creplace '-gnu$', '-musl'
      }
      $base = 'ripgrep-{0}-{1}' -f $Meta.tag, $target
      downloadRelease $Meta $base$ext, $base$ext`.sha256
      checkFileHash $buildDir/$base$ext (Get-Content -Raw -LiteralPath $buildDir/$base$ext`.sha256).Split(' ', 2)[0]
      tar -xf $buildDir/$base$ext -C $buildDir
      Move-Item -LiteralPath $buildDir/$base/rg$exe $binDir -Force
      Move-Item -LiteralPath $buildDir/$base/doc/rg.1 $dataDir/man/man1 -Force
      Move-Item -LiteralPath $buildDir/$base/complete/rg.bash $dataDir/bash-completion/completions -Force
      break
    }
    rga {
      if ($IsWindows) {
        cargo install ripgrep_all
        break
      }
      $base = 'ripgrep_all-{0}-{1}' -f $Meta.tag, ($rust.arch -ceq 'x86_64' ? $rust.target -creplace '-gnu$', '-musl' : $rust.target)
      downloadRelease $Meta $base$ext
      tar -xf $buildDir/$base$ext -C $buildDir
      [string[]]$files = 'rga', 'rga-fzf', 'rga-fzf-open', 'rga-preproc'
      $files = $files.ForEach{ "$buildDir/$base/$_$exe" }
      Move-Item -LiteralPath $files $binDir -Force
      break
    }
    rustup {
      if (Get-Command rustup -CommandType Application -TotalCount 1 -ea Ignore) {
        rustup self update
        break
      }
      if ($IsWindows) {
        throw [System.NotImplementedException]::new()
      }
      curl -sSf https://sh.rustup.rs | bash -s `-- -y
      break
    }
    taplo {
      $base = 'taplo-{0}-{1}' -f $go.os, $rust.arch
      downloadRelease $Meta $base`.gz
      gzip -df $buildDir/$base`.gz
      Move-Item -LiteralPath $buildDir/$base$exe $binDir/taplo$exe -Force
      if (!$IsWindows) {
        chmod +x $binDir/taplo
      }
      break
    }
    tmux {
      if ($IsWindows) {
        throw [System.NotImplementedException]::new()
      }
      $os = $IsMacOS ? 'macos' : 'linux'
      $base = 'tmux-{0}-{1}-{2}' -f $Meta.tag.Substring(1), $os, $rust.arch
      downloadRelease $Meta $base$ext
      tar -xf $buildDir/$base$ext -C $binDir
      break
    }
    tree-sitter {
      $os = switch ($true) {
        $IsLinux { 'linux'; break }
        $IsWindows { 'windows'; break }
        $IsMacOS { 'macos'; break }
        default { throw [System.NotImplementedException]::new() }
      }
      $base = 'tree-sitter-{0}-{1}' -f $os, [RuntimeInformation]::OSArchitecture.ToString().ToLowerInvariant()
      downloadRelease $Meta $base`.gz
      gzip -df $buildDir/$base`.gz
      Move-Item -LiteralPath $buildDir/$base $binDir/tree-sitter$exe -Force
      if (!$IsWindows) {
        chmod +x $binDir/tree-sitter
      }
      break
    }
    vncviewer {
      $file = if ($IsWindows) {
        switch ([RuntimeInformation]::OSArchitecture) {
          'X64' { 'vncviewer64-{0}.exe' -f $Meta.version; break }
          'X86' { 'vncviewer-{0}.exe' -f $Meta.version; break }
        }
      }
      $file ??= 'VncViewer-{0}.jar' -f $Meta.version
      $target = $file.EndsWith('.jar') ? "$dataDir/jar/vncviewer.jar" : "$binDir/vncviewer.exe"
      downloadFile "https://sourceforge.net/projects/tigervnc/files/stable/$($Meta.version)/$file/download" $target
      installBinary $target
      break
    }
    wabt {
      $os = switch ($true) {
        $IsLinux { 'linux'; break }
        $IsWindows { 'windows'; break }
        $IsMacOS { 'macos'; break }
        default { throw [System.NotImplementedException]::new() }
      }
      $file = 'wabt-{0}-{1}-{2}.tar.gz' -f $Meta.tag, $os, [RuntimeInformation]::OSArchitecture.ToString().ToLowerInvariant()
      downloadRelease $Meta $file
      tar -xf $buildDir/$file -C $prefixDir --strip-components=1
      break
    }
    wasm-bindgen {
      $base = 'wasm-bindgen-{0}-{1}' -f $Meta.tag, ($rust.target -creplace '-gnu$', '-musl')
      $file = "$base.tar.gz"
      downloadRelease $Meta $file, $file`.sha256sum
      checkFileHash $buildDir/$file (Get-Content -Raw -LiteralPath $buildDir/$file`.sha256sum).Split(' ', 2)[0]
      tar -xf $buildDir/$file -C $buildDir
      Move-Item -LiteralPath $buildDir/$base/wasm-*$exe $binDir -Force
      break
    }
    wasm-pack {
      $base = 'wasm-pack-{0}-{1}' -f $Meta.tag, ($rust.target -creplace '-gnu$', '-musl')
      downloadRelease $Meta $base`.tar.gz
      tar -xf $buildDir/$base`.tar.gz -C $buildDir
      Move-Item -LiteralPath $buildDir/$base/wasm-pack$exe $binDir -Force
      break
    }
    wechat {
      if (!$IsLinux) {
        throw [System.NotImplementedException]::new()
      }
      $arch = switch ([RuntimeInformation]::OSArchitecture) {
        'X64' { 'x86_64'; break }
        'Arm64' { 'arm64'; break }
        default { throw [System.NotImplementedException]::new() }
      }
      $ext = switch ($true) {
        $IsFedora { '.rpm'; break }
        $IsUbuntu { '.deb'; break }
        default { '.appimage'; break }
      }
      $file = "WeChatLinux_$arch$ext"
      downloadFile https://dldir1v6.qq.com/weixin/Universal/Linux/$file
      switch ($true) {
        $IsFedora { sudo dnf install -y $buildDir/$file; break }
        $IsUbuntu { sudo dpkg -i $buildDir/$file; break }
        default { Move-Item -LiteralPath $buildDir/$file $binDir/wechat -Force; chmod +x $binDir/wechat; break }
      }
      break
    }
    yq {
      $base = 'yq_{0}_{1}' -f $go.os, $go.arch
      downloadRelease $Meta $base$ext
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
    { $_ -ceq 'uv' -or $_ -ceq 'ruff' -or $_ -ceq 'ty' } {
      if ($IsWindows) {
        throw [System.NotImplementedException]::new()
      }
      $base = '{0}-{1}' -f $_, $rust.target
      downloadRelease $Meta $base$ext
      tar -xf $buildDir/$base$ext -C $buildDir
      Move-Item -LiteralPath $buildDir/$base/$_$exe $binDir -Force
      if ($_ -ceq 'uv') {
        Move-Item -LiteralPath $buildDir/$base/uvx$exe $binDir -Force
        if ($IsWindows) {
          Move-Item -LiteralPath $buildDir/$base/uvw$exe $binDir -Force
        }
      }
      break
    }
    default { throw "no install method for $_" }
  }
  $version = getLocalVersion $Meta.name
  if ($version -cne $Meta.version) {
    Write-Warning "expected $($Meta.name) installed version $($Meta.version), but got $version"
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
        (Get-Content -Raw -LiteralPath $PSScriptRoot/releases.yml | ConvertFrom-Yaml | Where-Object name -Like $WordToComplete*).name
      })]
    [Parameter(Position = 0)]
    [string[]]
    $Name,
    [Parameter()]
    [switch]
    $Force
  )
  $pkgMap = [ordered]@{}
  Get-Content -Raw -LiteralPath $PSScriptRoot/releases.yml | ConvertFrom-Yaml | ForEach-Object { $pkgMap[$_.name] = $_ }
  $Name ??= $pkgMap.Keys
  $Name | ForEach-Object {
    if (!$pkgMap.Contains($_)) {
      throw "unknown pkg $_"
    }
    updateLatestVersion $pkgMap[$_] -Force:$Force
  } | ForEach-Object { Install-Release $_ } -ea 'Continue'
  $pkgMap.Values | ConvertTo-Yaml > $PSScriptRoot/releases.yml
}

function Update-Software {
  [CmdletBinding(SupportsShouldProcess)]
  param (
    [Parameter()]
    [ArgumentCompleter({
        param (
          [string]$CommandName,
          [string]$ParameterName,
          [string]$WordToComplete
        )
        (Get-Content -Raw -LiteralPath $PSScriptRoot/globalTools.yml | ConvertFrom-Yaml).Keys.Where{ !$_.Contains('-') -and $_ -like "$WordToComplete*" }
      })]
    [string[]]
    $Category,
    [Parameter()]
    [switch]
    $Global,
    [Parameter()]
    [switch]
    $Force
  )
  $pkgMap = Get-Content -Raw -LiteralPath $PSScriptRoot/globalTools.yml | ConvertFrom-Yaml
  [string[]]$pkgs = @()
  switch ($Category) {
    { $true } { $pkgs = $pkgMap[$_] }
    apt {
      sudo apt update
      sudo apt install -f
      sudo apt upgrade -y --auto-remove
      if ($IsUbuntu) {
        sudo snap refresh
      }
      if (!$Force) {
        continue
      }
      if ($IsWSL) {
        if (!$pkgMap['apt-wsl']) {
          continue
        }
        $pkgs = $pkgMap['apt-wsl']
      }
      elseif ($IsRaspi) {
        if (!$pkgMap['apt-raspi']) {
          continue
        }
        $pkgs = $pkgMap['apt-raspi']
      }
      if ($pkgs) {
        sudo apt install -y $pkgs
      }
      continue
    }
    brew {
      if (!$IsMacOS) {
        Write-Warning 'using homebrew on non-macos system is not recommanded'
      }
      if (!(Get-Command brew -CommandType Application -TotalCount 1 -ea Ignore)) {
        downloadFile 'https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh'
        sudo bash $buildDir/install.sh
      }
      brew update
      brew upgrade -y
      if ($Force) {
        brew install -y $pkgs
        brew install -y --cask $pkgMap['brew-cask']
      }
      brew cleanup
      continue
    }
    bun {
      if ($Global) {
        $PSNativeCommandUseErrorActionPreference = $false
        # this fails with code 1 when there is nothing to update
        bun update -g --latest
        $PSNativeCommandUseErrorActionPreference = $true
        if ($Force -and $pkgs) {
          bun add -g --trust --omit=optional $pkgs
        }
        continue
      }
      bun update
      continue
    }
    cargo {
      if ($Global) {
        if (!(Get-Command cargo-install-update -CommandType Application -TotalCount 1 -ea Ignore)) {
          cargo install cargo-update
        }
        cargo install-update --all
        if ($Force -and $pkgs) {
          cargo install-update -i $pkgs
        }
        continue
      }
      cargo update
      continue
    }
    code { code --update-extensions; continue }
    deno {
      if ($Global) {
        deno upgrade
        deno jupyter --install
        if ($Force -and $pkgs) {
          deno install --global $pkgs
        }
        continue
      }
      deno update
      continue
    }
    dnf {
      sudo dnf upgrade -y
      if ($Force) {
        if ($IsWSL) {
          if (!$pkgMap['dnf-wsl']) {
            continue
          }
          $pkgs = $pkgMap['dnf-wsl']
        }
        if ($pkgs) {
          sudo dnf install -y $pkgs
        }
      }
      continue
    }
    flutter {
      if ($Global) {
        flutter upgrade --force
        if ($Force -and $pkgs) {
          flutter pub global activate $pkgs.ForEach{ "$_@latest" }
        }
        continue
      }
      flutter pub upgrade
      continue
    }
    gh {
      gh extension upgrade --all
      if ($Force -and $pkgs) {
        gh extension install $pkgs
      }
      continue
    }
    go {
      if ($Global) {
        $binDir = go env GOBIN
        if (!$binDir) {
          $binDir = [System.IO.Path]::Join((go env GOPATH), 'bin')
        }
        Convert-Path $binDir/* -ea Ignore | ForEach-Object {
          go install ((go version -m $_)[1].Split("`t")[-1] + '@latest')
        }
        if ($Force) {
          $pkgs.ForEach{ go install "$_@latest" }
        }
        continue
      }
      go get -u ./...
      go mod tidy
      continue
    }
    npm {
      if ($Global) {
        npm up -g
        if ($Force -and $pkgs) {
          npm add -g $pkgs
        }
        continue
      }
      npm up
      continue
    }
    pnpm {
      if ($Global) {
        Start-Process pnpm self-update -WorkingDirectory $HOME -NoNewWindow -Wait
        pnpm up -g
        if ($Force -and $pkgs) {
          pnpm add -g $pkgs
        }
        continue
      }
      pnpm self-update
      pnpm up
      continue
    }
    ps1 {
      Update-Script
      if ($Force -and $pkgs) {
        Install-Script $pkgs
      }
    }
    psm1 {
      if (Update-Module -AcceptLicense -PassThru) {
        Clear-Module
      }
      if ($Force -and $pkgs) {
        Install-Module $pkgs
      }
      continue
    }
    rustup {
      rustup update
      if ($Force -and $pkgs) {
        if ($pkgMap['rustup-components']) {
          $pkgs += @('--component', ($pkgMap['rustup-components'] -join ','))
        }
        if ($pkgMap['rustup-targets']) {
          $pkgs += @('--target', ($pkgMap['rustup-targets'] -join ','))
        }
        rustup toolchain install $pkgs
      }
      continue
    }
    uv {
      if ($Global) {
        uv tool upgrade --all
        if ($Force) {
          $pkgMap['uv-python'].ForEach{ uv python install $_ }
          $pkgs.ForEach{ uv tool install $_ }
        }
        continue
      }
      uv sync --upgrade
      continue
    }
    winget {
      if (!$IsWindows) {
        Write-Warning 'calling winget on non-Windows platform'
        continue
      }
      sudo winget upgrade -r --accept-package-agreements
      if ($Force -and $pkgs) {
        sudo winget install --accept-package-agreements $pkgs
      }
      continue
    }
    { $_ -ceq 'windows' -or $_ -ceq 'macos' -or $_ -ceq 'fedora' -or $_ -ceq 'ubuntu' -or $_ -ceq 'wsl' -or $_ -ceq 'raspi' } {
      if ($pkgs) {
        Update-Release $pkgs
      }
      continue
    }
    default { throw [System.NotImplementedException]::new() }
  }
}

function Update-System {
  if ($IsWindows) {
    Update-Software winget, windows -Force
  }
  elseif ($IsMacOS) {
    Update-Software brew, macos -Force
  }
  elseif ($IsLinux) {
    if ($PSVersionTable.OS.StartsWith('Ubuntu')) {
      Update-Software apt, ubuntu -Force
    }
    elseif ($PSVersionTable.OS.StartsWith('Fedora')) {
      Update-Software dnf, fedora -Force
    }
    elseif ($PSVersionTable.OS.StartsWith('Debian') -and
      [RuntimeInformation]::OSArchitecture -eq [Architecture]::Arm64) {
      Update-Software apt, raspi -Force
    }
  }
  else {
    throw [System.NotImplementedException]::new()
  }
  Update-Software bun, rustup, cargo, go, psm1, uv -Global -Force
  if (!$IsRaspi) {
    Update-Software code, flutter -Global -Force
  }
}

$go = goenv
$rust = rustenv
$buildDir = [System.IO.Path]::TrimEndingDirectorySeparator([System.IO.Path]::GetTempPath())
if ($IsLinux) {
  $IsUbuntu = $PSVersionTable.OS.StartsWith('Ubuntu')
  $IsFedora = $PSVersionTable.OS.StartsWith('Fedora')
  $IsRaspi = $PSVersionTable.OS.StartsWith('Debian') -and [RuntimeInformation]::OSArchitecture -eq [Architecture]::Arm64
  $IsWSL = Test-Path -LiteralPath Env:/WSL_DISTRO_NAME
}

$prefixDir = $IsWindows ? "$env:LOCALAPPDATA\prefix" : "$HOME/.local"
$dataDir = [System.IO.Path]::Join($prefixDir, 'share')
$binDir = [System.IO.Path]::Join($prefixDir, 'bin')

$sudoPrefixDir = $IsWindows ? "$env:ProgramData\prefix" : '/usr/local'
$sudoDataDir = [System.IO.Path]::Join($sudoPrefixDir, 'share')
$sudoBinDir = [System.IO.Path]::Join($sudoPrefixDir, 'bin')
