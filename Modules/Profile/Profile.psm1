using namespace System.Collections.Generic

#region exports
function Format-Duration {
  [CmdletBinding()]
  param (
    [Parameter(Mandatory, Position = 0, ValueFromPipeline, ValueFromPipelineByPropertyName)]
    [timespan]
    $Duration,
    [Parameter()]
    [switch]
    $NoColor
  )
  begin {
    $text = $NoColor ? '{1}' : "`e[{0}m{1}`e[0m"
  }
  process {
    # colors: green, cyan, blue, yellow, magenta, red
    $text -f @(switch ($true) {
        { $Duration.TotalMicroseconds -lt 1000 } {
          32
          [string]($Duration.Microseconds + $Duration.Nanoseconds / 1000) + 'μs'
          break
        }
        { $Duration.TotalMilliseconds -lt 1000 } {
          36
          [string]($Duration.Milliseconds + $Duration.Microseconds / 1000) + 'ms'
          break
        }
        { $Duration.TotalSeconds -lt 60 } {
          34
          [string]($Duration.Seconds + $Duration.Milliseconds / 1000) + 's'
          break
        }
        { $Duration.TotalMinutes -lt 60 } {
          33
          '{0}m{1}s' -f $Duration.Minutes, $Duration.Seconds
          break
        }
        { $Duration.TotalHours -lt 24 } {
          35
          '{0}h{1}m' -f $Duration.Hours, $Duration.Minutes
          break
        }
        default {
          31
          '{0}d{1}h' -f $Duration.Days, $Duration.Hours
          break
        }
      })
  }
}

function Get-PowerShellExecArgs ([switch]$ExpectingInput) {
  [string[]]$ags = $args.Where{ $null -ne $_ }
  if (!$ags) {
    return $ags
  }
  if ($args[0] -is [scriptblock]) {
    $ags = 'pwsh', '-nop', '-cwa' + $ags
    for ($i = 4; $i -lt $ags.Count; $i++) {
      if ($ags[$i].StartsWith('-')) {
        continue
      }
      $ags[$i] = "'" + $ags[$i].Replace("'", "''") + "'"
    }
    return $ags
  }
  $info = Get-Command $ags[0] -ea Ignore
  if ($info.CommandType -ceq 'Alias') {
    $info = $info.ResolvedCommand
  }
  while ($true) {
    if (!$info) {
      if ($ags[0].StartsWith('-')) {
        break
      }
      throw [System.Management.Automation.CommandNotFoundException]::new($ags[0])
    }
    elseif ($info.CommandType -ceq 'Application') {
      $ags[0] = $info.Source
      break
    }
    elseif ($info.CommandType -ceq 'ExternalScript') {
      $ags[0] = $info.Source
      $ags = 'pwsh', '-nop' + $ags
      break
    }
    elseif ($info.Module) {
      $ags[0] = $info.ModuleName + '\' + $info.Name
      if ($ExpectingInput) {
        $ags[0] = '$input|' + $ags[0]
      }
      $ags = 'pwsh', '-nop', '-c' + $ags
      for ($i = 4; $i -lt $ags.Count; $i++) {
        if ($ags[$i].StartsWith('-')) {
          continue
        }
        $ags[$i] = "'" + $ags[$i].Replace("'", "''") + "'"
      }
      break
    }
    else {
      $info = Get-Command $ags[0] -CommandType Application, ExternalScript -TotalCount 1 -ea Ignore
    }
  }
  $ags
}

