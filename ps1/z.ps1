$_zConfig = @{
  cmd             = 'z'
  dataFile        = "$HOME/.z"
  resolveSymlinks = $true
  maxHistory      = 1000.0
  excludePatterns = @($HOME, (Get-PSDrive -PSProvider FileSystem).Root, ([System.IO.Path]::GetTempPath() + '*'))
  _rankSum        = 0.0
}
$_zItemsMap = @{}

function _zGetPath {
  $item = Get-Item -LiteralPath .
  if ($_zConfig.resolveSymlinks -and $item.Mode[0] -eq 'l') {
    $item.ResolvedTarget
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
  foreach ($pat in $_zConfig.excludePatterns) {
    if ($path -like $pat) {
      return
    }
  }
  if (++$_zConfig._rankSum -gt $_zConfig.maxHistory) {
    $sum = 1.0
    foreach ($item in $_zItemsMap.Values) {
      if (($item.Rank *= 0.99) -lt 1.0) {
        $_zItemsMap.Remove($item.Path)
      }
      else {
        $sum += $item.Rank
      }
    }
    $_zConfig._rankSum = $sum
  }
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
  [CmdletBinding(DefaultParameterSetName = 'Main')]
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
    $items = $items | Where-Object Path -Like "$(_zGetPath)$([System.IO.Path]::DirectorySeparatorChar)*"
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
    $i = $items.Length
    while ($i--) {
      $path = $items[$i].Path
      try {
        return Set-Location $path -ErrorAction Stop
      }
      catch {
        Write-Warning "Set-Location failed, removing it: $path"
        $_zItemsMap.Remove($path)
      }
    }
    _zDumpData
  }
}

& {
  if (!(Test-Path $_zConfig.dataFile)) {
    $null = New-Item -Force $_zConfig.dataFile
  }
  Get-Content $_zConfig.dataFile | ForEach-Object {
    $path, [double]$rank, [int]$time = $_.Split("`t")
    $_zConfig._rankSum += $rank
    $_zItemsMap.Add($path, [PSCustomObject]@{
        Path = $path
        Rank = $rank
        Time = $time
      })
  }
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
