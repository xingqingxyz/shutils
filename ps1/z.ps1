$_zConfig = @{
  cmd             = 'z'
  dataFile        = "$HOME/.z"
  resolveSymlinks = $true
  maxHistory      = 100
  excludeDirs     = @($HOME, (Get-PSDrive -PSProvider FileSystem).Root, (Get-PSDrive -Name Temp).Root.TrimEnd([System.IO.Path]::DirectorySeparatorChar))
  _rankSum        = 0.0
}
$_zItemsMap = @{}

function _zGetPath {
  $item = Get-Item -LiteralPath .
  if ($_zConfig.resolveSymlinks -and $item.Mode[0] -eq 'l') {
    $item.LinkTarget
  }
  else {
    $item.FullName
  }
}

function _zDumpData {
  $_zItemsMap.Values | ForEach-Object {
    "$($_.Path)`t$($_.Rank)`t$($_.Time)"
  } > $_zConfig.dataFile
}

function _zAdd {
  if ($PWD.Provider.Name -ne 'FileSystem') {
    return
  }
  $path = _zGetPath
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
        Rank = 0.0
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
      $Queries = @('.')
    }
    $Queries | ForEach-Object {
      $path = _zGetPath $_
      $_zConfig._rankSum -= $_zItemsMap.$path.Rank
      $_zItemsMap.Remove($path)
    }
    return
  }

  $re = [regex]::new("^.*$($Queries -join '.*').*$")
  $items = $_zItemsMap.Values | Where-Object { $re.IsMatch($_.Path) }
  if ($Cwd) {
    $items = $items | Where-Object Path -Like "$(_zGetPath .)*"
  }

  if (!$items) {
    Write-Warning "no matches found for regexp $re"
    return
  }

  $items = @(switch ($true) {
      $Rank { $items | Sort-Object Rank; break }
      $Time { $items | Sort-Object Time; break }
      Default {
        [double]$now = Get-Date -UFormat '%s'
        $items | Sort-Object { 10000 * $_.Rank * (3.75 / (.0001 * ($now - $_.Time) + 1.25)) }
        break
      }
    })

  if ($List) {
    $items
  }
  elseif ($Echo) {
    $items[-1]
  }
  else {
    Set-Location $items[-1].Path
  }
}

if (!(Test-Path $_zConfig.dataFile)) {
  $null = New-Item -Force $_zConfig.dataFile
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
