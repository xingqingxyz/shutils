#region exports
function Get-GithubRepositoryBlob {
  [CmdletBinding()]
  param (
    [Parameter(Mandatory, Position = 0)]
    [ValidateNotNullOrEmpty()]
    [string]
    $Repo,
    [Parameter(Mandatory, Position = 1)]
    [ValidateNotNullOrEmpty()]
    [string[]]
    $Path,
    [Parameter()]
    [ValidateNotNullOrEmpty()]
    [string]
    $Ref = 'HEAD',
    [Parameter()]
    [ValidateNotNullOrEmpty()]
    [string]
    $Directory = [System.IO.Path]::GetTempPath()
  )
  $executables = @()
  $symbolicLinks = @()
  $files = for ($i = 0; $i -lt $Path.Count; $i++) {
    if (![System.IO.Path]::EndsInDirectorySeparator($Path[$i])) {
      $Path[$i].Replace('\', '/') -creplace '^\.?/', ''
      continue
    }
    $dir = $Path[$i].Replace('\', '/') -creplace '^\.?/|/$', ''
    $entries = Invoke-GithubGraphQL tree $Repo $Ref`:$dir | ConvertFrom-Json
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

function Invoke-GithubGraphQL {
  [CmdletBinding()]
  [OutputType([string])]
  param (
    [Parameter(Position = 0)]
    [ValidateSet('releases', 'limits', 'stars', 'tree')]
    [string]
    $Category,
    [Parameter(Position = 1, ValueFromRemainingArguments)]
    [ValidateNotNullOrEmpty()]
    [string[]]
    $Queries
  )
  [string]$query = "query=@$PSScriptRoot/github/$Category.gql"
  [string[]]$fields = @()
  [string]$jq = ''
  switch ($Category) {
    releases {
      $jq = '.repository.latestRelease.releaseAssets.nodes[].name'
      $owner, $name = $Queries[0].Split('/', 2)
      $fields += "owner=$owner", "name=$name"
      break
    }
    stars {
      $login = git config get --global user.name
      if (!$login) {
        throw 'recommands: git config set --global user.name foo'
      }
      $cursor = ''
      $hasNextPage = $true
      return @(while ($hasNextPage) {
          $data = gh api graphql -F $query -f "login=$login" -f "cursor=$cursor" -q .data.user.starredRepositories | ConvertFrom-Json
          $data.nodes.nameWithOwner
          $cursor = $data.pageInfo.endCursor
          $hasNextPage = $data.pageInfo.hasNextPage
        }) | Sort-Object
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
  gh api graphql -F $query $fields.ForEach{ "-f$_" } -q .data$jq
}

function Register-PSScheduledTask {
  <#
  .SYNOPSIS
  Register scheduled tasks running powershell code.
   #>
  [CmdletBinding()]
  param (
    [Parameter(Mandatory, Position = 0)]
    [ValidateNotNullOrEmpty()]
    [string]
    $Name,
    [Parameter(Mandatory, Position = 1)]
    [ValidateNotNullOrEmpty()]
    [string]
    $Command,
    [Parameter()]
    [int]
    $DaysInterval,
    [Parameter()]
    [datetime]
    $At = '0am',
    [Parameter()]
    [string]
    $WorkingDirectory = $HOME,
    [Parameter()]
    [switch]
    $AtStartup,
    [Parameter()]
    [switch]
    $Persistent,
    [Parameter()]
    [switch]
    $UsePowerShell,
    [Parameter()]
    [switch]
    $AsAdmin,
    [Parameter()]
    [switch]
    $Graphical,
    [Parameter()]
    [switch]
    $Network,
    [Parameter()]
    [switch]
    $Force
  )
  if ($UsePowerShell) {
    $Command = 'pwsh -noni -nop -e ' + [System.Convert]::ToBase64String([System.Text.Encoding]::Unicode.GetBytes($Command))
  }
  $Name = 'pwsh-' + ($AtStartup ? 'startup' : $DaysInterval ? "${DaysInterval}d" : 'once') + '-' + $Name
  if ($IsWindows) {
    $trigger = if ($AtStartup) {
      if ($AsAdmin) {
        New-ScheduledTaskTrigger -AtStartup
      }
      else {
        New-ScheduledTaskTrigger -AtLogOn
      }
    }
    elseif ($DaysInterval) {
      New-ScheduledTaskTrigger -At $At -Daily -DaysInterval $DaysInterval
    }
    else {
      New-ScheduledTaskTrigger -At $At -Once
    }
    # HACK: no show cmd window
    $action = New-ScheduledTaskAction -Execute (Get-Command uvw -Type Application -TotalCount 1).Source -Argument "run -- $Command" -WorkingDirectory $WorkingDirectory
    $settings = New-ScheduledTaskSettingsSet -StartWhenAvailable:$Persistent -RunOnlyIfNetworkAvailable:$Network -RestartCount 2 -RestartInterval 0:12
    Register-ScheduledTask $Name -Description "PowerShell $Name task" -Trigger $trigger -Action $action -Settings $settings -RunLevel ($AsAdmin ? 'Highest' : 'Limited') -Force:$Force
  }
  elseif ($IsLinux) {
    if (!$Force -and (systemctl show @(if (!$AsAdmin) { '--user' }) $Name -p ExecStart)) {
      return Write-Error "Task $Name already exists."
    }
    if (![System.IO.Path]::IsPathFullyQualified($Command.Split(' ', 2)[0])) {
      $Command = '/usr/bin/env ' + $Command
    }
    $service = @"
[Unit]
Description=PowerShell $Name task
StartLimitIntervalSec=12m
StartLimitBurst=2
$($AsAdmin -and $Network ? 'Wants=network-online.target
After=network-online.target' : '')

[Service]
Type=oneshot
ExecStart=$Command
WorkingDirectory=$WorkingDirectory
Environment="HOME=$HOME" "PSModulePath=$env:PSModulePath"
Restart=on-failure
RestartSec=12m
$(!$AsAdmin -and $Network ? 'ExecStartPre=/bin/sh -c "until ping -c1 -W1 8.8.8.8; do sleep 1; done"' : '')
$($AsAdmin ? "[Install]
WantedBy=$($Graphical ? 'graphical.target' : 'multi-user.target')" : '')
"@
    $timer = @"
[Unit]
Description=PowerShell $Name task timer

[Timer]
OnCalendar=$($DaysInterval -eq 1 ? '*-*-*' : $At.ToString('yyyy-MM-dd')) $($At.ToString('HH:mm:ss'))
OnUnitActiveSec=$($DaysInterval -le 1 ? [int]::MaxValue : $DaysInterval)d
$($AtStartup ? "On$($AsAdmin ? 'Boot' : 'Startup')Sec=10s" : '')
Persistent=$($Persistent.ToString().ToLowerInvariant())
AccuracySec=$($Persistent ? [System.Math]::Floor($DaysInterval * 12) : 0)h

[Install]
WantedBy=timers.target
"@
    if ($AsAdmin) {
      $null = $service | sudo tee /etc/systemd/system/$Name.service
      $null = $timer | sudo tee /etc/systemd/system/$Name.timer
      sudo systemctl daemon-reload
      sudo systemctl enable --now $Name`.timer
    }
    else {
      $service > ~/.config/systemd/user/$Name.service
      $timer > ~/.config/systemd/user/$Name.timer
      systemctl --user daemon-reload
      systemctl --user enable --now $Name`.timer
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
    [ValidateNotNullOrEmpty()]
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
      sudo systemctl disable $Name.ForEach{ $_ + '.timer' }
      sudo rm -f `-- $Name.ForEach{ "/etc/systemd/system/$_.service"; "/etc/systemd/system/$_.timer" }
      sudo systemctl daemon-reload
    }
    else {
      systemctl disable --user $Name.ForEach{ $_ + '.timer' }
      Remove-Item -LiteralPath $Name.ForEach{ "$HOME/.config/systemd/user/$_.service"; "$HOME/.config/systemd/user/$_.timer" } -Force
      systemctl daemon-reload --user
    }
  }
  else {
    throw [System.NotImplementedException]::new()
  }
}

function Get-Region {
  [CmdletBinding(DefaultParameterSetName = 'LiteralPath')]
  [OutputType([string[]])]
  param (
    [Parameter(Mandatory, Position = 0)]
    [ValidateNotNullOrEmpty()]
    [string]
    $Name,
    [Parameter(Mandatory, Position = 2, ParameterSetName = 'LiteralPath')]
    [Alias('LP')]
    [ValidateNotNullOrEmpty()]
    [string]
    $LiteralPath,
    [Parameter()]
    [ValidateNotNullOrEmpty()]
    [string]
    $LineComment,
    [Parameter(Mandatory, ValueFromPipeline, ParameterSetName = 'Stdin')]
    [System.Object]
    $InputObject
  )
  [string[]]$lines = $MyInvocation.ExpectingInput ? $input : (Get-Content -LiteralPath $LiteralPath -ea Ignore)
  $found = 0
  $lines = foreach ($line in $lines) {
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
    Write-Warning "#region $Name mark not found"
  }
  elseif ($found -eq 1) {
    Write-Warning '#endregion mark not found'
  }
  else {
    $lines
  }
}

function Set-Region {
  [CmdletBinding(DefaultParameterSetName = 'LiteralPath')]
  [OutputType([string[]])]
  param (
    [Parameter(Mandatory, Position = 0)]
    [ValidateNotNullOrEmpty()]
    [string]
    $Name,
    [Parameter(Mandatory, Position = 1)]
    [AllowEmptyCollection()]
    [string[]]
    $Value,
    [Parameter(Mandatory, Position = 2, ParameterSetName = 'LiteralPath')]
    [Alias('LP')]
    [ValidateNotNullOrEmpty()]
    [string]
    $LiteralPath,
    [Parameter(ParameterSetName = 'LiteralPath')]
    [switch]
    $Force,
    [Parameter()]
    [ValidateNotNullOrEmpty()]
    [string]
    $LineComment,
    [Parameter(Mandatory, ValueFromPipeline, ParameterSetName = 'Stdin')]
    [System.Object]
    $InputObject
  )
  if ($LiteralPath -and !(Test-Path -LiteralPath $LiteralPath -PathType Leaf)) {
    if (!$Force) {
      return Write-Error "file $LiteralPath not found"
    }
    New-Item $LiteralPath -Force
  }
  [string[]]$lines = $MyInvocation.ExpectingInput ? $input : (Get-Content -LiteralPath $LiteralPath)
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
  if ($LiteralPath) {
    $newLines > $LiteralPath
  }
  else {
    $newLines
  }
}

function ConvertTo-RelativeSymlink {
  <#
  .SYNOPSIS
  Convert absolute links to relative symbolic links, returns created link info.
  #>
  [CmdletBinding(DefaultParameterSetName = 'Path')]
  [OutputType([System.IO.FileInfo[]])]
  param (
    [Parameter(Mandatory, Position = 0, ParameterSetName = 'Path')]
    [ValidateNotNullOrEmpty()]
    [SupportsWildcards()]
    [string[]]
    $Path,
    [Parameter(Mandatory, ParameterSetName = 'LiteralPath')]
    [Alias('LP')]
    [ValidateNotNullOrEmpty()]
    [string[]]
    $LiteralPath
  )
  Get-Item @PSBoundParameters | ForEach-Object {
    if ($_.Attributes.HasFlag([System.IO.FileAttributes]::ReparsePoint) -and [System.IO.Path]::IsPathRooted($_.Target)) {
      New-Item -Type SymbolicLink -Target ([System.IO.Path]::GetRelativePath($_.DirectoryName, $_.Target)) $_.FullName -Force
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
    [ValidateNotNullOrEmpty()]
    [string]
    $Target,
    [Parameter(Mandatory, Position = 1)]
    [ValidateNotNullOrEmpty()]
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

function Get-DarkMode {
  if ($IsWindows) {
    !(Get-ItemProperty -LiteralPath 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize' -Name 'SystemUsesLightTheme').SystemUsesLightTheme
  }
  elseif ($IsLinux) {
    if ($env:XDG_CURRENT_DESKTOP -clike '*GNOME') {
      (gsettings get org.gnome.desktop.interface color-scheme) -ceq "'prefer-dark'"
    }
    elseif ($env:XDG_CURRENT_DESKTOP -clike '*KDE') {
      (kreadconfig6 --file kdeglobals --group General --key ColorScheme) -clike '*Dark*'
    }
    elseif (Get-Process dms -ea Ignore) {
      (dms ipc theme getMode) -ceq 'dark'
    }
    else {
      (gdbus call --session --dest org.freedesktop.portal.Desktop --object-path /org/freedesktop/portal/desktop --method org.freedesktop.portal.Settings.Read org.freedesktop.appearance color-scheme) -ceq '(<<uint32 1>>,)'
    }
  }
  else {
    $false
  }
}

function Set-Wallpaper {
  [CmdletBinding()]
  param (
    [Parameter(Mandatory, Position = 0)]
    [ValidateNotNullOrEmpty()]
    [string]
    $LiteralPath
  )
  if ($IsWindows) {
    $type = Add-Type -Namespace 'Win32' -PassThru '_SystemParametersInfo' @'
[DllImport("user32.dll", SetLastError = true, CharSet = CharSet.Auto)]
public static extern bool SystemParametersInfo(int uAction, int uParam, string lpvParam, int fuWinIni);
'@
    if (!$type::SystemParametersInfo(20, 0, $LiteralPath, 3)) {
      throw 'api set wallpaper failed'
    }
  }
  elseif ($IsMacOS) {
    osascript -e @"
      tell application "System Events"
        set picturePath to "$($LiteralPath.Replace('"', '\"'))"
        repeat with d in desktops
          set picture of d to picturePath
        end repeat
      end tell
"@
  }
  elseif ($IsLinux) {
    if ($env:XDG_CURRENT_DESKTOP -clike '*GNOME') {
      gsettings set org.gnome.desktop.background picture-uri "file://$LiteralPath"
      gsettings set org.gnome.desktop.background picture-uri-dark "file://$LiteralPath"
      gsettings set org.gnome.desktop.screensaver picture-uri "file://$LiteralPath"
    }
    elseif ($env:XDG_CURRENT_DESKTOP -clike '*KDE') {
      qdbus org.kde.plasmashell /PlasmaShell org.kde.PlasmaShell.evaluateScript @"
        var allDesktops = desktops();
        for (i = 0; i < allDesktops.length; i++) {
          d = allDesktops[i];
          d.wallpaperPlugin = "org.kde.image";
          d.currentConfigGroup = Array("Wallpaper", "org.kde.image", "General");
          d.writeConfig("Image", "file://$($LiteralPath.Replace('"', '\"'))");
          d.writeConfig("FillMode", 3);
        }
"@
    }
    elseif (Get-Process dms -ea Ignore) {
      dms ipc wallpaper set $LiteralPath
    }
    else {
      throw "unknown desktop $env:XDG_CURRENT_DESKTOP"
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
    [ValidateNotNullOrEmpty()]
    [string]
    $Text,
    [Parameter()]
    [ValidateNotNullOrEmpty()]
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

function Show-ScreenText {
  <#
  .OUTPUTS
  ScriptBlock to dispose the form.
  #>
  [CmdletBinding()]
  [OutputType([scriptblock])]
  param (
    [Parameter(Mandatory, Position = 0)]
    [ValidateNotNullOrEmpty()]
    [string]
    $Text,
    [Parameter()]
    [ValidateSet('TopLeft', 'TopCenter', 'TopRight', 'MiddleLeft', 'MiddleCenter', 'MiddleRight', 'BottomLeft', 'BottomCenter', 'BottomRight')]
    [string]
    $Position = 'MiddleCenter',
    [Parameter()]
    [string]
    $FontFamily = 'SimSun',
    [Parameter()]
    [int]
    $FontSize = 72,
    [Parameter()]
    [switch]
    $PassThru
  )

  if ($IsWindows) {
    throw [System.NotImplementedException]::new()
  }

  $run = {
    param ([string]$Text, [string]$Position, [string]$FontFamily, [int]$FontSize, [psobject]$Shared)

    function Get-Position ([string]$position, [System.Drawing.SizeF]$textSize, [System.Drawing.Size]$clientSize) {
      switch ($position) {
        'TopLeft' { return [System.Drawing.PointF]::new(0, 0) }
        'TopCenter' { return [System.Drawing.PointF]::new(($clientSize.Width - $textSize.Width) / 2, 0) }
        'TopRight' { return [System.Drawing.PointF]::new($clientSize.Width - $textSize.Width, 0) }
        'MiddleLeft' { return [System.Drawing.PointF]::new(0, ($clientSize.Height - $textSize.Height) / 2) }
        'MiddleCenter' { return [System.Drawing.PointF]::new(($clientSize.Width - $textSize.Width) / 2, ($clientSize.Height - $textSize.Height) / 2) }
        'MiddleRight' { return [System.Drawing.PointF]::new($clientSize.Width - $textSize.Width, ($clientSize.Height - $textSize.Height) / 2) }
        'BottomLeft' { return [System.Drawing.PointF]::new(0, $clientSize.Height - $textSize.Height) }
        'BottomCenter' { return [System.Drawing.PointF]::new(($clientSize.Width - $textSize.Width) / 2, $clientSize.Height - $textSize.Height) }
        'BottomRight' { return [System.Drawing.PointF]::new($clientSize.Width - $textSize.Width, $clientSize.Height - $textSize.Height) }
      }
    }

    Add-Type -Namespace Win32 _SetForegroundWindow @'
[DllImport("user32.dll")]
public static extern bool SetForegroundWindow(IntPtr hWnd);
'@
    Add-Type -Namespace Win32 _SetActiveWindow @'
[DllImport("user32.dll")]
public static extern bool SetActiveWindow(IntPtr hWnd);
'@

    Add-Type -AssemblyName System.Windows.Forms
    Add-Type -AssemblyName System.Drawing

    $form = New-Object System.Windows.Forms.Form
    $form.FormBorderStyle = 'None'
    $form.TopMost = $true
    $form.ShowInTaskbar = $false
    $form.StartPosition = 'Manual'
    $form.Bounds = [System.Windows.Forms.Screen]::PrimaryScreen.Bounds
    $form.BackColor = [System.Drawing.Color]::Black
    $form.TransparencyKey = [System.Drawing.Color]::Black

    $font = New-Object System.Drawing.Font($FontFamily, $FontSize, [System.Drawing.FontStyle]::Bold)
    $brush = [System.Drawing.Brushes]::White

    $form.Add_Paint({
        param($s, $e)
        $g = $e.Graphics
        $g.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::AntiAlias
        $pos = Get-Position $Position $g.MeasureString($Text, $font) $form.ClientSize
        $g.DrawString($Text, $font, $brush, $pos.X, $pos.Y)
      })

    $form.Add_KeyDown({
        param($s, $e)
        if ($e.KeyCode -eq [System.Windows.Forms.Keys]::Escape) {
          $form.Close()
        }
      })

    $form.Add_Load({
        param($s, $e)
        $null = [Win32._SetForegroundWindow]::SetForegroundWindow($form.Handle)
        $null = [Win32._SetActiveWindow]::SetActiveWindow($form.Handle)
      })

    [System.Windows.Forms.Application]::Run($form)
    $null = Start-ThreadJob {
      param ($Shared)
      $Shared.ps.Stop()
      $Shared.ps.Dispose()
      $Shared.rs.Close()
      $Shared.rs.Dispose()
    } -ArgumentList $Shared
  }

  $rs = [runspacefactory]::CreateRunspace()
  $rs.ApartmentState = 'STA'
  $rs.Open()
  $ps = [powershell]::Create().AddScript($run).AddArgument($Text).AddArgument($Position).AddArgument($FontFamily).AddArgument($FontSize)
  $null = $ps.AddArgument([pscustomobject]@{
      ps = $ps
      rs = $rs
    })
  $ps.Runspace = $rs
  $null = $ps.BeginInvoke()

  if ($PassThru) {
    {
      Add-Type -AssemblyName System.Windows.Forms
      [System.Windows.Forms.Application]::Exit()
      $ps.Stop()
      $ps.Dispose()
      $rs.Close()
      $rs.Dispose()
    }.GetNewClosure()
  }
}

function de {
  [CmdletBinding()]
  param (
    [Parameter(Mandatory, Position = 0)]
    [ValidateNotNullOrEmpty()]
    [string]
    $Digraph
  )
  if (!$vimDigraph) {
    $Script:vimDigraph = Import-Csv -LiteralPath $PSScriptRoot/vimDigraph.tsv -Delimiter "`t"
  }
  foreach ($item in $vimDigraph) {
    if ($item.digraph -ceq $Digraph) {
      return $item.char
    }
  }
  throw "no matches for digraph $Digraph"
}

#region fzf
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

function rg.f {
  [CmdletBinding()]
  param (
    [Parameter(Mandatory, Position = 0)]
    [ValidateNotNullOrEmpty()]
    [string]
    $Query,
    [Parameter(Position = 1, ValueFromRemainingArguments)]
    [ValidateNotNullOrEmpty()]
    [string[]]
    $Options,
    [Parameter(ValueFromPipeline)]
    [System.Object]
    $InputObject
  )
  if ($MyInvocation.ExpectingInput) {
    return $input | rg $Query $Options | fzf
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
  fzf $ags
}
#endregion
#endregion