function Show-CommandInfo {
  <#
  .SYNOPSIS
  Show/edit Command info.
   #>
  [CmdletBinding()]
  [Alias('l', 'k', 'e')]
  param (
    [ArgumentCompleter({
        param (
          [string]$CommandName,
          [string]$ParameterName,
          [string]$WordToComplete
        )
        if (Test-Path $WordToComplete*) {
          [System.Management.Automation.CompletionCompleters]::CompleteFilename($WordToComplete)
        }
        else {
          [System.Management.Automation.CompletionCompleters]::CompleteCommand($wordToComplete)
        }
      })]
    [Parameter(Position = 0)]
    [string]
    $Name,
    [Parameter(Position = 1, ValueFromRemainingArguments)]
    [string[]]
    $ArgumentList,
    [Parameter(ValueFromPipelineByPropertyName)]
    [Alias('Path')]
    [string]
    $FullName,
    [Parameter(ValueFromPipeline)]
    [System.Object]
    $InputObject,
    [Parameter()]
    [switch]
    $Man = $MyInvocation.InvocationName -eq 'k',
    [Parameter()]
    [switch]
    $Edit = $MyInvocation.InvocationName -eq 'e' -or $PSBoundParameters.ContainsKey('Editor'),
    [ArgumentCompleter({
        param (
          [string]$CommandName,
          [string]$ParameterName,
          [string]$WordToComplete
        )
        [System.Management.Automation.CompletionCompleters]::CompleteCommand($wordToComplete)
      })]
    [Parameter()]
    [string]
    $Editor = $env:EDITOR ?? 'edit'
  )
  begin {
    [string[]]$items = @()
    [string[]]$inputs = @()
  }
  process {
    if ($FullName) {
      $items += $FullName
    }
    else {
      $inputs += $InputObject
    }
  }
  end {
    if ($MyInvocation.ExpectingInput) {
      if ($Name) {
        $ArgumentList = @($Name) + $ArgumentList
      }
      if ($items) {
        $items = Get-Item -LiteralPath $items -Force -ea Stop | resolveItem
        if (!$items) {
          return
        }
        if ($Man) {
          Write-Debug "| showHelp $ArgumentList"
          $items | showHelp $ArgumentList
        }
        elseif ($Edit) {
          $ArgumentList = $items + $ArgumentList
          Write-Debug "$Editor $ArgumentList"
          & $Editor $ArgumentList
        }
        else {
          Write-Debug "| showFile $ArgumentList"
          $items | showFile $ArgumentList
        }
        return
      }
      if ($Man) {
        Write-Debug "| bat -plps1 $ArgumentList"
        $inputs | bat -plps1 $ArgumentList
      }
      elseif ($Edit) {
        Write-Debug "| $Editor $ArgumentList"
        $inputs | & $Editor $ArgumentList
      }
      else {
        Write-Debug 'showing Command help from stdin'
        $inputs | bat -plhelp $ArgumentList
      }
      return
    }
    if ($Edit) {
      $items = if ($Name) {
        Get-Command $Name -ea Ignore | commandEditable
      }
      else {
        $MyInvocation.MyCommand.Module.Path
      }
      $ArgumentList = $items ? ($items + $ArgumentList) : @($Name; $ArgumentList)
      Write-Debug "$Editor $ArgumentList"
      return & $Editor $ArgumentList
    }
    if (!$Name) {
      $Name = $Man ? $MyInvocation.MyCommand.Name : '.'
    }
    $item = (Get-Item $Name -Force -ea Ignore) ?? (Get-Command $Name -ea Ignore)
    if (!$item) {
      return Write-Error "item not found: $Name"
    }
    $showCommand = $Man ? 'showHelp' : 'showSource'
    Write-Debug "| $showCommand $ArgumentList"
    $item | & $showCommand $ArgumentList
  }
}

function .. {
  Set-Location -LiteralPath ..
}

function ... {
  Set-Location -LiteralPath ../..
}

function .... {
  Set-Location -LiteralPath ../../..
}

function ee {
  $cmd = switch -CaseSensitive -Wildcard ($env:TERM_PROGRAM) {
    'vscode*' { ${env:TERM_PRODUCT}?.ToLowerInvariant() ?? $_.Substring(2); break }
    default { $env:EDITOR; break }
  }
  if ($MyInvocation.ExpectingInput) {
    Write-Debug "| $cmd $ags"
    $input | & $cmd $ags
  }
  else {
    Write-Debug "$cmd $ags"
    & $cmd $ags
  }
}

