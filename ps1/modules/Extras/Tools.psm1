function Set-SystemProxy {
  <#
  .SYNOPSIS
  Simple impl for surfboard localnet network proxy.
   #>
  [CmdletBinding(DefaultParameterSetName = 'On')]
  param (
    [Parameter(Mandatory, Position = 0, ParameterSetName = 'On')]
    [string]
    $HostName,
    [Parameter(ParameterSetName = 'Off')]
    [switch]
    $Off,
    [Parameter()]
    [switch]
    $NoSystem
  )
  $On = !$Off.IsPresent
  if ($On) {
    Set-EnvironmentVariable -Scope User http_proxy=http://${hostName}:1234 https_proxy=http://${hostName}:1234 all_proxy=http://${hostName}:1235
  }
  else {
    Set-EnvironmentVariable -Scope User http_proxy= https_proxy= all_proxy=
  }
  if ($NoSystem) {
    return
  }
  if ($IsWindows) {
    Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings' -Name ProxyEnable -Value ([int]$On) -Type DWord
    if ($On) {
      Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings' -Name ProxyServer -Value ${hostName}:1234 -Type String
      Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings' -Name ProxyOverride -Value (@($env:no_proxy.Split(',').ForEach{ "https://$_" }; '<local>') -join ';') -Type String
    }
  }
  elseif ($IsLinux -and ($env:XDG_SESSION_DESKTOP -ceq 'gnome' -or $env:XDG_SESSION_DESKTOP -ceq 'ubuntu')) {
    $mode = $On ? 'manual' : 'none'
    gsettings set org.gnome.system.proxy mode $mode
    if ($On -and (gsettings get org.gnome.system.proxy.http host).Trim("'") -ne $hostName) {
      gsettings set org.gnome.system.proxy.http host $hostName
      gsettings set org.gnome.system.proxy.http port 1234
      gsettings set org.gnome.system.proxy.https host $hostName
      gsettings set org.gnome.system.proxy.https port 1234
      gsettings set org.gnome.system.proxy.socks host $hostName
      gsettings set org.gnome.system.proxy.socks port 1235
    }
  }
}

function Register-PSScheduledTask {
  <#
  .SYNOPSIS
  Register scheduled tasks running powershell code.
   #>
  [CmdletBinding()]
  param (
    [Parameter(Mandatory, Position = 0)]
    [string]
    $Name,
    [Parameter(Mandatory, Position = 1)]
    [string]
    $ScriptText,
    [Parameter(Mandatory)]
    [ValidateSet('monthly', 'weekly', 'daily')]
    [string[]]
    $Kind,
    [Parameter()]
    [datetime]
    $At = '0am'
  )
  $encodedCommand = [System.Convert]::ToBase64String([System.Text.Encoding]::Unicode.GetBytes($ScriptText))
  if ($IsLinux) {
    $Kind.ForEach{
      $service = @"
[Unit]
Description=PowerShell $_ $Name task

[Service]
Type=oneshot
ExecStart=/usr/bin/env pwsh -noni -nop -e $encodedCommand
"@
      $timer = @"
[Unit]
Description=PowerShell $_ $Name task timer

[Timer]
OnCalendar=$_
Persistent=true

[Install]
WantedBy=timers.target
"@
      $service > ~/.config/systemd/user/pwsh-$_-$Name`.service
      $timer > ~/.config/systemd/user/pwsh-$_-$Name`.timer
    }
    systemctl daemon-reload --user
    $Kind.ForEach{
      systemctl enable --user --now pwsh-$_-$Name`.timer
    }
  }
  elseif ($IsWindows) {
    $Kind.ForEach{
      $trigger = switch ($_) {
        'daily' { New-ScheduledTaskTrigger -At $At -Daily; break }
        'weekly' { New-ScheduledTaskTrigger -At $At -Weekly; break }
        'monthly' { New-ScheduledTaskTrigger -At $At -Daily -DaysInterval 30; break }
      }
      $action = New-ScheduledTaskAction -Execute pwsh -Argument "-noni -nop -w Hidden -e $encodedCommand"
      Register-ScheduledTask pwsh-$_-$Name -Force -Description "PowerShell $_ $Name task" -Trigger $trigger -Action $action
    }
  }
  else {
    throw [System.NotImplementedException]::new()
  }
}

function Unregister-PSScheduledTask {
  <#
  .SYNOPSIS
  Unregister scheduled tasks running powershell code.
   #>
  [CmdletBinding()]
  param (
    [Parameter(Mandatory, Position = 0)]
    [string]
    $Name,
    [Parameter(Mandatory)]
    [ValidateSet('monthly', 'weekly', 'daily')]
    [string[]]
    $Kind
  )
  if ($IsLinux) {
    $Kind.ForEach{
      systemctl disable --user pwsh-$_-$Name`.timer
      Remove-Item -LiteralPath ~/.config/systemd/user/pwsh-$_-$Name`.service, ~/.config/systemd/user/pwsh-$_-$Name`.timer -Force
    }
    systemctl daemon-reload --user
  }
  elseif ($IsWindows) {
    # it's a $ConfirmPreference = 'High' operation
    Unregister-ScheduledTask $Kind.ForEach{ "pwsh-$_-$Name" } -Confirm
  }
  else {
    throw [System.NotImplementedException]::new()
  }
}

