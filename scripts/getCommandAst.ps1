using namespace System.Management.Automation
using namespace System.Management.Automation.Language

param(
  [Parameter(Mandatory, Position = 1, ValueFromPipeline)]
  [string]
  $InputObject
)
$tuple = [CommandCompletion]::MapStringInputToParsedInput($InputObject, $InputObject.Length)
$tuple.Item1.EndBlock.Statements[0].PipelineElements[0]
