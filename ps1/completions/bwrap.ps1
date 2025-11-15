Register-ArgumentCompleter -Native -CommandName bwrap -ScriptBlock {
  param ([string]$wordToComplete)
  @(if ($wordToComplete.StartsWith('-')) {
      '--help', '--version', '--args', '--argv0', '--level-prefix', '--unshare-all', '--share-net', '--unshare-user', '--unshare-user-try', '--unshare-ipc', '--unshare-pid', '--unshare-net', '--unshare-uts', '--unshare-cgroup', '--unshare-cgroup-try', '--userns', '--userns2', '--disable-userns', '--assert-userns-disabled', '--pidns', '--uid', '--gid', '--hostname', '--chdir', '--clearenv', '--setenv', '--unsetenv', '--lock-file', '--sync-fd', '--bind', '--bind-try', '--dev-bind', '--dev-bind-try', '--ro-bind', '--ro-bind-try', '--bind-fd', '--ro-bind-fd', '--remount-ro', '--overlay-src', '--overlay', '--tmp-overlay', '--ro-overlay', '--exec-label', '--file-label', '--proc', '--dev', '--tmpfs', '--mqueue', '--dir', '--file', '--bind-data', '--ro-bind-data', '--symlink', '--seccomp', '--add-seccomp-fd', '--block-fd', '--userns-block-fd', '--info-fd', '--json-status-fd', '--new-session', '--die-with-parent', '--as-pid-1', '--cap-add', '--cap-drop', '--perms', '--size', '--chmod'
    }).Where{ $_ -like "$wordToComplete*" }
}
