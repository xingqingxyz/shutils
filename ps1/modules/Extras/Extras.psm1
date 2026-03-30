$ErrorActionPreference = 'Stop'
$PSNativeCommandUseErrorActionPreference = $true

function Clear-Module {
  <#
  .SYNOPSIS
  Clear outdated modules.
   #>
  Get-InstalledModule | Group-Object Name | Where-Object Count -GT 1 | ForEach-Object {
    $_.Group | Sort-Object -Descending { [version]$_.Version } | Select-Object -Skip 1
  } | ForEach-Object { Uninstall-Module $_.Name -MaximumVersion $_.Version }
}

function Get-Region {
  [CmdletBinding(DefaultParameterSetName = 'LiteralPath')]
  [OutputType([string[]])]
  param (
    [Parameter(Mandatory, Position = 0)]
    [string]
    $Name,
    [Parameter(Mandatory, Position = 2, ParameterSetName = 'LiteralPath')]
    [string]
    $LiteralPath,
    [Parameter(Mandatory, ValueFromPipeline, ParameterSetName = 'Stdin')]
    [System.Object]
    $InputObject,
    [Parameter()]
    [string]
    $LineComment
  )
  [string[]]$lines = $MyInvocation.ExpectingInput ? $input : (Get-Content -LiteralPath $LiteralPath -ea Ignore)
  if ($LiteralPath) {
    $lines = (Get-Content -LiteralPath $LiteralPath -ea Ignore) ?? ''
  }
  $found = 0
  foreach ($line in $lines) {
    if (!$found -and $line.Trim() -ceq "$LineComment#region $Name") {
      $found = 1
    }
    elseif ($found -eq 1) {
      if ($line.Trim() -ceq "$LineComment#endregion") {
        $found = 2
        break
      }
      else {
        $line
      }
    }
  }
  if (!$found) {
    Write-Error "#region $Name mark not found"
  }
  elseif ($found -eq 1) {
    Write-Error '#endregion mark not found'
  }
}

function Set-Region {
  [CmdletBinding(DefaultParameterSetName = 'LiteralPath')]
  [OutputType([string[]])]
  param (
    [Parameter(Mandatory, Position = 0)]
    [string]
    $Name,
    [Parameter(Mandatory, Position = 1)]
    [AllowEmptyCollection()]
    [string[]]
    $Value,
    [Parameter(Mandatory, Position = 2, ParameterSetName = 'LiteralPath')]
    [string]
    $LiteralPath,
    [Parameter(ParameterSetName = 'LiteralPath')]
    [switch]
    $Inplace,
    [Parameter(Mandatory, ValueFromPipeline, ParameterSetName = 'Stdin')]
    [System.Object]
    $InputObject,
    [Parameter()]
    [string]
    $LineComment
  )
  [string[]]$lines = $MyInvocation.ExpectingInput ? $input : (Get-Content -LiteralPath $LiteralPath -ea Ignore)
  $found = 0
  $newLines = $lines.ForEach{
    if (!$found -and $_.Trim() -ceq "$LineComment#region $Name") {
      $found = 1
      $_
    }
    elseif ($found -eq 1) {
      if ($_.Trim() -ceq "$LineComment#endregion") {
        $found = 2
        $Value
        $_
      }
    }
    else {
      $_
    }
  }
  if ($found -lt 2) {
    if ($found -eq 1) {
      Write-Warning '#endregion mark not found'
    }
    $newLines = @(
      $lines
      "$LineComment#region $Name"
      $Value
      "$LineComment#endregion"
    )
  }
  if ($Inplace) {
    $newLines > $LiteralPath
  }
  else {
    $newLines
  }
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
    if ($item.LinkType -cne 'SymbolicLink') {
      $target = Get-Content -Raw -LiteralPath $item
      if ($target.StartsWith('.' + [System.IO.Path]::DirectorySeparatorChar)) {
        $target = $target.Substring(2)
      }
      New-Item -ItemType SymbolicLink -Force -Target $target $item
    }
    elseif ($item.Target.StartsWith('.' + [System.IO.Path]::DirectorySeparatorChar)) {
      New-Item -ItemType SymbolicLink -Force -Target $item.Target.Substring(2) $item
    }
  }
}

