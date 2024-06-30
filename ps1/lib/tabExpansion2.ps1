using namespace System.Management.Automation
using namespace System.Management.Automation.Language

if (!$__TabExpansion2) {
  $__TabExpansion2 = $function:TabExpansion2
}
function TabExpansion2 {
  param(
    [string]$inputScript,
    [int]$cursorColumn,
    [hashtable]$options,
    [Ast]$ast,
    [Token[]]$tokens,
    [IScriptPosition]$positionOfCursor
  )
  if ($null -ne $inputScript) {
    $cmd = $inputScript.Split(' ', 2)[0]
    $cmd, $inputScript >> test.log
    & $__TabExpansion2 -inputScript $inputScript -cursorColumn $cursorColumn -options $options
  }
  else {
    $cmd = $ast.ToString().Split(' ', 2)[0]
    $cmd, $ast.ToString() >> test.log
    & $__TabExpansion2 -ast $ast -tokens $tokens -positionOfCursor $positionOfCursor -options $options
  }
  if ($cmd -eq 'gh') {
    . $PSScriptRoot/lib/cobra.ps1 gh, glow, vhs, tstoy
  }
}
