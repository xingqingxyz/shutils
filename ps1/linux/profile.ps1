<#
.FORWARDHELPTARGETNAME New-Item
.FORWARDHELPCATEGORY Cmdlet
#>
function mkdir {
  [CmdletBinding(DefaultParameterSetName = 'pathSet',
    SupportsShouldProcess = $true,
    SupportsTransactions = $true,
    ConfirmImpact = 'Medium')]
  [OutputType([System.IO.DirectoryInfo])]
  param(
    [Parameter(ParameterSetName = 'nameSet', Position = 0, ValueFromPipelineByPropertyName = $true)]
    [Parameter(ParameterSetName = 'pathSet', Mandatory = $true, Position = 0, ValueFromPipelineByPropertyName = $true)]
    [System.String[]]
    ${Path},
    [Parameter(ParameterSetName = 'nameSet', Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
    [AllowNull()]
    [AllowEmptyString()]
    [System.String]
    ${Name},
    [Parameter(ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
    [System.Object]
    ${Value},
    [Switch]
    ${Force},
    [Parameter(ValueFromPipelineByPropertyName = $true)]
    [System.Management.Automation.PSCredential]
    ${Credential}
  )
  begin {
    $wrappedCmd = $ExecutionContext.InvokeCommand.GetCommand('New-Item', [System.Management.Automation.CommandTypes]::Cmdlet)
    $scriptCmd = { & $wrappedCmd -Type Directory @PSBoundParameters }
    $steppablePipeline = $scriptCmd.GetSteppablePipeline()
    $steppablePipeline.Begin($PSCmdlet)
  }
  process {
    $steppablePipeline.Process($_)
  }
  end {
    $steppablePipeline.End()
  }
}

function Invoke-ExecutableAlias {
  if ($MyInvocation.ExpectingInput) {
    $input | /usr/bin/env $_executableAliasMap[$MyInvocation.InvocationName] @args
  }
  else {
    /usr/bin/env $_executableAliasMap[$MyInvocation.InvocationName] @args
  }
}

$_executableAliasMap = @{
  egrep   = 'egrep', '--color=auto'
  grep    = 'grep', '--color=auto'
  xzegrep = 'xzegrep', '--color=auto'
  xzfgrep = 'xzfgrep', '--color=auto'
  xzgrep  = 'xzgrep', '--color=auto'
  zegrep  = 'zegrep', '--color=auto'
  zfgrep  = 'zfgrep', '--color=auto'
  zgrep   = 'zgrep', '--color=auto'
  tree    = 'tree', '-C', '--hyperlink', '--gitignore'
  fd    = 'fd', '--hyperlink=auto'
}
$_executableAliasMap.Keys.ForEach{ Set-Alias $_ Invoke-ExecutableAlias }
Set-Alias ls Get-ChildItem
Set-Alias cp Copy-Item
Set-Alias mv Move-Item
Set-Alias rm Remove-Item
Set-Alias sort Sort-Object
