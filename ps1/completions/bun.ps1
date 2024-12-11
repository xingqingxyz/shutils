using namespace System.Management.Automation.Language

Register-ArgumentCompleter -Native -CommandName bun -ScriptBlock {
  param([string]$wordToComplete, [CommandAst]$commandAst, [int]$cursorPosition)
  $command = $commandAst.CommandElements | Select-Object -Skip 1 | ForEach-Object {
    if ($_ -isnot [StringConstantExpressionAst] -or
      $_.StringConstantType -ne [StringConstantType]::BareWord -or
      $_.Value.StartsWith('-')) {
      return
    }
    $_.Value
  } | Join-String -Separator ';'
  # $cursorPosition -= $wordToComplete.Length
  # foreach ($key in $commandAst.CommandElements) {
  #   if ($key.Extent.StartOffset -eq $cursorPosition) {
  #     break
  #   }
  #   $prev = $key
  # }
  @(switch ($command) {
      Default {
        if ($wordToComplete.StartsWith('-')) {
          @('-r', '--recursive')
        }
        else {
          @(('add', 'audit', 'cat-file', 'cat-index', 'exec', 'find-hash', 'i', 'import', 'install-test', 'install', 'it', 'licenses', 'link', 'list', 'ln', 'ls', 'outdated', 'pack', 'prune', 'publish', 'rb', 'rebuild', 'remove', 'rm', 'root', 'run', 'start', 'store', 't', 'test', 'unlink', 'up', 'update'))
        }
      }
    }) | Where-Object { $_ -like "$wordToComplete*" }
}