function env {
  $reEnv = [regex]::new('^\w+\+?=')
  $envMap = [Dictionary[string, string]]::new()
  # flat iterator args for native passing
  # note: replace token -- with `-- to escape function passing
  [string[]]$ags = $args.Where{ $null -ne $_ }
  $cmd, $ags = foreach ($arg in $ags) {
    if (!$reEnv.IsMatch($arg)) {
      $arg
      $foreach
      break
    }
    [string]$key, [string]$value = $arg.Split('=', 2)
    if ($key.EndsWith('+')) {
      $key = $key.TrimEnd('+')
      $value = [System.Environment]::GetEnvironmentVariable($key) + $value
    }
    $envMap[$key] = $value
  }
  $cmd = (Get-Command $cmd -Type Application -TotalCount 1 -ea Stop).Source
  $savedEnvMap = [Dictionary[string, string]]::new()
  $envMap.GetEnumerator().ForEach{
    $savedEnvMap[$_.Key] = [System.Environment]::GetEnvironmentVariable($_.Key)
    [System.Environment]::SetEnvironmentVariable($_.Key, $_.Value)
  }
  try {
    if ($MyInvocation.ExpectingInput) {
      Write-Debug "| $cmd $ags"
      $input | & $cmd $ags
    }
    else {
      Write-Debug "$cmd $ags"
      & $cmd $ags
    }
  }
  finally {
    $savedEnvMap.GetEnumerator().ForEach{
      Set-Item -LiteralPath Env:$($_.Key) $_.Value
    }
    Pop-Location
  }
}

function npm {
  $cmd = switch ($true) {
    # use npm as a cli, pipe output
    ($MyInvocation.PipelineLength -ne 1) { 'npm'; break }
    (Test-Path pnpm-lock.yaml) { 'pnpm'; break }
    (Test-Path bun.lock?) { 'bun'; break }
    (Test-Path yarn.lock) { 'yarn'; break }
    (Test-Path deno.json) { 'deno'; break }
    default { 'npm'; break }
  }
  $cmd = (Get-Command $cmd -Type Application -TotalCount 1 -ea Stop).Source
  [string[]]$ags = $args.Where{ $null -ne $_ }
  if ($MyInvocation.ExpectingInput) {
    Write-Debug "| $cmd $ags"
    $input | & $cmd $ags
  }
  else {
    Write-Debug "$cmd $ags"
    & $cmd $ags
  }
}

function npx {
  [string]$cmd, [string[]]$ags = $args.Where{ $null -ne $_ }
  $cmd = (Get-Command ./node_modules/.bin/$cmd, $cmd -Type Application -TotalCount 1 -ea Ignore)?[0].Source
  if (!$cmd) {
    # fallback to handle options
    $cmd, $ags = @(switch ($true) {
        (Test-Path pnpm-lock.yaml) { 'pnpm', 'dlx'; break }
        (Test-Path yarn.lock) { 'yarn', 'dlx'; break }
        (Test-Path bun.lock?) { 'bun', 'x'; break }
        default { 'npx'; break }
      }) + $args
    $cmd = (Get-Command $cmd -Type Application -TotalCount 1 -ea Stop).Source
  }
  if ($MyInvocation.ExpectingInput) {
    Write-Debug "| $cmd $ags"
    $input | & $cmd $ags
  }
  else {
    Write-Debug "$cmd $ags"
    & $cmd $ags
  }
}

function prompt {
  '{0} ({1}:{2}) {3}{4} ' -f @(
    # status
    switch ([int]!$? -shl 1 -bor [int][bool]$LASTEXITCODE) {
      0 { "`e[32mPS`e[0m"; break }
      1 { "`e[33m$LASTEXITCODE`e[0m"; break }
      2 { "`e[31mPS`e[0m"; break }
      3 { "`e[31m$LASTEXITCODE`e[0m"; break }
      # no default
    }
    # historyId
    $MyInvocation.HistoryId
    # duration
    Format-Duration ($MyInvocation.HistoryId -eq 1 ? 0 : (Get-History -Count 1).Duration)
    # pwd
    if ($PWD.Provider.Name -ceq 'FileSystem') {
      $PSStyle.FormatHyperlink(
        (($PWD.ProviderPath + [System.IO.Path]::DirectorySeparatorChar).StartsWith($HOME + [System.IO.Path]::DirectorySeparatorChar) ? '~' + $PWD.ProviderPath.Substring($HOME.Length) : $PWD.ProviderPath),
        [uri]::new($env:WSL_DISTRO_NAME ? (wslpath -w $PWD.ProviderPath) : $PWD.ProviderPath))
    }
    else {
      $PWD
    }
    # endMark
    ($PWD.Path.Length / [System.Console]::WindowWidth -gt .42 ? "`n" : '') + ('>' * ($NestedPromptLevel + 1))
  )
}

