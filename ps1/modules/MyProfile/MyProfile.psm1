function Show-CommandSource {
  <#
  .SYNOPSIS
  Show or edit command source.
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
        $([System.Management.Automation.CompletionCompleters]::CompleteFilename($wordToComplete)) ??
        [System.Management.Automation.CompletionCompleters]::CompleteCommand($wordToComplete)
      })]
    [Parameter(Position = 0)]
    [string[]]
    $Name,
    [Parameter(Position = 1, ValueFromRemainingArguments)]
    [string[]]
    $ExtraArgs,
    [Parameter(ValueFromPipeline)]
    [string]
    $InputObject,
    [Parameter()]
    [switch]
    $Edit = $MyInvocation.InvocationName -eq 'e',
    [ArgumentCompleter({
        param (
          [string]$CommandName,
          [string]$ParameterName,
          [string]$WordToComplete
        )
        $([System.Management.Automation.CompletionCompleters]::CompleteCommand($wordToComplete)) ??
        [System.Management.Automation.CompletionCompleters]::CompleteFilename($wordToComplete)
      })]
    [Parameter()]
    [string]
    $Editor = $env:EDITOR ?? 'code',
    [Alias('Path')]
    [Parameter(ValueFromPipelineByPropertyName)]
    [string]
    $FullName
  )
  begin {
    $paths = @()
  }
  process {
    if ($FullName) {
      $paths += $FullName
    }
  }
  end {
    if ($MyInvocation.ExpectingInput) {
      $ExtraArgs = $Name + $ExtraArgs
      if ($FullName) {
        $paths = Convert-Path -LiteralPath $paths
        if (!$paths) {
          return
        }
        if ($Edit) {
          Write-Debug "$Editor $paths $ExtraArgs"
          & $Editor $paths $ExtraArgs
        }
        else {
          Write-Debug "Invoke-Less $ExtraArgs"
          $paths | Invoke-Less $ExtraArgs
        }
        return
      }
      if ($Edit) {
        Write-Debug "$Editor $ExtraArgs"
        $input | & $Editor $ExtraArgs
      }
      else {
        Write-Debug 'showing help from stdin'
        $input | bat -plhelp $ExtraArgs
      }
      return
    }
    if ($Edit) {
      $paths = if ($Name) {
        Get-Command $Name -ea Ignore | editable
      }
      else {
        $MyInvocation.MyCommand.Module.Path
      }
      if ($paths) {
        Write-Debug "$Editor $paths $ExtraArgs"
        & $Editor $paths $ExtraArgs
      }
      else {
        Write-Debug "fallback: $Editor $Name $ExtraArgs"
        & $Editor $Name $ExtraArgs
      }
      return
    }
    $Name ??= '.'
    $Name.ForEach{
      # wildcard produces infos
      (Get-Item $_ -Force -ea Ignore) ?? (Get-Command $_ -ea Ignore) ??
      (Write-Error "command not found: $_")
    } | show $ExtraArgs
  }
}

filter show ([string[]]$ExtraArgs) {
  $info = $_
  if ($info -is [System.IO.FileSystemInfo]) {
    return $info | Invoke-Less $ExtraArgs
  }
  if ($info -isnot [System.Management.Automation.CommandInfo]) {
    # other PSProvider info, e.g. gi env:PATH
    return $info
  }
  if ($info.CommandType -eq 'Alias') {
    $info = $info.ResolvedCommand
  }
  switch ($info.CommandType) {
    Application {
      return $info.Source | Invoke-Less $ExtraArgs # for all other files
    }
    Cmdlet {
      return Get-Help $info.Name -Category Cmdlet -Full | bat -plman $ExtraArgs
    }
    Configuration {
      return & $info
    }
    { @('ExternalScript', 'Script').Contains($_.ToString()) } {
      return bat -plps1 $info.Source $ExtraArgs
    }
    { @('Filter', 'Function').Contains($_.ToString()) } {
      return $info.Definition | bat -plps1 $ExtraArgs
    }
  }
}

