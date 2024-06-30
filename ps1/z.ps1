$_zConfig = @{
  cmd            = 'z'
  dataFile       = "$HOME/.z.json"
  resoveSymlinks = $true
  excludeDirs    = @()
  maxHistory     = 1000
}

function _zAdd {
  if ($PWD.Provider.Name -ne 'FileSystem' -or !(Test-Path $_zConfig.dataFile)) {
    return
  }
  $target = $_zConfig.resoveSymlinks ? (Get-Item $PWD).ResolvedTarget : $PWD.Path
  if ($target -like '?:\' -or $target -eq $HOME -or $_zConfig.excludeDirs.Contains($target)) {
    return
  }
  $data = Get-Content $_zConfig.dataFile | ConvertFrom-Json -AsHashtable
  $itemsMap = $data.itemsMap
  if (++$data.historyCnt -gt $_zConfig.maxHistory) {
    foreach ($key in $itemsMap) {
      if (($itemsMap.$key.Rank -lt 1)) {
        $itemsMap.Remove($key)
        continue
      }
      $itemsMap.$key.Rank *= .99
    }
    $data.historyCnt *= .99
  }
  $targetItem = ($itemsMap.$target ??= @{})
  $targetItem.Rank++
  $targetItem.Time = Get-Date -UFormat '%s'
  $data.historyCnt++
  ConvertTo-Json $data > $_zConfig.dataFile
}

function _z {
  param (
    [Parameter(ParameterSetName = 'Main')][switch]$echo,
    [Parameter(ParameterSetName = 'Main')][switch]$list,
    [Parameter(ParameterSetName = 'Main')][switch]$rank,
    [Parameter(ParameterSetName = 'Main')][switch]$time,
    [Parameter(ParameterSetName = 'Main')][switch]$cwd,
    [Parameter(ValueFromRemainingArguments)][string[]]$rest,
    [Parameter(ParameterSetName = 'Remove', Mandatory)][string[]]$remove
  )

  if ($remove) {
    $data = Get-Content $_zConfig.dataFile | ConvertFrom-Json -AsHashtable
    $remove | ForEach-Object {
      $data.historyCnt -= $data.itemsMap.$_.Rank
      $data.itemsMap.Remove($_)
    }
    $data | ConvertTo-Json > $_zConfig.dataFile
    return
  }
  elseif ($rest -and $rest[-1].Contains([System.IO.Path]::DirectorySeparatorChar)) {
    Set-Location $rest[-1]
    return
  }
  elseif (!(Test-Path $_zConfig.dataFile)) {
    return
  }

  $itemsMap = (Get-Content $_zConfig.dataFile | ConvertFrom-Json -AsHashtable).itemsMap
  $items = $itemsMap.Keys | Where-Object {
    $_ -clike "*$($rest -join '*')*"
  }
  if ($cwd -and $PWD.Provider.Name -eq 'FileSystem') {
    $items = $items | Where-Object { $_.StartsWith($PWD.Path) }
  }

  if (!$items) {
    return
  }

  $items = @(switch ($true) {
      $rank { $items | Sort-Object { $itemsMap.$_.Rank } }
      $time { $items | Sort-Object { $itemsMap.$_.Time } }
      Default {
        [double]$now = Get-Date -UFormat '%s'
        filter frecent {
          10000 * $_.Rank * (3.75 / (.0001 * ($now - $_.Time) + 1.25))
        }
        $items | Sort-Object { $itemsMap.$_ | frecent }
      }
    })

  if ($echo) {
    $items[-1]
  }
  elseif ($list -or $items.Length -gt 1) {
    $items | ForEach-Object { "$($itemsMap.$_.Rank)`t$_" }
  }
  else {
    Set-Location $items[0]
  }
}

if (!((Test-Path $_zConfig.dataFile) -and (Test-Json -Path $_zConfig.dataFile))) {
  @{
    historyCnt = 0
    itemsMap   = @{}
  } | ConvertTo-Json > $_zConfig.dataFile
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