function sudo {
  $ags = Get-PowerShellExecArgs $args
  if ($cmd = (Get-Command sudo -CommandType Application -TotalCount 1 -ea Ignore).Source) {
    if ($ags[0] -ceq 'pwsh') {
      $ags = , '-E' + $ags
    }
    if ($MyInvocation.ExpectingInput) {
      Write-Debug "| $cmd $ags"
      $input | & $cmd $ags
    }
    else {
      Write-Debug "$cmd $ags"
      & $cmd $ags
    }
    return
  }
  if (!$IsWindows) {
    throw [System.Management.Automation.CommandNotFoundException]::new('sudo')
  }
  if ($MyInvocation.ExpectingInput) {
    Write-Warning 'no sudo executable found, ignoring input'
  }
  $cmd, $ags = $ags
  Write-Debug "$cmd $ags"
  Start-Process -FilePath $cmd -ArgumentList $ags -Verb runas
}

function x {
  $cmd, $ags = @(
    if (!$MyInvocation.ExpectingInput) {
      $term = switch ($env:TERM) {
        'alacritty' { $_; break }
        'xterm-ghostty' { $_; break }
        'xterm-kitty' { $_; break }
        default {
          if ($env:ALACRITTY_LOG) { 'alacritty' }
          elseif ($env:GHOSTTY_BIN_DIR) { 'ghostty' }
          elseif ($env:KITTY_PID) { 'kitty' }
          elseif ($env:WT_SESSION -or (Get-Command wt -CommandType Application -TotalCount 1 -ea Ignore)) { 'wt' }
          break
        }
      }
      switch ($term) {
        'alacritty' {
          if ($IsWindows) {
            { Start-Process alacritty ('--hold', '-e' + $args) }
          }
          elseif (Get-Process alacritty -ea Ignore) {
            'alacritty', 'msg', 'create-window', '--hold', '-e'
          }
          elseif ($IsMacOS) {
            'open', '-a', 'alacritty.app', '-n', '--', '--hold', '-e'
          }
          elseif ($IsLinux) {
            { (setsid -f alacritty --hold -e $args &) | Wait-Job | Remove-Job }
          }
          break
        }
        'xterm-ghostty' { 'ghostty', '+new-window', '-e'; break }
        'xterm-kitty' { $IsMacOS ? 'open', '-a', 'kitty.app', '-n', '--' : 'kitty', '--detach'; '--hold', '--'; break }
        'wt' { 'wt', 'nt', '--'; break }
        default {
          if ($IsWindows) {
            { $cmd, $ags = $args; Start-Process $cmd $ags }
          }
          elseif ($IsMacOS) {
            throw [System.NotImplementedException]::new('iterm2 not implemented')
          }
          elseif ($IsLinux) {
            { (Start-Process setsid (, '-f' + $args) &) | Wait-Job | Remove-Job }
          }
          break
        }
      }
    }
    $cmd, $ags = Get-PowerShellExecArgs $args $MyInvocation.ExpectingInput
    switch ([System.IO.Path]::GetFileNameWithoutExtension($cmd)) {
      'aria2c' { $cmd, '-x2', '-j32', '-d', [System.IO.Path]::GetTempPath(), '--allow-overwrite', "--file-allocation=$($IsWindows ? 'prealloc' : 'falloc')"; break }
      'msiexec' { 'sudo', '--', $cmd, '/qn', '/norestart', '/log', "$env:TEMP\msiexec.log", '/i'; break }
      'installer' { 'sudo', '--', $cmd, '-dumplog', '-pkg'; break }
      'winget' { 'sudo', '--', $cmd; break }
      default { $cmd; break }
    }
    $ags
  )
  if ($MyInvocation.ExpectingInput) {
    Write-Debug "| $cmd $ags"
    $input | & $cmd $ags
  }
  else {
    Write-Debug "$cmd $ags"
    & $cmd $ags
  }
}
#endregion

