<#
.SYNOPSIS
Show command source.
 #>
function Show-Command {
  [CmdletBinding(DefaultParameterSetName = 'Base')]
  param (
    [ArgumentCompleter({
        param (
          [string]$CommandName,
          [string]$ParameterName,
          [string]$WordToComplete
        )
        $results = @([System.Management.Automation.CompletionCompleters]::CompleteFilename($wordToComplete))
        if ($results) { $results } else {
          [System.Management.Automation.CompletionCompleters]::CompleteCommand($wordToComplete)
        }
      })]
    [Parameter(Position = 0, ValueFromRemainingArguments, ParameterSetName = 'Base')]
    [string[]]
    $ExtraArgs,
    [Alias('Path', 'Name')]
    [Parameter(ValueFromPipelineByPropertyName, ParameterSetName = 'FullName')]
    [string]
    $FullName,
    [Parameter(ValueFromPipeline, ParameterSetName = 'Stdin')]
    [string]
    $InputObject
  )
  begin {
    $Name = @()
  }
  process {
    if ($FullName) {
      $Name += $FullName
    }
  }
  end {
    switch -CaseSensitive ($PSCmdlet.ParameterSetName) {
      'Stdin' { return $InputObject | bat -plhelp @ExtraArgs }
      'FullName' { break }
      'Base' {
        if (!$ExtraArgs) {
          $ExtraArgs = '.'
        }
        for ($i = 0; $i -lt $ExtraArgs.Count; $i++) {
          if ($ExtraArgs[$i].StartsWith('-')) {
            break
          }
          $Name += $ExtraArgs[$i]
        }
        $ExtraArgs = $ExtraArgs[$i..($ExtraArgs.Count)]
        break
      }
    }
    $Name | ForEach-Object {
      if (Test-Path $_) {
        return lessfilter $_
      }
      $info = Get-Command $_ -TotalCount 1 -ea Ignore
      if (!$info) {
        return Write-Error "command not found: $_"
      }
      if ($info.CommandType -eq 'Alias') {
        $info = $info.ResolvedCommand
      }
      switch ($info.CommandType) {
        Application {
          return lessfilter $info.Source # for all other files
        }
        Cmdlet {
          return Get-Help $info.Name -Category Cmdlet -Full | bat -plman @ExtraArgs
        }
        Configuration {
          return & $info.Name
        }
        ExternalScript {
          return bat -plps1 @ExtraArgs '--' $info.Source
        }
        { 'Filter,Function'.Contains($_.ToString()) } {
          return $info.Definition | bat -plps1 @ExtraArgs
        }
        default {
          throw "not impletmented command type $_"
        }
      }
    }
  }
}

function execute {
  $cmd, $ags = $args
  try {
    $cmd = (Get-Command -CommandType Application -TotalCount 1 -ea Stop $cmd).Source
  }
  catch {
    $cmd = "C:\Program Files\Git\usr\bin\$cmd.exe"
    if (!($IsWindows -and (Test-Path -LiteralPath $cmd))) {
      throw $_
    }
  }
  Write-Debug "$cmd $ags"
  if ($MyInvocation.ExpectingInput) {
    $input | & $cmd $ags
  }
  else {
    & $cmd $ags
  }
}

function decompress ([System.IO.FileSystemInfo]$Item) {
  $ags = $(switch ($Item.Extension) {
      '.gz' { 'gzip -dc'; break }
      '.bz2' { 'bzip2 -dc'; break }
      '.lz' { 'lzip -dc'; break }
      '.zst' { 'zstd -dcq'; break }
      '.br' { 'brotli -dc'; break }
      '.xz' { 'xz -dc'; break }
      '.lzma' { 'xz -dc'; break }
      default { throw 'not implemented' }
    }).Split(' ') + @('--', $Item)
  execute @ags
}

