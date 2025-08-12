Register-ArgumentCompleter -Native -CommandName man -ScriptBlock {
  param([string]$wordToComplete)
  if ($wordToComplete.StartsWith('-')) {
    return @('-C', '--config-file=', '-d', '--debug', '-D', '--default', '--warnings', '--warnings=', '-f', '--whatis', '-k', '--apropos', '-K', '--global-apropos', '-l', '--local-file', '-w', '--where', '--path', '--location', '-W', '--where-cat', '--location-cat', '-c', '--catman', '-R', '--recode=', '-L', '--locale=', '-m', '--systems=', '-M', '--manpath=', '-S', '-s', '--sections=', '-e', '--extension=', '-i', '--ignore-case', '-I', '--match-case', '--regex', '--wildcard', '--names-only', '-a', '--all', '-u', '--update', '--no-subpages', '-P', '--pager=/usr/bin/cat', '--pager=/usr/bin/less', '-r', '--prompt=', '-7', '--ascii', '-E', '--encoding=utf8', '--encoding=utf16', '--encoding=utf32', '--encoding=ascii', '--no-hyphenation', '--nh', '--no-justification', '--nj', '-p', '--preprocessor=eqn', '--preprocessor=pic', '--preprocessor=tbl', '--preprocessor=grap', '--preprocessor=refer', '--preprocessor=vgrind', '-t', '--troff', '-T', '--troff-device', '--troff-device=', '-H', '--html', '-H', '--html=', '-X', '--gxditview=', '-X', '--gxditview=', '-Z', '--ditroff', '-?', '--help', '--usage', '-V', '--version').Where{ $_ -like "$wordToComplete*" }
  }
  man -k . | ForEach-Object {
    $v = $_.Split(' ', 2)[0]
    if ($v -like "$wordToComplete*") {
      $v
    }
  }
}