filter showHelp ([string[]]$ArgumentList) {
  $item = $_
  if ($item -is [System.IO.FileSystemInfo]) {
    $item = $item | resolveItem
    if ($item.Attributes.HasFlag([System.IO.FileAttributes]::Directory)) {
      return $item | showDirectory $ArgumentList
    }
    if ($IsWindows -and $item.Extension -cmatch '^\.(exe|bat|cmd)$') {
      return & $item $ArgumentList --help | bat -plhelp
    }
    if ($IsLinux -and $item.UnixFileMode.HasFlag([System.IO.UnixFileMode]::UserExecute)) {
      $manCmd = Get-Command man -Type Application -TotalCount 1 -ea Ignore
      if ($manCmd -and (& $manCmd -w $item.BaseName)) {
        return & $manCmd $item.BaseName
      }
      return & $item $ArgumentList --help | bat -plhelp
    }
    return $item | showFile $ArgumentList
  }
  elseif ($item -is [System.Management.Automation.CommandInfo]) {
    if ($item.CommandType -ceq 'Alias') {
      $item = $item.ResolvedCommand
    }
    switch ($item.CommandType) {
      Application {
        $baseName = Split-Path -LeafBase $item.Name
        $manCmd = Get-Command man -Type Application -TotalCount 1 -ea Ignore
        if ($manCmd -and (& $manCmd -w $baseName)) {
          & $manCmd $baseName
          break
        }
        & $item.Source $ArgumentList --help | bat -plhelp
        break
      }
      Configuration {
        & $item
        break
      }
      default {
        Get-Help $item.Name -Category $_ -Full | bat -plman $ArgumentList
        break
      }
    }
    return
  }
  $item
}

filter showSource ([string[]]$ArgumentList) {
  $item = $_
  if ($item -is [System.IO.FileSystemInfo]) {
    $item = $item | resolveItem
    if ($item.Attributes.HasFlag([System.IO.FileAttributes]::Directory)) {
      return $item | showDirectory $ArgumentList
    }
    return $item | showFile $ArgumentList
  }
  elseif ($item -is [System.Management.Automation.CommandInfo]) {
    if ($item.CommandType -ceq 'Alias') {
      $item = $item.ResolvedCommand
    }
    switch ($item.CommandType) {
      Application {
        Get-Item -LiteralPath $item.Source -Force -ea Stop | showFile $ArgumentList
        break
      }
      Cmdlet {
        Get-Help $item.Name -Category Cmdlet -Full | bat -plman $ArgumentList
        break
      }
      Configuration {
        & $item
        break
      }
      { $_ -ceq 'ExternalScript' -or $_ -ceq 'Script' } {
        bat -plps1 $item.Source $ArgumentList
        break
      }
      { $_ -ceq 'Filter' -or $_ -ceq 'Function' } {
        $item.Definition | bat -plps1 $ArgumentList
        break
      }
      # no default
    }
    return
  }
  $item
}

