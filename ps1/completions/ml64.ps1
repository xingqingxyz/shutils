using namespace System.Management.Automation.Language

Register-ArgumentCompleter -Native -CommandName ml64 -ScriptBlock {
  param ([string]$wordToComplete, [CommandAst]$commandAst, [int]$cursorPosition)
  $foundLink = $false
  foreach ($i in ($commandAst.CommandElements | Select-Object -Skip 1)) {
    if ($i.Extent.EndOffset -ge $cursorPosition) {
      break
    }
    if ($i -is [StringConstantExpressionAst] -and $i.Value -eq '/link') {
      $foundLink = $true
      break
    }
  }
  if ($foundLink) {
    return & (Get-ArgumentCompleter link) $wordToComplete $commandAst $cursorPosition
  }
  @(if ($wordToComplete.StartsWith('/')) {
      '/Bl', '/Sf', '/c', '/Sl', '/Cp', '/Sn', '/Cx', '/Sp', '/D', '/Ss', '/EP', '/St', '/F', '/Sx', '/Fe', '/Ta', '/Fl', '/w', '/Fm', '/WX', '/Fo', '/W', '/Fr', '/X', '/FR', '/Zd', '/I', '/Zf', '/link', '/Zi', '/nologo', '/Zp', '/Sa', '/Zs', '/ZH:MD5', '/ZH:SHA_256', '/Gy', '/quiet', '/Gy-', '/quiet', '/errorReport:none', '/errorReport:prompt', '/errorReport:queue', '/errorReport:send'
    }).Where{ $_ -like "$wordToComplete*" }
}
