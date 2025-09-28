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
  } | ForEach-Object {
    Uninstall-Module $_.Name -MaximumVersion $_.Version
  }
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
    $executeCommand = (Get-Content -LiteralPath $executeCommandFile -Raw).Trim()
    # Insert command into PowerShell up/down arrow key history
    [Microsoft.PowerShell.PSConsoleReadLine]::AddToHistory($executeCommand)
    # Execute command
    if ($PSCmdlet.ShouldProcess('execute', $executeCommand)) {
      Invoke-Expression $executeCommand
    }
  }
  clean {
    # Clean up temporary file used to store potential command user wants to execute when exiting
    Remove-Item -Path $executeCommandFile
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
