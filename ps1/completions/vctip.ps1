Register-ArgumentCompleter -Native -CommandName vctip -ScriptBlock {
  param ([string]$wordToComplete, [System.Management.Automation.Language.CommandAst]$commandAst, [int]$cursorPosition)
  @(if ($wordToComplete.StartsWith('-')) {
      '-upload:optout', '-upload:optin', '-upload:skip', '-unstable:mark', '-unstable:clear', '-unstable:info', '-timeout:', '-timeout:0', '-sendDiscreteEvents', '-agglimit:', '-aggtimeout:', '-trace'
    }).Where{ $_ -like "$wordToComplete*" }
}
