using namespace System.Management.Automation.Language

Register-ArgumentCompleter -Native -CommandName MakeCert -ScriptBlock {
  param ([string]$wordToComplete, [CommandAst]$commandAst, [int]$cursorPosition)
  $cursorPosition -= $wordToComplete.Length
  foreach ($i in $commandAst.CommandElements) {
    if ($i.Extent.StartOffset -ge $cursorPosition) {
      break
    }
    $prev = $i
  }
  $prev = $prev -is [System.Management.Automation.Language.StringConstantExpressionAst] ? $prev.Value : $prev.ToString()

  @(switch ($prev) {
      '-a' { 'md5', 'sha1', 'sha256', 'sha384', 'sha512'; break }
      '-ir' { 'CurrentUser', 'LocalMachine'; break }
      '-iky' { 'signature', 'exchange', '1'; break }
      '-sky' { 'signature', 'exchange', '1'; break }
      '-cy' { 'end', 'authority'; break }
      '-len' { '2048', '512'; break }
      default {
        if ($wordToComplete.StartsWith('-')) {
          '-tbs', '-sc', '-sv', '-ic', '-ik', '-iv', '-is', '-ir', '-in', '-a', '-ip', '-iy', '-sp', '-sy', '-iky', '-sky', '-l', '-cy', '-b', '-m', '-e', '-h', '-len', '-r', '-nscp', '-crl', '-eku', '-?', '-!'
          break
        }
        break
      }
    }).Where{ $_ -like "$wordToComplete*" }
}
