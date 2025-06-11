& {
  $hook = {
    Set-Item Variable:Global:npm $(switch ($true) {
        (Test-Path pnpm-lock.yaml) { 'pnpm'; break }
        (Test-Path bun.lockb) { 'bun' ; break }
        (Test-Path yarn.lock) { 'yarn'; break }
        (Test-Path deno.json) { 'deno'; break }
        Default { 'npm' }
      })
  }
  # init search
  & $hook
  $action = $ExecutionContext.SessionState.InvokeCommand.LocationChangedAction
  $ExecutionContext.SessionState.InvokeCommand.LocationChangedAction = if ($action) {
    [Delegate]::Combine($action, [System.EventHandler[System.Management.Automation.LocationChangedEventArgs]]$hook)
  }
  else {
    $hook
  }
}
Set-Alias npm Invoke-Npm
Set-Alias npx Invoke-Npx