filter resolveItem {
  [System.IO.FileSystemInfo]$item = $_
  if ($IsWindows) {
    (Get-Item -LiteralPath $item.ResolvedTarget -Force -ea Stop) ?? $item
  }
  else {
    Get-Item -LiteralPath (realpath `-- $item.FullName) -Force -ea Stop
  }
}

filter commandEditable {
  [System.Management.Automation.CommandInfo]$info = $_
  if ($info.CommandType -ceq 'Alias') {
    $info = $info.ResolvedCommand
  }
  switch ($info.CommandType) {
    Application {
      if ($info.Source | fileEditable) {
        $info.Source
      }
      else {
        Write-Warning "skip to edit binary $($info.Source)"
      }
      break
    }
    { $_ -ceq 'ExternalScript' -or $_ -ceq 'Script' } {
      $info.Source
      break
    }
    { $_ -ceq 'Cmdlet' -or $_ -ceq 'Configuration' -or $_ -ceq 'Filter' -or $_ -ceq 'Function' } {
      if ($info.Module) {
        $info.Module.Path
      }
      else {
        Write-Warning "skip to edit non-module $($info.CommandType) $info"
      }
      break
    }
  }
}

filter fileEditable {
  [System.IO.FileInfo]$item = $_
  if ($item.Length -gt 0x300000) {
    return $false # gt 3M
  }
  $s = $item.OpenRead()
  $buffer = [byte[]]::new(0xff)
  $Len = $s.Read($buffer, 0, 0xff)
  for ($i = 0; $i -lt $Len; $i++) {
    if (!$buffer[$i]) {
      break
    }
  }
  $s.Close()
  return $i -ge $Len
}

filter decompress {
  $cmd, $ags = @(switch ([System.IO.Path]::GetExtension($_)) {
      '.gz' { 'gzip', '-dc'; break }
      '.bz2' { 'bzip2', '-dc'; break }
      '.lz' { 'lzip', '-dc'; break }
      '.zst' { 'zstd -dcq'; break }
      '.br' { 'brotli', '-dc'; break }
      '.xz' { 'xz', '-dc'; break }
      '.lzma' { 'xz', '-dc'; break }
      default { throw [System.NotImplementedException]::new() }
    }; $_)
  & $cmd $ags
}

filter showDirectory ([string[]]$ArgumentList) {
  [string]$path = $_
  $oldValue = $PSStyle.OutputRendering
  $PSStyle.OutputRendering = 'Ansi'
  try {
    Get-ChildItem -LiteralPath $path -Force -ea Stop | less $ArgumentList
  }
  finally {
    $PSStyle.OutputRendering = $oldValue
  }
}

filter showFile ([string[]]$ArgumentList) {
  [System.IO.FileInfo]$_
  [string]$path = $_
  switch -CaseSensitive -Regex ($path) {
    '\.(?:[1-9n]|[1-9]x|man)\.(?:bz2|[glx]z|lzma|zst|br)$' {
      if (($path | decompress | file -L -).Contains('troff')) {
        $path | decompress | & ('man') -l - 2>$null | sed 's/\x1b\[[0-9;]*m\|.\x08//g' | bat -plman $ArgumentList
      }
      else {
        bat -p $path $ArgumentList
      }
      break
    }
    '\.(?:[1-9n]|[1-9]x|man)$' {
      if ((file -L $path).Contains('troff')) {
        & ('man') -l $path 2>$null | sed 's/\x1b\[[0-9;]*m\|.\x08//g' | bat -plman $ArgumentList
      }
      else {
        bat -p $path $ArgumentList
      }
      break
    }
    '\.(?:tar|tgz|tbz2)$' {
      tar -tvf $path | less
      break
    }
    '\.tar\.(?:bz2|[glx]z|[zZ]|lzma|br)$' {
      tar -tvf $path | less
      break
    }
    '\.tar\.zst$' {
      tar --zstd -tvf $path | less
      break
    }
    '\.tar\.lz$' {
      tar --lzip -tvf $path | less
      break
    }
    '\.(?:zip|jar|nbm)$' {
      if ($IsWindows) {
        tar -tvf $path | less
      }
      else {
        zipinfo $path | less
      }
      break
    }
    '\.(?:[glx]z|bz2|zst|br|lzma)$' {
      decompress $path | bat -p --file-name=$(Split-Path -LeafBase $path) $ArgumentList
      break
    }
    '\.deb$' {
      dpkg-deb -c $path | less
      break
    }
    '\.rpm$' {
      rpm -qpivl --changelog --nomanifest $path | less
      break
    }
    '\.7z$' {
      7z l $path | less
      break
    }
    '\.cpio?$' {
      Get-Content -LiteralPath $path | cpio -itv | less
      break
    }
    '\.gpg$' {
      gpg -d $path | less
      break
    }
    '\.(?:gif|jpeg|jpg|pcd|png|tga|tiff|tif)$' {
      icat $path
      break
    }
    '\.(md|markdown)$' {
      glow $path
      break
    }
    default {
      switch -CaseSensitive (file -Lb --mime-encoding $path) {
        binary { sh -c 'hexyl "$@" | less' `-- $path $ArgumentList <# auto close hexyl pipe #>; break }
        { $_ -ceq $OutputEncoding.WebName -or $_.StartsWith('unknown') } { bat -p $path $ArgumentList; break }
        default { Get-Content -Encoding ([System.Text.Encoding]::GetEncoding($_)) -LiteralPath $path | bat -p --file-name=$path $ArgumentList; break }
      }
      break
    }
  }
}
