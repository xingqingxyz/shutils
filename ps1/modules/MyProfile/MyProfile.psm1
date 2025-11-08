function Show-CommandSource {
  <#
  .SYNOPSIS
  Show or edit command source.
  .PARAMETER List
  Defaults editing for Invoke-Sudo.
   #>
  [CmdletBinding()]
  [Alias('l', 'e')]
  param (
    [ArgumentCompleter({
        param (
          [string]$CommandName,
          [string]$ParameterName,
          [string]$WordToComplete
        )
        [System.Management.Automation.CompletionCompleters]::CompleteCommand($wordToComplete)
      })]
    [Parameter(Position = 0)]
    [string]
    $Name,
    [Parameter(Position = 1, ValueFromRemainingArguments)]
    [string[]]
    $ExtraArgs,
    [Parameter(ValueFromPipeline)]
    [string]
    $InputObject,
    [Parameter()]
    [switch]
    $List = $MyInvocation.InvocationName -ceq 'l',
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
    $Editor = $env:EDITOR ?? 'edit',
    [Alias('Path')]
    [Parameter(ValueFromPipelineByPropertyName)]
    [string]
    $FullName
  )
  begin {
    [string[]]$paths = @()
    [string[]]$inputs = @()
  }
  process {
    if ($FullName) {
      $paths += $FullName
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
      if ($paths) {
        $paths = Convert-Path -LiteralPath $paths | fsPath
        if (!$paths) {
          return
        }
        if ($List) {
          Write-CommandDebug showFile $ExtraArgs
          $paths | showFile $ExtraArgs
        }
        else {
          $ExtraArgs = $paths + $ExtraArgs
          Write-CommandDebug $Editor $ExtraArgs
          & $Editor $ExtraArgs
        }
        return
      }
      if ($List) {
        Write-Debug 'showing help from stdin'
        $inputs | bat -plhelp $ExtraArgs
      }
      else {
        Write-CommandDebug $Editor $ExtraArgs
        $inputs | & $Editor $ExtraArgs
      }
      return
    }
    if ($List) {
      if (!$Name) {
        $Name = '.'
      }
      $item = (Convert-Path $Name -Force -ea Ignore) ?? (Get-Command $Name -ea Ignore)
      if (!$item) {
        return Write-Error "command not found: $Name"
      }
      Write-CommandDebug show $ExtraArgs
      $item | show $ExtraArgs
      return
    }
    $paths = if ($Name) {
      Get-Command $Name -ea Ignore | editable
    }
    else {
      $MyInvocation.MyCommand.Module.Path
    }
    $ExtraArgs = $paths ? (($paths | fsPath) + $ExtraArgs) : @($Name; $ExtraArgs)
    Write-CommandDebug $Editor $ExtraArgs
    & $Editor $ExtraArgs
  }
}

filter show ([string[]]$ExtraArgs) {
  if ($_ -is [string]) {
    return $_ | showFile $ExtraArgs
  }
  if ($_ -isnot [System.Management.Automation.CommandInfo]) {
    # other PSProvider info, e.g. gi env:PATH
    return $_
  }
  [System.Management.Automation.CommandInfo]$info = $_
  if ($info.CommandType -ceq 'Alias') {
    $info = $info.ResolvedCommand
  }
  switch ($info.CommandType) {
    Application {
      return $info.Source | showFile $ExtraArgs # for all other files
    }
    Cmdlet {
      return Get-Help $info.Name -Category Cmdlet -Full | bat -plman $ExtraArgs
    }
    Configuration {
      return & $info
    }
    { $_ -ceq 'ExternalScript' -or $_ -ceq 'Script' } {
      return bat -plps1 $info.Source $ExtraArgs
    }
    { $_ -ceq 'Filter' -or $_ -ceq 'Function' } {
      return $info.Definition | bat -plps1 $ExtraArgs
    }
  }
}

filter fsPath {
  if ($IsWindows) {
    $item = (Get-Item -LiteralPath $_ -ea Stop)
    $item.ResolvedTarget ?? $item.FullName
  }
  else {
    realpath `-- $_
  }
}

filter editable {
  [System.Management.Automation.CommandInfo]$info = $_
  if ($info.CommandType -ceq 'Alias') {
    $info = $info.ResolvedCommand
  }
  switch ($info.CommandType) {
    Application {
      if ($info.Source | shouldEdit) {
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

filter shouldEdit {
  $item = Get-Item -LiteralPath $_ -Force
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

filter showFile ([string[]]$ExtraArgs) {
  [string]$path = $_ | fsPath
  if (Test-Path -LiteralPath $path -PathType Container) {
    $oldValue = $PSStyle.OutputRendering
    $PSStyle.OutputRendering = 'Ansi'
    try {
      Get-ChildItem -LiteralPath $path -ea Stop | less
    }
    finally {
      $PSStyle.OutputRendering = $oldValue
    }
    return
  }
  Get-Item -LiteralPath $path -ea Stop
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

function Write-CommandDebug ([string]$CommandName, [string[]]$ArgumentList) {
  Write-Debug ((@($CommandName) + $ArgumentList).ForEach{
      $null -eq $_ ? "''" : $_ -cmatch '\s' ? "'$([System.Management.Automation.Language.CodeGeneration]::EscapeSingleQuotedStringContent($_))'" : $_
    } -join ' ')
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