function Invoke-CodeFormatter {
  [CmdletBinding(DefaultParameterSetName = 'Path')]
  [Alias('icf')]
  param (
    [Parameter(Mandatory, Position = 0, ParameterSetName = 'Path')]
    [ValidateNotNullOrEmpty()]
    [SupportsWildcards()]
    [string[]]
    $Path,
    [Parameter(Mandatory, ParameterSetName = 'LiteralPath')]
    [Alias('PSPath')]
    [ValidateNotNullOrEmpty()]
    [string[]]
    $LiteralPath
  )
  $Path + $LiteralPath | ForEach-Object { & (getParser $_ -Inplace) $_ }
}

function batf {
  if ($MyInvocation.ExpectingInput) {
    $name = $args[0]
    if ($MyInvocation.PipelinePosition -lt $MyInvocation.PipelineLength) {
      return $input | & (getParser $name -Stdin) $name
    }
    return $input | & (getParser $name -Stdin) $name | bat -p --file-name=$name
  }
  if ($MyInvocation.PipelinePosition -lt $MyInvocation.PipelineLength) {
    return Convert-Path -Force $args | ForEach-Object { & (getParser $_) $_ }
  }
  Convert-Path -Force $args | ForEach-Object {
    & (getParser $_) $_ | bat -p --color=always --file-name=$_
  } | & $env:PAGER
}

