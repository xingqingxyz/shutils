using namespace System.Runtime.InteropServices

$ErrorActionPreference = 'Stop'
$PSNativeCommandUseErrorActionPreference = $true

#region exports
function Update-Release {
  [CmdletBinding()]
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
  $Name.ForEach{
    if (!$pkgMap.Contains($_)) {
      return Write-Warning "skipping unknown pkg $_"
    }
    if (Update-LatestVersion $pkgMap[$_] -Force:$Force) {
      Install-Release $pkgMap[$_] -ea 'Continue'
    }
  }
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
        Invoke-FileDownload 'https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh'
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
        # this exits with code 1 while nothing to update
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
    code {
      code --update-extensions
      if ($Force) {
        $configDir = switch ($true) {
          $IsWindows { $env:APPDATA; break }
          $IsMacOS { "$HOME/Library/Application Support"; break }
          $IsLinux { "$HOME/.config"; break }
          default { throw [System.NotImplementedException]::new() }
        }
        if (!(Test-Path -LiteralPath $configDir/Code/User/sync/profiles/lastSyncprofiles.json)) {
          continue
        }
        ((Get-Content -Raw -LiteralPath $configDir/Code/User/sync/profiles/lastSyncprofiles.json |
            ConvertFrom-Json).syncData.content | ConvertFrom-Json).name | ForEach-Object {
            code --update-extensions --profile $_
          }
      }
      continue
    }
    deno {
      if ($Global) {
        deno jupyter --install
        if ($Force -and $pkgs) {
          deno install -g $pkgs.ForEach{ "$_@latest" }
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
    flatpak {
      flatpak update -y --noninteractive --force-remove
      if ($Force -and $pkgs) {
        flatpak install -y --noninteractive flathub $pkgs
      }
      continue
    }
    flutter {
      if ($Global) {
        [string[]]$ags = if ($Force) { '--force' }
        flutter upgrade $ags
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

function Update-System ([switch]$Force) {
  if ($IsWindows) {
    Update-Software winget, windows -Force:$Force
  }
  elseif ($IsMacOS) {
    Update-Software brew, macos -Force:$Force
  }
  elseif ($IsLinux) {
    if ($PSVersionTable.OS.StartsWith('Ubuntu ')) {
      Update-Software apt, ubuntu -Force:$Force
    }
    elseif ($PSVersionTable.OS.StartsWith('Fedora ')) {
      Update-Software dnf, fedora -Force:$Force
    }
    elseif ($PSVersionTable.OS.StartsWith('Debian ') -and
      [RuntimeInformation]::OSArchitecture -eq [Architecture]::Arm64) {
      Update-Software apt, raspi -Force:$Force
    }
  }
  else {
    throw [System.NotImplementedException]::new()
  }
  Update-Software bun, rustup, cargo, go, psm1, uv -Global -Force:$Force
  if (!$IsRaspi) {
    Update-Software code, flutter -Global -Force:$Force
  }
}
#endregion

#region utils
function goenv {
  $arch = switch ([RuntimeInformation]::OSArchitecture) {
    'X64' { 'amd64'; break }
    'Arm64' { 'arm64'; break }
    'Arm' { 'armv7'; break }
    'LoongArch64' { 'loong64'; break }
    default { throw [System.NotImplementedException]::new() }
  }
  $os = switch ($true) {
    $IsWindows { 'windows'; break }
    $IsMacOS { 'darwin'; break }
    $IsLinux { 'linux'; break }
    default { throw [System.NotImplementedException]::new() }
  }
  [pscustomobject]@{
    arch = $arch
    os   = $os
  }
}

function rustenv {
  $arch = switch ([RuntimeInformation]::OSArchitecture) {
    'X64' { 'x86_64'; break }
    'Arm64' { 'aarch64'; break }
    'Arm' { 'armv7'; break }
    'LoongArch64' { 'loongarch64'; break }
    default { throw [System.NotImplementedException]::new() }
  }
  $platform = switch ($true) {
    $IsWindows { 'pc'; break }
    $IsMacOS { break }
    $IsLinux { 'unknown'; break }
    default { throw [System.NotImplementedException]::new() }
  }
  $os = switch ($true) {
    $IsWindows { 'windows'; break }
    $IsMacOS { 'darwin'; break }
    $IsLinux { 'linux'; break }
  }
  $clib = switch ($true) {
    $IsWindows { 'msvc'; break }
    $IsMacOS { break }
    $IsLinux { 'gnu'; break }
  }
  $target = @($arch, $platform, $os, $clib).Where{ $null -ne $_ } -join '-'
  [pscustomobject]@{
    arch     = $arch
    platform = $platform
    os       = $os
    clib     = $clib
    target   = $target
  }
}

function execute {
  $cmd, $ags = $args
  $cmd = (Get-Command $cmd -Type Application -TotalCount 1).Source
  if ($MyInvocation.ExpectingInput) {
    Write-Debug "| $cmd $ags"
    $input | & $cmd $ags
  }
  else {
    Write-Debug "$cmd $ags"
    & $cmd $ags
  }
}

function Assert-FileHash ([string]$Name, [string]$CheckSums) {
  Write-Debug "checking file hash: $Name"
  $actual = (Get-FileHash -LiteralPath $buildDir/$Name).Hash
  $expected = (Get-Content -LiteralPath $buildDir/$CheckSums | Select-String -Raw -SimpleMatch $Name).Split(' ', 2)[0]
  if ($actual -ne $expected) {
    throw "file hash not match: $Name ($actual) $expected"
  }
}

function Install-Binary ([string[]]$Path) {
  $Path.ForEach{
    $name = [System.IO.Path]::GetFileNameWithoutExtension($_)
    $fullName = [System.IO.Path]::GetFullPath($_)
    $cmd = '"' + $fullName.Replace('"', ($IsWindows ? '""' : '\"')) + '"'
    switch ([System.IO.Path]::GetExtension($_)) {
      '.jar' { $cmd = 'java -jar ' + $cmd; break }
      '.js' { $cmd = 'node ' + $cmd; break }
      '' {
        if ($IsWindows) {
          break
        }
        chmod +x $fullName
        ln -sf $fullName $binDir/$name
        return
      }
    }
    if ($IsWindows) {
      "@$cmd %*" > $binDir/$name.cmd
      return
    }
    # exec -a requires bash
    "#!/bin/bash`nexec -a $name $cmd `"$@`"" > $binDir/$name
    chmod +x $binDir/$name
  }
}

function New-EmptyDir ([string[]]$Path) {
  Remove-Item -LiteralPath $Path -Recurse -Force -ea Ignore
  New-Item -ItemType Directory -Force $Path
}

function Invoke-FileDownload ([string]$Url, [string]$Path) {
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
  execute aria2c $Url -x2 -j32 --allow-overwrite --file-allocation=$($IsWindows ? 'prealloc' : 'falloc') -d $dir -o $file >> $buildDir/aria2c.log
}

function Invoke-ReleaseDownload ($Meta, [string[]]$Name) {
  $Name.ForEach{
    if (Test-Path -LiteralPath $buildDir/$_) {
      execute aria2c "http://github.com/$($Meta.repo)/releases/download/$($Meta.tag)/$_" -c -x2 -j32 --allow-overwrite "--file-allocation=$($IsWindows ? 'prealloc' : 'falloc')" -d $buildDir >> $buildDir/aria2c.log
      return
    }
    execute gh release download -R $Meta.repo -p $_ -D $buildDir $Meta.tag
  }
}

function Get-LocalVersion ([string]$Name) {
  try {
    $line = switch ($Name) {
      binaryen { wasm2js --version; break }
      less { (less --version 2>$null)[0].Split(' ', 3)[1] + '.0'; break }
      wabt { wat2wasm --version; break }
      vncviewer {
        if (Test-Path -LiteralPath $dataDir/jar/vncviewer.jar) {
          (java -jar $dataDir/jar/vncviewer.jar --version 2>&1)[1].ToString().Split(' ', 5)[3].Substring(1)
        }
        else {
          (vncviewer --version 2>&1)[1].ToString().Split(' ', 2)[1].Substring(1)
        }
        break
      }
      wechat {
        if ($IsFedora) {
          @(dnf list --installed wechat)[1]
          break
        }
        throw [System.NotImplementedException]::new()
      }
      { $_ -ceq 'localsend' -or $_ -ceq 'nerd-fonts' } {
        (Get-Content -Raw -LiteralPath $PSScriptRoot/releases.yml | ConvertFrom-Yaml | Where-Object name -CEQ $_).version
        break
      }
      default { @(& $_ --version 2>$null)[0]; break }
    }
    [regex]::Match($line, '\d+\.\d+(?:\.\d+(?:-\d+)?|)').Value.Replace('-', '.')
  }
  catch {
    Write-Warning "cannot detect local version for $($Name)"
    '0.0.0'
  }
}
#endregion

#region recipes
function Update-LatestVersion ($Meta, [switch]$Force) {
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
      [string[]]$ags = if ($Meta.prerelease) {
        '-L5', '--json', 'tagName,isPrerelease', '-q', 'first(.[] | select(.isPrerelease)) | .tagName'
      }
      else {
        '--exclude-pre-releases'
        switch ($Meta.name) {
          node { '-L5', '--json', 'tagName,isLatest', '-q', 'first(.[] | select(.isLatest)) | .tagName'; break }
          default { '-L1', '--json', 'tagName', '-q', '.[0].tagName'; break }
        }
      }
      $tag = $Meta.tag = execute gh release list -R $Meta.repo --exclude-drafts @ags
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
  $version = Get-LocalVersion $Meta.name
  if ([version]$Meta.version -gt $version) {
    $Meta
  }
  else {
    Write-Warning "$($Meta.name)@$version is already newer than $($Meta.version)"
  }
}

function Install-Release {
  [CmdletBinding()]
  param (
    [Parameter(Mandatory, Position = 0)]
    $Meta
  )
  Write-Information "Installing $($Meta.name)@$($Meta.version)"
  $ext = $IsWindows ? '.zip' : '.tar.gz'
  $exe = $IsWindows ? '.exe' : ''
  switch ($Meta.name) {
    alacritty {
      if (!$IsLinux) {
        throw [System.NotImplementedException]::new()
      }
      cargo install alacritty@$($Meta.version)
      Invoke-ReleaseDownload $Meta 'Alacritty.svg', 'alacritty.1.gz', 'alacritty-msg.1.gz', 'alacritty.5.gz', 'alacritty-bindings.5.gz', 'alacritty.bash', 'Alacritty.desktop'
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
          Invoke-ReleaseDownload $Meta $file
          sudo dnf install -y $buildDir/$file
          break
        }
        $IsUbuntu {
          $file = "balena-etcher_$($Meta.version)_amd64.deb"
          Invoke-ReleaseDownload $Meta $file
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
      Invoke-FileDownload "https://mirrors.tuna.tsinghua.edu.cn/gnu/bash/$file"
      Invoke-FileDownload "https://mirrors.tuna.tsinghua.edu.cn/gnu/bash/$file.sig"
      gpg --verify $buildDir/$file.sig $buildDir/$file
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
    { $_ -ceq 'bat' -or $_ -ceq 'diskus' -or $_ -ceq 'fd' -or $_ -ceq 'hexyl' -or $_ -ceq 'hyperfine' } {
      $base = $_, $Meta.tag, $rust.target -join '-'
      Invoke-ReleaseDownload $Meta $base$ext
      tar -xf $buildDir/$base$ext -C $buildDir --strip-components=1
      Move-Item -LiteralPath $buildDir/$_$exe $binDir -Force
      Move-Item -LiteralPath $buildDir/$_.1 $dataDir/man/man1 -Force
      break
    }
    binaryen {
      $os = switch ($true) {
        $IsLinux { 'linux'; break }
        $IsWindows { 'windows'; break }
        $IsMacOS { 'macos'; break }
        default { throw [System.NotImplementedException]::new() }
      }
      $file = 'binaryen-{0}-{1}-{2}.tar.gz' -f $Meta.tag, $rust.arch, $os
      Invoke-ReleaseDownload $Meta $file, $file.sha256
      Assert-FileHash $file $file.sha256
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
      Invoke-ReleaseDownload $Meta $file, SHASUMS256.txt
      Assert-FileHash $file SHASUMS256.txt
      Expand-Archive -LiteralPath $buildDir/$file $buildDir -Force
      Move-Item -LiteralPath $buildDir/$(Split-Path -LeafBase $file)/bun $binDir -Force
      $null = New-Item -ItemType SymbolicLink -Force -Target bun $binDir/bunx
      break
    }
    cargo-generate {
      $file = 'cargo-generate-{0}-{1}.tar.gz' -f $Meta.tag, $rust.target
      Invoke-ReleaseDownload $Meta $file
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
          Invoke-FileDownload "https://update.code.visualstudio.com/latest/linux-deb-$arch/stable" $buildDir/code.deb
          sudo dpkg -i $buildDir/code.deb
          break
        }
        default { throw [System.NotImplementedException]::new() }
      }
      break
    }
    copilot {
      $file = 'github-copilot-{0}.tgz' -f $Meta.tag.Substring(1)
      Invoke-ReleaseDownload $Meta $file
      tar -xf $buildDir/$file -C (New-Item -Type Directory $prefixDir/copilot -Force) --strip-components=1
      # Install-Binary $prefixDir/copilot/index.js
      break
    }
    cosign {
      $file = switch ($true) {
        $IsWindows { 'cosign-windows-{0}.exe' -f $Meta.version, $go.os; break }
        $IsMacOS { 'cosign-darwin-{0}' -f $go.os; break }
        $IsFedora { 'cosign-{0}-1.{1}.rpm' -f $Meta.version, $rust.arch; break }
        ($IsUbuntu -or $IsRaspi) { 'cosign_{0}_{1}.deb' -f $Meta.version, $go.arch; break }
        default { throw [System.NotImplementedException]::new() }
      }
      Invoke-ReleaseDownload $Meta $file, cosign_checksums.txt, $file.sigstore.json, release-cosign.pub
      Assert-FileHash $file cosign_checksums.txt
      switch ($true) {
        $IsWindows { Move-Item -LiteralPath $buildDir/$file $binDir/cosign.exe -Force; break }
        $IsMacOS { Move-Item -LiteralPath $buildDir/$file $binDir/cosign -Force; chmod +x $binDir/cosign; break }
        $IsFedora { sudo dnf install -y $buildDir/$file; break }
        ($IsUbuntu -or $IsRaspi) { sudo dpkg -i $buildDir/$file; break }
      }
      cosign verify-blob $buildDir/$file --bundle $buildDir/$file.sigstore.json --certificate-identity 'keyless@projectsigstore.iam.gserviceaccount.com' --certificate-oidc-issuer 'https://accounts.google.com'
      break
    }
    { $_ -ceq 'crush' -or $_ -ceq 'glow' -or $_ -ceq 'gum' -or $_ -ceq 'vhs' } {
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
      $base = $_, $Meta.version, $os, $arch -join '_'
      if ($_ -ceq 'gum') {
        Invoke-ReleaseDownload $Meta $base$ext, checksums.txt, checksums.txt.pem, checksums.txt.sig
        cosign verify-blob $buildDir/checksums.txt --cert $buildDir/checksums.txt.pem --signature $buildDir/checksums.txt.sig --certificate-identity 'https://github.com/charmbracelet/meta/.github/workflows/goreleaser.yml@refs/heads/main' --certificate-oidc-issuer 'https://token.actions.githubusercontent.com'
      }
      else {
        Invoke-ReleaseDownload $Meta $base$ext, checksums.txt, checksums.txt.sigstore.json
        cosign verify-blob $buildDir/checksums.txt --bundle $buildDir/checksums.txt.sigstore.json --certificate-identity 'https://github.com/charmbracelet/meta/.github/workflows/goreleaser.yml@refs/heads/main' --certificate-oidc-issuer 'https://token.actions.githubusercontent.com'
      }
      Assert-FileHash $base$ext checksums.txt
      tar -xf $buildDir/$base$ext -C $buildDir --strip-components=1
      Move-Item -LiteralPath $buildDir/$_$exe $binDir -Force
      Move-Item -LiteralPath $buildDir/completions/$_.bash $dataDir/bash-completion/completions -Force
      Move-Item -LiteralPath $buildDir/manpages/$_.1.gz $dataDir/man/man1 -Force
      break
    }
    deno {
      if ($IsWindows) {
        throw [System.NotImplementedException]::new()
      }
      $file = 'deno-{0}.zip' -f $rust.target
      Invoke-ReleaseDownload $Meta $file, $file.sha256sum
      Assert-FileHash $file $file.sha256sum
      Expand-Archive -LiteralPath $buildDir/$file $binDir -Force
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
      Invoke-FileDownload "https://aka.ms/dotnet/$ChannelQuality/$file"
      switch ($true) {
        $IsWindows { sudo $buildDir/$file; break }
        $IsMacOS { sudo installer -pkg $buildDir/$file -dumplog > Temp:/$file.log; break }
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
      Invoke-ReleaseDownload $Meta $base$ext
      tar -xf $buildDir/$base$ext -C (New-EmptyDir $prefixDir/dsc)
      Install-Binary $prefixDir/dsc/dsc$exe
      break
    }
    edit {
      switch ($true) {
        $IsWindows {
          $base = 'edit-{0}-{1}-windows' -f $Meta.version, $rust.arch
          Invoke-ReleaseDownload $Meta $base.zip
          Expand-Archive -LiteralPath $buildDir/$base.zip $buildDir -Force
          break
        }
        $IsLinux {
          break # FIXME: after edit-1.2.1
          $base = 'edit-{0}-{1}-linux-gnu' -f $Meta.version, $rust.arch
          Invoke-ReleaseDownload $Meta $base.tar.zst
          tar -xf $buildDir/$base.tar.zst --zstd -C $buildDir
          break
        }
        default { throw [System.NotImplementedException]::new() }
      }
      Move-Item -LiteralPath $buildDir/edit$exe $binDir -Force
      break
    }
    flutter {
      if (Get-Command flutter -CommandType Application -TotalCount 1 -ea Ignore) {
        flutter upgrade
        break
      }
      Invoke-FileDownload $Meta.file
      $file = [System.IO.Path]::GetFileName($Meta.file)
      if ((Get-FileHash -LiteralPath $buildDir/$file).Hash -ne $Meta.sha256) {
        throw 'hash not match'
      }
      Remove-Item -LiteralPath $prefixDir/flutter -Recurse -Force -ea Ignore
      tar -xf $buildDir/$file -C $prefixDir
      $baseDir = "$prefixDir/flutter/bin"
      $exe = $IsWindows ? '.bat' : ''
      Install-Binary $baseDir/flutter$exe, $baseDir/flutter-dev$exe, $baseDir/dart$exe
      break
    }
    fzf {
      $base = 'fzf-{0}-{1}_{2}' -f $Meta.version, $go.os, $go.arch
      Invoke-ReleaseDownload $Meta $base$ext
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
        Invoke-ReleaseDownload $Meta $file
        sudo dnf install -y $buildDir/$file
      }
      elseif ($IsUbuntu -or $IsRaspi) {
        $file += '.deb'
        Invoke-ReleaseDownload $Meta $file
        sudo apt install -y $buildDir/$file
      }
      break
    }
    ghostty {
      switch ($true) {
        $IsMacOS {
          Invoke-FileDownload "https://release.files.ghostty.org/$($Meta.version)/Ghostty.dmg"
          sudo installer -pkg $buildDir/Ghostty.dmg -dumplog > Temp:/$file.log
          break
        }
        $IsLinux {
          $file = 'Ghostty-{0}-{1}.AppImage' -f $Meta.version, $rust.arch
          Invoke-ReleaseDownload $file
          Move-Item -LiteralPath $buildDir/$file $binDir/ghostty -Force
          chmod +x $binDir/ghostty
          break
        }
        default { throw [System.NotImplementedException]::new() }
      }
    }
    go {
      $file = $Meta.file
      Invoke-FileDownload "https://golang.google.cn/dl/$file"
      if ((Get-FileHash -LiteralPath $buildDir/$file).Hash -ne $Meta.sha256) {
        throw 'hash not match'
      }
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
          sudo installer -pkg $buildDir/$file -dumplog > Temp:/$file.log
          break
        }
        default { throw [System.NotImplementedException]::new() }
      }
      break
    }
    golangci-lint {
      $base = 'golangci-lint-{0}-{1}-{2}' -f $Meta.version, $go.os, $go.arch
      Invoke-ReleaseDownload $Meta $base$ext, "golangci-lint-$($Meta.version)-checksums.txt"
      Assert-FileHash $base$ext "golangci-lint-$($Meta.version)-checksums.txt"
      tar -xf $buildDir/$base$ext -C $buildDir --strip-components=1
      Move-Item -LiteralPath $buildDir/golangci-lint$exe $binDir -Force
      break
    }
    goreleaser {
      $os = $go.os.Substring(0, 1).ToUpperInvariant() + $go.os.Substring(1)
      $base = 'goreleaser_{0}_{1}' -f $os, $rust.arch
      Invoke-ReleaseDownload $Meta $base$ext
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
      Invoke-ReleaseDownload $Meta $file
      sudo $buildDir/$file
      break
    }
    java {
      if (!$IsLinux) {
        throw [System.NotImplementedException]::new()
      }
      Invoke-FileDownload $Meta.url
      $file = Split-Path -Leaf $Meta.url
      if ((Get-FileHash -LiteralPath $buildDir/$file).Hash -ne $Meta.sha256) {
        throw 'hash not match'
      }
      sudo tar -xf $buildDir/$file -C $sudoPrefixDir
      sudo ln -sf $sudoPrefixDir/jdk-$($Meta.version)/bin/java $binDir
      sudo ln -sf $sudoPrefixDir/jdk-$($Meta.version)/bin/javac $binDir
      break
    }
    jd {
      $file = 'jd-{0}-{1}{2}' -f $go.arch, $go.os, $exe
      Invoke-ReleaseDownload $Meta $file
      Move-Item -LiteralPath $buildDir/$file $binDir/jd$exe -Force
      if (!$IsWindows) {
        chmod +x $binDir/jd
      }
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
      Invoke-ReleaseDownload $Meta $file
      Move-Item -LiteralPath $buildDir/$file $binDir/jq$exe -Force
      if (!$IsWindows) {
        chmod +x $binDir/jq
      }
      Invoke-FileDownload "https://github.com/$($Meta.repo)/raw/HEAD/jq.1.prebuilt" $dataDir/man/man1/jq.1
      break
    }
    less {
      if (!$IsLinux) {
        throw [System.NotImplementedException]::new()
      }
      $base = 'less-{0}' -f $Meta.version.Split('.', 2)[0]
      Invoke-FileDownload "http://www.greenwoodsoftware.com/less/$base.tar.gz"
      Invoke-FileDownload "http://www.greenwoodsoftware.com/less/$base.sig"
      gpg --verify $buildDir/$base.sig $buildDir/$base.tar.gz
      tar -xf $buildDir/$base.tar.gz -C $buildDir
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
      Invoke-ReleaseDownload $Meta $base$ext
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
      Invoke-ReleaseDownload $Meta $pattern
      Move-Item $buildDir/$pattern $binDir/magick -Force
      chmod +x $binDir/magick
      break
    }
    { $_ -ceq 'mdbook' -or $_ -ceq 'mdbook-mermaid' } {
      $base = $_, $Meta.tag, $rust.target -join '-'
      Invoke-ReleaseDownload $Meta $base$ext
      tar -xf $buildDir/$base$ext -C $binDir
      break
    }
    mkcert {
      $file = 'mkcert-{0}-{1}-{2}{3}' -f $Meta.tag, $go.os, $go.arch, $exe
      Invoke-ReleaseDownload $Meta $file
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
      Invoke-ReleaseDownload $Meta $base$ext
      sudo tar -xf $buildDir/$base$ext -C $sudoPrefixDir --strip-components=1
      break
    }
    nerd-fonts {
      Invoke-ReleaseDownload $Meta 0xProto.zip
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
      Invoke-FileDownload "https://nodejs.org/dist/$($Meta.tag)/$file"
      switch ($true) {
        $IsWindows { Invoke-Sudo Install-MSIProduct -LiteralPath $buildDir/$file; break }
        $IsMacOS { sudo installer -pkg $buildDir/$file -dumplog > Temp:/$file.log; break }
        $IsLinux {
          $root = "$prefixDir/nodejs/$($Meta.tag)"
          tar -xf $buildDir/$file -C (New-EmptyDir $root) --strip-components=1
          Install-Binary $root/bin/node, $root/bin/npm
          break
        }
      }
    }
    numbat {
      $base = 'numbat-{0}-{1}' -f $Meta.tag, $rust.target
      Invoke-ReleaseDownload $Meta $base$ext
      tar -xf $buildDir/$base$ext -C (New-EmptyDir $prefixDir/numbat) --strip-components=1
      Install-Binary $prefixDir/numbat/numbat$exe
      break
    }
    pastel {
      $base = 'pastel-{0}-{1}' -f $Meta.tag, $rust.target
      Invoke-ReleaseDownload $Meta $base$ext
      tar -xf $buildDir/$base$ext -C $buildDir --strip-components=1
      Move-Item -LiteralPath $buildDir/pastel$exe $binDir -Force
      Move-Item -LiteralPath $buildDir/autocomplete/pastel.bash $dataDir/bash-completion/completions -Force
      Move-Item $buildDir/man/* $dataDir/man/man1 -Force
      break
    }
    plantuml {
      $file = 'plantuml-gplv2-{0}.jar' -f $Meta.version
      Invoke-ReleaseDownload $Meta $file
      Move-Item -LiteralPath $buildDir/$file $dataDir/jar/plantuml.jar -Force
      Install-Binary $dataDir/jar/plantuml.jar
      break
    }
    pwsh {
      $id = $Meta.tag.Substring(1)
      $arch = [RuntimeInformation]::OSArchitecture.ToString().ToLowerInvariant()
      switch ($true) {
        $IsWindows {
          $file = 'PowerShell-{0}-win-{1}.msi' -f $id, $arch
          Invoke-ReleaseDownload $Meta $file
          Invoke-Sudo Install-MSIProduct -LiteralPath $buildDir/$file
          break
        }
        $IsMacOS {
          $file = 'powershell-{0}-osx-{1}.pkg' -f $id, $arch
          Invoke-ReleaseDownload $Meta $file
          sudo installer -pkg $buildDir/$file -dumplog > Temp:/$file.log
          break
        }
        $IsLinux {
          $file = 'powershell-{0}-linux-{1}.tar.gz' -f $id, $arch
          Invoke-ReleaseDownload $Meta $file
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
      Invoke-ReleaseDownload $Meta $base$ext, $base$ext.sha256
      Assert-FileHash $base$ext $base$ext.sha256
      tar -xf $buildDir/$base$ext -C $buildDir --strip-components=1
      Move-Item -LiteralPath $buildDir/rg$exe $binDir -Force
      Move-Item -LiteralPath $buildDir/doc/rg.1 $dataDir/man/man1 -Force
      Move-Item -LiteralPath $buildDir/complete/rg.bash $dataDir/bash-completion/completions -Force
      break
    }
    rga {
      if ($IsWindows) {
        cargo install ripgrep_all
        break
      }
      $base = 'ripgrep_all-{0}-{1}' -f $Meta.tag, ($rust.arch -ceq 'x86_64' ? $rust.target -creplace '-gnu$', '-musl' : $rust.target)
      Invoke-ReleaseDownload $Meta $base$ext
      tar -xf $buildDir/$base$ext -C $buildDir --strip-components=1
      [string[]]$files = 'rga', 'rga-fzf', 'rga-fzf-open', 'rga-preproc'
      $files = $files.ForEach{ "$buildDir/$_$exe" }
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
    sing-box {
      if ($IsWindows) {
        throw [System.NotImplementedException]::new()
      }
      $suffix = if ($IsLinux) { '-glibc.tar.gz' } else { $ext }
      $file = 'sing-box-{0}-{1}-{2}{3}' -f $Meta.version, $go.os, $go.arch, $suffix
      Invoke-ReleaseDownload $Meta $file
      tar -xf $buildDir/$file -C $buildDir --strip-components=1
      Move-Item -LiteralPath $buildDir/sing-box$exe $binDir -Force
      break
    }
    taplo {
      $base = 'taplo-{0}-{1}' -f $go.os, $rust.arch
      Invoke-ReleaseDownload $Meta $base.gz
      gzip -df $buildDir/$base.gz
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
      Invoke-ReleaseDownload $Meta $base$ext
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
      Invoke-ReleaseDownload $Meta $base.gz
      gzip -df $buildDir/$base.gz
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
      Invoke-FileDownload "https://sourceforge.net/projects/tigervnc/files/stable/$($Meta.version)/$file/download" $target
      if ($file.EndsWith('.jar')) {
        Install-Binary $target
      }
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
      Invoke-ReleaseDownload $Meta $file
      tar -xf $buildDir/$file -C $binDir --strip-components=1
      break
    }
    wasm-bindgen {
      $file = 'wasm-bindgen-{0}-{1}.tar.gz' -f $Meta.tag, ($rust.target -creplace '-gnu$', '-musl')
      Invoke-ReleaseDownload $Meta $file, $file.sha256sum
      Assert-FileHash $file $file.sha256sum
      tar -xf $buildDir/$file -C $buildDir --strip-components=1
      Move-Item $buildDir/wasm-*$exe $binDir -Force
      break
    }
    wasm-pack {
      $file = 'wasm-pack-{0}-{1}.tar.gz' -f $Meta.tag, ($rust.target -creplace '-gnu$', '-musl')
      Invoke-ReleaseDownload $Meta $file
      tar -xf $buildDir/$file -C $buildDir --strip-components=1
      Move-Item -LiteralPath $buildDir/wasm-pack$exe $binDir -Force
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
      Invoke-FileDownload https://dldir1v6.qq.com/weixin/Universal/Linux/$file
      switch ($true) {
        $IsFedora { sudo dnf install -y $buildDir/$file; break }
        $IsUbuntu { sudo dpkg -i $buildDir/$file; break }
        default { Move-Item -LiteralPath $buildDir/$file $binDir/wechat -Force; chmod +x $binDir/wechat; break }
      }
      break
    }
    yq {
      $base = 'yq_{0}_{1}' -f $go.os, $go.arch
      Invoke-ReleaseDownload $Meta $base$ext
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
      Invoke-ReleaseDownload $Meta $base$ext
      tar -xf $buildDir/$base$ext -C $buildDir --strip-components=1
      Move-Item -LiteralPath $buildDir/$_$exe $binDir -Force
      if ($_ -ceq 'uv') {
        Move-Item -LiteralPath $buildDir/uvx$exe $binDir -Force
        if ($IsWindows) {
          Move-Item -LiteralPath $buildDir/uvw$exe $binDir -Force
        }
      }
      break
    }
    default { throw "no install method for $_" }
  }
  $version = Get-LocalVersion $Meta.name
  if ($version -cne $Meta.version) {
    Write-Warning "expected $($Meta.name) installed version $($Meta.version), but got $version"
  }
}
#endregion

#region init
$go = goenv
$rust = rustenv
$buildDir = [System.IO.Path]::TrimEndingDirectorySeparator([System.IO.Path]::GetTempPath())
if ($IsLinux) {
  $IsUbuntu = $PSVersionTable.OS.StartsWith('Ubuntu ')
  $IsFedora = $PSVersionTable.OS.StartsWith('Fedora ')
  $IsRaspi = $PSVersionTable.OS.StartsWith('Debian ') -and [RuntimeInformation]::OSArchitecture -eq [Architecture]::Arm64
  $IsWSL = [bool]$env:WSL_DISTRO_NAME
}

$prefixDir = $IsWindows ? "$env:LOCALAPPDATA\prefix" : "$HOME/.local"
$dataDir = [System.IO.Path]::Join($prefixDir, 'share')
$binDir = [System.IO.Path]::Join($prefixDir, 'bin')

$sudoPrefixDir = $IsWindows ? "$env:ProgramData\prefix" : '/usr/local'
$sudoDataDir = [System.IO.Path]::Join($sudoPrefixDir, 'share')
$sudoBinDir = [System.IO.Path]::Join($sudoPrefixDir, 'bin')
#endregion
