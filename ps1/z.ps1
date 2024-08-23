$_zConfig = @{
  cmd            = 'z'
  dataFile       = "$HOME/.z.tsv"
  resoveSymlinks = $true
  maxHistory     = 100
  excludeDirs    = @($HOME, (Get-PSDrive -PSProvider FileSystem).Root)
}
$_zRankCnt = 0.0
$_zItemsMap = @{}

function _zAdd {
  if ($PWD.Provider.Name -ne 'FileSystem') {
    return
  }
  $path = $_zConfig.resoveSymlinks ? (Get-Item .).ResolvedTarget : $PWD.Path
  if ($_zConfig.excludeDirs.Contains($path)) {
    return
  }
  $cnt = $_zRankCnt
  if (++$cnt -gt $_zConfig.maxHistory) {
    $cnt = 0.0
    foreach ($i in $_zItemsMap) {
      if ($_zItemsMap.$i.Rank -lt 1.0) {
        $_zItemsMap.Remove($i)
        continue
      }
      $cnt += ($_zItemsMap.$i.Rank *= 0.99)
    }
  }
  # add the new one
  $Global:_zRankCnt = $cnt + 1
  $item = ($_zItemsMap.$path ??= ([PSCustomObject]@{
        Rank = 0
        Time = 0
      }))
  $item.Rank++
  [int]$item.Time = Get-Date -UFormat '%s'
}

function _z {
  param (
    [Parameter(ParameterSetName = 'Main')][switch]$Echo,
    [Parameter(ParameterSetName = 'Main')][switch]$List,
    [Parameter(ParameterSetName = 'Main')][switch]$Rank,
    [Parameter(ParameterSetName = 'Main')][switch]$Time,
    [Parameter(ParameterSetName = 'Main')][switch]$Cwd,
    [Parameter(ValueFromRemainingArguments)][string[]]$Rest,
    [Parameter(ParameterSetName = 'Remove', Mandatory)][string[]]$Remove
  )

  if ($Remove) {
    $Remove | ForEach-Object {
      $_zRankCnt -= $_zItemsMap.$_.Rank
      $_zItemsMap.Remove($_)
    }
    return
  }

  $re = [regex]::new("^.*$($Rest -join '.*').*$".ToLower())
  $paths = $_zItemsMap.Keys | Where-Object { $re.IsMatch($_.ToLower()) }
  if ($Cwd -and $PWD.Provider.Name -eq 'FileSystem') {
    $paths = $paths | Where-Object { $_.StartsWith($PWD.Path) }
  }

  if (!$paths) {
    return
  }

  $paths = @(switch ($true) {
      $Rank { $paths | Sort-Object { $_zItemsMap.$_.Rank } }
      $Time { $paths | Sort-Object { $_zItemsMap.$_.Time } }
      Default {
        [double]$now = Get-Date -UFormat '%s'
        filter frecent {
          10000 * $_.Rank * (3.75 / (.0001 * ($now - $_.Time) + 1.25))
        }
        $paths | Sort-Object { $_zItemsMap.$_ | frecent }
      }
    })

  if ($Echo) {
    $paths[-1]
  }
  elseif ($List -or $paths.Length -gt 1) {
    $paths
  }
  else {
    Set-Location $paths[-1]
  }
}

if (!(Test-Path $_zConfig.dataFile)) {
  $null = New-Item $_zConfig.dataFile
}
Get-Content $_zConfig.dataFile | ForEach-Object {
  $path, [double]$rank, [int]$time = $_.Split("`t")
  $_zItemsMap.Add($path, [PSCustomObject]@{
      Rank = $rank
      Time = $time
    })
}
& {
  $hook = [System.EventHandler[System.Management.Automation.LocationChangedEventArgs]]$function:_zAdd
  $action = $ExecutionContext.SessionState.InvokeCommand.LocationChangedAction
  $ExecutionContext.SessionState.InvokeCommand.LocationChangedAction = if ($action) {
    [Delegate]::Combine($action, $hook)
  }
  else {
    $hook
  }
}
Register-EngineEvent -SourceIdentifier PowerShell.Exiting -SupportEvent -Action {
  $_zItemsMap.GetEnumerator() | ForEach-Object {
    "$($_.Key)`t$($_.Value.Rank)`t$($_.Value.Time)"
  } > $_zConfig.dataFile
}
Set-Alias $_zConfig.cmd _z
Set-PSReadLineKeyHandler -Chord Alt+z -ScriptBlock {
  $path = $_zItemsMap.Keys | fzf --scheme=path
  if ($LASTEXITCODE -eq 0) {
    Set-Location $path
    [Microsoft.PowerShell.PSConsoleReadLine]::InvokePrompt()
  }
}