function New-RelativeSymlink {
  <#
  .SYNOPSIS
  Create relative symbolic links from path to target.
  #>
  [CmdletBinding()]
  [OutputType([System.IO.FileInfo[]])]
  param (
    [Parameter(Mandatory, Position = 0)]
    [string]
    $Target,
    [Parameter(Mandatory, Position = 1)]
    [string[]]
    $Path,
    [Parameter()]
    [switch]
    $Force
  )
  $Path.ForEach{
    New-Item -Type SymbolicLink -Force:$Force -Target ([System.IO.Path]::GetRelativePath($_, $Target).Substring(3)) $_
  }
}

function ConvertTo-RelativeSymlink {
  <#
  .SYNOPSIS
  Convert absolute links to relative symbolic links, returns created link info.
  #>
  [CmdletBinding()]
  [OutputType([System.IO.FileInfo[]])]
  param (
    [Parameter(Mandatory, Position = 0)]
    [SupportsWildcards()]
    [string[]]
    $Path
  )
  Get-Item $Path -Force -ea Ignore | ForEach-Object {
    if ($_.Attributes.HasFlag([System.IO.FileAttributes]::ReparsePoint) -and [System.IO.Path]::IsPathRooted($_.Target)) {
      New-Item -Type SymbolicLink -Target ([System.IO.Path]::GetRelativePath($_.DirectoryName, $_.Target)) $_.FullName -Force
    }
  }
}

function Register-PSScheduledTask {
  <#
  .SYNOPSIS
  Register scheduled tasks running powershell code.
   #>
  [CmdletBinding()]
  param (
    [Parameter(Mandatory, Position = 0)]
    [string]
    $Name,
    [Parameter(Mandatory, Position = 1)]
    [string]
    $Command,
    [Parameter()]
    [ValidateSet('once', 'daily', 'weekly', 'monthly')]
    [string]
    $Interval = 'once',
    [Parameter()]
    [datetime]
    $At = '0am',
    [Parameter()]
    [string]
    $WorkingDirectory = $HOME,
    [Parameter()]
    [switch]
    $UsePowerShell,
    [Parameter()]
    [switch]
    $AsAdmin,
    [Parameter()]
    [switch]
    $Persistent
  )
  if ($UsePowerShell) {
    $Command = 'pwsh -noni -nop -e ' + [System.Convert]::ToBase64String([System.Text.Encoding]::Unicode.GetBytes($Command))
    $Name = 'pwsh-' + $Name
  }
  if ($Interval -cne 'once') {
    $Name = $Interval + '-' + $Name
  }
  if ($IsWindows) {
    $trigger = switch ($Interval) {
      'once' { New-ScheduledTaskTrigger -At $At -Once; break }
      'daily' { New-ScheduledTaskTrigger -At $At -Daily; break }
      'weekly' { New-ScheduledTaskTrigger -At $At -Weekly -DaysOfWeek Monday; break }
      'monthly' { New-ScheduledTaskTrigger -At $At -Daily -DaysInterval 30; break }
    }
    # HACK: no show cmd window
    $action = New-ScheduledTaskAction -Execute (Get-Command uvw -Type Application -TotalCount 1).Source -Argument "run -- $Command" -WorkingDirectory $WorkingDirectory
    $settings = New-ScheduledTaskSettingsSet -StartWhenAvailable:$Persistent
    Register-ScheduledTask $Name -Force -Description "PowerShell $Name task" -Trigger $trigger -Action $action -Settings $settings -RunSeverity ($AsAdmin ? 'Highest' : 'Limited')
  }
  elseif ($IsLinux) {
    $date, $acc = switch ($Interval) {
      'once' { $_, '2h'; break }
      'daily' { '*-*-*', '1d'; break }
      'weekly' { 'Mon *-*-*', '7d'; break }
      'monthly' { '*-*-01', '30d'; break }
    }
    $service = @"
[Unit]
Description=PowerShell $Name task

[Service]
Type=oneshot
ExecStart=/usr/bin/env $Command
WorkingDirectory=$WorkingDirectory
"@
    $timer = @"
[Unit]
Description=PowerShell $Name task timer

[Timer]
OnCalendar=$date $($At.ToString('HH:mm:ss'))
Persistent=$($Persistent.ToString().ToLowerInvariant())
AccuracySec=$acc

[Install]
WantedBy=timers.target
"@
    if ($AsAdmin) {
      $null = $service | sudo tee /etc/systemd/system/$Name.service
      $null = $timer | sudo tee /etc/systemd/system/$Name.timer
      sudo systemctl daemon-reload
      sudo systemctl enable --now $Name.timer
    }
    else {
      $service > ~/.config/systemd/user/$Name.service
      $timer > ~/.config/systemd/user/$Name.timer
      systemctl daemon-reload --user
      systemctl enable --user --now $Name.timer
    }
  }
  else {
    throw [System.NotImplementedException]::new()
  }
}

