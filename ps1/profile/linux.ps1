# alias from interactive bash
$__alias_arguments_map = @{}
function _handleAlias {
  if ($MyInvocation.ExpectingInput) {
    $input | /usr/bin/env $__alias_arguments_map[$MyInvocation.InvocationName] @args
  }
  else {
    /usr/bin/env $__alias_arguments_map[$MyInvocation.InvocationName] @args
  }
}
bash -ic alias 2>$null | ForEach-Object {
  $first, $second = $_.Split(' ', 2)[1].Split('=', 2)
  $__alias_arguments_map[$first] = $second.SubString(1, $second.Length - 2).Split(' ')
  Set-Alias $first _handleAlias
}

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

# remove can't use aliases
Remove-Alias l., which -ErrorAction Ignore
Set-Alias ls Get-ChildItem
Set-Alias cp Copy-Item
Set-Alias mv Move-Item
Set-Alias rm Remove-Item
