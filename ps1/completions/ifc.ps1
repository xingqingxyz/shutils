Register-ArgumentCompleter -Native -CommandName ifc -ScriptBlock {
  param ([string]$wordToComplete, [System.Management.Automation.Language.CommandAst]$commandAst, [int]$cursorPosition)
  $i = $commandAst.CommandElements.Count
  if ($commandAst.CommandElements[$i - 1].Extent.EndOffset -ge $cursorPosition) {
    while (--$i) {
      if ($commandAst.CommandElements[$i].Extent.StartOffset -le $cursorPosition) {
        break
      }
    }
  }
  @(if ($i -eq 1) {
      'obj', 'embed', 'extract', 'locate'
    }).Where{ $_ -like "$wordToComplete*" }
}
