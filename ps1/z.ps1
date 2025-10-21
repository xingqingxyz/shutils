function Invoke-Z {
  <#
  .SYNOPSIS
  Z, jumps to most frecently used directory.
  #>
  [CmdletBinding(DefaultParameterSetName = 'Main')]
  [Alias('z')]
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
  $sum = $_z.rankSum
  switch ($PSCmdlet.ParameterSetName) {
    'Add' {
      if ($PWD.Provider.Name -ne 'FileSystem') {
        return
      }
      Convert-Path $Add -ea Ignore | Where-Object { !$_.Contains("`n") } | ForEach-Object {
        $path = [System.IO.Path]::TrimEndingDirectorySeparator($_z.config.resolveSymlinks ? (Get-Item -LiteralPath $_).ResolvedTarget : $_)
        foreach ($pat in $_z.config.excludePatterns) {
          if ($path -like $pat) {
            return
          }
        }
        $item = ($_z.itemsMap.$path ??= ([pscustomobject]@{
              Path = $path
              Rank = 0.0
              Time = 0
            }))
        $item.Rank++
        $sum++
        [int]$item.Time = Get-Date -UFormat '%s'
      }
      if ($sum -gt $_z.config.maxHistory) {
        $sum = 0.0
        foreach ($item in $_z.itemsMap.Values) {
          if (($item.Rank *= 0.99) -lt 1.0) {
            $_z.itemsMap.Remove($item.Path)
          }
          else {
            $sum += $item.Rank
          }
        }
      }
      break
    }
    'Delete' {
      Convert-Path $Delete -ea Ignore | ForEach-Object {
        $path = [System.IO.Path]::TrimEndingDirectorySeparator($_z.config.resolveSymlinks ? (Get-Item -LiteralPath $_).ResolvedTarget : $_)
        $item = $_z.itemsMap.$path
        if ($item) {
          $_z.itemsMap.Remove($path)
          $sum -= $item.Rank
        }
      }
      break
    }
    'Main' {
      if ($Queries.Length -eq 1 -and $Queries[0] -like '*[\/]*') {
        return Set-Location $Queries[0]
      }
      $items = $_z.itemsMap.Values | Where-Object Path -Like *$($Queries -join '*')*
      if ($Cwd) {
        $items = $items | Where-Object Path -Like (Join-Path ( $_z.config.resolveSymlinks ? (Get-Item -LiteralPath .).ResolvedTarget : (Convert-Path -LiteralPath .)) '*')
      }
      if (!$items) {
        return Write-Error 'no matches'
      }
      $items = switch ($true) {
        $Rank { $items | Sort-Object Rank; break }
        $Time { $items | Sort-Object Time; break }
        default {
          [double]$now = Get-Date -UFormat '%s'
          $items | Sort-Object { 10000 * $_.Rank * (3.75 / (.0001 * ($now - $_.Time) + 1.25)) }
          break
        }
      }
      if ($List) {
        return $items
      }
      elseif ($Echo) {
        return $items[-1]
      }
      for ($i = $items.Count - 1; $i -ge 0; $i--) {
        $item = $items[$i]
        try {
          Set-Location -LiteralPath $item.Path -ea Stop
          break
        }
        catch {
          Write-Warning "Set-Location failed, removing it: $($item.Path)"
          $_z.itemsMap.Remove($item.Path)
          $sum -= $item.Rank
        }
      }
      break
    }
  }
  if ($sum -ne $_z.rankSum) {
    $_z.rankSum = $sum
    $_z.itemsMap.Values.ForEach{
      $_.Path, $_.Rank, $_.Time -join $_z.config.dataSeperator
    } > $_z.config.dataFile
  }
}

Set-Variable -Option ReadOnly -Force _z ([pscustomobject]@{
    config   = [pscustomobject]@{
      dataFile        = "$HOME/.z"
      dataSeperator   = '|'
      resolveSymlinks = $true
      maxHistory      = 1000
      excludePatterns = @($HOME, ([System.IO.Path]::GetTempPath() + '*'); (Get-PSDrive -PSProvider FileSystem).Root)
    }
    rankSum  = 0.0
    itemsMap = @{}
  })

& {
  if (!(Test-Path -LiteralPath $_z.config.dataFile)) {
    $null = New-Item $_z.config.dataFile -Force
  }
  Get-Content -LiteralPath $_z.config.dataFile -ea Ignore | ForEach-Object {
    $path, [double]$rank, [int]$time = $_.Split($_z.config.dataSeperator)
    $_z.itemsMap.Add($path, [pscustomobject]@{
        Path = $path
        Rank = $rank
        Time = $time
      })
    $_z.rankSum += $rank
  }
  $hook = [System.EventHandler[System.Management.Automation.LocationChangedEventArgs]] { Invoke-Z -Add . }
  $action = $ExecutionContext.SessionState.InvokeCommand.LocationChangedAction
  $ExecutionContext.SessionState.InvokeCommand.LocationChangedAction =
  $action ? [Delegate]::Combine($action, $hook) : $hook
}
