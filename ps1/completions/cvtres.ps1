Register-ArgumentCompleter -Native -CommandName cvtres -ScriptBlock {
  param ([string]$wordToComplete, [System.Management.Automation.Language.CommandAst]$commandAst, [int]$cursorPosition)
  @(if ($wordToComplete.StartsWith('/')) {
      '/DEFINE:', '/FOLDDUPS', '/MACHINE:ARM', '/MACHINE:ARM64', '/MACHINE:ARM64EC', '/MACHINE:ARM64X', '/MACHINE:EBC', '/MACHINE:IA64', '/MACHINE:X64', '/MACHINE:X86', '/NOLOGO', '/OUT:', '/READONLY', '/VERBOSE'
    }).Where{ $_ -like "$wordToComplete*" }
}
