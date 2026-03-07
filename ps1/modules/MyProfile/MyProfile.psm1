function Show-CommandInfo {
  <#
  .SYNOPSIS
  Show command info.
  .PARAMETER List
  Defaults to edit for Invoke-Sudo.
   #>
  [CmdletBinding()]
  [Alias('e', 'k', 'l')]
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
    $ExtraArgs,
    [Parameter(ValueFromPipelineByPropertyName)]
    [Alias('Path')]
    [string]
    $FullName,
    [Parameter(ValueFromPipeline)]
    [string]
    $InputObject,
    [Parameter()]
    [switch]
    $List = $MyInvocation.InvocationName -ceq 'l',
    [Parameter()]
    [switch]
    $Man = $MyInvocation.InvocationName -ceq 'k',
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
    $items = @()
    $inputs = @()
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
        $ExtraArgs = @($Name) + $ExtraArgs
      }
      if ($items) {
        $items = Get-Item -LiteralPath $items -Force -ea Stop | resolveItem
        if (!$items) {
          return
        }
        if ($List) {
          Write-CommandDebug showFile $ExtraArgs
          $items | showFile $ExtraArgs
        }
        elseif ($Man) {
          Write-CommandDebug showHelp $ExtraArgs
          $items | showHelp $ExtraArgs
        }
        else {
          $ExtraArgs = $items + $ExtraArgs
          Write-CommandDebug $Editor $ExtraArgs
          & $Editor $ExtraArgs
        }
        return
      }
      if ($List) {
        Write-Debug 'showing command help from stdin'
        $inputs | bat -plhelp $ExtraArgs
      }
      elseif ($Man) {
        Write-Debug 'showing powershell source from stdin'
        $inputs | bat -plps1 $ExtraArgs
      }
      else {
        Write-CommandDebug $Editor $ExtraArgs
        $inputs | & $Editor $ExtraArgs
      }
      return
    }
    if (!$List -and !$Man) {
      $items = if ($Name) {
        Get-Command $Name -ea Ignore | commandEditable
      }
      else {
        $MyInvocation.MyCommand.Module.Path
      }
      $ExtraArgs = $items ? ($items + $ExtraArgs) : @($Name; $ExtraArgs)
      Write-CommandDebug $Editor $ExtraArgs
      return & $Editor $ExtraArgs
    }
    if (!$Name) {
      $Name = $List ? '.' : $MyInvocation.MyCommand.Name
    }
    $item = (Get-Item $Name -Force -ea Ignore) ?? (Get-Command $Name -ea Ignore)
    if (!$item) {
      return Write-Error "item not found: $Name"
    }
    $showCommand = $List ? 'showSource' : 'showHelp'
    Write-CommandDebug $showCommand $ExtraArgs
    $item | & $showCommand $ExtraArgs
  }
}

filter showHelp ([string[]]$ExtraArgs) {
  $item = $_
  if ($item -is [System.IO.FileSystemInfo]) {
    $item = $item | resolveItem
    if ($item.Attributes.HasFlag([System.IO.FileAttributes]::Directory)) {
      return $item | showDirectory $ExtraArgs
    }
    if ($IsWindows -and $item.Extension -cmatch '^\.(exe|bat|cmd)$') {
      return & $item $ExtraArgs --help | bat -plhelp
    }
    if ($IsLinux -and $item.UnixFileMode.HasFlag([System.IO.UnixFileMode]::UserExecute)) {
      $manCmd = Get-Command man -Type Application -TotalCount 1 -ea Ignore
      if ($manCmd -and (& $manCmd -w $item.BaseName)) {
        return & $manCmd $item.BaseName
      }
      return & $item $ExtraArgs --help | bat -plhelp
    }
    return $item | showFile $ExtraArgs
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
          return & $manCmd $baseName
        }
        return & $item.Source $ExtraArgs --help | bat -plhelp
      }
      Configuration {
        return & $item
      }
      default {
        return Get-Help $item.Name -Category $_ -Full | bat -plman $ExtraArgs
      }
    }
  }
  return $item
}

