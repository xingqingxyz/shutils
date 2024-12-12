$_zConfig = @{
  cmd            = 'z'
  dataFile       = "$HOME/.z"
  resoveSymlinks = $true
  maxHistory     = 100
  excludeDirs    = @($HOME, (Get-PSDrive -PSProvider FileSystem).Root)
  _rankSum       = 0.0
}
$_zItemsMap = @{}

function _zDumpData {
  $_zItemsMap.Values | ForEach-Object {
    "$($_.Path)`t$($_.Rank)`t$($_.Time)"
  } > $_zConfig.dataFile
}

function _zAdd {
  if ($PWD.Provider.Name -ne 'FileSystem') {
    return
  }
  $path = $_zConfig.resoveSymlinks ? (Get-Item .).ResolvedTarget : $PWD.Path
  if ($_zConfig.excludeDirs.Contains($path)) {
    return
  }
  $sum = $_zConfig._rankSum
  if (++$sum -gt $_zConfig.maxHistory) {
    $sum = 1.0
    foreach ($item in $_zItemsMap.Values) {
      if ($item.Rank -lt 1.0) {
        $_zItemsMap.Remove($item.Path)
        continue
      }
      $sum += ($item.Rank *= 0.99)
    }
  }
  $_zConfig._rankSum = $sum
  # add the new one
  $item = ($_zItemsMap.$path ??= ([PSCustomObject]@{
        Path = $path
        Rank = 0
        Time = 0
      }))
  $item.Rank++
  [int]$item.Time = Get-Date -UFormat '%s'
  # dump data before return
  _zDumpData
}

function _z {
  param (
    [Parameter(ParameterSetName = 'Main')][switch]$Echo,
    [Parameter(ParameterSetName = 'Main')][switch]$List,
    [Parameter(ParameterSetName = 'Main')][switch]$Rank,
    [Parameter(ParameterSetName = 'Main')][switch]$Time,
    [Parameter(ParameterSetName = 'Main')][switch]$Cwd,
    [Parameter(ParameterSetName = 'Delete', Mandatory)][switch]$Delete,
    [Parameter(ValueFromRemainingArguments)][string[]]$Queries
  )

  if ($Delete) {
    if (!$Queries.Length) {
      $Queries = @($_zConfig.resoveSymlinks ? (Get-Item .).ResolvedTarget : $PWD.Path)
    }
    $prop = $_zConfig.resoveSymlinks ? 'ResolvedTarget' : 'FullName' 
    $Queries | ForEach-Object {
      $_zItemsMap.Remove((Get-Item $_).$prop)
      $_zConfig._rankSum -= $_zItemsMap.$_.Rank
    }
    return
  }

  $re = [regex]::new("^.*$($Queries -join '.*').*$".ToLower())
  $items = $_zItemsMap.Values | Where-Object { $re.IsMatch($_.Path.ToLower()) }
  if ($Cwd -and $PWD.Provider.Name -eq 'FileSystem') {
    $items = $items | Where-Object { $_.Path.StartsWith($PWD.Path) }
  }

  if (!$items) {
    if ($Queries.Length -and (Test-Path $Queries[-1])) {
      Set-Location $Queries[-1]
    }
    return
  }

  $items = @(switch ($true) {
      $Rank { $items | Sort-Object Rank; break }
      $Time { $items | Sort-Object Time; break }
      Default {
        [double]$now = Get-Date -UFormat '%s'
        filter frecent {
          10000 * $_.Rank * (3.75 / (.0001 * ($now - $_.Time) + 1.25))
        }
        $items | Sort-Object { frecent }
        break
      }
    })

  if ($items.Length -eq 1) {
    if ($Echo -or $List) {
      $items
    }
    else {
      Set-Location $items[0].Path
    }
  }
  else {
    if ($Rank -or $Time -and !$List) {
      Set-Location $items[-1].Path
    }
    else {
      $items
    }
  }
}

if (!(Test-Path $_zConfig.dataFile)) {
  $null = New-Item $_zConfig.dataFile
}
Get-Content $_zConfig.dataFile | ForEach-Object {
  $path, [double]$rank, [int]$time = $_.Split("`t")
  $_zItemsMap.Add($path, [PSCustomObject]@{
      Path = $path
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
Set-Alias $_zConfig.cmd _z
