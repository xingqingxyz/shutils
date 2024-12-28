Register-ArgumentCompleter -Native -CommandName 7z -ScriptBlock {
  param([string]$wordToComplete, [System.Management.Automation.Language.CommandAst]$commandAst, [int]$cursorPosition)

  @(if ($commandAst.CommandElements.Count -le 2) {
      @('a', 'b', 'd', 'e', 'h', 'i', 'l', 'rn', 't', 'u', 'x')
    }
    elseif ($wordToComplete.StartsWith('-')) {
      @('-ai', '-an', '-aoa', '-aos', '-aot', '-aou', '-ax', '-bb0', '-bb1', '-bb2', '-bb3', '-bd', '-bs', '-bse', '-bso', '-bsp', '-bt', '-i', '-m', '-mmt', '-mx', '-o', '-p', '-r', '-saa', '-sae', '-sas', '-sccDOS', '-sccUTF-8', '-sccWIN', '-scrc*', '-scrcCRC32', '-scrcCRC64', '-scrcSHA1', '-scrcSHA256', '-scrcXXH64', '-scsDOS', '-scsUTF-16BE', '-scsUTF-16LE', '-scsUTF-8', '-scsWIN', '-sdel', '-seml.', '-seml', '-sfx', '-si', '-slp', '-slt', '-snh', '-sni', '-snl', '-sns-', '-sns', '-so', '-spd', '-spe', '-spf', '-spf2', '-ssc-', '-ssc', '-sse', '-ssp', '-ssw', '-stl', '-stm', '-stx', '-t', '-u', '-v', '-w', '-x', '-y')
    }) | Where-Object { $_ -like "$wordToComplete*" }
}
