$ErrorCode = 0
$ExecutionTime = 0
$TransientPrompt = $false
$ToolTipCommand = ''
# prepare the environment for oh-my-posh execution
$env:POWERLINE_COMMAND = 'oh-my-posh'
$env:CONDA_PROMPT_MODIFIER = $false
$env:POSH_SHELL_VERSION = $PSVersionTable.PSVersion.ToString()
$env:POSH_PID = $PID
$env:POSH_THEME ??= "${env:POSH_THEMES_PATH}/1_shell.omp.json"

function Set-PoshContext {}

function Set-TransientPrompt {
  $executingCommand = $false

  try {
    $parseErrors = $null
    [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$null, [ref]$null, [ref]$parseErrors, [ref]$null)
    if ($parseErrors.Count -eq 0) {
      $executingCommand = $true
      $script:TransientPrompt = $true
      [Microsoft.PowerShell.PSConsoleReadLine]::InvokePrompt()
    }
  }
  finally {
    # If PSReadline is set to display suggestion list, this workaround is needed to clear the buffer below
    # before accepting the current commandline. The max amount of items in the list is 10, so 12 lines
    # are cleared (10 + 1 more for the prompt + 1 more for current commandline).
    if ((Get-PSReadLineOption).PredictionViewStyle -eq 'ListView') {
      $terminalHeight = $Host.UI.RawUI.WindowSize.Height
      # only do this on an valid value
      if ($terminalHeight -gt 0) {
        [Microsoft.PowerShell.PSConsoleReadLine]::Insert("`n" * [System.Math]::Min($terminalHeight - $Host.UI.RawUI.CursorPosition.Y - 1, 12))
        [Microsoft.PowerShell.PSConsoleReadLine]::Undo()
      }
    }
  }

  $executingCommand
}

function Get-FileHyperlink {
  param(
    [Parameter(Mandatory, ValuefromPipeline = $True)]
    [string]$uri,
    [Parameter(ValuefromPipeline = $True)]
    [string]$name = $uri
  )
  if ($env:WSL_DISTRO_NAME) {
    # wsl conversion if needed
    $uri = & wslpath -m $uri
  }
  # return an ANSI formatted hyperlink
  return "`e]8;;file://$uri`e\$name`e]8;;`e\"
}

function Set-PoshPromptType {
  if ($script:TransientPrompt) {
    $script:PromptType = 'transient'
    $script:TransientPrompt = $false
    return
  }
  $script:PromptType = $Host.Runspace.Debugger.InBreakpoint ? 'debug' : 'primary'
}

function Update-PoshErrorCode {
  $lastHistory = Get-History -Count 1 -ErrorAction Ignore
  # error code should be updated only when a non-empty command is run
  if (($null -eq $lastHistory) -or ($script:LastHistoryId -eq $lastHistory.Id)) {
    $script:ExecutionTime = 0
    $script:NoExitCode = $true
    return
  }
  $script:NoExitCode = $false
  $script:LastHistoryId = $lastHistory.Id
  $script:ExecutionTime = ($lastHistory.EndExecutionTime - $lastHistory.StartExecutionTime).TotalMilliseconds
  if ($script:OriginalLastExecutionStatus) {
    $script:ErrorCode = 0
    return
  }
  $invocationInfo = $Error[0].InvocationInfo

  # check if the last command caused the last error
  if ($invocationInfo -and $lastHistory.CommandLine -eq $invocationInfo.Line) {
    $script:ErrorCode = 1
    return
  }
  if ($script:OriginalLastExitCode -is [int] -and $script:OriginalLastExitCode -ne 0) {
    # native app exit code
    $script:ErrorCode = $script:OriginalLastExitCode
    return
  }
}

function prompt {
  # store the orignal last command execution status
  $script:OriginalLastExecutionStatus = $?
  # store the orignal last exit code
  $script:OriginalLastExitCode = $global:LASTEXITCODE

  Set-PoshPromptType
  if ($script:PromptType -ne 'transient') {
    Update-PoshErrorCode
  }
  $cleanPSWD = [System.Environment]::CurrentDirectory
  $stackCount = Get-PoshStackCount
  Set-PoshContext
  $terminalWidth = $Host.UI.RawUI.WindowSize.Width
  # set a sane default when the value can't be retrieved
  if (-not $terminalWidth) {
    $terminalWidth = 0
  }

  # in some cases we have an empty $script:NoExitCode
  # this is a workaround to make sure we always have a value
  # see https://github.com/JanDeDobbeleer/oh-my-posh/issues/4128
  if ($null -eq $script:NoExitCode) {
    $script:NoExitCode = $true
  }

  # set the cursor positions, they are zero based so align with other platforms
  $env:POSH_CURSOR_LINE = $Host.UI.RawUI.CursorPosition.Y + 1
  $env:POSH_CURSOR_COLUMN = $Host.UI.RawUI.CursorPosition.X + 1

  $standardOut = @(Start-Utf8Process $script:OMPExecutable @('print', $script:PromptType, "--status=$script:ErrorCode", "--pswd=$cleanPSWD", "--execution-time=$script:ExecutionTime", "--stack-count=$stackCount", "--config=$env:POSH_THEME", "--shell-version=$script:PSVersion", "--terminal-width=$terminalWidth", "--shell=$script:ShellName", "--no-status=$script:NoExitCode"))
  # make sure PSReadLine knows if we have a multiline prompt
  Set-PSReadLineOption -ExtraPromptLineCount (($standardOut | Measure-Object -Line).Lines - 1)
  # the output can be multiline, joining these ensures proper rendering by adding line breaks with `n
  $standardOut -join "`n"

  # remove any posh-git status
  $env:POSH_GIT_STATUS = $null

  # remove cached tip command
  $script:ToolTipCommand = ''

  # restore the orignal last exit code
  $global:LASTEXITCODE = $script:OriginalLastExitCode
}

# set secondary prompt
Set-PSReadLineOption -ContinuationPrompt (oh-my-posh print secondary | Out-String -NoNewline)

Set-PSReadLineKeyHandler -Key Enter -BriefDescription 'OhMyPoshEnterKeyHandler' -ScriptBlock {
  Set-TransientPrompt
  [Microsoft.PowerShell.PSConsoleReadLine]::AcceptLine()
}
Set-PSReadLineKeyHandler -Key Ctrl+c -BriefDescription 'OhMyPoshCtrlCKeyHandler' -ScriptBlock {
  $start = 0
  [Microsoft.PowerShell.PSConsoleReadLine]::GetSelectionState([ref]$start, [ref]$null)
  # only render a transient prompt when no text is selected
  if ($start -eq -1) {
    Set-TransientPrompt
  }
  [Microsoft.PowerShell.PSConsoleReadLine]::CopyOrCancelLine()
}

# perform cleanup on removal so a new initialization in current session works
$ExecutionContext.SessionState.Module.OnRemove = {
  if ((Get-PSReadLineKeyHandler -Key Spacebar).Function -eq 'OhMyPoshSpaceKeyHandler') {
    Remove-PSReadLineKeyHandler -Key Spacebar
  }
  if ((Get-PSReadLineKeyHandler -Key Enter).Function -eq 'OhMyPoshEnterKeyHandler') {
    Set-PSReadLineKeyHandler -Key Enter -Function AcceptLine
  }
  if ((Get-PSReadLineKeyHandler -Key Ctrl+c).Function -eq 'OhMyPoshCtrlCKeyHandler') {
    Set-PSReadLineKeyHandler -Key Ctrl+c -Function CopyOrCancelLine
  }
}

Export-ModuleMember -Function @(
  'Set-PoshContext'
)
