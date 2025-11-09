using namespace System.Management.Automation.Language

Register-ArgumentCompleter -Native -CommandName ninja -ScriptBlock {
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
      '-f' { 'build.ninja'; break }
      '-j' { '0', '34', '8', '32'; break }
      '-k' { '0', '1'; break }
      '-l' { '0', '24'; break }
      '-d' { 'stats', 'explain', 'keepdepfile', 'keeprsp', 'nostatcache'; break }
      '-t' { 'browse', 'msvc', 'clean', 'commands', 'inputs', 'deps', 'missingdeps', 'graph', 'query', 'targets', 'compdb', 'recompact', 'restat', 'rules', 'cleandead', 'wincodepage'; break }
      '-w' { 'phonycycle=err', 'phonycycle=warn'; break }
      default {
        if ($wordToComplete.StartsWith('-')) {
          '--version', '-v', '--verbose', '--quiet', '-C', '-f', '-j', '-k', '-l', '-n', '-d', '-t', '-w', '--help'
          break
        }
        break
      }
    }).Where{ $_ -like "$wordToComplete*" }
}