function getParser ([string]$Path, [switch]$Inplace, [switch]$Stdin) {
  switch -CaseSensitive -Regex ([System.IO.Path]::GetExtension($Path).Substring(1)) {
    '^(?:c|m|mm|cpp|cc|cp|cxx|c\+\+|h|hh|hpp|hxx|h\+\+|inl|ipp)$' {
      if ($Inplace) {
        { clang-format -i --style=LLVM `-- $args[0] }
      }
      elseif ($Stdin) {
        { $input | clang-format --style=LLVM --assume-filename=$args[0] }
      }
      else {
        { clang-format --style=LLVM `-- $args[0] }
      }
      break
    }
    '^(?:dart)$' {
      if ($Inplace) {
        { dart format `-- $args[0] }
      }
      elseif ($Stdin) {
        { $input | dart format }
      }
      else {
        { dart format -o show --show none --summary none `-- $args[0] }
      }
      break
    }
    '^(?:cs|csx|fs|fsi|fsx|vb)$' {
      if ($Inplace) {
        { dotnet format }
      }
      elseif ($Stdin) {
        { $input | dotnet format }
      }
      else {
        { <# dotnet format; #> Get-Content -AsByteStream -LiteralPath $args[0] }
      }
      break
    }
    '^(?:go)$' {
      if ($Inplace) {
        { gofmt -w `-- $args[0] }
      }
      elseif ($Stdin) {
        { $input | gofmt }
      }
      else {
        { gofmt `-- $args[0] }
      }
      break
    }
    '^(?:java)$' {
      if ($Inplace) {
        {}
      }
      elseif ($Stdin) {
        { $input }
      }
      else {
        {}
      }
      break
    }
    '^(?:js|cjs|mjs|jsx|tsx|ts|cts|mts|json|jsonc|json5|yml|yaml|htm|html|xhtml|shtml|vue|gql|graphql|css|scss|sass|less|hbs|md|markdown)$' {
      if ($Inplace) {
        { prettier -w --ignore-path= `-- $args[0] }
      }
      elseif ($Stdin) {
        { $input | prettier --ignore-path= --stdin-filepath=$args[0] }
      }
      else {
        { prettier --ignore-path= `-- $args[0] }
      }
      break
    }
    '^(?:ps1|psm1|psd1)$' {
      if ($Inplace) {
        { PSScriptAnalyzer\Invoke-Formatter (Get-Content -Raw -LiteralPath $args[0]) -Settings $env:SHUTILS_ROOT/CodeFormatting.psd1 | Out-File -NoNewline $args[0] }
      }
      elseif ($Stdin) {
        { PSScriptAnalyzer\Invoke-Formatter $input -Settings $env:SHUTILS_ROOT/CodeFormatting.psd1 }
      }
      else {
        { PSScriptAnalyzer\Invoke-Formatter (Get-Content -Raw -LiteralPath $args[0]) -Settings $env:SHUTILS_ROOT/CodeFormatting.psd1 }
      }
      break
    }
    '^(?:py|pyi|pyw|pyx|pxd|gyp|gypi)$' {
      if ($Inplace) {
        { ruff format -n `-- $args[0] }
      }
      elseif ($Stdin) {
        { $input | ruff format -n --stdin-filename $args[0] }
      }
      else {
        { Get-Content -AsByteStream -LiteralPath $args[0] | ruff format -n --stdin-filename $args[0] }
      }
      break
    }
    '^(?:rs)$' {
      if ($Inplace) {
        { rustfmt `-- $args[0] }
      }
      elseif ($Stdin) {
        { $input | rustfmt --emit stdout }
      }
      else {
        { rustfmt --emit stdout `-- $args[0] }
      }
      break
    }
    '^(?:sh|bash|zsh|ash)$' {
      if ($Inplace) {
        { shfmt -i 2 -bn -ci -sr `-- $args[0] }
      }
      elseif ($Stdin) {
        { $input | shfmt -i 2 -bn -ci -sr --filename $args[0] }
      }
      else {
        { Get-Content -AsByteStream -LiteralPath $args[0] | shfmt -i 2 -bn -ci -sr --filename $args[0] }
      }
      break
    }
    '^(?:lua)$' {
      if ($Inplace) {
        { stylua `-- $args[0] }
      }
      elseif ($Stdin) {
        { $input | stylua }
      }
      else {
        { Get-Content -AsByteStream -LiteralPath $args[0] | stylua }
      }
      break
    }
    '^(?:zig)$' {
      if ($Inplace) {
        {}
      }
      elseif ($Stdin) {
        { $input }
      }
      else {
        {}
      }
      break
    }
    default {
      if ($Stdin) {
        { $input }
      }
      else {
        { Get-Content -AsByteStream -LiteralPath $args[0] }
      }
      break
    }
  }
}

function ghQuery {
  [CmdletBinding()]
  param (
    [Parameter(Position = 0)]
    [ValidateSet('releases', 'limit', 'stars')]
    [string]
    $Category = 'releases',
    [Parameter(Position = 1, ValueFromRemainingArguments)]
    [string[]]
    $Queries
  )
  [string]$query = "query=@$PSScriptRoot/github/$Category.gql"
  [string[]]$fields = @()
  [string]$jq = '.'
  switch ($Category) {
    releases {
      $jq = '.repository.latestRelease[].name'
      $owner, $name = $Queries.Split('/', 2)
      $fields += "owner=$owner", "name=$name"
      break
    }
    stars {
      $jq = '.user.starredRepositories[].nameWithOwner'
      $login = git config get --global user.name
      if (!$login) {
        throw 'please setup git and git global config user.name'
      }
      $fields += "login=$login"
      break
    }
  }
  gh api graphql -F $query $fields.ForEach{ "-f=$_" } -q $jq | jq
}

function icat {
  <#
  .SYNOPSIS
  Image cat using sixels protocol.
  .NOTES
  When passing data from stdin, please use `gc -AsByteStream` or byte[] directly.
   #>
  [CmdletBinding(DefaultParameterSetName = 'Path')]
  param (
    [Parameter(Position = 0, ValueFromPipelineByPropertyName, ParameterSetName = 'Path')]
    [SupportsWildcards()]
    [string[]]
    $Path = $ExecutionContext.SessionState.Path.CurrentFileSystemLocation,
    [Parameter(Mandatory, ValueFromPipeline, ParameterSetName = 'Stdin')]
    [byte]
    $InputObject,
    [Parameter(Mandatory, ParameterSetName = 'Stdin')]
    [string]
    $Format,
    [Parameter()]
    [string]
    $Size = [System.Console]::WindowHeight * 20,
    [Parameter(Position = 1, ValueFromRemainingArguments)]
    [string[]]
    $ArgumentList
  )
  if ($MyInvocation.ExpectingInput) {
    return $input | magick -density 3000 -background transparent "${Format}:-" -resize "${Size}x" -define sixel:diffuse=true @ArgumentList sixel:- 2>$null
  }
  $Path.ForEach{
    magick -density 3000 -background transparent $_ -resize "${Size}x" -define sixel:diffuse=true @ArgumentList sixel:- 2>$null
    identify `-- $_
  }
}

function jq.f {
  $file = fzf '--walker=file,hidden' -q '.json$ '
  if (!$file) {
    return
  }
  $query = jq -r 'paths | map(
    if type == "string" then
      "." + (
        if test("^[a-zA-Z_]\\w*$") then
          .
        else
          "\"\(.)\""
        end)
    else
      "[\(.)]"
    end) | join("")' `-- $file | fzf
  $query = "jq '{0}' '{1}'" -f @(
    [System.Management.Automation.Language.CodeGeneration]::EscapeSingleQuotedStringContent($query)
    [System.Management.Automation.Language.CodeGeneration]::EscapeSingleQuotedStringContent((Convert-Path -LiteralPath $file)))
  $query
  [Microsoft.PowerShell.PSConsoleReadLine]::AddToHistory($query)
}

[psobject[]]$vimDigraph = $null
function de {
  [CmdletBinding()]
  param (
    [Parameter(Mandatory, Position = 0)]
    [string]
    $Digraph
  )
  if (!$vimDigraph) {
    $Script:vimDigraph = Import-Csv -LiteralPath $PSScriptRoot/vimDigraph.tsv -Delimiter "`t" -ea Stop
  }
  foreach ($item in $vimDigraph) {
    if ($item.digraph -ceq $Digraph) {
      return $item.char
    }
  }
  return Write-Error 'no matches'
}

function de.f {
  [string]$line = Get-Content -LiteralPath $PSScriptRoot/vimDigraph.tsv | Select-Object -Skip 1 | fzf
  $line.Split("`t", 2)[0]
}

function figlet.f ([string]$Value) {
  if ([string]::IsNullOrEmpty($Value)) {
    $Value = if ($MyInvocation.ExpectingInput) {
      $input
    }
    else {
      'hello world'
    }
  }
  $Value = $Value.Replace("'", "\'")
  $envVar = $IsWindows ? '%FZF_PREVIEW_COLUMNS%' : '$FZF_PREVIEW_COLUMNS'
  Split-Path -Resolve -LeafBase /usr/share/figlet/*.flf | fzf --reverse --preview-window=70% "--preview=figlet -f {} -w $envVar '$Value'" "--bind=enter:become:figlet -f {} -w $([System.Console]::WindowWidth) '$Value'"
}

function rg.f {
  [CmdletBinding()]
  param (
    [Parameter(Mandatory, Position = 0)]
    [string]
    $Query,
    [Parameter(Position = 1, ValueFromRemainingArguments)]
    [string[]]
    $Options,
    [Parameter(ValueFromPipeline)]
    [System.Object]
    $InputObject
  )
  if ($MyInvocation.ExpectingInput) {
    return $input | rg $Query @Options | fzf
  }
  $reload = @"
rg $Options --column --color=always {q} || exit 0
"@
  $open = @'
code --open-url "vscode://file$(realpath -- {1}):{2}:{3}"
'@
  $envVar = $IsWindows ? '%FZF_PREVIEW_COLUMNS%' : '$FZF_PREVIEW_COLUMNS'
  $preview = @"
bat --number --color=always --terminal-width=$envVar --highlight-line={2} {1}
"@
  $ags = @(
    "--query=$Query"
    '--ansi'
    '--delimiter=:'
    '--preview-window=up,border-bottom,~3,+{2}+3/3'
    "--preview=$preview"
    "--bind=start,ctrl-r:reload:$reload"
    "--bind=enter:become:$open"
    "--bind=ctrl-o:execute:$open"
  )
  fzf @ags
}