function Unregister-PSScheduledTask {
  <#
  .SYNOPSIS
  Unregister scheduled tasks running powershell code.
   #>
  [CmdletBinding()]
  param (
    [Parameter(Mandatory, Position = 0)]
    [string[]]
    $Name,
    [Parameter()]
    [switch]
    $AsAdmin
  )
  if ($IsWindows) {
    # it's a $ConfirmPreference = 'High' operation
    Unregister-ScheduledTask $Name -Confirm:$false
  }
  elseif ($IsLinux) {
    if ($AsAdmin) {
      try {
        sudo systemctl disable $Name.ForEach{ $_ + '.timer' }
        sudo rm -f `-- $Name.ForEach{ "/etc/systemd/system/$_.service"; "/etc/systemd/system/$_.timer" }
      }
      finally {
        sudo systemctl daemon-reload
      }
    }
    else {
      try {
        systemctl disable --user $Name.ForEach{ $_ + '.timer' }
        Remove-Item -LiteralPath $Name.ForEach{ "$HOME/.config/systemd/user/$_.service"; "$HOME/.config/systemd/user/$_.timer" } -Force
      }
      finally {
        systemctl daemon-reload --user
      }
    }
  }
  else {
    throw [System.NotImplementedException]::new()
  }
}

function Send-Notify {
  [CmdletBinding()]
  param (
    [Parameter(Mandatory, Position = 0)]
    [string]
    $Text,
    [Parameter()]
    [string]
    $Title = 'Send-Notify',
    [Parameter()]
    [ValidateSet('Information', 'Warning', 'Error')]
    [string]
    $Severity = 'Information',
    [Parameter()]
    [int]
    $Timeout = 3000
  )
  if ($IsWindows) {
    Add-Type -AssemblyName System.Windows.Forms
    $notify = [System.Windows.Forms.NotifyIcon]::new()
    $notify.BalloonTipIcon = $Severity -ceq 'Information' ? [System.Windows.Forms.ToolTipIcon]::Info : [System.Windows.Forms.ToolTipIcon]$Severity
    $notify.BalloonTipTitle = $Title
    $notify.BalloonTipText = $Text
    $notify.Icon = [System.Drawing.SystemIcons]::Application
    $notify.Visible = $true
    $null = Register-ObjectEvent $notify -EventName BalloonTipClosed -MaxTriggerCount 1 -Action {
      $args[0].Dispose()
    }
    $notify.ShowBalloonTip($Timeout)
  }
  elseif ($IsLinux) {
    $urgency = switch -CaseSensitive ($Severity) {
      'Information' { 'low'; break }
      'Warning' { 'normal'; break }
      'Error' { 'critical'; break }
    }
    notify-send $Text --app-name=$Title --urgency=$urgency --expire-time=$Timeout --icon=/usr/share/icons/breeze/status/64/dialog-$($Severity.ToLowerInvariant()).svg
  }
  else {
    throw [System.NotImplementedException]::new()
  }
}

function Invoke-CodeFormatter {
  [CmdletBinding(DefaultParameterSetName = 'Path')]
  [Alias('icf')]
  param (
    [Parameter(Mandatory, Position = 0, ParameterSetName = 'Path')]
    [ValidateNotNullOrEmpty()]
    [SupportsWildcards()]
    [string[]]
    $Path,
    [Parameter(Mandatory, ParameterSetName = 'LiteralPath')]
    [Alias('PSPath')]
    [ValidateNotNullOrEmpty()]
    [string[]]
    $LiteralPath
  )
  $Path + $LiteralPath | ForEach-Object { & (getParser $_ -Inplace) $_ }
}

function batf {
  if ($MyInvocation.ExpectingInput) {
    $name = $args[0]
    if ($MyInvocation.PipelinePosition -lt $MyInvocation.PipelineLength) {
      return $input | & (getParser $name -Stdin) $name
    }
    return $input | & (getParser $name -Stdin) $name | bat -p --file-name=$name
  }
  if ($MyInvocation.PipelinePosition -lt $MyInvocation.PipelineLength) {
    return Convert-Path $args -Force | ForEach-Object { & (getParser $_) $_ }
  }
  Convert-Path $args -Force | ForEach-Object {
    & (getParser $_) $_ | bat -p --color=always --file-name=$_
  } | & $env:PAGER
}

function getParser ([string]$Path, [switch]$Inplace, [switch]$Stdin) {
  switch -CaseSensitive -Regex ([System.IO.Path]::GetExtension($Path).Substring(1)) {
    '^(?:c|m|mm|cpp|cc|cp|cxx|c\+\+|h|hh|hpp|hxx|h\+\+|inl|ipp|java|proto|protodevel)$' {
      if ($Inplace) {
        { clang-format -i --style=LLVM `-- $args[0] }
      }
      elseif ($Stdin) {
        { $input | clang-format --style=LLVM --assume-filename=$args[0] }
      }
      else {
        { clang-format --style=LLVM `-- $args[0] }
      }
      break
    }
    '^(?:dart)$' {
      if ($Inplace) {
        { dart format `-- $args[0] }
      }
      elseif ($Stdin) {
        { $input | dart format }
      }
      else {
        { dart format -o show --show none --summary none `-- $args[0] }
      }
      break
    }
    '^(?:cs|csx|fs|fsi|fsx|vb)$' {
      if ($Inplace) {
        { dotnet format --no-restore --include `-- $args[0] }
      }
      elseif ($Stdin) {
        {
          process {
            $file = [System.IO.Path]::GetRandomFileName() + [System.IO.Path]::GetExtension($args[0])
            $input > $file
            dotnet format --no-restore --include `-- $file
            Get-Content -LiteralPath $file
          }
          clean {
            Remove-Item -LiteralPath $file -Force
          }
        }
      }
      else {
        {
          process {
            $file = [System.IO.Path]::GetTempFileName()
            Copy-Item -LiteralPath $args[0] $file -Force
            dotnet format --no-restore --include `-- $args[0]
            Get-Content -LiteralPath $args[0]
          }
          clean {
            Copy-Item -LiteralPath $file $args[0] -Force
            Remove-Item -LiteralPath $file -Force
          }
        }
      }
      break
    }
    '^(?:go)$' {
      if ($Inplace) {
        { goimports -w `-- $args[0] }
      }
      elseif ($Stdin) {
        { $input | goimports }
      }
      else {
        { goimports `-- $args[0] }
      }
      break
    }
    '^(?:js|cjs|mjs|jsx|tsx|ts|cts|mts|json|jsonc|json5|yml|yaml|htm|html|xhtml|shtml|vue|gql|graphql|css|scss|sass|less|hbs|md|markdown)$' {
      if ($Inplace) {
        { prettier -w --ignore-path= `-- $args[0] }
      }
      elseif ($Stdin) {
        { $input | prettier --ignore-path= --stdin-filepath=$args[0] }
      }
      else {
        { prettier --ignore-path= `-- $args[0] }
      }
      break
    }
    '^(?:ps1|psm1|psd1)$' {
      if ($Inplace) {
        { PSScriptAnalyzer\Invoke-Formatter (Get-Content -Raw -LiteralPath $args[0]) -Settings $env:SHUTILS_ROOT/CodeFormatting.psd1 | Out-File -NoNewline $args[0] }
      }
      elseif ($Stdin) {
        { PSScriptAnalyzer\Invoke-Formatter $input -Settings $env:SHUTILS_ROOT/CodeFormatting.psd1 }
      }
      else {
        { PSScriptAnalyzer\Invoke-Formatter (Get-Content -Raw -LiteralPath $args[0]) -Settings $env:SHUTILS_ROOT/CodeFormatting.psd1 }
      }
      break
    }
    '^(?:py|pyi|pyw|pyx|pxd|gyp|gypi)$' {
      if ($Inplace) {
        { ruff format -n `-- $args[0] }
      }
      elseif ($Stdin) {
        { $input | ruff format -n --stdin-filename $args[0] }
      }
      else {
        { Get-Content -LiteralPath $args[0] | ruff format -n --stdin-filename $args[0] }
      }
      break
    }
    '^(?:rs)$' {
      if ($Inplace) {
        { rustfmt `-- $args[0] }
      }
      elseif ($Stdin) {
        { $input | rustfmt --emit stdout }
      }
      else {
        { rustfmt --emit stdout `-- $args[0] }
      }
      break
    }
    '^(?:sh|bash|zsh|ash)$' {
      if ($Inplace) {
        { shfmt -i 2 -bn -ci -sr `-- $args[0] }
      }
      elseif ($Stdin) {
        { $input | shfmt -i 2 -bn -ci -sr --filename $args[0] }
      }
      else {
        { Get-Content -LiteralPath $args[0] | shfmt -i 2 -bn -ci -sr --filename $args[0] }
      }
      break
    }
    '^(?:toml)$' {
      if ($Inplace) {
        { taplo format `-- $args[0] }
      }
      elseif ($Stdin) {
        { $input | taplo format - --stdin-filepath=$args[0] }
      }
      else {
        { Get-Content -LiteralPath $args[0] | taplo format - --stdin-filepath=$args[0] }
      }
      break
    }
    '^(?:lua)$' {
      if ($Inplace) {
        { stylua `-- $args[0] }
      }
      elseif ($Stdin) {
        { $input | stylua }
      }
      else {
        { Get-Content -LiteralPath $args[0] | stylua }
      }
      break
    }
    '^(?:zig)$' {
      if ($Inplace) {
        { zig fmt $args[0] }
      }
      elseif ($Stdin) {
        { $input | zig fmt --stdin }
      }
      else {
        { Get-Content -LiteralPath $args[0] | zig fmt --stdin }
      }
      break
    }
    default {
      if ($Stdin) {
        { $input }
      }
      else {
        { Get-Content -LiteralPath $args[0] }
      }
      break
    }
  }
}

