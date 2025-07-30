Register-ArgumentCompleter -Native -CommandName yad -ScriptBlock {
  param([string]$wordToComplete, [System.Management.Automation.Language.CommandAst]$commandAst, [int]$cursorPosition)
  @(if ($wordToComplete.StartsWith('-')) {
      '--help', '--help-all', '--help-general', '--help-common', '--help-about', '--help-app', '--help-calendar', '--help-color', '--help-dnd', '--help-entry', '--help-file', '--help-font', '--help-form', '--help-icons', '--help-list', '--help-notebook', '--help-notification', '--help-paned', '--help-picture', '--help-print', '--help-progress', '--help-scale', '--help-text', '--help-source', '--help-filter', '--help-misc', '--help-gtk', '--rest=FILENAME', '--about', '--app', '--calendar', '--color', '--dnd', '--entry', '--file', '--font', '--form', '--icons', '--list', '--notebook', '--notification', '--paned', '--picture', '--print', '--progress', '--scale', '--text-info', '--display=DISPLAY'
    }).Where{ $_ -like "$wordToComplete*" }
}
