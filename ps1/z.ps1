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

  $sum = $z.rankSum
  switch ($PSCmdlet.ParameterSetName) {
    'Add' {
      if ($PWD.Provider.Name -ne 'FileSystem') {
        return
      }
      Get-Item $Add -ea Ignore | ForEach-Object {
        $path = $z.config.resolveSymlinks ? $_.ResolvedTarget : $_.FullName
        foreach ($pat in $z.config.excludePatterns) {
          if ($path -like $pat) {
            return
          }
        }
        $item = ($z.itemsMap.$path ??= ([PSCustomObject]@{
              Path = $path
              Rank = 0.0
              Time = 0
            }))
        $item.Rank++
        $sum++
        [int]$item.Time = Get-Date -UFormat '%s'
      }
      if ($sum -gt $z.config.maxHistory) {
        $sum = 0.0
        foreach ($item in $z.itemsMap.Values) {
          if (($item.Rank *= 0.99) -lt 1.0) {
            $z.itemsMap.Remove($item.Path)
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
        $path = $z.config.resolveSymlinks ? $_.ResolvedTarget : $_.FullName
        $item = $z.itemsMap.$path
        if ($item) {
          $z.itemsMap.Remove($path)
          $sum -= $item.Rank
        }
      }
      break
    }
    'Main' {
      if ($Queries.Length -eq 1 -and $Queries[0] -like '*[\/]*') {
        return Set-Location $Queries[0]
      }
      $items = $z.itemsMap.Values | Where-Object Path -Like *$($Queries -join '*')*
      if ($Cwd) {
        $base = $z.config.resolveSymlinks ? (Get-Item -LiteralPath .).ResolvedTarget : (Get-Item -LiteralPath .).FullName
        $items = $items | Where-Object Path -Like $base$([System.IO.Path]::DirectorySeparatorChar)*
      }
      if (!$items) {
        return Write-Warning "no matches found for regexp $re"
      }
      $items = @(switch ($true) {
          $Rank { $items | Sort-Object Rank; break }
          $Time { $items | Sort-Object Time; break }
          default {
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
          $z.itemsMap.Remove($item.Path)
          $sum -= $item.Rank
        }
      }
      break
    }
  }
  if ($sum -ne $z.rankSum) {
    $z.rankSum = $sum
    $z.itemsMap.Values.ForEach{
      $_.Path, $_.Rank, $_.Time -join $z.config.dataSeperator
    } > $z.config.dataFile
  }
}

Set-Variable -Option ReadOnly z ([pscustomobject]@{
    config   = [pscustomobject]@{
      dataFile        = "$HOME/.z"
      dataSeperator   = '|'
      resolveSymlinks = $true
      maxHistory      = 1000
      excludePatterns = @($HOME, (Get-PSDrive -PSProvider FileSystem).Root, ([System.IO.Path]::GetTempPath() + '*'))
    }
    rankSum  = 0.0
    itemsMap = @{}
  })

if (!(Test-Path -LiteralPath $z.config.dataFile)) {
  $null = New-Item $z.config.dataFile -Force
}
Get-Content -LiteralPath $z.config.dataFile -ea Ignore | ForEach-Object {
  $path, [double]$rank, [int]$time = $_.Split($z.config.dataSeperator)
  $z.itemsMap.Add($path, [PSCustomObject]@{
      Path = $path
      Rank = $rank
      Time = $time
    })
  $z.rankSum += $rank
}
Set-Alias z Invoke-Z
& {
  $hook = [System.EventHandler[System.Management.Automation.LocationChangedEventArgs]] { Invoke-Z -Add . }
  $action = $ExecutionContext.SessionState.InvokeCommand.LocationChangedAction
  $ExecutionContext.SessionState.InvokeCommand.LocationChangedAction =
  $action ? [Delegate]::Combine($action, $hook) : $hook
}
