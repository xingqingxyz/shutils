$_zConfig = @{
  cmd             = 'z'
  dataFile        = "$HOME/.z"
  dataSeperator   = '|'
  resolveSymlinks = $true
  maxHistory      = 1000
  excludePatterns = @($HOME, (Get-PSDrive -PSProvider FileSystem).Root, ([System.IO.Path]::GetTempPath() + '*'))
}
$_zRankSum = 0.0
$_zItemsMap = @{}

function _zGetPath([string]$Path) {
  try {
    $item = Get-Item $Path -ea Stop
  }
  catch {
    return
  }
  if ($_zConfig.resolveSymlinks -and $item.Mode[0] -eq 'l') {
    $item.ResolvedTarget
  }
  else {
    $item.FullName
  }
}

function _zDumpData {
  $_zItemsMap.Values.ForEach{
    $_.Path, $_.Rank, $_.Time -join $_zConfig.dataSeperator
  } > $_zConfig.dataFile
}

<#
.DESCRIPTION
Z, jumps to most frecently used directory.
 #>
function _z {
  [CmdletBinding(DefaultParameterSetName = 'Main')]
  param (
    [Parameter(ParameterSetName = 'Add', Mandatory)][string[]]$Add,
    [Parameter(ParameterSetName = 'Delete', Mandatory)][string[]]$Delete,
    [Parameter(ParameterSetName = 'Main')][switch]$Echo,
    [Parameter(ParameterSetName = 'Main')][switch]$List,
    [Parameter(ParameterSetName = 'Main')][switch]$Rank,
    [Parameter(ParameterSetName = 'Main')][switch]$Time,
    [Parameter(ParameterSetName = 'Main')][switch]$Cwd,
    [Parameter(ParameterSetName = 'Main', ValueFromRemainingArguments)][string[]]$Queries
  )

  $sum = $Global:_zRankSum
  switch ($PSCmdlet.ParameterSetName) {
    'Add' {
      if ($PWD.Provider.Name -ne 'FileSystem') {
        return
      }
      foreach ($path in $Add) {
        $path = _zGetPath $path
        if (!$path -or $_zConfig.excludePatterns.Where{ $path -like $_ }) {
          continue
        }
        $item = ($_zItemsMap.$path ??= ([PSCustomObject]@{
              Path = $path
              Rank = 0.0
              Time = 0
            }))
        $item.Rank++
        $sum++
        [int]$item.Time = Get-Date -UFormat '%s'
      }
      if ($sum -gt $_zConfig.maxHistory) {
        $sum = 0.0
        foreach ($item in $_zItemsMap.Values) {
          if (($item.Rank *= 0.99) -lt 1.0) {
            $_zItemsMap.Remove($item.Path)
          }
          else {
            $sum += $item.Rank
          }
        }
      }
      break
    }
    'Delete' {
      $Delete.ForEach{
        $item = $_zItemsMap.(_zGetPath $_)
        if ($item) {
          $_zItemsMap.Remove($item.path)
          $sum -= $item.Rank
        }
      }
      break
    }
    'Main' {
      if ($Queries.Length -eq 1 -and $Queries[0] -like '*[\/]*') {
        return Set-Location $Queries[0]
      }
      $re = [regex]::new("^.*$($Queries -join '.*').*$")
      $items = $_zItemsMap.Values.Where{ $re.IsMatch($_.Path) }
      if ($Cwd) {
        $items = $items | Where-Object Path -Like "$(_zGetPath .)$([System.IO.Path]::DirectorySeparatorChar)*"
      }
      if (!$items) {
        return Write-Warning "no matches found for regexp $re"
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
        return $items
      }
      elseif ($Echo) {
        return $items[-1]
      }
      for ($i = $items.Count - 1; $i -ge 0; $i--) {
        $item = $items[$i]
        try {
          Set-Location $item.Path -ea Stop
          break
        }
        catch {
          Write-Warning ('Set-Location failed, removing it: ' + $item.Path)
          $_zItemsMap.Remove($item.Path)
          $sum -= $item.Rank
        }
      }
      break
    }
  }
  if ($sum -ne $Global:_zRankSum) {
    $Global:_zRankSum = $sum
    _zDumpData
  }
}

& {
  if (!(Test-Path $_zConfig.dataFile)) {
    $null = New-Item $_zConfig.dataFile -Force -ea Stop
  }
  Get-Content $_zConfig.dataFile | ForEach-Object {
    $path, [double]$rank, [int]$time = $_.Split($_zConfig.dataSeperator)
    $_zItemsMap.Add($path, [PSCustomObject]@{
        Path = $path
        Rank = $rank
        Time = $time
      })
    $Global:_zRankSum += $rank
  }
  $hook = [System.EventHandler[System.Management.Automation.LocationChangedEventArgs]] { _z -Add . }
  $action = $ExecutionContext.SessionState.InvokeCommand.LocationChangedAction
  $ExecutionContext.SessionState.InvokeCommand.LocationChangedAction = if ($action) {
    [Delegate]::Combine($action, $hook)
  }
  else {
    $hook
  }
}
Set-Alias $_zConfig.cmd _z