function ghQuery {
  [CmdletBinding()]
  param (
    [Parameter(Position = 0)]
    [ValidateSet('releases', 'limits', 'stars', 'tree')]
    [string]
    $Category,
    [Parameter(Position = 1, ValueFromRemainingArguments)]
    [string[]]
    $Queries
  )
  [string]$query = "query=@$PSScriptRoot/github/$Category.gql"
  [string[]]$fields = @()
  [string]$jq = ''
  switch ($Category) {
    releases {
      $jq = '.repository.latestRelease[].name'
      $owner, $name = $Queries[0].Split('/', 2)
      $fields += "owner=$owner", "name=$name"
      break
    }
    stars {
      $jq = '.user.starredRepositories[].nameWithOwner'
      $login = git config get --global user.name
      if (!$login) {
        throw 'recommands: git config set --global user.name foo'
      }
      $fields += "login=$login"
      break
    }
    tree {
      $jq = '.repository.object.entries'
      $owner, $name = $Queries[0].Split('/', 2)
      $items = $Queries[1].Split(':', 2)
      if ($items.Count -eq 1) {
        $items = 'HEAD', $items
      }
      $items[1] = $items[1].Replace('\', '/') -creplace '^\.?/|/$', ''
      $expression = $items -join ':'
      $fields += "owner=$owner", "name=$name", "expression=$expression"
      break
    }
  }
  gh api graphql -F $query $fields.ForEach{ "-f$_" } -q .data$jq | Tee-Object -LiteralPath Temp:/ghQuery.json
}

function Get-RepoBlob {
  [CmdletBinding()]
  param (
    [Parameter(Mandatory, Position = 0)]
    [string]
    $Repo,
    [Parameter(Mandatory, Position = 1)]
    [string[]]
    $Path,
    [Parameter()]
    [string]
    $Ref = 'HEAD',
    [Parameter()]
    [string]
    $Directory = [System.IO.Path]::GetTempPath()
  )
  [string[]]$executables = @()
  [string[]]$symbolicLinks = @()
  [string[]]$files = for ($i = 0; $i -lt $Path.Count; $i++) {
    if (![System.IO.Path]::EndsInDirectorySeparator($Path[$i])) {
      $Path[$i].Replace('\', '/') -creplace '^\.?/', ''
      continue
    }
    $dir = $Path[$i].Replace('\', '/') -creplace '^\.?/|/$', ''
    $entries = ghQuery tree $Repo $Ref`:$dir | ConvertFrom-Json
    foreach ($entry in $entries) {
      $file = $dir + '/' + $entry.name
      switch ([System.Convert]::ToString($entry.mode, 8)) {
        '100644' { $file; break }
        '100755' { $executables += $file; $file; break }
        '120000' { $symbolicLinks += $file; $file; break }
        '160000' { Write-Warning "ignore submodule $file"; break }
        '40000' { $Path += $file + '/'; break }
        default { Write-Warning "ignore $_ $file"; break }
      }
    }
  }
  try {
    Push-Location -LiteralPath (New-Item -Type Directory -Force $Directory)
    New-Item $files -Force
    $files.ForEach{ "https://github.com/$Repo/raw/$Ref/$_"; " out=$_" } | aria2c -i- -x2 -j32 --allow-overwrite --file-allocation=$($IsWindows ? 'prealloc' : 'falloc') >> Temp:/aria2c.log
    $ErrorActionPreference = 'Continue'
    if (!$IsWindows -and $executables) {
      chmod 0755 `-- $executables
    }
    $symbolicLinks.ForEach{ New-Item -ItemType SymbolicLink -Force -Target (Get-Content -Raw -LiteralPath $_) $_ }
  }
  finally {
    Pop-Location
  }
}

function jq.f {
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

[psobject[]]$vimDigraph = $null
function de {
  [CmdletBinding()]
  param (
    [Parameter(Mandatory, Position = 0)]
    [string]
    $Digraph
  )
  if (!$vimDigraph) {
    $Script:vimDigraph = Import-Csv -LiteralPath $PSScriptRoot/vimDigraph.tsv -Delimiter "`t" -ea Stop
  }
  foreach ($item in $vimDigraph) {
    if ($item.digraph -ceq $Digraph) {
      return $item.char
    }
  }
  return Write-Error 'no matches'
}

function de.f {
  [string]$line = Get-Content -LiteralPath $PSScriptRoot/vimDigraph.tsv | Select-Object -Skip 1 | fzf
  $line.Split("`t", 2)[0]
}

function figlet.f ([string]$Value) {
  if ([string]::IsNullOrEmpty($Value)) {
    $Value = if ($MyInvocation.ExpectingInput) {
      $input
    }
    else {
      'hello world'
    }
  }
  $Value = $Value.Replace("'", "\'")
  $envVar = $IsWindows ? '%FZF_PREVIEW_COLUMNS%' : '$FZF_PREVIEW_COLUMNS'
  Split-Path -Resolve -LeafBase /usr/share/figlet/*.flf | fzf --reverse --preview-window=70% "--preview=figlet -f {} -w $envVar '$Value'" "--bind=enter:become:figlet -f {} -w $([System.Console]::WindowWidth) '$Value'"
}

function rg.f {
  [CmdletBinding()]
  param (
    [Parameter(Mandatory, Position = 0)]
    [string]
    $Query,
    [Parameter(Position = 1, ValueFromRemainingArguments)]
    [string[]]
    $Options,
    [Parameter(ValueFromPipeline)]
    [System.Object]
    $InputObject
  )
  if ($MyInvocation.ExpectingInput) {
    return $input | rg $Query @Options | fzf
  }
  $reload = @"
rg $Options --column --color=always {q} || exit 0
"@
  $open = @'
code --open-url "vscode://file$(realpath -- {1}):{2}:{3}"
'@
  $envVar = $IsWindows ? '%FZF_PREVIEW_COLUMNS%' : '$FZF_PREVIEW_COLUMNS'
  $preview = @"
bat --number --color=always --terminal-width=$envVar --highlight-line={2} {1}
"@
  $ags = @(
    "--query=$Query"
    '--ansi'
    '--delimiter=:'
    '--preview-window=up,border-bottom,~3,+{2}+3/3'
    "--preview=$preview"
    "--bind=start,ctrl-r:reload:$reload"
    "--bind=enter:become:$open"
    "--bind=ctrl-o:execute:$open"
  )
  fzf @ags
}

function theme.f {
  [CmdletBinding()]
  param (
    [Parameter(Position = 0)]
    [ValidateSet('alacritty', 'bat')]
    [string]
    $AppName
  )
  if (!$AppName) {
    if ($env:ALACRITTY_LOG) {
      $AppName = 'alacritty'
    }
  }
  switch ($AppName) {
    alacritty {
      [string]$preview = {
        $configFile = "$env:SHUTILS_ROOT/_/.config/alacritty/alacritty.toml"
        $importFile = "$($env:SHUTILS_ROOT.Replace($HOME, '~').Replace('\', '/'))/alacritty-theme/themes/$("$input".Trim(' "')).toml"
        Set-Region -Inplace import "import = [`"$importFile`"]" $configFile
        @"
|039| `e[39mDefault `e[m  |049| `e[49mDefault `e[m  |037| `e[37mLight gray `e[m     |047| `e[47mLight gray `e[m
|030| `e[30mBlack `e[m    |040| `e[40mBlack `e[m    |090| `e[90mDark gray `e[m      |100| `e[100mDark gray `e[m
|031| `e[31mRed `e[m      |041| `e[41mRed `e[m      |091| `e[91mLight red `e[m      |101| `e[101mLight red `e[m
|032| `e[32mGreen `e[m    |042| `e[42mGreen `e[m    |092| `e[92mLight green `e[m    |102| `e[102mLight green `e[m
|033| `e[33mYellow `e[m   |043| `e[43mYellow `e[m   |093| `e[93mLight yellow `e[m   |103| `e[103mLight yellow `e[m
|034| `e[34mBlue `e[m     |044| `e[44mBlue `e[m     |094| `e[94mLight blue `e[m     |104| `e[104mLight blue `e[m
|035| `e[35mMagenta `e[m  |045| `e[45mMagenta `e[m  |095| `e[95mLight magenta `e[m  |105| `e[105mLight magenta `e[m
|036| `e[36mCyan `e[m     |046| `e[46mCyan `e[m     |096| `e[96mLight cyan `e[m     |106| `e[106mLight cyan `e[m
"@
      }
      $preview = [System.Convert]::ToBase64String([System.Text.Encoding]::Unicode.GetBytes($preview))
      $configFile = "$env:SHUTILS_ROOT/_/.config/alacritty/alacritty.toml"
      $region = Get-Region import $configFile
      $theme = [regex]::Match($region[0], '([^"/]+)\.toml"$').Groups[1].Value
      Split-Path -Resolve -LeafBase $env:SHUTILS_ROOT/alacritty-theme/themes/* -ea Stop | fzf --preview="echo {} | pwsh -nop -o Text -e $preview" -q $theme
      if (!$?) {
        Set-Region -Inplace import $region $configFile
      }
      break
    }
    bat {
      $theme = bat --list-themes | fzf --preview="bat --theme={} -plsh --color=always $HOME/.bashrc" -q "$env:BAT_THEME"
      if ($theme) {
        Set-EnvironmentVariable -Scope User BAT_THEME=$theme
      }
      break
    }
  }
}