function lessfilter ([string]$Path) {
  [System.IO.FileSystemInfo]$item = Get-Item -LiteralPath $Path -Force -ea Stop
  if ($item.Mode.StartsWith('l')) {
    $item = $item.ResolveLinkTarget($true)
  }
  if ($item.Mode.StartsWith('d')) {
    return execute ls -xA --color=auto --hyperlink=auto '--' $item
  }
  switch -CaseSensitive -Regex ($item.Name) {
    '\.(?:[1-9n]|[1-9]x|man)\.(?:bz2|[glx]z|lzma|zst|br)$' {
      if ((decompress $item | execute file -L -).Contains('troff')) {
        decompress $item | execute man -l - | execute sed 's/\x1b\[[0-9;]*m\|.\x08//g' | bat -plman
      }
      else {
        bat -p '--' $item
      }
      break
    }
    '\.(?:[1-9n]|[1-9]x|man)$' {
      if ((execute file -L '--' $item).Contains('troff')) {
        execute man -l '--' $item | execute sed 's/\x1b\[[0-9;]*m\|.\x08//g' | bat -plman
      }
      else {
        bat -p '--' $item
      }
      break
    }
    '\.(?:tar|tgz|tbz2)$' {
      tar -tvvf $item
      break
    }
    '\.tar\.(?:bz2|[glx]z|[zZ]|lzma|br)$' {
      tar -tvvf $item
      break
    }
    '\.tar\.zst$' {
      tar --zstd -tvvf $item
      break
    }
    '\.tar\.lz$' {
      tar --lzip -tvvf $item
      break
    }
    '\.(?:zip|jar|nbm)$' {
      tar -tvvf $item
      break
    }
    '\.(?:[glx]z|bz2|zst|br|lzma)$' {
      decompress $item | bat -p --file-name=$(Split-Path -LeafBase $item)
      break
    }
    '\.rpm$' {
      rpm -qpivl --changelog --nomanifest '--' $item
      break
    }
    '\.cpio?$' {
      Get-Content -AsByteStream -LiteralPath $item | cpio -itv
      break
    }
    '\.gpg$' {
      gpg -d '--' $item
      break
    }
    '\.(?:gif|jpeg|jpg|pcd|png|tga|tiff|tif)$' {
      icat -- $item # unsafe `--` for Function\:icat
      break
    }
    default {
      switch -CaseSensitive (execute file -Lb --mime-encoding '--' $item) {
        binary { hexyl '--' $item | & { $input | less <# fixes hexyl pipe close #> }; break }
        $OutputEncoding.WebName { bat -p '--' $item; break }
        default { Get-Content -Encoding ([System.Text.Encoding]::GetEncoding($_)) -LiteralPath $item | bat -p --file-name=$item; break }
      }
      break
    }
  }
}

<#
.SYNOPSIS
Edit command source.
 #>
function Edit-Command {
  [CmdletBinding()]
  param (
    [ArgumentCompleter({
        param (
          [string]$CommandName,
          [string]$ParameterName,
          [string]$WordToComplete
        )
        $results = @([System.Management.Automation.CompletionCompleters]::CompleteFilename($wordToComplete))
        if ($results.Length) { $results } else {
          [System.Management.Automation.CompletionCompleters]::CompleteCommand($wordToComplete)
        }
      })]
    [Alias('Path', 'Name')]
    [Parameter(Position = 0, ValueFromPipelineByPropertyName)]
    [string]
    $FullName,
    [Parameter(Position = 1, ValueFromRemainingArguments)]
    [string[]]
    $ExtraArgs,
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
    $Editor = $env:EDITOR,
    [Parameter(ValueFromPipeline)]
    [string]
    $InputObject
  )
  if ($MyInvocation.ExpectingInput -and (!$FullName -or
      $PSBoundParameters.BoundPositionally.Contains('FullName'))) {
    Write-Debug "| $Editor $FullName $ExtraArgs"
    return $input | & $Editor $FullName @ExtraArgs
  }
  if (Test-Path $FullName) {
    return & $Editor $FullName @ExtraArgs
  }
  if (!$FullName) {
    $FullName = $MyInvocation.MyCommand.Name
  }
  $info = Get-Command $FullName -TotalCount 1 -ea Ignore
  if (!$info) {
    return & $Editor $FullName @ExtraArgs # fallback, e.g. code --help
  }
  if ($info.CommandType -eq 'Alias') {
    $info = $info.ResolvedCommand
  }
  if ('Cmdlet,Configuration,Filter,Function'.Contains($info.CommandType.ToString())) {
    if ($info.Module) {
      Write-Debug "$Editor $($info.Module.Path) $ExtraArgs"
      & $Editor $info.Module.Path @ExtraArgs
    }
    else {
      Show-Command $info.Name @ExtraArgs
    }
  }
  elseif ($info.CommandType -eq 'ExternalScript') {
    Write-Debug "$Editor $($info.Source) $ExtraArgs"
    & $Editor $info.Source @ExtraArgs
  }
  elseif ($info.CommandType -eq 'Application') {
    if (shouldEdit $info.Source) {
      Write-Debug "$Editor $($info.Source) $ExtraArgs"
      & $Editor $info.Source @ExtraArgs
    }
    else {
      Write-Warning "skip to edit binary $($info.Source)"
    }
  }
  else {
    throw 'not implemented'
  }
}

function shouldEdit ([string]$LiteralPath) {
  end {
    $item = Get-Item -LiteralPath $LiteralPath -Force
    $s = $item.OpenRead()
    if ($s.Length -gt 0x300000) {
      return $false # gt 3M
    }
    $buffer = [byte[]]::new(0xff)
    $Len = $s.Read($buffer, 0, 0xff)
    for ($i = 0; $i -lt $Len; $i++) {
      if (!$buffer[$i]) {
        return $false
      }
    }
    return $true
  }
  clean {
    $s.Close()
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
  $npm = (Get-Command $npm -Type Application -TotalCount 1 -ea Stop).Path
  if ($MyInvocation.ExpectingInput) {
    $input | & $npm $args
  }
  else {
    & $npm $args
  }
}

function Invoke-Npx {
  $cmd, $ags = $args
  $cmd = (Get-Command ./node_modules/.bin/$cmd -Type Application -TotalCount 1 -ea Ignore).Path
  if (!$cmd) {
    $cmd, $ags = switch ($true) {
      (Test-Path pnpm-lock.yaml) { @('pnpm', 'dlx', '--') + $args; break }
      (Test-Path yarn.lock) { @('yarn', 'dlx', '--') + $args; break }
      (Test-Path bun.lock?) { @('bun', 'x') + $args; break }
      default { @('npx') + $args; break }
    }
    $cmd = (Get-Command $cmd -Type Application -TotalCount 1 -ea Stop).Path
  }
  Write-Debug "$cmd $ags"
  if ($MyInvocation.ExpectingInput) {
    $input | & $cmd $ags
  }
  else {
    & $cmd $ags
  }
}

$pwshExe, $sudoExe = (Get-Command pwsh, sudo -CommandType Application -TotalCount 1 -ea Ignore).Path
function Invoke-Sudo {
  [string[]]$extraArgs = if ($args[0] -is [scriptblock]) {
    $args[0] = $args[0].ToString()
    @($pwshExe, '-nop', '-cwa')
  }
  else {
    $info = Get-Command $args[0] -TotalCount 1 -ea Ignore
    if ($info.CommandType -eq 'Alias') {
      $info = $info.ResolvedCommand
    }
    if (!$info) {
      # fallback to handle sudo options
      return & (Get-Command -CommandType Application -TotalCount 1 -ea Stop sudo).Path $args
    }
    if ($info.CommandType -eq 'Application') {
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
  }
  if ($sudoExe) {
    $ags = @('-E', '--') + $extraArgs + $args
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
    Write-Debug "$cmd $ags"
    if ($MyInvocation.ExpectingInput) {
      Write-Warning 'ignored stdin'
    }
    Start-Process -FilePath $cmd -ArgumentList $ags -Verb RunAs -WorkingDirectory .
  }
}

Set-Alias l Show-Command
Set-Alias e Edit-Command
