_watchman() {
  mapfile -t COMPREPLY < <(compgen -W '-h --help --inetd -S --no-site-spawner -v --version -U --sockname
          --named-pipe-path -u --unix-listener-path -o --logfile --log-level --pidfile -p --persistent -n --no-save-state --statefile -j --json-command --output-encoding --server-encoding --pretty --no-pretty --no-spawn --no-local' -- "$2" || [ "$COMP_CWORD" = 1 ] \
    && compgen -W 'clock debug-ageout debug-contenthash debug-drop-privs debug-get-asserted-states debug-get-subscriptions debug-poison debug-recrawl debug-root-status debug-set-parallel-crawl debug-set-subscriptions-paused debug-show-cursors debug-status debug-symlink-target-cache debug-watcher-info debug-watcher-info-clear find flush-subscriptions get-config get-log get-pid get-sockname global-log-level list-capabilities log log-level query shutdown-server since state-enter state-leave subscribe trigger trigger-del trigger-list unsubscribe version watch watch-del watch-del-all watch-list watch-project' -- "$2")
}

complete -o default -F _watchman watchman
