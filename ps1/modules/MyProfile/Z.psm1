<#
.SYNOPSIS
Z, jumps to most frecently used directory.
 #>
function Invoke-Z {
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

  $sum = $zRankSum
  switch ($PSCmdlet.ParameterSetName) {
    'Add' {
      if ($PWD.Provider.Name -ne 'FileSystem') {
        return
      }
      Get-Item $Add -ea Ignore | ForEach-Object {
        $path = $zConfig.resolveSymlinks ? $_.ResolvedTarget : $_.FullName
        foreach ($pat in $zConfig.excludePatterns) {
          if ($path -like $pat) {
            return
          }
        }
        $item = ($zItemsMap.$path ??= ([PSCustomObject]@{
              Path = $path
              Rank = 0.0
              Time = 0
            }))
        $item.Rank++
        $sum++
        [int]$item.Time = Get-Date -UFormat '%s'
      }
      if ($sum -gt $zConfig.maxHistory) {
        $sum = 0.0
        foreach ($item in $zItemsMap.Values) {
          if (($item.Rank *= 0.99) -lt 1.0) {
            $zItemsMap.Remove($item.Path)
          }
          else {
            $sum += $item.Rank
          }
        }
      }
      break
    }
    'Delete' {
      Get-Item $Delete -ea Ignore | ForEach-Object {
        $path = $zConfig.resolveSymlinks ? $_.ResolvedTarget : $_.FullName
        $item = $zItemsMap.$path
        if ($item) {
          $zItemsMap.Remove($path)
          $sum -= $item.Rank
        }
      }
      break
    }
    'Main' {
      if ($Queries.Length -eq 1 -and $Queries[0] -like '*[\/]*') {
        return Set-Location $Queries[0]
      }
      $items = $zItemsMap.Values | Where-Object Path -Like *$($Queries -join '*')*
      if ($Cwd) {
        $base = $zConfig.resolveSymlinks ? (Get-Item -LiteralPath .).ResolvedTarget : (Get-Item -LiteralPath .).FullName
        $items = $items | Where-Object Path -Like $base$([System.IO.Path]::DirectorySeparatorChar)*
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
          Set-Location -LiteralPath $item.Path -ea Stop
          break
        }
        catch {
          Write-Warning ('Set-Location failed, removing it: ' + $item.Path)
          $zItemsMap.Remove($item.Path)
          $sum -= $item.Rank
        }
      }
      break
    }
  }
  if ($sum -ne $zRankSum) {
    $Script:zRankSum = $sum
    $zItemsMap.Values.ForEach{
      $_.Path, $_.Rank, $_.Time -join $zConfig.dataSeperator
    } > $zConfig.dataFile
  }
}

$zConfig = @{
  dataFile        = "$HOME/.z"
  dataSeperator   = '|'
  resolveSymlinks = $true
  maxHistory      = 1000
  excludePatterns = @($HOME, (Get-PSDrive -PSProvider FileSystem).Root, ([System.IO.Path]::GetTempPath() + '*'))
} + ($Global:zConfig ?? @{})
$zRankSum = 0.0
$zItemsMap = @{}

if (!(Test-Path -LiteralPath $zConfig.dataFile)) {
  $null = New-Item $zConfig.dataFile -Force
}
Get-Content -LiteralPath $zConfig.dataFile -ea Ignore | ForEach-Object {
  $path, [double]$rank, [int]$time = $_.Split($zConfig.dataSeperator)
  $zItemsMap.Add($path, [PSCustomObject]@{
      Path = $path
      Rank = $rank
      Time = $time
    })
  $zRankSum += $rank
}
$hook = [System.EventHandler[System.Management.Automation.LocationChangedEventArgs]] { Invoke-Z -Add . }
$action = $ExecutionContext.SessionState.InvokeCommand.LocationChangedAction
$ExecutionContext.SessionState.InvokeCommand.LocationChangedAction =
$action ? [Delegate]::Combine($action, $hook) : $hook
Set-Alias z Invoke-Z

$ExecutionContext.SessionState.Module.OnRemove = {
  $action = $ExecutionContext.SessionState.InvokeCommand.LocationChangedAction
  $ExecutionContext.SessionState.InvokeCommand.LocationChangedAction = if ($action) {
    [Delegate]::Remove($action, $hook)
  }
}