filter editable {
  [System.Management.Automation.CommandInfo]$info = $_
  if ($info.CommandType -eq 'Alias') {
    $info = $info.ResolvedCommand
  }
  switch ($info.CommandType) {
    Application {
      if (shouldEdit $info.Source) {
        $info.Source
      }
      else {
        Write-Warning "skip to edit binary $($info.Source)"
      }
      break
    }
    { @('ExternalScript', 'Script').Contains($_.ToString()) } {
      $info.Source
      break
    }
    { @('Cmdlet', 'Configuration', 'Filter', 'Function').Contains($_.ToString()) } {
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

function shouldEdit ([string]$Path) {
  $item = Get-Item -LiteralPath $Path -Force
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

function decompress ([System.IO.FileSystemInfo]$Item) {
  $cmd, $ags = $(switch ($Item.Extension) {
      '.gz' { 'gzip -dc'; break }
      '.bz2' { 'bzip2 -dc'; break }
      '.lz' { 'lzip -dc'; break }
      '.zst' { 'zstd -dcq'; break }
      '.br' { 'brotli -dc'; break }
      '.xz' { 'xz -dc'; break }
      '.lzma' { 'xz -dc'; break }
      default { throw 'not implemented' }
    }).Split(' ') + @($Item)
  & $cmd $ags
}

filter Invoke-Less ([string[]]$ExtraArgs) {
  $item = Get-Item -LiteralPath $_ -Force -ea Stop
  if ($item.LinkType) {
    $item = $item.ResolveLinkTarget($true) ?? $item
  }
  if ($item.Attributes.HasFlag([System.IO.FileAttributes]::Directory)) {
    if (!$IsWindows) {
      return env ls -lah --color=always --hyperlink=always $item $ExtraArgs | less
    }
    $oldValue = $PSStyle.OutputRendering
    $PSStyle.OutputRendering = 'Ansi'
    try {
      Get-ChildItem -LiteralPath $item | less
    }
    finally {
      $PSStyle.OutputRendering = $oldValue
    }
    return
  }
  $PSStyle.FormatHyperlink($item, [uri]::new($item))
  switch -CaseSensitive -Regex ($item.Name) {
    '\.(?:[1-9n]|[1-9]x|man)\.(?:bz2|[glx]z|lzma|zst|br)$' {
      if ((decompress $item | file -L -).Contains('troff')) {
        decompress $item | & ('man') -l - 2>$null | sed 's/\x1b\[[0-9;]*m\|.\x08//g' | bat -plman $ExtraArgs
      }
      else {
        bat -p $item $ExtraArgs
      }
      break
    }
    '\.(?:[1-9n]|[1-9]x|man)$' {
      if ((file -L $item).Contains('troff')) {
        & ('man') -l $item 2>$null | sed 's/\x1b\[[0-9;]*m\|.\x08//g' | bat -plman $ExtraArgs
      }
      else {
        bat -p $item $ExtraArgs
      }
      break
    }
    '\.(?:tar|tgz|tbz2)$' {
      tar -tvf $item | less
      break
    }
    '\.tar\.(?:bz2|[glx]z|[zZ]|lzma|br)$' {
      tar -tvf $item | less
      break
    }
    '\.tar\.zst$' {
      tar --zstd -tvf $item | less
      break
    }
    '\.tar\.lz$' {
      tar --lzip -tvf $item | less
      break
    }
    '\.(?:zip|jar|nbm)$' {
      if ($IsWindows) {
        tar -tvf $item | less
      }
      else {
        zipinfo $item | less
      }
      break
    }
    '\.(?:[glx]z|bz2|zst|br|lzma)$' {
      decompress $item | bat -p --file-name=$(Split-Path -LeafBase $item) $ExtraArgs
      break
    }
    '\.rpm$' {
      rpm -qpivl --changelog --nomanifest $item | less
      break
    }
    '\.cpio?$' {
      Get-Content -AsByteStream -LiteralPath $item | cpio -itv | less
      break
    }
    '\.gpg$' {
      gpg -d $item | less
      break
    }
    '\.(?:gif|jpeg|jpg|pcd|png|tga|tiff|tif)$' {
      icat $item
      break
    }
    default {
      switch -CaseSensitive (file -Lb --mime-encoding $item) {
        binary { sh -c 'hexyl "$@" | less' `-- $item $ExtraArgs <# auto close hexyl pipe #>; break }
        { $_ -ceq $OutputEncoding.WebName -or $_.StartsWith('unknown') } { bat -p $item $ExtraArgs; break }
        default { Get-Content -Encoding ([System.Text.Encoding]::GetEncoding($_)) -LiteralPath $item | bat -p --file-name=$item $ExtraArgs; break }
      }
      break
    }
  }
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
  Write-Debug "$cmd $ags"
  if ($MyInvocation.ExpectingInput) {
    $input | & $cmd $ags
  }
  else {
    & $cmd $ags
  }
}

$pwshExe, $sudoExe = (Get-Command pwsh, sudo -Type Application -TotalCount 1 -ea Ignore).Source
function Invoke-Sudo {
  $extraArgs = @(if ($args[0] -is [scriptblock]) {
      $args[0] = $args[0].ToString()
      @($pwshExe, '-nop', '-cwa')
    }
    else {
      $info = Get-Command $args[0] -ea Ignore
      if ($info.CommandType -eq 'Alias') {
        $info = $info.ResolvedCommand
      }
      if (!$info) {
        # fallback to handle sudo options
      }
      elseif ($info.CommandType -eq 'Application') {
        $args[0] = $info.Source
      }
      elseif ($info.CommandType -eq 'ExternalScript') {
        $args[0] = $info.Source
        @($pwshExe, '-nop')
      }
      else {
        if ($info.Module) {
          $args[0] = $info.Source + '\' + $info.Name
        }
        else {
          Write-Warning "running a no module $($info.CommandType) $info"
        }
        @($pwshExe, '-nop', '-c')
      }
    })
  if ($sudoExe) {
    $ags = $extraArgs + $args
    Write-Debug "$sudoExe $ags"
    if ($MyInvocation.ExpectingInput) {
      $input | & $sudoExe $ags
    }
    else {
      & $sudoExe $ags
    }
  }
  else {
    $cmd, $ags = $extraArgs + $args
    if ($MyInvocation.ExpectingInput) {
      Write-Warning 'ignored stdin'
    }
    Write-Debug "$cmd $ags"
    Start-Process -FilePath $cmd -ArgumentList $ags -Verb RunAs -WorkingDirectory .
  }
}