filter showSource ([string[]]$ExtraArgs) {
  $item = $_
  if ($item -is [System.IO.FileSystemInfo]) {
    $item = $item | resolveItem
    if ($item.Attributes.HasFlag([System.IO.FileAttributes]::Directory)) {
      return $item | showDirectory $ExtraArgs
    }
    return $item | showFile $ExtraArgs
  }
  elseif ($item -is [System.Management.Automation.CommandInfo]) {
    if ($item.CommandType -ceq 'Alias') {
      $item = $item.ResolvedCommand
    }
    switch ($item.CommandType) {
      Application {
        return $item.Source | showFile $ExtraArgs # for all other files
      }
      Cmdlet {
        return Get-Help $item.Name -Category Cmdlet -Full | bat -plman $ExtraArgs
      }
      Configuration {
        return & $item
      }
      { $_ -ceq 'ExternalScript' -or $_ -ceq 'Script' } {
        return bat -plps1 $item.Source $ExtraArgs
      }
      { $_ -ceq 'Filter' -or $_ -ceq 'Function' } {
        return $item.Definition | bat -plps1 $ExtraArgs
      }
      default { return }
    }
  }
  return $item
}

filter resolveItem {
  [System.IO.FileSystemInfo]$item = $_
  if ($IsWindows) {
    (Get-Item -LiteralPath $item.ResolvedTarget -ea Stop) ?? $item
  }
  else {
    Get-Item -LiteralPath (realpath `-- $item.FullName) -ea Stop
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
  [string]$cmd, [string[]]$ags = @(switch ([System.IO.Path]::GetExtension($_)) {
      '.gz' { 'gzip', '-dc'; break }
      '.bz2' { 'bzip2', '-dc'; break }
      '.lz' { 'lzip', '-dc'; break }
      '.zst' { 'zstd -dcq'; break }
      '.br' { 'brotli', '-dc'; break }
      '.xz' { 'xz', '-dc'; break }
      '.lzma' { 'xz', '-dc'; break }
      default { throw [System.NotImplementedException]::new() }
    }) + $_
  & $cmd $ags
}

filter showDirectory ([string[]]$ExtraArgs) {
  [string]$path = $_
  $oldValue = $PSStyle.OutputRendering
  $PSStyle.OutputRendering = 'Ansi'
  try {
    Get-ChildItem -LiteralPath $path -Force -ea Stop | less $ExtraArgs
  }
  finally {
    $PSStyle.OutputRendering = $oldValue
  }
}

filter showFile ([string[]]$ExtraArgs) {
  [System.IO.FileInfo]$_
  [string]$path = $_
  switch -CaseSensitive -Regex ($path) {
    '\.(?:[1-9n]|[1-9]x|man)\.(?:bz2|[glx]z|lzma|zst|br)$' {
      if (($path | decompress | file -L -).Contains('troff')) {
        $path | decompress | & ('man') -l - 2>$null | sed 's/\x1b\[[0-9;]*m\|.\x08//g' | bat -plman $ExtraArgs
      }
      else {
        bat -p $path $ExtraArgs
      }
      break
    }
    '\.(?:[1-9n]|[1-9]x|man)$' {
      if ((file -L $path).Contains('troff')) {
        & ('man') -l $path 2>$null | sed 's/\x1b\[[0-9;]*m\|.\x08//g' | bat -plman $ExtraArgs
      }
      else {
        bat -p $path $ExtraArgs
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
      decompress $path | bat -p --file-name=$(Split-Path -LeafBase $path) $ExtraArgs
      break
    }
    '\.rpm$' {
      rpm -qpivl --changelog --nomanifest $path | less
      break
    }
    '\.cpio?$' {
      Get-Content -AsByteStream -LiteralPath $path | cpio -itv | less
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
        binary { sh -c 'hexyl "$@" | less' `-- $path $ExtraArgs <# auto close hexyl pipe #>; break }
        { $_ -ceq $OutputEncoding.WebName -or $_.StartsWith('unknown') } { bat -p $path $ExtraArgs; break }
        default { Get-Content -Encoding ([System.Text.Encoding]::GetEncoding($_)) -LiteralPath $path | bat -p --file-name=$path $ExtraArgs; break }
      }
      break
    }
  }
}

function Write-CommandDebug ([string]$CommandName, [string[]]$ArgumentList, [string]$Environment) {
  Write-Debug "$Environment $CommandName $($ArgumentList.ForEach{
      $null -eq $_ ? "''" : $_ -cmatch '\s' ? "'$([System.Management.Automation.Language.CodeGeneration]::EscapeSingleQuotedStringContent($_))'" : $_
    })"
}

function Invoke-Npm {
  $npm = switch ($true) {
    # use npm as a cli, pipe output
    ($MyInvocation.PipelineLength -ne 1) { 'npm'; break }
    (Test-Path pnpm-lock.yaml) { 'pnpm'; break }
    (Test-Path bun.lock?) { 'bun' ; break }
    (Test-Path yarn.lock) { 'yarn'; break }
    (Test-Path deno.json) { 'deno'; break }
    default { 'npm'; break }
  }
  $npm = (Get-Command $npm -Type Application -TotalCount 1 -ea Stop).Source
  if ($MyInvocation.ExpectingInput) {
    $input | & $npm $args
  }
  else {
    & $npm $args
  }
}

