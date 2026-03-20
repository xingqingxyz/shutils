Register-ArgumentCompleter -Native -CommandName bluemoon -ScriptBlock {
  param ([string]$wordToComplete, [System.Management.Automation.Language.CommandAst]$commandAst, [int]$cursorPosition)
  @(if ($wordToComplete.StartsWith('-')) {
      '-A', '--bdaddr=', '-F', '--firmware=', '-C', '--check=', '-R', '--reset', '-B', '--coldboot', '-E', '--exception', '-i', '--index=', '-h', '--help'
    }).Where{ $_ -like "$wordToComplete*" }
}
