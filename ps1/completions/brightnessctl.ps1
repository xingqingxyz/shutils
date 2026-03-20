using namespace System.Management.Automation.Language

Register-ArgumentCompleter -Native -CommandName brightnessctl -ScriptBlock {
  param ([string]$wordToComplete, [System.Management.Automation.Language.CommandAst]$commandAst, [int]$cursorPosition)
  $command = @(foreach ($i in $commandAst.CommandElements) {
      if ($i.Extent.StartOffset -eq $commandAst.Extent.StartOffset -or $i.Extent.EndOffset -eq $cursorPosition) {
        continue
      }
      if ($i -isnot [StringConstantExpressionAst] -or
        $i.StringConstantType -ne [StringConstantType]::BareWord -or
        $i.Value.StartsWith('-')) {
        break
      }
      $i.Value
    }) -join ' '
  @(if ($wordToComplete.StartsWith('-')) {
      '-l', '--list', '-q', '--quiet', '-p', '--pretend', '-m', '--machine-readable', '-P', '--percentage', '-n', '--min-value=1', '--min-value=10', '-e', '--exponent', '--exponent=', '-s', '--save', '-r', '--restore', '-h', '--help', '-d', '--device=', '--device=*', '-c', '--class=', '-V', '--version'
    }
    elseif (!$command) {
      'i', 'info', 'g', 'get', 'm', 'max', 's', 'set'
    }).Where{ $_ -like "$wordToComplete*" }
}
