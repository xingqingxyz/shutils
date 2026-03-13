Register-ArgumentCompleter -Native -CommandName microsoft-edge, microsoft-edge-stable, microsoft-edge-beta -ScriptBlock {
  param ([string]$wordToComplete, [System.Management.Automation.Language.CommandAst]$commandAst, [int]$cursorPosition)
  @(if ($wordToComplete.StartsWith('-')) {
      '--user-data-dir=', '--inprivate', '--new-window', '--proxy-server=', '--proxy-server=socks://', '--proxy-server=socks4://', '--proxy-server=socks5://', '--proxy-server=', '--no-proxy-server', '--proxy-auto-detect', '--proxy-pac-url=', '--password-store=basic', '--password-store=gnome', '--password-store=kwallet', '--version'
    }).Where{ $_ -like "$wordToComplete*" }
}
