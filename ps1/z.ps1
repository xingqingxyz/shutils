function Invoke-Z {
  <#
  .SYNOPSIS
  Z, jumps to most frecently used directory.
  #>
  [CmdletBinding(DefaultParameterSetName = 'Main')]
  [Alias('z')]
  param (
    [Parameter(ParameterSetName = 'Add', Mandatory)][switch]$Add,
    [Parameter(ParameterSetName = 'Delete', Mandatory)][switch]$Delete,
    [Parameter(ParameterSetName = 'Main')][switch]$Echo,
    [Parameter(ParameterSetName = 'Main')][switch]$List,
    [Parameter(ParameterSetName = 'Main')][switch]$rank,
    [Parameter(ParameterSetName = 'Main')][switch]$time,
    [Parameter(ParameterSetName = 'Main')][switch]$Cwd,
    [Parameter(ValueFromRemainingArguments)][string[]]$Queries
  )
  [hashtable]$json = try {
    Get-Content -LiteralPath $_zConfig.dataFile -ea Stop | ConvertFrom-Json -AsHashtable -ea Stop
  }
  catch {
    @{
      itemsMap = @{}
      rankSum  = 0.0
    }
  }
  [hashtable]$itemsMap = $json.itemsMap
  $sum = $json.rankSum
  switch ($PSCmdlet.ParameterSetName) {
    'Add' {
      if ($PWD.Provider.Name -cne 'FileSystem') {
        return
      }
      Get-Item $Queries -ea Ignore | ForEach-Object {
        [string]$path = $_.Attributes.HasFlag([System.IO.FileAttributes]::ReparsePoint) ? $_.ResolvedTarget : $_.FullName
        foreach ($pat in $_zConfig.excludePatterns) {
          if ($path -clike $pat) {
            return
          }
        }
        $item = $itemsMap[$path]
        $item ??= [pscustomobject]@{
          rank = 0.0
          time = 0
        }
        $item.rank++
        [int]$item.time = Get-Date -UFormat '%s'
        $itemsMap[$path] = $item
        $sum++
      }
      if ($sum -gt $_zConfig.maxHistory) {
        $sum = 0.0
        @($itemsMap.GetEnumerator()).ForEach{
          if (($_.Value.rank *= 0.99) -lt 1.0) {
            $itemsMap.Remove($_.Key)
          }
          else {
            $sum += $_.Value.rank
          }
        }
      }
      break
    }
    'Delete' {
      Get-Item $Queries -ea Ignore | ForEach-Object {
        [string]$path = $_.Attributes.HasFlag([System.IO.FileAttributes]::ReparsePoint) ? $_.ResolvedTarget : $_.FullName
        $item = $itemsMap[$path]
        if ($item) {
          $itemsMap.Remove($path)
          $sum -= $item.rank
        }
      }
      break
    }
    'Main' {
      $reQuery = "^.*$($Queries -join '.*').*$"
      if ($IsWindows) {
        $reQuery = $reQuery.Replace('/', '\\')
      }
      # use (?i) ... (?-i) or (?i:...) to ignore case
      $items = $itemsMap.GetEnumerator() | Where-Object Key -CMatch $reQuery -ea Ignore
      if ($Cwd) {
        $items = $items | Where-Object Key -CLike (Join-Path $ExecutionContext.SessionState.Path.CurrentFileSystemLocation.ProviderPath *)
      }
      if (!$items) {
        if ($Queries -and $Queries[-1] -clike '*[\/]*') {
          return Set-Location $Queries[-1]
        }
        return Write-Error "no matches for regexp $reQuery"
      }
      $items = switch ($true) {
        $rank { $items | Sort-Object { $_.Value.rank }; break }
        $time { $items | Sort-Object { $_.Value.time }; break }
        default {
          [double]$now = Get-Date -UFormat '%s'
          $items | Sort-Object { 10000 * $_.Value.rank * (3.75 / (.0001 * ($now - $_.Value.time) + 1.25)) }
          break
        }
      }
      if ($List) {
        return $items
      }
      elseif ($Echo) {
        return $items[-1].Key
      }
      for ($i = $items.Count - 1; $i -ge 0; $i--) {
        $item = $items[$i]
        try {
          Set-Location -LiteralPath $item.Key -ea Stop
          break
        }
        catch {
          Write-Warning "Set-Location failed, removing it: $($item.Key)"
          $itemsMap.Remove($item.Key)
          $sum -= $item.Value.rank
          break
        }
      }
      break
    }
  }
  if ($sum -ne $json.rankSum) {
    $json.rankSum = $sum
    $json | ConvertTo-Json -Compress > $_zConfig.dataFile
  }
}

& {
  if ($_zConfig) {
    return
  }
  $hook = [System.EventHandler[System.Management.Automation.LocationChangedEventArgs]] { Invoke-Z -Add . }
  $action = $ExecutionContext.SessionState.InvokeCommand.LocationChangedAction
  $ExecutionContext.SessionState.InvokeCommand.LocationChangedAction =
  $action ? [Delegate]::Combine($action, $hook) : $hook
}

Set-Variable -Option ReadOnly -Force _zConfig ([pscustomobject]@{
    dataFile        = "$HOME/.z.json"
    maxHistory      = 1000
    excludePatterns = @($HOME, ([System.IO.Path]::GetTempPath() + '*')) + (Get-PSDrive -PSProvider FileSystem).Root
  })
