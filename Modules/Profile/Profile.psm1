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

function Get-PowerShellExecArgs {
  [CmdletBinding()]
  [OutputType([string[]])]
  param (
    [Parameter(Mandatory, Position = 0, ValueFromRemainingArguments)]
    [System.Object[]]
    $ArgumentList,
    [Parameter()]
    [switch]
    $ExpectingInput
  )
  if (!$ArgumentList) {
    return $ArgumentList
  }
  if ($ArgumentList[0] -is [scriptblock]) {
    $ArgumentList[0] = '$ErrorActionPreference = "Stop"; $PSNativeCommandUseErrorActionPreference = $true; ' + $ArgumentList[0]
    [string[]]$ArgumentList = 'pwsh', '-nop', '-cwa' + $ArgumentList
    for ($i = 4; $i -lt $ArgumentList.Count; $i++) {
      if ($ArgumentList[$i].StartsWith('-')) {
        continue
      }
      $ArgumentList[$i] = "'" + $ArgumentList[$i].Replace("'", "''") + "'"
    }
    return $ArgumentList
  }
  $ArgumentList = [string[]]$ArgumentList
  $info = Get-Command $ArgumentList[0]
  if ($info.CommandType -ceq 'Alias') {
    $info = $info.ResolvedCommand
  }
  while ($true) {
    if ($info.CommandType -ceq 'Application') {
      $ArgumentList[0] = $info.Source
      break
    }
    elseif (!$info.Module -and $info.CommandType -cne 'ExternalScript') {
      $info = Get-Command $ArgumentList[0] -CommandType Application, ExternalScript -TotalCount 1
      continue
    }
    $ArgumentList[0] = $info.Module ? $info.Module.Name + '\' + $info.Name : $info.Source
    if ($ExpectingInput) {
      $ArgumentList[0] = '$input|' + $ArgumentList[0]
    }
    $ArgumentList[0] = '$ErrorActionPreference = "Stop"; $PSNativeCommandUseErrorActionPreference = $true; ' + $ArgumentList[0]
    $ArgumentList = 'pwsh', '-nop', '-c' + $ArgumentList
    for ($i = 4; $i -lt $ArgumentList.Count; $i++) {
      if ($ArgumentList[$i].StartsWith('-')) {
        continue
      }
      $ArgumentList[$i] = "'" + $ArgumentList[$i].Replace("'", "''") + "'"
    }
    break
  }
  $ArgumentList
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
    $ArgumentList = @(),
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
        $ArgumentList = , $Name + $ArgumentList
      }
      if ($items) {
        $items = Get-Item -LiteralPath $items -Force | resolveItem
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
      $ArgumentList = ($items ?? , $Name) + $ArgumentList
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

function cd... {
  Set-Location -LiteralPath ../..
}

function cd.... {
  Set-Location -LiteralPath ../../..
}

function uev {
  $reEnv = [regex]::new('^\w+=')
  $envMap = [Dictionary[string, string]]::new()
  $ags = $args.ForEach{ $_.Where{ $null -ne $_ } }
  $ags = foreach ($arg in $ags) {
    if ($arg -isnot [string] -or !$reEnv.IsMatch($arg)) {
      $arg
      $foreach
      break
    }
    $key, $value = $arg.Split('=', 2)
    $envMap[$key] = $value
  }
  $cmd, $ags = Get-PowerShellExecArgs $ags -ExpectingInput:$MyInvocation.ExpectingInput
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
    if ($LASTEXITCODE) {
      throw "$cmd exit code $LASTEXITCODE"
    }
  }
  finally {
    $savedEnvMap.GetEnumerator().ForEach{
      Set-Item -LiteralPath Env:$($_.Key) $_.Value
    }
  }
}

