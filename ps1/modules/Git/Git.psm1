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

function Clear-Module {
  <#
  .SYNOPSIS
  Clear outdated modules.
   #>
  Get-InstalledModule | Group-Object Name | Where-Object Count -GT 1 | ForEach-Object {
    $_.Group | Sort-Object -Descending { [version]$_.Version } | Select-Object -Skip 1
  } | ForEach-Object { Uninstall-Module $_.Name -MaximumVersion $_.Version }
}

function howto {
  [CmdletBinding(SupportsShouldProcess)]
  param (
    [Parameter()]
    [string]
    $HostName,
    [ValidateSet('gh', 'git', 'shell')]
    [Parameter()]
    [String]
    $Target = 'shell',
    [Parameter(Position = 0, ValueFromRemainingArguments)]
    [string]
    $Prompt
  )
  begin {
    $executeCommandFile = New-TemporaryFile
    $envGhDebug = $env:GH_DEBUG
    if ($PSBoundParameters.Debug) {
      $env:GH_DEBUG = 'api'
    }
  }
  process {
    gh copilot suggest -t $Target -s $executeCommandFile --hostname $HostName $Prompt
    if ($executeCommandFile.Length -le 0) {
      return
    }
    $executeCommand = (Get-Content -Raw -LiteralPath $executeCommandFile).Trim()
    # Insert command into PowerShell up/down arrow key history
    [Microsoft.PowerShell.PSConsoleReadLine]::AddToHistory($executeCommand)
    if (!$PSCmdlet.ShouldProcess('execute', $executeCommand)) {
      return
    }
    # Execute command
    $now = Get-Date
    Invoke-Expression $executeCommand
    Add-History ([pscustomobject]@{
        CommandLine        = $executeCommand
        StartExecutionTime = $now
        EndExecutionTime   = Get-Date
        ExecutionStatus    = [System.Management.Automation.Runspaces.PipelineState]::NotStarted
      })
  }
  clean {
    # Clean up temporary file used to store potential command user wants to execute when exiting
    Remove-Item -LiteralPath $executeCommandFile
    # Restore GH_* environment variables to their original value
    $env:GH_DEBUG = $envGhDebug
  }
}

function ex {
  [CmdletBinding()]
  param (
    [Parameter()]
    [string]
    $HostName,
    [Parameter(Position = 0, ValueFromRemainingArguments)]
    [string]
    $Prompt
  )
  begin {
    $envGhDebug = $env:GH_DEBUG
    if ($PSBoundParameters.Debug) {
      $env:GH_DEBUG = 'api'
    }
  }
  process {
    gh copilot explain --hostname $HostName $Prompt
  }
  clean {
    $env:GH_DEBUG = $envGhDebug
  }
}

function ijq {
  $file = fzf '--walker=file,hidden'
  if (!$file) {
    return
  }
  $query = jq -r 'paths | (map(
    if type == "string" then
      "." + (
        if test("^[a-zA-Z_]\\w*$") then
          .
        else
          "\"\(.)\""
        end)
    else
      "[\(.)]"
    end) | join(""))' `-- $file | fzf
  $query = "jq '{0}' '{1}'" -f @(
    [System.Management.Automation.Language.CodeGeneration]::EscapeSingleQuotedStringContent($query)
    [System.Management.Automation.Language.CodeGeneration]::EscapeSingleQuotedStringContent((Convert-Path -LiteralPath $file)))
  $query
  [Microsoft.PowerShell.PSConsoleReadLine]::AddToHistory($query)
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
  if (!$Global) {
    switch ($Category) {
      bun { bun update; continue }
      cargo { cargo update; continue }
      deno { deno update; continue }
      flutter { flutter pub upgrade; continue }
      pnpm { pnpm self-update; pnpm update; "a`ny`n" | pnpm approve-builds; continue }
      uv { uv sync --upgrade; continue }
      go {
        [string[]]$pkgs = go list
        go get $pkgs.ForEach{ "$_@latest" }
        continue
      }
      default { throw [System.NotImplementedException]::new() }
    }
    return
  }
  switch ($Category) {
    code { code --update-extensions; continue }
    go { go install $pkgMap.go.ForEach{ "$_@latest" }; continue }
    bun {
      bun upgrade -g
      if ($Force) {
        bun add -g $pkgMap.bun
      }
      continue
    }
    deno {
      deno jupyter --install
      if ($Force) {
        deno install --global $pkgMap.deno
      }
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
      [string[]]$pkgs = flutter pub global list
      if ($Force) {
        $pkgs += $pkgMap.flutter
      }
      flutter pub global activate $pkgs.ForEach{ "$_@latest" }
      continue
    }
    gh {
      gh extension upgrade --all
      if ($Force) {
        gh extension install $pkgMap.gh
      }
      continue
    }
    rustup {
      rustup update
      if ($Force) {
        rustup toolchain install $pkgMap.rustup.toolchains --component ($pkgMap.rustup.components -join ',') --target ($pkgMap.rustup.targets)
      }
      continue
    }
    cargo {
      cargo install-update --all
      if ($Force) {
        cargo install $pkgMap.cargo
      }
      continue
    }
    pnpm {
      pnpm self-update
      pnpm update -g
      "a`ny`n" | pnpm approve-builds -g
      if ($Force) {
        pnpm add -g $pkgMap.pnpm
      }
      continue
    }
    psm1 {
      Update-Module
      Clear-Module
      if ($Force) {
        Install-Module $pkgMap.psm1
      }
      continue
    }
    ps1 {
      Update-Script
      if ($Force) {
        Install-Script $pkgMap.ps1
      }
    }
    uv {
      uv self update
      uv tool upgrade
      if ($Force) {
        uv tool install $pkgMap.uv
      }
      continue
    }
    default { throw [System.NotImplementedException]::new() }
  }
}
