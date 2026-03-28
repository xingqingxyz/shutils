using namespace System.Management.Automation.Language

Register-ArgumentCompleter -Native -CommandName dconf -ScriptBlock {
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
  @(switch -CaseSensitive -Regex ($command) {
      '^(|help)$' {
        if ($wordToComplete.StartsWith('-')) {
          break
        }
        'help', 'read', 'list', 'list-locks', 'write', 'reset', 'compile', 'update', 'watch', 'dump', 'load', 'blame'
        break
      }
      '^(list|list-locks|dump|load)$' {
        if ($wordToComplete.StartsWith('-')) {
          break
        }
        dconf _complete '/' $wordToComplete
        break
      }
      '^(read|write|lock|unlock|watch|reset)$' {
        if ($wordToComplete.StartsWith('-')) {
          break
        }
        dconf _complete '' $wordToComplete
        break
      }
    }).Where{ $_ -like "$wordToComplete*" }
}
