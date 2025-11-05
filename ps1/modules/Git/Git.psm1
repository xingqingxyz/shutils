function Clear-Module {
  <#
  .SYNOPSIS
  Clear outdated modules.
   #>
  Get-InstalledModule | Group-Object Name | Where-Object Count -GT 1 | ForEach-Object {
    $_.Group | Sort-Object -Descending { [version]$_.Version } | Select-Object -Skip 1
  } | ForEach-Object { Uninstall-Module $_.Name -MaximumVersion $_.Version }
}

function Repair-GitSymlinks {
  git ls-files -s | ForEach-Object {
    [int]$mode, $item = $_ -split '\s+', 4
    if ($mode -ne 120000) {
      return
    }
    $item = $item[2].TrimStart()
    try {
      $item = Get-Item -LiteralPath $item -Force -ea Stop
    }
    catch {
      return Write-Warning "staged symlink not found: $item"
    }
    if ($item.LinkType -ne 'SymbolicLink') {
      $target = Get-Content -Raw -LiteralPath $item
      New-Item -ItemType SymbolicLink -Force -Target $target $item
    }
  }
}

function Update-Software {
  [CmdletBinding()]
  param (
    [Parameter()]
    [ArgumentCompleter({
        param (
          [string]$CommandName,
          [string]$ParameterName,
          [string]$WordToComplete
        )
        (Get-Content -Raw -LiteralPath $env:SHUTILS_ROOT/data/globalTools.yml | ConvertFrom-Yaml).Keys.Where{ $_ -like "$WordToComplete*" }
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
  $pkgMap = Get-Content -Raw -LiteralPath $env:SHUTILS_ROOT/data/globalTools.yml | ConvertFrom-Yaml
  switch ($Category) {
    apt {
      sudo apt update
      sudo apt install -f
      sudo apt upgrade -y --auto-remove
      if ($Force) {
        sudo apt install -y $pkgMap.apt
      }
      continue
    }
    bun {
      if ($Global) {
        bun upgrade -g
        if ($Force) {
          bun add -g $pkgMap.bun
        }
        continue
      }
      bun update
      continue
    }
    cargo {
      if ($Global) {
        cargo install-update --all
        if ($Force) {
          cargo install $pkgMap.cargo
        }
        continue
      }
      cargo update
      continue
    }
    code { code --update-extensions; continue }
    deno {
      if ($Global) {
        deno jupyter --install
        if ($Force) {
          deno install --global $pkgMap.deno
        }
        continue
      }
      deno update
      continue
    }
    dnf {
      sudo dnf upgrade -y
      if ($Force) {
        sudo dnf install -y $pkgMap.dnf
      }
      continue
    }
    flutter {
      if ($Global) {
        [string[]]$pkgs = flutter pub global list
        if ($Force) {
          $pkgs += $pkgMap.flutter
        }
        flutter pub global activate $pkgs.ForEach{ "$_@latest" }
        continue
      }
      flutter pub upgrade
      continue
    }
    gh {
      gh extension upgrade --all
      if ($Force) {
        gh extension install $pkgMap.gh
      }
      continue
    }
    go {
      if ($Global) {
        go install $pkgMap.go.ForEach{ "$_@latest" }
        continue
      }
      [string[]]$pkgs = go list
      go get $pkgs.ForEach{ "$_@latest" }
      continue
    }
    pnpm {
      if ($Global) {
        pnpm self-update
        pnpm update -g
        if ($Force) {
          pnpm add -g $pkgMap.pnpm
        }
        pnpm approve-builds -g
        continue
      }
      pnpm self-update
      pnpm update
      pnpm approve-builds
      continue
    }
    ps1 {
      Update-Script
      if ($Force) {
        Install-Script $pkgMap.ps1
      }
    }
    psm1 {
      Update-Module
      Clear-Module
      if ($Force) {
        Install-Module $pkgMap.psm1
      }
      continue
    }
    releases {
      Update-Release $pkgMap.releases
      continue
    }
    rustup {
      rustup update
      if ($Force) {
        rustup toolchain install $pkgMap.rustup.toolchains --component ($pkgMap.rustup.components -join ',') --target ($pkgMap.rustup.targets)
      }
      continue
    }
    uv {
      if ($Global) {
        uv self update
        uv tool upgrade
        if ($Force) {
          $pkgMap.uv.python | ForEach-Object { uv python install $_ }
          $pkgMap.uv.tools | ForEach-Object { uv tool install $_ }
        }
        continue
      }
      uv sync --upgrade
      continue
    }
    winget {
      if (!$IsWindows) {
        Write-Warning 'Calling winget on non-Windows platform'
        continue
      }
      sudo winget upgrade -r --accept-package-agreements
      if ($Force) {
        sudo winget install --accept-package-agreements $pkgMap.winget
      }
      continue
    }
    default { throw [System.NotImplementedException]::new() }
  }
}

function ijq {
  $file = fzf '--walker=file,hidden' -q '.json$ '
  if (!$file) {
    return
  }
  $query = jq -r 'paths | map(
    if type == "string" then
      "." + (
        if test("^[a-zA-Z_]\\w*$") then
          .
        else
          "\"\(.)\""
        end)
    else
      "[\(.)]"
    end) | join("")' `-- $file | fzf
  $query = "jq '{0}' '{1}'" -f @(
    [System.Management.Automation.Language.CodeGeneration]::EscapeSingleQuotedStringContent($query)
    [System.Management.Automation.Language.CodeGeneration]::EscapeSingleQuotedStringContent((Convert-Path -LiteralPath $file)))
  $query
  [Microsoft.PowerShell.PSConsoleReadLine]::AddToHistory($query)
}
