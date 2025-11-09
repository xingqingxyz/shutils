using namespace System.Management.Automation.Language

Register-ArgumentCompleter -Native -CommandName MSBuild -ScriptBlock {
  param ([string]$wordToComplete, [CommandAst]$commandAst, [int]$cursorPosition)
  $cursorPosition -= $wordToComplete.Length
  foreach ($i in $commandAst.CommandElements) {
    if ($i.Extent.StartOffset -ge $cursorPosition) {
      break
    }
    $prev = $i
  }
  $prev = $prev -is [System.Management.Automation.Language.StringConstantExpressionAst] ? $prev.Value : $prev.ToString()

  @(switch ($prev) {
      default {
        if ($wordToComplete.StartsWith('-')) {
          '-target:Resources', '-target:Compile', '-p:', '-property:', '-property:WarningLevel=2', '-l:', '-logger:', '-logger:XMLLogger', '-logger:OutputAsHTML', '-dl', '-distributedLogger:', '-distributedLogger:XMLLogger', '-distributedLogger:OutputAsHTML', '-verbosity:', '-verbosity:quiet', '-verbosity:minimal', '-verbosity:normal', '-verbosity:detailed', '-verbosity:diagnostic', '-val:', '-validate', '-validate:', '-clp:', '-consoleLoggerParameters:', '-consoleLoggerParameters:PerformanceSummary', '-consoleLoggerParameters:Summary', '-consoleLoggerParameters:NoSummary', '-consoleLoggerParameters:ErrorsOnly', '-consoleLoggerParameters:WarningsOnly', '-consoleLoggerParameters:NoItemAndPropertyList', '-consoleLoggerParameters:ShowCommandLine', '-consoleLoggerParameters:ShowTimestamp', '-consoleLoggerParameters:ShowEventId', '-consoleLoggerParameters:ForceNoAlign', '-consoleLoggerParameters:DisableConsoleColor', '-consoleLoggerParameters:EnableMPLogging', '-consoleLoggerParameters:ForceConsoleColor', '-consoleLoggerParameters:ForceConsoleColor', '-m:', '-maxCpuCount:', '-maxCpuCount:1', '-ignore:', '-ignoreprojectextensions:', '-ignoreprojectextensions:.sln', '-toolsversion:', '-toolsversion:3.5', '-fileloggerparameters1:', '-fileloggerparameters1:LogFile', '-fileloggerparameters1:Append', '-fileloggerparameters1:Encoding', '-tl:', '-terminalLogger:auto', '-terminalLogger:on', '-terminalLogger:off', '-tlp:', '-terminalLoggerParameters:on', '-terminalLoggerParameters:off', '-terminalLoggerParameters:auto', '-nodeReuse:True', '-nodeReuse:False', '-pp:', '-preprocess', '-ts:', '-targets:', '-warnAsError:', '-warnNotAsError:', '-warnAsMessage:', '-bl:', '-binaryLogger:', '-binaryLogger:ProjectImports=None', '-binaryLogger:ProjectImports=Embed', '-binaryLogger:ProjectImports=ZipFile', '-check', '-r:', '-restore:True', '-restore:False', '-profileEvaluation:', '-rp:', '-restoreProperty:', '-restoreProperty:IsRestore=true', '-interactive:True', '-interactive:False', '-isolate:', '-isolateProjects:True', '-isolateProjects:MessageUponIsolationViolation', '-isolateProjects:False', '-graph:', '-graphBuild:True', '-graphBuild:False', '-irc:', '-inputResultsCaches:', '-orc:', '-outputResultsCache:', '-reportFileAccesses:True', '-reportFileAccesses:False', '-low:', '-lowPriority:True', '-lowPriority:False', '-q', '-question', '-ds:', '-detailedSummary', '-getProperty:', '-getItem:', '-getTargetResult:', '-getResultOutputFile:', '-fa:', '-featureAvailability:Undefined', '-featureAvailability:Available', '-featureAvailability:NotAvailable', '-featureAvailability:Preview', '-mt:', '-multithreaded', '-?', '-h', '-help', '-ver', '-version', '-noLogo', '-noAutoRsp', '-noAutoResponse', '-noConLog', '-noConsoleLogger', '-fl1', '-fl9', '-fileLogger1', '-fileLogger9', '-distributedFileLogger'
          break
        }
        break
      }
    }).Where{ $_ -like "$wordToComplete*" }
}
