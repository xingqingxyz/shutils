function Invoke-Z {
  <#
  .SYNOPSIS
  Z, jumps to most frecently used directory.
  #>
  [CmdletBinding(DefaultParameterSetName = 'Main')]
  [Alias('z')]
  param (
    [Parameter(ParameterSetName = 'Add', Mandatory)][switch]$Add,
    [Parameter(ParameterSetName = 'Main')][switch]$List,
    [Parameter(ParameterSetName = 'Main')][switch]$Rank,
    [Parameter(ParameterSetName = 'Main')][switch]$Time,
    [Parameter(ParameterSetName = 'Main')][switch]$Cwd,
    [Parameter(ValueFromRemainingArguments)][string[]]$Queries
  )
  switch ($PSCmdlet.ParameterSetName) {
    'Add' {
      if ($PWD.Provider.Name -cne 'FileSystem') {
        return
      }
      $paths = Get-Item $Queries -ea Ignore | ForEach-Object {
        $path = $_.Attributes.HasFlag([System.IO.FileAttributes]::ReparsePoint) ? $_.ResolvedTarget : $_.FullName
        foreach ($pat in $_zConfig.excludePatterns) {
          if ($path -clike $pat) {
            return
          }
        }
      }
      if (!$paths) {
        return
      }
      $itemsMap = @{}
      try {
        Get-Content -LiteralPath $_zConfig.dataFile -Raw | ConvertFrom-Json | ForEach-Object { $itemsMap[$_.path] = $_ }
      }
      catch {
        return
      }
      [int]$now = Get-Date -UFormat %s
      $paths.ForEach{
        if ($itemsMap.Contains($_)) {
          $item = $itemsMap[$_]
          $item.rank++
          $item.time = $now
        }
        else {
          $itemsMap[$_] = [pscustomobject]@{
            rank = 0.0
            time = $now
            path = $_
          }
        }
      }
      $rankSum = ($itemsMap.Values | Measure-Object -Sum).Sum
      if ($rankSum -gt $_zConfig.maxHistory) {
        $itemsMap.Values.ForEach{
          if (($_.rank *= 0.99) -lt 1.0) {
            $itemsMap.Remove($_.path)
          }
        }
      }
      $itemsMap.Values | ConvertTo-Json -Compress > $_zConfig.dataFile
      break
    }
    'Main' {
      # use (?i) ... (?-i) or (?i:...) to ignore case
      $reQuery = "^.*$($Queries -join '.*').*$"
      if ($IsWindows) {
        $reQuery = $reQuery.Replace('/', '\\')
      }
      # check regex or stop first
      $reQuery = [regex]::new($reQuery)
      $json = Get-Content -LiteralPath $_zConfig.dataFile -Raw | ConvertFrom-Json
      $items = $json.Where{ $reQuery.IsMatch($_.path) }
      if ($Cwd) {
        $items = $items | Where-Object path -CLike ([System.IO.Path]::Join($ExecutionContext.SessionState.Path.CurrentFileSystemLocation.ProviderPath, '*'))
      }
      if (!$items) {
        if ($Queries -and $Queries[-1] -clike '*[\/]*') {
          return Set-Location $Queries[-1]
        }
        return Write-Error "no matches for regexp $reQuery"
      }
      $items = switch ($true) {
        $Rank { $items | Sort-Object -Descending rank; break }
        $Time { $items | Sort-Object -Descending time; break }
        default {
          [double]$now = Get-Date -UFormat '%s'
          $items | Sort-Object -Descending { 10000 * $_.rank * (3.75 / (0.0001 * ($now - $_.time) + 1.25)) }
          break
        }
      }
      if ($List) {
        return $items
      }
      $itemsMap = @{}
      $json.ForEach{ $itemsMap[$_.path] = $_ }
      foreach ($item in $items) {
        try {
          Set-Location -LiteralPath $item.path
          break
        }
        catch {
          Write-Warning "Set-Location failed, removing it: $($item.path)"
          $itemsMap.Remove($item.path)
        }
      }
      if ($json.Count -ne $itemsMap.Count) {
        $itemsMap.Values | ConvertTo-Json -Compress > $_zConfig.dataFile
      }
      break
    }
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
