Register-ArgumentCompleter -Native -CommandName dpkg -ScriptBlock {
  param ([string]$wordToComplete, [System.Management.Automation.Language.CommandAst]$commandAst, [int]$cursorPosition)
  $cursorPosition -= $wordToComplete.Length
  foreach ($i in $commandAst.CommandElements) {
    if ($i.Extent.StartOffset -ge $cursorPosition) {
      break
    }
    $prev = $i
  }
  $prev = $prev -is [System.Management.Automation.Language.StringConstantExpressionAst] ? $prev.Value : $prev.ToString()
  @(switch ($prev) {
      { $_ -ceq '--remove' -or $_ -ceq '--verify' } {
        grep -A 1 "Package: $wordToComplete" /var/lib/dpkg/status |
          grep -B 1 -Ee 'ok installed|half-installed|unpacked|half-configured' -Ee '^Essential: yes' |
          awk "/Package: $wordToComplete/ { print `$2 }"
        break
      }
      { $_ -ceq '--listfiles' -or $_ -ceq '--purge' } {
        grep -A 1 "Package: $wordToComplete" /var/lib/dpkg/status |
          grep -B 1 -Ee 'ok installed|half-installed|unpacked|half-configured|config-files' -Ee '^Essential: yes' |
          awk "/Package: $wordToComplete/ { print `$2 }"
        break
      }
      default {
        if ($wordToComplete.StartsWith('-')) {
          '--install', '--unpack', '--record-avail', '--contents', '--info', '--fsys-tarfile', '--field', '--control', '--extract', '--vextract', '--raw-extract', '--build', '--status', '--print-avail', '--list', '--show', '--search', '--remove', '--verify', '--listfiles', '--purge'
        }
        break
      }
    }).Where{ $_ -like "$wordToComplete*" }
}