function npx {
  $root = $ExecutionContext.SessionState.Path.CurrentFileSystemLocation.ProviderPath
  $npm = $(do {
      $lockFile = Split-Path -Resolve -Leaf $root/pnpm-lock.yaml, $root/bun.lock?, $root/yarn.lock, $root/deno.json -ea Ignore | Select-Object -First 1
      if ($lockFile) {
        $lockFile.Split('-.'.ToCharArray(), 2)[0]
        break
      }
      $root = [System.IO.Path]::GetDirectoryName($root)
    } while (![System.IO.Path]::IsPathRooted($root))) ?? 'npm'
  $cmd, $ags = $args.ForEach{ $_.Where{ $null -ne $_ } }
  $cmd = (Get-Command ./node_modules/.bin/$cmd, $root/node_modules/.bin/$cmd, $cmd -CommandType Application -TotalCount 1 -ea Ignore)?[0].Source
  if (!$cmd) {
    $cmd, $ags = @(switch ($npm) {
        bun { 'bun', 'x'; break }
        deno { 'npm', 'exec', '--'; break }
        npm { 'npm', 'exec', '--'; break }
        pnpm { 'pnpm', 'exec'; break }
        yarn { 'yarn', 'exec'; break }
        default { throw 'command not found' }
      }) + $cmd + $ags
    $cmd = (Get-Command $cmd -CommandType Application -TotalCount 1).Source
  }
  if ($MyInvocation.ExpectingInput) {
    Write-Debug "| $cmd $ags"
    $input | & $cmd $ags
  }
  else {
    Write-Debug "$cmd $ags"
    & $cmd $ags
  }
  if ($LASTEXITCODE) {
    throw "npx exit code $LASTEXITCODE"
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
  $options = @()
  $ags = $args.ForEach{ $_.Where{ $null -ne $_ } }
  $ags = foreach ($arg in $ags) {
    if ($arg -isnot [string] -or !$arg.StartsWith('-')) {
      $arg
      $foreach
      break
    }
    $options += $arg
  }
  $ags = Get-PowerShellExecArgs $ags -ExpectingInput:$MyInvocation.ExpectingInput
  if ($cmd = (Get-Command sudo -CommandType Application -TotalCount 1 -ea Ignore).Source) {
    $ags = if ($ags[0] -ceq 'pwsh') {
      $options + ($IsWindows ? '-E' : '--preserve-env=PATH,PSModulePath'), '--' + $ags
    }
    else {
      $options + '--' + $ags
    }
    if ($MyInvocation.ExpectingInput) {
      Write-Debug "| $cmd $ags"
      $input | & $cmd $ags
    }
    else {
      Write-Debug "$cmd $ags"
      & $cmd $ags
    }
    if ($LASTEXITCODE) {
      throw "sudo exit code $LASTEXITCODE"
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
  <#
  .SYNOPSIS
  Open a terminal executing the command with expanded arguments and/or piped input.
   #>
  $ags = $args.ForEach{ $_.Where{ $null -ne $_ } }
  if (!$ags) {
    throw 'no command to execute'
  }
  [string[]]$term = switch ($env:TERM) {
    'alacritty' { $_; break }
    'xterm-ghostty' { 'ghostty'; break }
    'xterm-kitty' { 'kitty'; break }
    default {
      if ($env:ALACRITTY_LOG) { 'alacritty' }
      elseif ($env:GHOSTTY_BIN_DIR) { 'ghostty' }
      elseif ($env:KITTY_PID) { 'kitty' }
      # for wsl compatibility, check wt.exe to prefer wt
      elseif ($env:WT_SESSION -or (Get-Command wt.exe -CommandType Application -TotalCount 1 -ea Ignore)) { 'wt' }
      elseif ($IsWindows) { 'cmd' }
      else { throw 'terminal not found' }
      break
    }
  }
  [string]$cmd = $ags[0]
  $term = switch ($term[0]) {
    'alacritty' {
      if ($IsWindows) {
        'conhost', 'alacritty', '--title', $cmd, '-e'
      }
      elseif (Get-Process alacritty -ea Ignore) {
        # alacritty msg working directory is defined by config or $HOME
        'alacritty', 'msg', 'create-window', '--working-directory', $ExecutionContext.SessionState.Path. CurrentFileSystemLocation.ProviderPath, '--title', $cmd, '-e'
      }
      elseif ($IsMacOS) {
        'open', '-n', '-a', 'alacritty.app', '--', '--title', $cmd, '-e'
      }
      else {
        'sh', '-c', 'setsid -f "$0" "$@" > /dev/null 2>&1', 'alacritty', '--title', $cmd, '-e'
      }
      break
    }
    'ghostty' { 'ghostty', '+new-window', '--title', $cmd, '-e'; break }
    'kitty' { $IsMacOS ? 'open', '-n', '-a', 'kitty.app', '--', '--title', $cmd, '--' : 'kitty', '--detach', '--title', $cmd; '--'; break }
    'wt' { 'wt.exe', '-w', '0', 'nt', '-d', $ExecutionContext.SessionState.Path.CurrentFileSystemLocation.ProviderPath, '--title', $cmd, '--'; break }
    'cmd' { 'cmd', '/d', '/c', 'start', ('"' + $cmd.Replace('"', '""') + '"'); break }
    # no default
  }
  $ags = Get-PowerShellExecArgs $ags -ExpectingInput:$MyInvocation.ExpectingInput
  $ags = foreach ($cmd in $ags) {
    switch ([System.IO.Path]::GetFileNameWithoutExtension($cmd)) {
      'aria2c' { $cmd, '-x2', '-j32', '-d', [System.IO.Path]::GetTempPath(), '--allow-overwrite', "--file-allocation=$($IsWindows ? 'prealloc' : 'falloc')"; break }
      'msiexec' { 'sudo', '--', $cmd, '/qn', '/norestart', '/log', "${env:TEMP}msiexec.log", '/i'; break }
      'installer' { 'sudo', '--', $cmd, '-dumplog', '-pkg'; break }
      'winget' { 'sudo', '--', $cmd; break }
      default { $cmd; break }
    }
    $foreach
    break
  }
  $ags = if ($IsWindows) {
    $ags.Replace('"', '""') | Join-String -Separator '" "' -OutputPrefix '"' -OutputSuffix '"'
  }
  else {
    $ags.Replace("'", "'\''") | Join-String -Separator "' '" -OutputPrefix "'" -OutputSuffix "'"
  }
  if ($MyInvocation.ExpectingInput) {
    $file = [System.IO.Path]::GetTempFileName()
    $input > $file
    $ags = "$ags < $file"
    $clean = $IsWindows ? "del $file" : "rm $file"
  }
  else {
    $clean = $IsWindows ? 'break' : ':'
  }
  $cmd, $ags = if ($IsWindows) {
    if ($term[0] -ceq 'wt.exe') {
      # wt cmdline parsing is weird, escape ; to avoid splitting args
      $ags = $ags.Replace(';', '\;')
    }
    $term + 'cmd', '/v:on', '/d', '/c', (@"
@echo off &
for /l %_ in () do (
  $ags &
  if errorlevel 1 (
    set ec=!ERRORLEVEL! &
    echo process exited with code !ec! >&2 &
    choice /d n /t 9999 /m Retry &
    if errorlevel 2 ($clean & exit /b !ec!)
  ) else ($clean & exit /b 0)
)
"@ -creplace '\r?\n\s*', ' ')
  }
  else {
    $term + 'bash', '-c', @"
while true; do
  $ags
  ec=`$?
  if [ "`$ec" != 0 ]; then
    echo "process exited with code `$ec" >&2
    echo 'press ctrl+d to exit, or press enter to retry' >&2
    while read -rsn1 -t "`$EPOCHSECONDS"; do
      if [ "`$REPLY" = $'\004' ]; then
        break
      elif [ -z "`$REPLY" ]; then
        continue 2
      fi
    done
  fi
  $clean
  exit "`$ec"
done
"@
  }
  Write-Debug "$cmd $ags"
  & $cmd $ags
  if ($LASTEXITCODE) {
    throw "x exit code $LASTEXITCODE"
  }
}
#endregion

#region internal
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
        $baseName = [System.IO.Path]::GetFileNameWithoutExtension($item.Name)
        $manCmd = Get-Command man -CommandType Application -TotalCount 1 -ea Ignore
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
        Get-Item -LiteralPath $item.Source -Force | showFile $ArgumentList
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
    (Get-Item -LiteralPath $item.ResolvedTarget -Force) ?? $item
  }
  else {
    Get-Item -LiteralPath (realpath `-- $item.FullName) -Force
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
  $ags = switch ([System.IO.Path]::GetExtension($_)) {
    '.gz' { 'gzip', '-dc'; break }
    '.bz2' { 'bzip2', '-dc'; break }
    '.lz' { 'lzip', '-dc'; break }
    '.zst' { 'zstd', '-dcq'; break }
    '.br' { 'brotli', '-dc'; break }
    '.xz' { 'xz', '-dc'; break }
    '.lzma' { 'xz', '-dc'; break }
    default { throw [System.NotImplementedException]::new() }
  }
  $cmd, $ags = $ags + $_
  & $cmd $ags
}

filter showDirectory ([string[]]$ArgumentList) {
  [string]$path = $_
  $oldValue = $PSStyle.OutputRendering
  $PSStyle.OutputRendering = 'Ansi'
  try {
    Get-ChildItem -LiteralPath $path -Force | less $ArgumentList
  }
  finally {
    $PSStyle.OutputRendering = $oldValue
  }
}

filter showFile ([string[]]$ArgumentList) {
  switch -CaseSensitive -Regex (([System.IO.FileInfo]$_).FullName) {
    '\.(?:[1-9n]|[1-9]x|man)\.(?:bz2|[glx]z|lzma|zst|br)$' {
      if (($_ | decompress | file -L -).Contains('troff')) {
        $_ | decompress | & ('man') -l - 2>$null | sed 's/\x1b\[[0-9;]*m\|.\x08//g' | bat -plman $ArgumentList
      }
      else {
        bat -p $_ $ArgumentList
      }
      break
    }
    '\.(?:[1-9n]|[1-9]x|man)$' {
      if ((file -L $_).Contains('troff')) {
        & ('man') -l $_ 2>$null | sed 's/\x1b\[[0-9;]*m\|.\x08//g' | bat -plman $ArgumentList
      }
      else {
        bat -p $_ $ArgumentList
      }
      break
    }
    '\.(?:tar|tgz|tbz2)$' {
      tar -tvvf $_ | less
      break
    }
    '\.tar\.(?:bz2|[glx]z|[zZ]|lzma|br)$' {
      tar -tvvf $_ | less
      break
    }
    '\.tar\.zst$' {
      tar --zstd -tvvf $_ | less
      break
    }
    '\.tar\.lz$' {
      tar --lzip -tvvf $_ | less
      break
    }
    '\.(?:zip|jar|nbm)$' {
      if ($IsWindows) {
        tar -tvvf $_ | less
      }
      else {
        zipinfo $_ | less
      }
      break
    }
    '\.(?:[glx]z|bz2|zst|br|lzma)$' {
      decompress $_ | bat -p --file-name=$([System.IO.Path]::GetFileNameWithoutExtension($_)) $ArgumentList
      break
    }
    '\.deb$' {
      dpkg-deb -c $_ | less
      break
    }
    '\.rpm$' {
      rpm -qpivl --changelog --nomanifest $_ | less
      break
    }
    '\.7z$' {
      7z l $_ | less
      break
    }
    '\.cpio?$' {
      Get-Content -LiteralPath $_ | cpio -itv | less
      break
    }
    '\.gpg$' {
      gpg -d $_ | less
      break
    }
    '\.(?:gif|jpeg|jpg|pcd|png|tga|tiff|tif)$' {
      icat $_
      break
    }
    '\.(md|markdown)$' {
      glow $_
      break
    }
    default {
      $path = $_
      switch -CaseSensitive (file -Lb --mime-encoding $_) {
        binary { sh -c 'hexyl "$@" | less' `-- $path $ArgumentList <# auto close hexyl pipe #>; break }
        { $_ -ceq $OutputEncoding.WebName -or $_.StartsWith('unknown') } { bat -p $path $ArgumentList; break }
        default { Get-Content -LiteralPath $path -Encoding ([System.Text.Encoding]::GetEncoding($_)) | bat -p --file-name=$path $ArgumentList; break }
      }
      break
    }
  }
}
#endregion
