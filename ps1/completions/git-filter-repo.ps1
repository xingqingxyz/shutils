using namespace System.Management.Automation.Language

Register-ArgumentCompleter -Native -CommandName git-filter-repo -ScriptBlock {
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

  @(switch ($command) {
      '' {
        if ($wordToComplete.StartsWith('-')) {
          '--analyze', '--report-dir=', '--invert-paths', '--path-match=', '--path=', '--path-glob=', '--path-regex=', '--use-base-name', '--path-rename=', '--path-rename-match=', '--paths-from-file=', '--subdirectory-filter=', '--to-subdirectory-filter=', '--replace-text=', '--strip-blobs-bigger-than=', '--strip-blobs-with-ids=', '--tag-rename=', '--replace-message=', '--preserve-commit-hashes', '--preserve-commit-encoding', '--mailmap=', '--use-mailmap', '--replace-refs=delete-no-add', '--replace-refs=delete-and-add', '--replace-refs=update-no-add', '--replace-refs=update-or-add', '--replace-refs=update-and-add', '--replace-refs=old-default', '--prune-empty=always', '--prune-empty=auto', '--prune-empty=never', '--prune-degenerate=always', '--prune-degenerate=auto', '--prune-degenerate=never', '--no-ff', '--filename-callback=', '--file-info-callback=', '--message-callback=', '--name-callback=', '--email-callback=', '--refname-callback=', '--blob-callback=', '--commit-callback=', '--tag-callback=', '--reset-callback=', '--sensitive-data-removal', '--sdr', '--no-fetch', '--source=', '--target=', '--date-order', '--help', '-h', '--version', '--proceed', '--force', '-f', '--partial', '--no-gc', '--refs=', '--dry-run', '--debug', '--stdin', '--quiet'
          break
        }
        break
      }
    }).Where{ $_ -like "$wordToComplete*" }
}
