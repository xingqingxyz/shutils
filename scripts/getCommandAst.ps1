using namespace System.Management.Automation.Language

param (
  [Parameter(Mandatory, Position = 1, ValueFromPipeline)]
  [string]
  $InputObject
)
[Token[]]$tokens = $null
[ParseError[]]$errors = $null
[ScriptBlockAst]$scriptBlockAst = [Parser]::ParseInput($InputObject, [ref]$tokens, [ref]$errors)
[PipelineAst]$pipeLineAst = $scriptBlockAst.EndBlock.Statements[0]
[CommandAst]$commandAst = $pipeLineAst.PipelineElements[0]
$commandAst
