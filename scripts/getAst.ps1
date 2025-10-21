using namespace System.Management.Automation.Language

param (
  [Parameter(Position = 0)]
  [string]
  $ScriptInput,
  [Parameter()]
  [string]
  $LiteralPath
)
[Token[]]$tokens = $null
[ParseError[]]$pe = $null
$ast = if ($LiteralPath) {
  [Parser]::ParseFile($LiteralPath, [ref]$tokens, [ref]$pe)
}
else {
  [Parser]::ParseInput($ScriptInput, [ref]$tokens, [ref]$pe)
}
$ast
