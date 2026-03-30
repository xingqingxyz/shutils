using namespace System.Management.Automation.Language

Register-ArgumentCompleter -Native -CommandName pkcon -ScriptBlock {
  param ([string]$wordToComplete, [CommandAst]$commandAst, [int]$cursorPosition)
  $command = @(foreach ($i in $commandAst.CommandElements) {
      if ($i.Extent.StartOffset -eq $commandAst.Extent.StartOffset -or $i.Extent.EndOffset -eq $cursorPosition) {
        continue
      }
      if ($i -isnot [StringConstantExpressionAst] -or
        $i.StringConstantType -ne [StringConstantType]::BareWord -or
        $i.Value.StartsWith('-')) {
        break
      }
      $i.Value
    }) -join ' '

  @(if ($wordToComplete.StartsWith('-')) {
      '--version', '-h', '--help', '--help-all', '--filter=', '-y', '--noninteractive', '--only-download', '-n', '--background', '-p', '--plain', '-v', '--verbose', '-c', '--cache-age=', '--allow-untrusted', '--allow-downgrade', '--allow-reinstall'
    }
    switch ($command) {
      '' {
        if ($wordToComplete.StartsWith('-')) {
          break
        }
        'backend-details', 'get-roles', 'get-groups', 'get-filters', 'get-transactions', 'get-time', 'search', 'install', 'install-local', 'download', 'install-sig', 'remove', 'update', 'refresh', 'resolve', 'upgrade-system', 'get-updates', 'get-distro-upgrades', 'depends-on', 'required-by', 'get-details', 'get-details-local', 'get-files', 'get-files-local', 'get-update-detail', 'get-packages', 'repo-list', 'repo-enable', 'repo-disable', 'repo-set-data', 'repo-remove', 'what-provides', 'accept-eula', 'get-categories', 'repair', 'offline-get-prepared', 'offline-trigger', 'offline-status'
        break
      }
      'search' {
        if ($wordToComplete.StartsWith('-')) {
          break
        }
        'name', 'details', 'group', 'file'
        break
      }
      'refresh' {
        if ($wordToComplete.StartsWith('-')) {
          break
        }
        'force'
        break
      }
      'upgrade-system' {
        if ($wordToComplete.StartsWith('-')) {
          break
        }
        'minimal', 'default', 'complete'
        break
      }
    }
  ).Where{ $_ -like "$wordToComplete*" }
}
