using namespace System.Management.Automation
using namespace System.Management.Automation.Language

Register-ArgumentCompleter -Native -CommandName glow, gh, vhs, oh-my-posh -ScriptBlock {
  & $PSScriptRoot/cobra.ps1 @args
}

Register-ArgumentCompleter -Native -CommandName (Get-Item $PSScriptRoot/completions/*.ps1).BaseName -ScriptBlock {
  param([string]$wordToComplete, [CommandAst]$commandAst, [int]$cursorPosition)
  $name = $commandAst.CommandElements[0].Extent.Text.Split('.', 2)[0]
  & "$PSScriptRoot/completions/$name.ps1" @args
}

# winget packages completions
fd --search-path $HOME\AppData\Local\Microsoft\WinGet\Packages -g *.ps1 | Out-String | Invoke-Expression -ErrorAction Ignore
@(
  'rustup completions powershell',
  'volta completions powershell',
  ‘delta --generate-completion powershell'
) | ForEach-Object { Invoke-Expression $_ -ErrorAction Ignore | Out-String | Invoke-Expression }
