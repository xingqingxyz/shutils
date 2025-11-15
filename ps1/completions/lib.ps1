Register-ArgumentCompleter -Native -CommandName lib -ScriptBlock {
  param ([string]$wordToComplete, [System.Management.Automation.Language.CommandAst]$commandAst, [int]$cursorPosition)
  @(if ($wordToComplete.StartsWith('/')) {
      '/DEF', '/DEF:', '/ERRORREPORT:NONE', '/ERRORREPORT:PROMPT', '/ERRORREPORT:QUEUE', '/ERRORREPORT:SEND', '/EXPORT:', '/EXTRACT:', '/INCLUDE:', '/LIBPATH:', '/LINKREPRO:', '/LINKREPROFULLPATHRSP:', '/LINKREPROTARGET:', '/LIST', '/LIST:', '/LTCG', '/MACHINE:ARM64', '/MACHINE:ARM64X', '/MACHINE:EBC', '/MACHINE:X64', '/MACHINE:X86', '/NAME:', '/NODEFAULTLIB', '/NODEFAULTLIB:', '/NOLOGO', '/OUT:', '/REMOVE:', '/SUBSYSTEM:BOOT_APPLICATION', '/SUBSYSTEM:CONSOLE', '/SUBSYSTEM:EFI_APPLICATION', '/SUBSYSTEM:EFI_BOOT_SERVICE_DRIVER', '/SUBSYSTEM:EFI_ROM', '/SUBSYSTEM:EFI_RUNTIME_DRIVER', '/SUBSYSTEM:NATIVE', '/SUBSYSTEM:POSIX', '/SUBSYSTEM:WINDOWS', '/SUBSYSTEM:WINDOWSCE', '/VERBOSE', '/WX', '/WX:NO', '/WX:'
    }).Where{ $_ -like "$wordToComplete*" }
}
