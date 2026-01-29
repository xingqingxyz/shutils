Register-ArgumentCompleter -Native -CommandName bscmake -ScriptBlock {
  param ([string]$wordToComplete, [System.Management.Automation.Language.CommandAst]$commandAst, [int]$cursorPosition)
  @(if ($wordToComplete.StartsWith('/')) {
      '/Es', '/Ei', '/Ei', '/Er', '/Er', '/El', '/Em', '/errorreport:none', '/errorreport:prompt', '/errorreport:queue', '/errorreport:send', '/Iu', '/S', '/S', '/o', '/n', '/v', '/nologo', '/?', '/help'
    }).Where{ $_ -like "$wordToComplete*" }
}
