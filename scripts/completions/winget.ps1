$Local:word = $wordToComplete.Replace('"', '""')
$Local:ast = $commandAst.ToString().Replace('"', '""')
winget.exe complete --word="$Local:word" --commandline "$Local:ast" --position $cursorPosition | ForEach-Object {
  [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', $_)
}
