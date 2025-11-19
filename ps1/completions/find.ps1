Register-ArgumentCompleter -Native -CommandName find -ScriptBlock {
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
      '-D' {
        'exec', 'opt', 'rates', 'search', 'stat', 'time', 'tree', 'all', 'help'
        break
      }
      default {
        if ($wordToComplete.StartsWith('-')) {
          '-H', '-L', '-P', '-O1', '-O2', '-O3', '-D', '-not', '-and', '-or', '-daystart', '-follow', '-nowarn', '-regextype', '-warn', '-depth', '-files0-from', '-maxdepth', '-mindepth', '-mount', '-noleaf', '-xautofs', '-xdev', '-ignore_readdir_race', '-noignore_readdir_race', '-amin', '-anewer', '-atime', '-cmin', '-cnewer', '-context', '-ctime', '-empty', '-false', '-fstype', '-gid', '-group', '-ilname', '-iname', '-inum', '-iwholename', '-iregex', '-links', '-lname', '-mmin', '-mtime', '-name', '-newer', '-nouser', '-nogroup', '-path', '-perm', '-regex', '-readable', '-writable', '-executable', '-wholename', '-size', '-true', '-type', '-uid', '-used', '-user', '-xtype', '-delete', '-print0', '-printf', '-fprintf', '-print', '-fprint0', '-fprint', '-ls', '-fls', '-prune', '-quit', '-exec', '-exec', '-ok', '-execdir', '-execdir', '-okdir', '--help', '--version'
        }
        break
      }
    }).Where{ $_ -like "$wordToComplete*" }
}
