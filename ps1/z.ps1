using namespace System.Management.Automation
using namespace System.Management.Automation.Language

$_Z_CMD = 'z'
$_Z_RESOLVE_SYMLINKS = $true
$_Z_EXCLUDE_DIRS = @()
$_Z_MAX_HISTORY = 1000

function _zAdd {
  if ($_Z_RESOLVE_SYMLINKS) {
    $target = (Get-Item $PWD).ResolvedTarget ?? $PWD
  }
  else {
    $target = $PWD
  }
  if ($target -like '?:\' -or $target -eq $HOME -or $_Z_EXCLUDE_DIRS.Contains($target) -or !(Test-Path ~/.z)) {
    return
  }
  $cnt = 0
  $hasRecord = $false
  $items = Get-Content ~/.z | ForEach-Object {
    $path, [int]$rank, $time = $_.Split('|')
    if ($path -eq $target) {
      $rank++
      $time = Get-Date -UFormat '%s'
      $hasRecord = $true
    }
    $cnt += $rank
    [PSCustomObject]@{Path = $path; Rank = $rank; Time = $time }
  }
  if (!$hasRecord) {
    $items += [PSCustomObject]@{Path = $target; Rank = 1; Time = Get-Date -UFormat '%s' }
    $cnt++
  }
  if ($cnt -gt $_Z_MAX_HISTORY) {
    foreach ($i in $items) {
      $i.Rank *= .99
    }
  }

  $items | ForEach-Object { '{0}|{1}|{2}' -f $_.Path, $_.Rank, $_.Time } > ~/.z
}



function _z {
  param (
    [Parameter(ParameterSetName = 'Main')][switch]$echo, [Parameter(ParameterSetName = 'Main')][switch]$help, [Parameter(ParameterSetName = 'Main')][switch]$list, [Parameter(ParameterSetName = 'Main')][switch]$rank, [Parameter(ParameterSetName = 'Main')][switch]$time, [Parameter(ParameterSetName = 'Main')][switch]$cwd,
    [Parameter(ValueFromRemainingArguments, ParameterSetName = 'Main')][string[]]$remain,
    [Parameter(ParameterSetName = 'Remove', Mandatory)][string[]]$remove
  )

  if ($help) {
    help _z
    return
  }
  elseif ($remove) {
    [hashtable]$tbl = @{}
    $remove | ForEach-Object { $tbl.Add($_, $null) }
    (Get-Content ~/.z) | Where-Object { !$tbl.ContainsKey($_.Split('|')[0]) } > ~/.z
    return
  }
  elseif ($remain -and $remain[-1].Contains('\')) {
    Set-Location $remain[-1]
    return
  }
  elseif (!(Test-Path ~/.z)) {
    return
  }

  $re = [regex]::new($remain -join '.*')
  $items = @(
    foreach ($i in Get-Content ~/.z) {
      $i = $i.Split('|')
      if ($re.IsMatch($i[0])) {
        [PSCustomObject]@{
          Path = $i[0]
          Rank = $i[1]
          Time = $i[2]
        }
      }
    }
  )

  if (!$items.Length) {
    return
  }

  [int]$now = Get-Date -UFormat '%s'
  function _zFrecent([double]$rank, [int]$time) {
    [int](10000 * $rank * (3.75 / (.0001 * ($now - $time) + 1.25)))
  }

  switch ($true) {
    $rank { $items = $items | Sort-Object Rank }
    $time { $items = $items | Sort-Object Time }
    Default { $items = $items | ForEach-Object { $_.Rank = _zFrecent $_.Rank $_.Time ; $_ } | Sort-Object Rank }
  }

  if ($items.Length -eq 1) {
    if ($echo -or $list) {
      $items[0].Path
    }
    else {
      Set-Location $items[0].Path
    }
  }
  else {
    if ($list) {
      $items
    }
    else {
      Set-Location $items[-1].Path
    }
  }
}

Set-Alias $_Z_CMD _z
Register-ArgumentCompleter -CommandName z -ScriptBlock {
  param([string]$wordToComplete, [CommandAst]$commandAst, [int]$cursorPosition)
  if ($wordToComplete.StartsWith('-') -or $cursorPosition -ne $commandAst.CommandElements[-1].Extent.EndOffset -or !(Test-Path ~/.z)) {
  }
  $re = $commandAst.CommandElements | Select-Object -Skip 1 | Where-Object { $_.Extent -is [StringConstantExpressionAst] } | Join-String Value '.*'
  $re = [regex]::new($re)
  foreach ($i in Get-Content ~/.z) {
    $i = $i.Split('|')[0]
    if ($re.IsMatch($i)) {
      [CompletionResult]::new($i)
    }
  }
}

& {
  $hook = [System.EventHandler[LocationChangedEventArgs]]$Function:_zAdd
  $action = $ExecutionContext.SessionState.InvokeCommand.LocationChangedAction
  $ExecutionContext.SessionState.InvokeCommand.LocationChangedAction = if ($action) {
    [Delegate]::Combine($action, $hook)
  }
  else {
    $hook
  }
}
