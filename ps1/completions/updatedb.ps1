Register-ArgumentCompleter -Native -CommandName updatedb -ScriptBlock {
  param ([string]$wordToComplete, [System.Management.Automation.Language.CommandAst]$commandAst, [int]$cursorPosition)
  @(if ($wordToComplete.StartsWith('-')) {
      '-f', '--add-prunefs=btrfs', '--add-prunefs=ext4', '--add-prunefs=vfat', '--add-prunefs=xfs', '-n', '--add-prunenames=', '-e', '--add-prunepaths=', '--add-single-prunepath=', '-U', '--database-root=', '-h', '--help', '-o', '--output=', '-b', '--block-size=', '--prune-bind-mounts=no', '--prune-bind-mounts=yes', '--prunefs=btrfs', '--prunefs=ext4', '--prunefs=vfat', '--prunefs=xfs', '--prunenames=', '--prunepaths=', '-l', '--require-visibility=yes', '--require-visibility=no', '-v', '--verbose', '-V', '--version'
    }).Where{ $_ -like "$wordToComplete*" }
}