function Invoke-Npx {
  $cmd, $ags = $args
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
  Write-CommandDebug $cmd $ags
  if ($MyInvocation.ExpectingInput) {
    $input | & $cmd $ags
  }
  else {
    & $cmd $ags
  }
}

[string]$pwshExe, [string]$sudoExe = (Get-Command pwsh, sudo -Type Application -TotalCount 1 -ea Ignore).Source
function Invoke-Sudo {
  [string[]]$ags = $args.ForEach{
    if ($null -ne $_) {
      $_
    }
  }
  if ($args[0] -is [scriptblock]) {
    $ags = $pwshExe, '-nop', '-cwa' + $ags
  }
  else {
    $info = Get-Command $ags[0] -ea Ignore
    if ($info.CommandType -ceq 'Alias') {
      $info = $info.ResolvedCommand
    }
    if (!$info) {
      # fallback to handle sudo options
    }
    elseif ($info.CommandType -ceq 'Application') {
      $ags[0] = $info.Source
    }
    else {
      if ($_ -ceq 'ExternalScript') {
        $ags[0] = $info.Source
      }
      elseif ($info.Module) {
        $ags[0] = $info.Name
      }
      else {
        Write-Warning "running a no module $($info.CommandType) $info"
      }
      $ags[0] = "`$env:PSModulePath = '{0}'; {1} & '{2}' @args" -f $env:PSModulePath.Replace("'", "''"), ($MyInvocation.ExpectingInput ? '$input | ' : ''), $ags[0].Replace("'", "''")
      $ags = $pwshExe, '-nop', '-cwa' + $ags
    }
  }
  if ($sudoExe) {
    Write-CommandDebug $sudoExe $ags
    if ($MyInvocation.ExpectingInput) {
      $input | & $sudoExe $ags
    }
    else {
      & $sudoExe $ags
    }
    return
  }
  if ($MyInvocation.ExpectingInput) {
    Write-Warning 'ignored stdin'
  }
  [string]$cmd, $ags = $ags
  Write-CommandDebug $cmd $ags
  Start-Process -FilePath $cmd -ArgumentList $ags -Verb RunAs -WorkingDirectory .
}

function x {
  [CmdletBinding()]
  param (
    [Parameter(Mandatory, Position = 0)]
    [ArgumentCompleter({
        param (
          [string]$CommandName,
          [string]$ParameterName,
          [string]$WordToComplete
        )
        [System.Management.Automation.CompletionCompleters]::CompleteCommand($wordToComplete)
      })]
    [string]
    $CommandName,
    [ArgumentCompleter({
        [OutputType([System.Management.Automation.CompletionResult])]
        param (
          [string]$CommandName,
          [string]$ParameterName,
          [string]$WordToComplete,
          [System.Management.Automation.Language.CommandAst]$CommandAst,
          [System.Collections.IDictionary]$FakeBoundParameters
        )
        $astList = $commandAst.CommandElements | Select-Object -Skip 1
        $commandAst = [System.Management.Automation.Language.Parser]::ParseInput("$astList", [ref]$null, [ref]$null).EndBlock.Statements[0].PipelineElements[0]
        & (Get-ArgumentCompleter $FakeBoundParameters.CommandName) $wordToComplete $commandAst $CommandAst.CommandElements[-1].Extent.EndOffset
      })]
    [Parameter(Position = 1, ValueFromRemainingArguments)]
    [string[]]
    $ExtraArgs
  )
  $ags = switch (Split-Path -LeafBase $CommandName) {
    'aria2c' { @('-x2', '-j32', '-d', [System.IO.Path]::GetTempPath(), "--file-allocation=$($IsWindows ? 'prealloc' : 'falloc')") + $ExtraArgs; break }
    'msiexec' { @($CommandName, '/qn', '/norestart', '/log', "Temp:/$($ExtraArgs[0]).log", '/i') + $ExtraArgs; $CommandName = 'sudo'; break }
    'installer' { @($CommandName, '-dumplog', '-pkg') + $ExtraArgs; $CommandName = 'sudo'; break }
    default {
      if ($IsWindows) {
        @('nt', $CommandName) + $ExtraArgs
        $CommandName = 'wt'
        break
      }
      @('-e', $CommandName) + $ExtraArgs
      $CommandName = 'alacritty'
      break
    }
  }
  if ($MyInvocation.ExpectingInput) {
    $input | & $CommandName @ags
  }
  else {
    & $CommandName @ags
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
