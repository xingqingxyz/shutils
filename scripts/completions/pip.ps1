
param (
  [string]$wordToComplete,
  [System.Management.Automation.Language.CommandAst]$commandAst,
  [int]$cursorPosition
)
$env:COMP_WORDS = $commandAst.ToString()
$env:COMP_CWORD = $commandAst.CommandElements.Count - 1
$env:PIP_AUTO_COMPLETE = 1
  (pip) -split ' ' | ForEach-Object {
  [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', $_)
}
