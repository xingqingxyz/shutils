using namespace System.Management.Automation.Language

Register-ArgumentCompleter -Native -CommandName git -ScriptBlock {
  param ([string]$wordToComplete, [CommandAst]$commandAst, [int]$cursorPosition)
  $commands = @()
  $prev = ''
  foreach ($el in ($commandAst.CommandElements | Select-Object -Skip 1)) {
    if ($el.Extent.EndOffset -ge $cursorPosition) {
      break
    }
    $text = if ($el -is [StringConstantExpressionAst]) {
      $el.Value
    }
    elseif ($el -is [CommandParameterAst]) {
      $el.ToString()
    }
    else {
      break
    }
    if ($text.StartsWith('-')) {
      if ($commands.Count -eq 0) {
        $prev = $text
        continue
      }
      break
    }
    if ($commands.Count -eq 0 -and $prev -cmatch '^-[^-]') {
      $prev = $text
      continue
    }
    $prev = $text
    $commands += $text
  }
  $externalCommands = Get-Command -Type Application git-* | ForEach-Object { $_.Name.split('-', 2)[1].split('.')[0] }

  if ($externalCommands.Contains($commands[0])) {
    $astList = $commandAst.CommandElements | Select-Object -Skip 2
    $commandName = 'git-' + $commands[0]
    $cursorPosition = $cursorPosition - $astList[0].Extent.StartOffset + $commandName.Length + 1
    $commandAst = [Parser]::ParseInput("$commandName $astList", [ref]$null, [ref]$null).EndBlock.Statements[0].PipelineElements[0]
    return & (Get-ArgumentCompleter $commandName) $wordToComplete $commandAst $cursorPosition
  }

  $command = $commands -join ' '
  @(switch ($command) {
      '' {
        if ($wordToComplete.StartsWith('-')) {
          '-v', '--version', '-h', '--help', '-C', '-c', '--exec-path=', '--html-path', '--man-path', '--info-path', '-p', '--paginate', '-P', '--no-pager', '--no-replace-objects', '--no-lazy-fetch', '--no-optional-locks', '--no-advice', '--bare', '--git-dir=', '--work-tree=', '--namespace=', '--config-env='
          break
        }
        'add', 'am', 'archive', 'bisect', 'branch', 'bundle', 'checkout', 'cherry-pick', 'citool', 'clean', 'clone', 'commit', 'describe', 'diff', 'fetch', 'format-patch', 'gc', 'gitk', 'grep', 'gui', 'init', 'log', 'maintenance', 'merge', 'mv', 'notes', 'pull', 'push', 'range-diff', 'rebase', 'reset', 'restore', 'revert', 'rm', 'shortlog', 'show', 'sparse-checkout', 'stash', 'status', 'submodule', 'subtree', 'switch', 'tag', 'worktree', 'config', 'fast-export', 'fast-import', 'filter-branch', 'mergetool', 'pack-refs', 'prune', 'reflog', 'refs', 'remote', 'repack', 'replace', 'annotate', 'blame', 'bugreport', 'count-objects', 'diagnose', 'difftool', 'fsck', 'gitweb', 'help', 'instaweb', 'merge-tree', 'rerere', 'show-branch', 'verify-commit', 'verify-tag', 'version', 'whatchanged', 'archimport', 'cvsexportcommit', 'cvsimport', 'cvsserver', 'imap-send', 'p4', 'quiltimport', 'request-pull', 'send-email', 'svn', 'apply', 'checkout-index', 'commit-graph', 'commit-tree', 'hash-object', 'index-pack', 'merge-file', 'merge-index', 'mktag', 'mktree', 'multi-pack-index', 'pack-objects', 'prune-packed', 'read-tree', 'replay', 'symbolic-ref', 'unpack-objects', 'update-index', 'update-ref', 'write-tree', 'cat-file', 'cherry', 'diff-files', 'diff-index', 'diff-tree', 'for-each-ref', 'for-each-repo', 'get-tar-commit-id', 'ls-files', 'ls-remote', 'ls-tree', 'merge-base', 'name-rev', 'pack-redundant', 'rev-list', 'rev-parse', 'show-index', 'show-ref', 'unpack-file', 'var', 'verify-pack', 'daemon', 'fetch-pack', 'http-backend', 'send-pack', 'update-server-info', 'check-attr', 'check-ignore', 'check-mailmap', 'check-ref-format', 'column', 'credential', 'credential-cache', 'credential-store', 'fmt-merge-msg', 'hook', 'interpret-trailers', 'mailinfo', 'mailsplit', 'merge-one-file', 'patch-id', 'sh-i18n', 'sh-setup', 'stripspace', 'attributes', 'cli', 'hooks', 'ignore', 'mailmap', 'modules', 'repository-layout'
        $externalCommands
        break
      }
      'help' {
        if ($wordToComplete.StartsWith('-')) {
          break
        }
        'add', 'am', 'archive', 'bisect', 'branch', 'bundle', 'checkout', 'cherry-pick', 'citool', 'clean', 'clone', 'commit', 'describe', 'diff', 'fetch', 'format-patch', 'gc', 'gitk', 'grep', 'gui', 'init', 'log', 'maintenance', 'merge', 'mv', 'notes', 'pull', 'push', 'range-diff', 'rebase', 'reset', 'restore', 'revert', 'rm', 'scalar', 'shortlog', 'show', 'sparse-checkout', 'stash', 'status', 'submodule', 'switch', 'tag', 'worktree', 'config', 'fast-export', 'fast-import', 'filter-branch', 'mergetool', 'pack-refs', 'prune', 'reflog', 'refs', 'remote', 'repack', 'replace', 'annotate', 'blame', 'bugreport', 'count-objects', 'diagnose', 'difftool', 'fsck', 'gitweb', 'help', 'instaweb', 'merge-tree', 'rerere', 'show-branch', 'verify-commit', 'verify-tag', 'version', 'whatchanged', 'archimport', 'cvsexportcommit', 'cvsimport', 'cvsserver', 'imap-send', 'p4', 'quiltimport', 'request-pull', 'send-email', 'svn', 'apply', 'checkout-index', 'commit-graph', 'commit-tree', 'hash-object', 'index-pack', 'merge-file', 'merge-index', 'mktag', 'mktree', 'multi-pack-index', 'pack-objects', 'prune-packed', 'read-tree', 'replay', 'symbolic-ref', 'unpack-objects', 'update-index', 'update-ref', 'write-tree', 'cat-file', 'cherry', 'diff-files', 'diff-index', 'diff-tree', 'for-each-ref', 'for-each-repo', 'get-tar-commit-id', 'ls-files', 'ls-remote', 'ls-tree', 'merge-base', 'name-rev', 'pack-redundant', 'rev-list', 'rev-parse', 'show-index', 'show-ref', 'unpack-file', 'var', 'verify-pack', 'daemon', 'fetch-pack', 'http-backend', 'send-pack', 'update-server-info', 'check-attr', 'check-ignore', 'check-mailmap', 'check-ref-format', 'column', 'credential', 'credential-cache', 'credential-store', 'fmt-merge-msg', 'hook', 'interpret-trailers', 'mailinfo', 'mailsplit', 'merge-one-file', 'patch-id', 'sh-i18n', 'sh-setup', 'stripspace', 'attributes', 'cli', 'hooks', 'ignore', 'mailmap', 'modules', 'repository-layout', 'revisions', 'format-bundle', 'format-chunk', 'format-commit-graph', 'format-index', 'format-pack', 'format-signature', 'protocol-capabilities', 'protocol-common', 'protocol-http', 'protocol-pack', 'protocol-v2', 'askpass', 'askyesno', 'credential-helper-selector', 'credential-manager', 'flow', 'lfs', 'update-git-for-windows', 'git-lfs-checkout(1)', 'git-lfs-completion(1)', 'git-lfs-dedup(1)', 'git-lfs-env(1)', 'git-lfs-ext(1)', 'git-lfs-fetch(1)', 'git-lfs-fsck(1)', 'git-lfs-install(1)', 'git-lfs-lock(1)', 'git-lfs-locks(1)', 'git-lfs-logs(1)', 'git-lfs-ls-files(1)', 'git-lfs-migrate(1)', 'git-lfs-prune(1)', 'git-lfs-pull(1)', 'git-lfs-push(1)', 'git-lfs-status(1)', 'git-lfs-track(1)', 'git-lfs-uninstall(1)', 'git-lfs-unlock(1)', 'git-lfs-untrack(1)', 'git-lfs-update(1)', 'git-lfs-version(1)'
        break
      }
      'add' {
        if ($wordToComplete.StartsWith('-')) {
          '-n', '--dry-run', '-v', '--verbose', '-f', '--force', '--sparse', '-i', '--interactive', '-p', '--patch', '-e', '--edit', '-u', '--update', '-A', '--all', '--no-ignore-removal', '--no-all', '--ignore-removal', '-N', '--intent-to-add', '--refresh', '--ignore-errors', '--ignore-missing', '--no-warn-embedded-repo', '--renormalize', '--chmod=+x', '--chmod=-x', '--pathspec-from-file=', '--pathspec-file-nul'
          break
        }
        break
      }
      'am' {
        if ($wordToComplete.StartsWith('-')) {
          '-s', '--signoff', '-k', '--keep', '--keep-non-patch', '--keep-cr', '--no-keep-cr', '-c', '--scissors', '--no-scissors', '--quoted-cr=', '--empty=drop', '--empty=keep', '--empty=stop', '-m', '--message-id', '--no-message-id', '-q', '--quiet', '-u', '--utf8', '--no-utf8', '-3', '--3way', '--no-3way', '--rerere-autoupdate', '--no-rerere-autoupdate', '--ignore-space-change', '--ignore-whitespace', '--whitespace=', '-C', '-p', '--directory=', '--exclude=', '--include=', '--reject', '--patch-format', '-i', '--interactive', '-n', '--no-verify', '--committer-date-is-author-date', '--ignore-date', '--skip', '-S', '--gpg-sign', '--gpg-sign=', '--no-gpg-sign', '--continue', '-r', '--resolved', '--resolvemsg=', '--abort', '--quit', '--retry', '--show-current-patch', '--show-current-patch=diff', '--show-current-patch=raw', '--allow-empty'
          break
        }
        break
      }
      'archive' {
        if ($wordToComplete.StartsWith('-')) {
          '--format=', '-l', '--list', '-v', '--verbose', '--prefix=/', '-o', '--output=', '--add-file=', '--add-virtual-file=:', '--worktree-attributes', '--mtime=', '--remote=', '--exec='
          break
        }
        break
      }
      'bisect' {
        if ($wordToComplete.StartsWith('-')) {
          '--no-checkout', '--first-parent'
          break
        }
        break
      }
      'branch' {
        if ($wordToComplete.StartsWith('-')) {
          '-d', '--delete', '-D', '--create-reflog', '-f', '--force', '-m', '--move', '-M', '-c', '--copy', '-C', '--color', '--color=', '--no-color', '-i', '--ignore-case', '--omit-empty', '--column', '--column=', '--no-column', '-r', '--remotes', '-a', '--all', '-l', '--list', '--show-current', '-v', '-vv', '--verbose', '-q', '--quiet', '--abbrev=', '--no-abbrev', '-t', '--track', '--track=direct', '--track=inherit', '--no-track', '--recurse-submodules', '--set-upstream', '-u', '--set-upstream-to=', '--unset-upstream', '--edit-description', '--contains', '--no-contains', '--merged', '--no-merged', '--sort=', '--points-at', '--format'
          break
        }
        break
      }
      'bundle' {
        if ($wordToComplete.StartsWith('-')) {
          '--progress', '--version=', '-q', '--quiet'
          break
        }
        'create', 'verify', 'list-heads', 'unbundle'
        break
      }
      'checkout' {
        if ($wordToComplete.StartsWith('-')) {
          '-q', '--quiet', '--progress', '--no-progress', '-f', '--force', '--ours', '--theirs', '-b', '-B', '-t', '--track', '--track=direct', '--track=inherit', '--no-track', '--guess', '--no-guess', '-l', '-d', '--detach', '--orphan', '--ignore-skip-worktree-bits', '-m', '--merge', '--conflict=', '-p', '--patch', '--ignore-other-worktrees', '--overwrite-ignore', '--no-overwrite-ignore', '--recurse-submodules', '--no-recurse-submodules', '--overlay', '--no-overlay', '--pathspec-from-file=', '--pathspec-file-nul'
          break
        }
        break
      }
      'cherry-pick' {
        if ($wordToComplete.StartsWith('-')) {
          '-e', '--edit', '--cleanup=', '-x', '-r', '-m', '--mainline', '-n', '--no-commit', '-s', '--signoff', '-S', '--gpg-sign', '--gpg-sign=', '--no-gpg-sign', '--ff', '--allow-empty', '--allow-empty-message', '--empty=drop', '--empty=keep', '--empty=stop', '--keep-redundant-commits', '--strategy=', '-X', '--strategy-option=', '--rerere-autoupdate', '--no-rerere-autoupdate'
          break
        }
        break
      }
      'clean' {
        if ($wordToComplete.StartsWith('-')) {
          '-d', '-f', '--force', '-i', '--interactive', '-n', '--dry-run', '-q', '--quiet', '-e', '--exclude=', '-x', '-X'
          break
        }
        break
      }
      'clone' {
        if ($wordToComplete.StartsWith('-')) {
          '-l', '--local', '--no-hardlinks', '-s', '--shared', '--reference[-if-able]', '--dissociate', '-q', '--quiet', '-v', '--verbose', '--progress', '--server-option=', '-n', '--no-checkout', '--reject-shallow', '--no-reject-shallow', '--bare', '--sparse', '--filter=', '--also-filter-submodules', '--mirror', '-o', '--origin', '-b', '--branch', '-u', '--upload-pack', '--template=', '-c', '--config', '--depth', '--shallow-since=', '--shallow-exclude=', '--single-branch', '--no-single-branch', '--no-tags', '--recurse-submodules', '--recurse-submodules=', '--shallow-submodules', '--no-shallow-submodules', '--remote-submodules', '--no-remote-submodules', '--separate-git-dir=', '--ref-format=', '-j', '--jobs', '--bundle-uri='
          break
        }
        break
      }
      'commit' {
        if ($wordToComplete.StartsWith('-')) {
          '-a', '--all', '-p', '--patch', '-C', '--reuse-message', '-c', '--reedit-message', '--fixup', '--squash', '--reset-author', '--short', '--branch', '--porcelain', '--long', '-z', '--null', '-F', '--file', '--author', '--date', '-m', '--message', '-t', '--template', '-s', '--signoff', '--no-signoff', '--trailer', '-n', '--verify', '--no-verify', '--allow-empty', '--allow-empty-message', '--cleanup', '-e', '--edit', '--no-edit', '--amend', '--no-post-rewrite', '-i', '--include', '-o', '--only', '--pathspec-from-file', '--pathspec-file-nul', '-u', '--untracked-files', '-v', '--verbose', '-q', '--quiet', '--dry-run', '--status', '--no-status', '-S', '--gpg-sign', '--no-gpg-sign'
          break
        }
        break
      }
      'describe' {
        if ($wordToComplete.StartsWith('-')) {
          '--dirty', '--dirty=', '--broken', '--broken=', '--all', '--tags', '--contains', '--abbrev=', '--candidates=', '--exact-match', '--debug', '--long', '--match', '--exclude', '--always', '--first-parent'
          break
        }
        break
      }
      'diff' {
        if ($wordToComplete.StartsWith('-')) {
          '-p', '-u', '--patch', '-s', '--no-patch', '-U', '--unified=', '--output=', '--output-indicator-new=', '--output-indicator-old=', '--output-indicator-context=', '--raw', '--patch-with-raw', '--indent-heuristic', '--no-indent-heuristic', '--minimal', '--patience', '--histogram', '--anchored=', '--diff-algorithm=patience', '--diff-algorithm=minimal', '--diff-algorithm=histogram', '--diff-algorithm=myers', '--stat', '--stat=', '--compact-summary', '--numstat', '--shortstat', '-X', '--dirstat', '--dirstat=', '--cumulative', '--dirstat-by-file', '--dirstat-by-file=', '--summary', '--patch-with-stat', '-z', '--name-only', '--name-status', '--submodule', '--submodule=', '--color', '--color=', '--no-color', '--color-moved', '--color-moved=', '--no-color-moved', '--color-moved-ws=', '--no-color-moved-ws', '--word-diff', '--word-diff=', '--word-diff-regex=', '--color-words', '--color-words=', '--no-renames', '--rename-empty', '--no-rename-empty', '--check', '--ws-error-highlight=', '--full-index', '--binary', '--abbrev', '--abbrev=', '-B', '--break-rewrites', '--break-rewrites=', '-M', '--find-renames', '--find-renames=', '-C', '--find-copies', '--find-copies=', '--find-copies-harder', '-D', '--irreversible-delete', '-l', '--diff-filter=', '-S', '-G', '--find-object=', '--pickaxe-all', '--pickaxe-regex', '-O', '--skip-to=', '--rotate-to=', '-R', '--relative', '--relative=', '--no-relative', '-a', '--text', '--ignore-cr-at-eol', '--ignore-space-at-eol', '-b', '--ignore-space-change', '-w', '--ignore-all-space', '--ignore-blank-lines', '-I', '--ignore-matching-lines=', '--inter-hunk-context=', '-W', '--function-context', '--exit-code', '--quiet', '--ext-diff', '--no-ext-diff', '--textconv', '--no-textconv', '--ignore-submodules', '--ignore-submodules=', '--src-prefix=', '--dst-prefix=', '--no-prefix', '--default-prefix', '--line-prefix=', '--ita-invisible-in-index'
          break
        }
        break
      }
      'fetch' {
        if ($wordToComplete.StartsWith('-')) {
          '--all', '--no-all', '-a', '--append', '--atomic', '--depth=', '--deepen=', '--shallow-since=', '--shallow-exclude=', '--unshallow', '--update-shallow', '--negotiation-tip=', '--negotiate-only', '--dry-run', '--porcelain', '--write-fetch-head', '--no-write-fetch-head', '-f', '--force', '-k', '--keep', '--multiple', '--auto-maintenance', '--no-auto-maintenance', '--auto-gc', '--no-auto-gc', '--write-commit-graph', '--no-write-commit-graph', '--prefetch', '-p', '--prune', '-P', '--prune-tags', '-n', '--no-tags', '--refetch', '--refmap=', '-t', '--tags', '--recurse-submodules=yes', '--recurse-submodules=on-demand', '--recurse-submodules=no', '-j', '--jobs=', '--no-recurse-submodules', '--set-upstream', '--submodule-prefix=', '--recurse-submodules-default=yes', '--recurse-submodules-default=on-demand', '-u', '--update-head-ok', '--upload-pack', '-q', '--quiet', '-v', '--verbose', '--progress', '-o', '--server-option=', '--show-forced-updates', '--no-show-forced-updates', '-4', '--ipv4', '-6', '--ipv6', '--stdin'
          break
        }
        break
      }
      'format-patch' {
        if ($wordToComplete.StartsWith('-')) {
          '-p', '--no-stat', '-U', '--unified=', '--output=', '--output-indicator-new=', '--output-indicator-old=', '--output-indicator-context=', '--indent-heuristic', '--no-indent-heuristic', '--minimal', '--patience', '--histogram', '--anchored=', '--diff-algorithm=patience', '--diff-algorithm=minimal', '--diff-algorithm=histogram', '--diff-algorithm=myers', '--stat', '--stat=', '--compact-summary', '--numstat', '--shortstat', '-X', '--dirstat', '--dirstat=', '--cumulative', '--dirstat-by-file', '--dirstat-by-file=', '--summary', '--no-renames', '--rename-empty', '--no-rename-empty', '--full-index', '--binary', '--abbrev', '--abbrev=', '-B', '--break-rewrites', '--break-rewrites=', '-M', '--find-renames', '--find-renames=', '-C', '--find-copies', '--find-copies=', '--find-copies-harder', '-D', '--irreversible-delete', '-l', '-O', '--skip-to=', '--rotate-to=', '--relative', '--relative=', '--no-relative', '-a', '--text', '--ignore-cr-at-eol', '--ignore-space-at-eol', '-b', '--ignore-space-change', '-w', '--ignore-all-space', '--ignore-blank-lines', '-I', '--ignore-matching-lines=', '--inter-hunk-context=', '-W', '--function-context', '--ext-diff', '--no-ext-diff', '--textconv', '--no-textconv', '--ignore-submodules', '--ignore-submodules=', '--src-prefix=', '--dst-prefix=', '--no-prefix', '--default-prefix', '--line-prefix=', '--ita-invisible-in-index'
          break
        }
        break
      }
      'gc' {
        if ($wordToComplete.StartsWith('-')) {
          '--aggressive', '--auto', '--detach', '--no-detach', '--cruft', '--no-cruft', '--max-cruft-size=', '--prune=', '--no-prune', '--quiet', '--force', '--keep-largest-pack'
          break
        }
        break
      }
      'grep' {
        if ($wordToComplete.StartsWith('-')) {
          '--cached', '--untracked', '--no-index', '--no-exclude-standard', '--exclude-standard', '--recurse-submodules', '-a', '--text', '--textconv', '--no-textconv', '-i', '--ignore-case', '-I', '--max-depth', '-r', '--recursive', '--no-recursive', '-w', '--word-regexp', '-v', '--invert-match', '-h', '-H', '--full-name', '-E', '--extended-regexp', '-G', '--basic-regexp', '-P', '--perl-regexp', '-F', '--fixed-strings', '-n', '--line-number', '--column', '-l', '--files-with-matches', '--name-only', '-L', '--files-without-match', '-O', '--open-files-in-pager', '--open-files-in-pager=', '-z', '--null', '-o', '--only-matching', '-c', '--count', '--color', '--color=', '--no-color', '--break', '--heading', '-p', '--show-function', '-', '-C', '--context', '-A', '--after-context', '-B', '--before-context', '-W', '--function-context', '-m', '--max-count', '--threads', '-f', '-e', '--and', '--or', '--not', '--all-match', '-q', '--quiet'
          break
        }
        break
      }
      'gui' {
        if ($wordToComplete.StartsWith('-')) {
          break
        }
        'blame', 'browser', 'citool', 'version'
        break
      }
      'init' {
        if ($wordToComplete.StartsWith('-')) {
          '-q', '--quiet', '--bare', '--object-format='
          break
        }
        break
      }
      'log' {
        if ($wordToComplete.StartsWith('-')) {
          '--follow', '--no-decorate', '--decorate', '--decorate=short', '--decorate=full', '--decorate=auto', '--decorate=no', '--decorate-refs=', '--decorate-refs-exclude=', '--clear-decorations', '--source', '--mailmap', '--no-mailmap', '--use-mailmap', '--no-use-mailmap', '--full-diff', '--log-size', '--pretty=oneline', '--pretty=short', '--pretty=medium', '--pretty=full', '--pretty=fuller', '--pretty=reference', '--pretty=email', '--pretty=mboxrd', '--pretty=raw', '--pretty=format:', '--pretty=tformat:', '--oneline', '-p', '--stat', '--shortstat', '--name-only', '--name-status', '--abbrev-commit', '--relative-date', '--graph', '--since=', '--until=', '--after=', '--before=', '--author=', '--committer=', '--grep=', '--no-merges', '-S'
          break
        }
        break
      }
      'maintanance' {
        if ($wordToComplete.StartsWith('-')) {
          '--auto', '--schedule', '--quiet', '--task=', '--scheduler=auto', '--scheduler=crontab', '--scheduler=systemd-timer', '--scheduler=launchctl', '--scheduler=schtasks'
          break
        }
        'run', 'start', 'stop', 'register', 'unregister'
        break
      }
      'merge' {
        if ($wordToComplete.StartsWith('-')) {
          '--commit', '--no-commit', '--edit', '-e', '--no-edit', '--cleanup=', '--ff', '--no-ff', '--ff-only', '-S', '--gpg-sign', '--gpg-sign=', '--no-gpg-sign', '--log', '--log=', '--no-log', '--signoff', '--no-signoff', '--stat', '-n', '--no-stat', '--squash', '--no-squash', '--verify', '--no-verify', '-s', '--strategy=', '-X', '--strategy-option=', '--verify-signatures', '--no-verify-signatures', '--summary', '--no-summary', '-q', '--quiet', '-v', '--verbose', '--progress', '--no-progress', '--autostash', '--no-autostash', '--allow-unrelated-histories', '-m', '--into-name', '-F', '--file=', '--rerere-autoupdate', '--no-rerere-autoupdate', '--overwrite-ignore', '--no-overwrite-ignore', '--abort', '--quit', '--continue'
          break
        }
        break
      }
      'mv' {
        if ($wordToComplete.StartsWith('-')) {
          '-f', '--force', '-k', '-n', '--dry-run', '-v', '--verbose'
          break
        }
        break
      }
      'notes' {
        if ($wordToComplete.StartsWith('-')) {
          '-f', '--force', '-m', '--message=', '-F', '--file=', '-C', '--reuse-message=', '-c', '--reedit-message=', '--allow-empty', '--separator,', '--no-separator,', '--stripspace', '--no-stripspace', '--ref', '--ignore-missing', '--stdin', '-n', '--dry-run', '-s', '--strategy=', '--commit', '--abort', '-q', '--quiet', '-v', '--verbose'
          break
        }
        'list', 'add', 'copy', 'append', 'edit', 'show', 'merge', 'remove', 'prune', 'get-ref'
        break
      }
      'pull' {
        if ($wordToComplete.StartsWith('-')) {
          '-q', '--quiet', '-v', '--verbose', '--recurse-submodules', '--recurse-submodules=yes', '--recurse-submodules=on-demand', '--recurse-submodules=no', '--no-recurse-submodules'
          break
        }
        break
      }
      'push' {
        if ($wordToComplete.StartsWith('-')) {
          '--all', '--branches', '--prune', '--mirror', '-n', '--dry-run', '--porcelain', '-d', '--delete', '--tags', '--follow-tags', '--signed', '--no-signed', '--signed=true', '--signed=false', '--signed=if-asked', '--atomic', '--no-atomic', '-o', '--push-option=', '--receive-pack=', '--exec=', '--force-with-lease', '--no-force-with-lease', '--force-with-lease=', '--force-with-lease=:', '-f', '--force', '--force-if-includes', '--no-force-if-includes', '--repo=', '-u', '--set-upstream', '--thin', '--no-thin', '-q', '--quiet', '-v', '--verbose', '--progress', '--recurse-submodules', '--recurse-submodules=check', '--recurse-submodules=yes', '--recurse-submodules=on-demand', '--recurse-submodules=no', '--no-recurse-submodules', '--verify', '--no-verify', '-4', '--ipv4', '-6', '--ipv6'
          break
        }
        break
      }
      'range-diff' {
        if ($wordToComplete.StartsWith('-')) {
          '--no-dual-color', '--creation-factor=', '--left-only', '--right-only', '--notes', '--notes=', '--no-notes', '--no-notes='
          break
        }
        break
      }
      'rebase' {
        if ($wordToComplete.StartsWith('-')) {
          '--continue', '--skip', '--abort', '--quit', '--edit-todo', '--show-current-patch'
          break
        }
        break
      }
      'reset' {
        if ($wordToComplete.StartsWith('-')) {
          '-q', '--quiet', '--refresh', '--no-refresh', '--pathspec-from-file=', '--pathspec-file-nul', '--stdin', '-z'
          break
        }
        break
      }
      'restore' {
        if ($wordToComplete.StartsWith('-')) {
          '-s', '--source=', '-p', '--patch', '-W', '--worktree', '-S', '--staged', '-q', '--quiet', '--progress', '--no-progress', '--ours', '--theirs', '-m', '--merge', '--conflict=', '--ignore-unmerged', '--ignore-skip-worktree-bits', '--recurse-submodules', '--no-recurse-submodules', '--overlay', '--no-overlay', '--pathspec-from-file=', '--pathspec-file-nul'
          break
        }
        break
      }
      'revert' {
        if ($wordToComplete.StartsWith('-')) {
          '-e', '--edit', '-m', '--mainline', '--no-edit', '--cleanup=', '-n', '--no-commit', '-S', '--gpg-sign', '--gpg-sign=', '--no-gpg-sign', '-s', '--signoff', '--strategy=', '-X', '--strategy-option=', '--rerere-autoupdate', '--no-rerere-autoupdate', '--reference'
          break
        }
        break
      }
      'rm' {
        if ($wordToComplete.StartsWith('-')) {
          '-f', '--force', '-n', '--dry-run', '-r', '--cached', '--ignore-unmatch', '--sparse', '-q', '--quiet', '--pathspec-from-file=', '--pathspec-file-nul'
          break
        }
        break
      }
      'shortlog' {
        if ($wordToComplete.StartsWith('-')) {
          '-n', '--numbered', '-s', '--summary', '-e', '--email', '--format', '--format=', '--date=', '--group=', '-c', '--committer', '-w'
          break
        }
        break
      }
      'show' {
        if ($wordToComplete.StartsWith('-')) {
          '--pretty', '--pretty=', '--format=', '--abbrev-commit', '--no-abbrev-commit', '--oneline', '--encoding=', '--expand-tabs=', '--expand-tabs', '--no-expand-tabs', '--notes', '--notes=', '--no-notes', '--show-notes-by-default', '--show-notes', '--show-notes=', '--standard-notes', '--no-standard-notes', '--show-signature'
          break
        }
        break
      }
      'sparse-checkout' {
        if ($wordToComplete.StartsWith('-')) {
          break
        }
        'list', 'set', 'add', 'reapply', 'disable', 'init', 'check-rules'
        break
      }
      'stash' {
        if ($wordToComplete.StartsWith('-')) {
          '-a', '--all', '-u', '--include-untracked', '--no-include-untracked', '--only-untracked', '--index', '-k', '--keep-index', '--no-keep-index', '-p', '--patch', '-S', '--staged', '--pathspec-from-file=', '--pathspec-file-nul', '-q', '--quiet'
          break
        }
        'push', 'save', 'list', 'show', 'pop', 'apply', 'branch', 'clear', 'drop', 'create', 'store'
        break
      }
      'status' {
        if ($wordToComplete.StartsWith('-')) {
          '-s', '--short', '-b', '--branch', '--show-stash', '--porcelain', '--porcelain=', '--long', '-v', '--verbose', '-u', '--untracked-files', '--untracked-files=', '--ignore-submodules', '--ignore-submodules=', '--ignored', '--ignored=', '-z', '--column', '--column=', '--no-column', '--ahead-behind', '--no-ahead-behind', '--renames', '--no-renames', '--find-renames', '--find-renames='
          break
        }
        break
      }
      'submodule' {
        if ($wordToComplete.StartsWith('-')) {
          '-q', '--quiet', '--progress', '--all', '-b', '--branch', '-f', '--force', '--cached', '--files', '-n', '--summary-limit', '--remote', '-N', '--no-fetch', '--checkout', '--merge', '--rebase', '--init', '--name', '--reference', '--dissociate', '--recursive', '--depth', '--recommend-shallow', '--no-recommend-shallow', '-j', '--jobs', '--single-branch', '--no-single-branch'
          break
        }
        'add', 'status', 'init', 'deinit', 'update', 'set-branch', 'set-branch', 'set-url', 'summary', 'foreach', 'sync', 'absorbgitdirs'
        break
      }
      'subtree' {
        if ($wordToComplete.StartsWith('-')) {
          '-h', '--help', '-q', '--quiet', '-d', '--debug', '-P', '--prefix', '--no-prefix'
          break
        }
        'add', 'merge', 'split', 'pull', 'push'
        break
      }
      { $_ -ceq 'subtree split' -or $_ -ceq 'subtree push' } {
        if ($wordToComplete.StartsWith('-')) {
          '--annotate', '--no-annotate', '-b', '--branch', '--ignore-joins', '--no-ignore-joins', '--onto', '--no-onto', '--rejoin', '--no-rejoin', '--squash', '--no-squash', '-m', '--message', '-S', '--gpg-sign', '--no-gpg-sign'
          break
        }
        break
      }
      { $_ -ceq 'subtree add' -or $_ -ceq 'subtree merge' } {
        if ($wordToComplete.StartsWith('-')) {
          '--squash', '--no-squash', '-m', '--message', '-S', '--gpg-sign', '--no-gpg-sign'
          break
        }
        break
      }
      'switch' {
        if ($wordToComplete.StartsWith('-')) {
          '-c', '--create', '-C', '--force-create', '-d', '--detach', '--guess', '--no-guess', '-f', '--force', '--discard-changes', '-m', '--merge', '--conflict=', '-q', '--quiet', '--progress', '--no-progress', '-t', '--track', '--no-track', '--orphan', '--ignore-other-worktrees', '--recurse-submodules', '--no-recurse-submodules'
          break
        }
        break
      }
      'tag' {
        if ($wordToComplete.StartsWith('-')) {
          '-a', '--annotate', '-s', '--sign', '--no-sign', '-u', '--local-user=', '-f', '--force', '-d', '--delete', '-v', '--verify', '-n', '-l', '--list', '--sort=', '--color', '--color=', '-i', '--ignore-case', '--omit-empty', '--column', '--column=', '--no-column', '--contains', '--no-contains', '--merged', '--no-merged', '--points-at', '-m', '--message=', '-F', '--file=', '--trailer', '-e', '--edit', '--cleanup=', '--create-reflog', '--format='
          break
        }
        break
      }
      'worktree' {
        if ($wordToComplete.StartsWith('-')) {
          '-f', '--force', '-b', '-B', '-d', '--detach', '--checkout', '--no-checkout', '--guess-remote', '--no-guess-remote', '--track', '--no-track', '--lock', '-n', '--dry-run', '--orphan', '--porcelain', '-z', '-q', '--quiet', '-v', '--verbose', '--expire', '--reason'
          break
        }
        'add', 'list', 'lock', 'move', 'prune', 'remove', 'repair', 'unlock'
        break
      }
      'config' {
        if ($wordToComplete.StartsWith('-')) {
          '--replace-all', '--append', '--comment', '--all', '--regexp', '--url=', '--global', '--system', '--local', '--worktree', '-f', '--file', '--blob', '--fixed-value', '--type', '--bool', '--int', '--bool-or-int', '--path', '--expiry-date', '--no-type', '-z', '--null', '--name-only', '--show-origin', '--show-scope', '--get-colorbool', '--includes', '--no-includes', '--default'
          break
        }
        'list', 'get', 'set', 'unset', 'rename-section', 'remove-section', 'edit'
        break
      }
      'fast-export' {
        if ($wordToComplete.StartsWith('-')) {
          '--progress=', '--signed-tags=verbatim', '--signed-tags=warn', '--signed-tags=warn-strip', '--signed-tags=strip', '--signed-tags=abort', '--tag-of-filtered-object=abort', '--tag-of-filtered-object=drop', '--tag-of-filtered-object=rewrite', '-M', '-C', '--export-marks=', '--import-marks=', '--mark-tags', '--fake-missing-tagger', '--use-done-feature', '--no-data', '--full-tree', '--anonymize', '--anonymize-map=', '--reference-excluded-parents', '--show-original-ids', '--reencode=yes', '--reencode=no', '--reencode=abort', '--refspec'
          break
        }
        break
      }
      'fast-import' {
        if ($wordToComplete.StartsWith('-')) {
          '--force', '--quiet', '--stats', '--allow-unsafe-features'
          break
        }
        break
      }
      'filter-branch' {
        if ($wordToComplete.StartsWith('-')) {
          '--setup', '--subdirectory-filter', '--env-filter', '--tree-filter', '--index-filter', '--parent-filter', '--msg-filter', '--commit-filter', '--tag-name-filter', '--prune-empty', '--original', '-d', '-f', '--force', '--state-branch'
          break
        }
        break
      }
      'mergetool' {
        if ($wordToComplete.StartsWith('-')) {
          '-t', '--tool=vscode', '--tool=vim', '--tool-help', '-y', '--no-prompt', '--prompt', '-g', '--gui', '--no-gui', '-O'
          break
        }
        break
      }
      'pack-refs' {
        if ($wordToComplete.StartsWith('-')) {
          '--all', '--no-prune', '--auto', '--include', '--exclude'
          break
        }
        break
      }
      'prune' {
        if ($wordToComplete.StartsWith('-')) {
          '-n', '--dry-run', '-v', '--verbose', '--progress', '--expire'
          break
        }
        break
      }
      'reflog' {
        if ($wordToComplete.StartsWith('-')) {
          '--all', '--single-worktree', '--expire=', '--expire-unreachable=', '--updateref', '--rewrite', '--stale-fix', '-n', '--dry-run', '--verbose'
          break
        }
        break
      }
      'refs' {
        if ($wordToComplete.StartsWith('-')) {
          '--ref-format=', '--dry-run'
          break
        }
        'migrate', 'verify'
        break
      }
      'remote' {
        if ($wordToComplete.StartsWith('-')) {
          '-v', '--verbose'
          break
        }
        'add', 'rename', 'remove', 'rm', 'set-head', 'set-branches', 'get-url', 'set-url', 'show', 'prune', 'update'
        break
      }
      'repack' {
        if ($wordToComplete.StartsWith('-')) {
          '-a', '-A', '-d', '--cruft', '--cruft-expiration=', '--max-cruft-size=', '--expire-to=', '-l', '-f', '-F', '-q', '--quiet', '-n', '--window=', '--depth=', '--threads=', '--window-memory=', '--max-pack-size=', '--filter=', '--filter-to=', '-b', '--write-bitmap-index', '--pack-kept-objects', '--keep-pack=', '--unpack-unreachable=', '-k', '--keep-unreachable', '-i', '--delta-islands', '-g', '--geometric=', '-m', '--write-midx', '--path-walk'
          break
        }
        break
      }
      'replace' {
        if ($wordToComplete.StartsWith('-')) {
          '-f', '--force', '-d', '--delete', '--edit', '--raw', '--graft', '--convert-graft-file', '-l', '--list', '--format='
          break
        }
        break
      }
      'annotate' {
        if ($wordToComplete.StartsWith('-')) {
          '-b', '--root', '--show-stats', '-L', '-l', '-t', '-S', '--reverse', '--first-parent', '-p', '--porcelain', '--line-porcelain', '--incremental', '--encoding=', '--contents', '--date', '--progress', '--no-progress', '-M', '-C', '--ignore-rev', '--ignore-revs-file', '--color-lines', '--color-by-age', '-h'
          break
        }
        break
      }
      'blame' {
        if ($wordToComplete.StartsWith('-')) {
          '-b', '--root', '--show-stats', '-L', '-l', '-t', '-S', '--reverse', '--first-parent', '-p', '--porcelain', '--line-porcelain', '--incremental', '--encoding=', '--contents', '--date', '--progress', '--no-progress', '-M', '-C', '--ignore-rev', '--ignore-revs-file', '--color-lines', '--color-by-age', '-h', '-c', '--score-debug', '-f', '--show-name', '-n', '--show-number', '-s', '-e', '--show-email', '-w', '--abbrev='
          break
        }
        break
      }
      'bugreport' {
        if ($wordToComplete.StartsWith('-')) {
          '-o', '--output-directory', '-s', '--suffix', '--no-suffix', '--no-diagnose', '--diagnose', '--diagnose='
          break
        }
        break
      }
      'count-objects' {
        if ($wordToComplete.StartsWith('-')) {
          '-v', '--verbose', '-H', '--human-readable'
          break
        }
        break
      }
      'diagnose' {
        if ($wordToComplete.StartsWith('-')) {
          '-o', '--output-directory', '-s', '--suffix', '--mode=stats', '--mode=all'
          break
        }
        break
      }
      'difftool' {
        if ($wordToComplete.StartsWith('-')) {
          '-d', '--dir-diff', '-y', '--no-prompt', '--prompt', '--rotate-to=', '--skip-to=', '-t', '--tool=vscode', '--tool=vim', '--tool-help', '--symlinks', '--no-symlinks', '-x', '--extcmd=', '-g', '--gui', '--no-gui', '--trust-exit-code', '--no-trust-exit-code'
          break
        }
        break
      }
      'fsck' {
        if ($wordToComplete.StartsWith('-')) {
          '--unreachable', '--dangling', '--no-dangling', '--root', '--tags', '--cache', '--no-reflogs', '--full', '--connectivity-only', '--strict', '--verbose', '--lost-found', '--name-objects', '--progress', '--no-progress'
          break
        }
        break
      }
      'help' {
        if ($wordToComplete.StartsWith('-')) {
          '-a', '--all', '--no-external-commands', '--no-aliases', '--verbose', '-c', '--config', '-g', '--guides', '--user-interfaces', '--developer-interfaces', '-i', '--info', '-m', '--man', '-w', '--web'
          break
        }
        break
      }
      'instaweb' {
        if ($wordToComplete.StartsWith('-')) {
          '-l', '--local', '-d', '--httpd', '-m', '--module-path', '-p', '--port', '-b', '--browser', 'start', '--start', 'stop', '--stop', 'restart', '--restart'
          break
        }
        break
      }
      'merge-tree' {
        if ($wordToComplete.StartsWith('-')) {
          '-z', '--name-only', '--messages', '--no-messages', '--allow-unrelated-histories', '--merge-base=', '-X', '--strategy-option='
          break
        }
        break
      }
      'rerere' {
        if ($wordToComplete.StartsWith('-')) {
          break
        }
        'clear', 'forget', 'diff', 'status', 'remaining', 'gc'
        break
      }
      'show-branch' {
        if ($wordToComplete.StartsWith('-')) {
          '-r', '--remotes', '-a', '--all', '--current', '--topo-order', '--date-order', '--sparse', '--more=', '--list', '--merge-base', '--independent', '--no-name', '--sha1-name', '--topics', '-g', '--reflog', '--reflog=', '--color', '--color=', '--no-color'
          break
        }
        break
      }
      'verify-commit' {
        if ($wordToComplete.StartsWith('-')) {
          '--raw', '-v', '--verbose'
          break
        }
        break
      }
      'verify-tag' {
        if ($wordToComplete.StartsWith('-')) {
          '--raw', '-v', '--verbose'
          break
        }
        break
      }
      'version' {
        if ($wordToComplete.StartsWith('-')) {
          '--build-options'
          break
        }
        break
      }
      'imap-send' {
        if ($wordToComplete.StartsWith('-')) {
          '-v', '--verbose', '-q', '--quiet', '--curl', '--no-curl'
          break
        }
        break
      }
      'p4' {
        if ($wordToComplete.StartsWith('-')) {
          '--git-dir', '-v', '--verbose'
          break
        }
      }
      'quiltimport' {
        if ($wordToComplete.StartsWith('-')) {
          '-n', '--dry-run', '--author', '--patches', '--series', '--keep-non-patch'
          break
        }
        break
      }
      'request-pull' {
        if ($wordToComplete.StartsWith('-')) {
          '-p'
          break
        }
        break
      }
      'send-email' {
        if ($wordToComplete.StartsWith('-')) {
          '--annotate', '--bcc=,…​', '--cc=,…​', '--compose', '--from=', '--reply-to=', '--in-reply-to=', '--subject=', '--to=,…​', '--8bit-encoding=', '--compose-encoding=', '--transfer-encoding=7bit', '--transfer-encoding=8bit', '--transfer-encoding=quoted-printable', '--transfer-encoding=base64', '--transfer-encoding=auto', '--xmailer', '--no-xmailer'
          break
        }
        break
      }
      'svn' {
        if ($wordToComplete.StartsWith('-')) {
          '--shared', '--shared=false', '--shared=true', '--shared=umask', '--shared=group', '--shared=all', '--shared=world', '--shared=everybody', '--template=', '-r', '--revision', '-', '--stdin', '--rmdir', '-e', '--edit', '-l', '--find-copies-harder', '-A', '--authors-file=', '--authors-prog=', '-q', '--quiet', '-m', '--merge', '-s', '--strategy=', '-p', '--rebase-merges', '-n', '--dry-run', '--use-log-author', '--add-author-from'
          break
        }
        'init', 'fetch', 'clone', 'rebase', 'dcommit', 'branch', 'tag', 'log', 'blame', 'find-rev', 'set-tree', 'create-ignore', 'show-ignore', 'mkdirs', 'commit-diff', 'info', 'proplist', 'propget', 'propset', 'show-externals', 'gc', 'reset'
        break
      }
      'apply' {
        if ($wordToComplete.StartsWith('-')) {
          '--stat', '--numstat', '--summary', '--check', '--index', '--cached', '--intent-to-add', '-3', '--3way', '--ours', '--theirs', '--union', '--build-fake-ancestor=', '-R', '--reverse', '--reject', '-z', '-p', '-C', '--unidiff-zero', '--apply', '--no-add', '--allow-binary-replacement', '--binary', '--exclude=', '--include=', '--ignore-space-change', '--ignore-whitespace', '--whitespace=', '--inaccurate-eof', '-v', '--verbose', '-q', '--quiet', '--recount', '--directory=', '--unsafe-paths', '--allow-empty'
          break
        }
        break
      }
      'checkout-index' {
        if ($wordToComplete.StartsWith('-')) {
          '-u', '--index', '-q', '--quiet', '-f', '--force', '-a', '--all', '-n', '--no-create', '--prefix=', '--stage=all', '--temp', '--ignore-skip-worktree-bits', '--stdin', '-z'
          break
        }
        break
      }
      'commit-graph' {
        if ($wordToComplete.StartsWith('-')) {
          '--object-dir', '--progress', '--no-progress'
          break
        }
        break
      }
      'commit-tree' {
        if ($wordToComplete.StartsWith('-')) {
          '-p', '-m', '-F', '-S', '--gpg-sign', '--gpg-sign=', '--no-gpg-sign'
          break
        }
        break
      }
      'hash-object' {
        if ($wordToComplete.StartsWith('-')) {
          '-t', '-w', '--stdin', '--stdin-paths', '--path', '--no-filters', '--literally'
          break
        }
        break
      }
      'index-pack' {
        if ($wordToComplete.StartsWith('-')) {
          '-v', '-o', '--rev-index', '--no-rev-index', '--stdin', '--fix-thin', '--keep', '--keep=', '--index-version=', '--strict', '--strict=', '--progress-title', '--check-self-contained-and-connected', '--fsck-objects', '--fsck-objects=', '--threads=', '--max-input-size=', '--object-format='
          break
        }
        break
      }
      'merge-file' {
        if ($wordToComplete.StartsWith('-')) {
          '--object-id', '-L', '-p', '-q', '--diff3', '--zdiff3', '--ours', '--theirs', '--union', '--diff-algorithm=patience', '--diff-algorithm=minimal', '--diff-algorithm=histogram', '--diff-algorithm=myers'
          break
        }
        break
      }
      'merge-index' {
        if ($wordToComplete.StartsWith('-')) {
          '-a', '-o', '-q'
          break
        }
        break
      }
      'mktag' {
        if ($wordToComplete.StartsWith('-')) {
          '--strict'
          break
        }
        break
      }
      'mktree' {
        if ($wordToComplete.StartsWith('-')) {
          '-z', '--missing', '--batch'
          break
        }
        break
      }
      'multi-pack-index' {
        if ($wordToComplete.StartsWith('-')) {
          '--object-dir=', '--progress', '--no-progress'
          break
        }
        break
      }
      'pack-objects' {
        if ($wordToComplete.StartsWith('-')) {
          'base-name', '--stdout', '--revs', '--unpacked', '--all', '--include-tag', '--stdin-packs', '--cruft', '--cruft-expiration=', '--window=', '--depth=', '--window-memory=', '--max-pack-size=', '--honor-pack-keep', '--keep-pack=', '--incremental', '--local', '--non-empty', '--progress', '--all-progress', '--all-progress-implied', '-q', '--no-reuse-delta', '--no-reuse-object', '--compression=', '--sparse', '--no-sparse', '--thin', '--shallow', '--delta-base-offset', '--threads=', '--index-version=', '--keep-true-parents', '--filter=', '--no-filter', '--missing=', '--exclude-promisor-objects', '--keep-unreachable', '--pack-loose-unreachable', '--unpack-unreachable', '--delta-islands', '--path-walk'
          break
        }
        break
      }
      'prune-packed' {
        if ($wordToComplete.StartsWith('-')) {
          '-n', '--dry-run', '-q', '--quiet'
          break
        }
        break
      }
      'read-tree' {
        if ($wordToComplete.StartsWith('-')) {
          '-m', '--reset', '-u', '-i', '-n', '--dry-run', '-v', '--trivial', '--aggressive', '--prefix=', '--index-output=', '--recurse-submodules', '--no-recurse-submodules', '--no-sparse-checkout', '--empty', '-q', '--quiet'
          break
        }
        break
      }
      'replay' {
        if ($wordToComplete.StartsWith('-')) {
          '--onto', '--advance'
          break
        }
        break
      }
      'symbolic-ref' {
        if ($wordToComplete.StartsWith('-')) {
          '-d', '--delete', '-q', '--quiet', '--short', '--recurse', '--no-recurse', '-m'
          break
        }
        break
      }
      'unpack-objects' {
        if ($wordToComplete.StartsWith('-')) {
          '-n', '-q', '-r', '--strict', '--max-input-size='
          break
        }
        break
      }
      'update-index' {
        if ($wordToComplete.StartsWith('-')) {
          '--add', '--remove', '--refresh', '-q', '--ignore-submodules', '--unmerged', '--ignore-missing', '--cacheinfo', '--cacheinfo', '--index-info', '--chmod=(+|-)x', '--assume-unchanged', '--no-assume-unchanged', '--really-refresh', '--skip-worktree', '--no-skip-worktree', '--ignore-skip-worktree-entries', '--no-ignore-skip-worktree-entries', '--fsmonitor-valid', '--no-fsmonitor-valid', '-g', '--again', '--unresolve', '--info-only', '--force-remove', '--replace', '--stdin', '--verbose', '--index-version', '--show-index-version', '-z', '--split-index', '--no-split-index', '--untracked-cache', '--no-untracked-cache', '--test-untracked-cache', '--force-untracked-cache', '--fsmonitor', '--no-fsmonitor'
          break
        }
        break
      }
      'update-ref' {
        if ($wordToComplete.StartsWith('-')) {
          break
        }
        'update', 'create', 'delete', 'symref-update', 'verify'
        break
      }
      'write-tree' {
        if ($wordToComplete.StartsWith('-')) {
          '--missing-ok', '--prefix='
          break
        }
        break
      }
      'cat-file' {
        if ($wordToComplete.StartsWith('-')) {
          '-t', '-s', '-e', '-p', '--mailmap', '--no-mailmap', '--use-mailmap', '--no-use-mailmap', '--textconv', '--filters', '--path=', '--batch', '--batch=', '--batch-check', '--batch-check=', '--batch-command', '--batch-command=', '--batch-all-objects', '--buffer', '--unordered', '--allow-unknown-type', '--follow-symlinks', '-Z', '-z'
          break
        }
        break
      }
      'cherry' {
        if ($wordToComplete.StartsWith('-')) {
          '-v'
          break
        }
        break
      }
      'diff-files' {
        if ($wordToComplete.StartsWith('-')) {
          '-p', '-u', '--patch', '-s', '--no-patch', '-U', '--unified=', '--output=', '--output-indicator-new=', '--output-indicator-old=', '--output-indicator-context=', '--raw', '--patch-with-raw', '--indent-heuristic', '--no-indent-heuristic', '--minimal', '--patience', '--histogram', '--anchored=', '--diff-algorithm=patience', '--diff-algorithm=minimal', '--diff-algorithm=histogram', '--diff-algorithm=myers', '--stat', '--stat=', '--compact-summary', '--numstat', '--shortstat', '-X', '--dirstat', '--dirstat=', '--cumulative', '--dirstat-by-file', '--dirstat-by-file=', '--summary', '--patch-with-stat', '-z', '--name-only', '--name-status', '--submodule', '--submodule=', '--color', '--color=', '--no-color', '--color-moved', '--color-moved=', '--no-color-moved', '--color-moved-ws=', '--no-color-moved-ws', '--word-diff', '--word-diff=', '--word-diff-regex=', '--color-words', '--color-words=', '--no-renames', '--rename-empty', '--no-rename-empty', '--check', '--ws-error-highlight=', '--full-index', '--binary', '--abbrev', '--abbrev=', '-B', '--break-rewrites', '--break-rewrites=', '-M', '--find-renames', '--find-renames=', '-C', '--find-copies', '--find-copies=', '--find-copies-harder', '-D', '--irreversible-delete', '-l', '--diff-filter=', '-S', '-G', '--find-object=', '--pickaxe-all', '--pickaxe-regex', '-O', '--skip-to=', '--rotate-to=', '-R', '--relative', '--relative=', '--no-relative', '-a', '--text', '--ignore-cr-at-eol', '--ignore-space-at-eol', '-b', '--ignore-space-change', '-w', '--ignore-all-space', '--ignore-blank-lines', '-I', '--ignore-matching-lines=', '--inter-hunk-context=', '-W', '--function-context', '--exit-code', '--quiet', '--ext-diff', '--no-ext-diff', '--textconv', '--no-textconv', '--ignore-submodules', '--ignore-submodules=', '--src-prefix=', '--dst-prefix=', '--no-prefix', '--default-prefix', '--line-prefix=', '--ita-invisible-in-index'
          break
        }
        break
      }
      'diff-index' {
        if ($wordToComplete.StartsWith('-')) {
          '-p', '-u', '--patch', '-s', '--no-patch', '-U', '--unified=', '--output=', '--output-indicator-new=', '--output-indicator-old=', '--output-indicator-context=', '--raw', '--patch-with-raw', '--indent-heuristic', '--no-indent-heuristic', '--minimal', '--patience', '--histogram', '--anchored=', '--diff-algorithm=patience', '--diff-algorithm=minimal', '--diff-algorithm=histogram', '--diff-algorithm=myers', '--stat', '--stat=', '--compact-summary', '--numstat', '--shortstat', '-X', '--dirstat', '--dirstat=', '--cumulative', '--dirstat-by-file', '--dirstat-by-file=', '--summary', '--patch-with-stat', '-z', '--name-only', '--name-status', '--submodule', '--submodule=', '--color', '--color=', '--no-color', '--color-moved', '--color-moved=', '--no-color-moved', '--color-moved-ws=', '--no-color-moved-ws', '--word-diff', '--word-diff=', '--word-diff-regex=', '--color-words', '--color-words=', '--no-renames', '--rename-empty', '--no-rename-empty', '--check', '--ws-error-highlight=', '--full-index', '--binary', '--abbrev', '--abbrev=', '-B', '--break-rewrites', '--break-rewrites=', '-M', '--find-renames', '--find-renames=', '-C', '--find-copies', '--find-copies=', '--find-copies-harder', '-D', '--irreversible-delete', '-l', '--diff-filter=', '-S', '-G', '--find-object=', '--pickaxe-all', '--pickaxe-regex', '-O', '--skip-to=', '--rotate-to=', '-R', '--relative', '--relative=', '--no-relative', '-a', '--text', '--ignore-cr-at-eol', '--ignore-space-at-eol', '-b', '--ignore-space-change', '-w', '--ignore-all-space', '--ignore-blank-lines', '-I', '--ignore-matching-lines=', '--inter-hunk-context=', '-W', '--function-context', '--exit-code', '--quiet', '--ext-diff', '--no-ext-diff', '--textconv', '--no-textconv', '--ignore-submodules', '--ignore-submodules=', '--src-prefix=', '--dst-prefix=', '--no-prefix', '--default-prefix', '--line-prefix=', '--ita-invisible-in-index'
          break
        }
        break
      }
      'diff-tree' {
        if ($wordToComplete.StartsWith('-')) {
          '-p', '-u', '--patch', '-s', '--no-patch', '-U', '--unified=', '--output=', '--output-indicator-new=', '--output-indicator-old=', '--output-indicator-context=', '--raw', '--patch-with-raw', '--indent-heuristic', '--no-indent-heuristic', '--minimal', '--patience', '--histogram', '--anchored=', '--diff-algorithm=patience', '--diff-algorithm=minimal', '--diff-algorithm=histogram', '--diff-algorithm=myers', '--stat', '--stat=', '--compact-summary', '--numstat', '--shortstat', '-X', '--dirstat', '--dirstat=', '--cumulative', '--dirstat-by-file', '--dirstat-by-file=', '--summary', '--patch-with-stat', '-z', '--name-only', '--name-status', '--submodule', '--submodule=', '--color', '--color=', '--no-color', '--color-moved', '--color-moved=', '--no-color-moved', '--color-moved-ws=', '--no-color-moved-ws', '--word-diff', '--word-diff=', '--word-diff-regex=', '--color-words', '--color-words=', '--no-renames', '--rename-empty', '--no-rename-empty', '--check', '--ws-error-highlight=', '--full-index', '--binary', '--abbrev', '--abbrev=', '-B', '--break-rewrites', '--break-rewrites=', '-M', '--find-renames', '--find-renames=', '-C', '--find-copies', '--find-copies=', '--find-copies-harder', '-D', '--irreversible-delete', '-l', '--diff-filter=', '-S', '-G', '--find-object=', '--pickaxe-all', '--pickaxe-regex', '-O', '--skip-to=', '--rotate-to=', '-R', '--relative', '--relative=', '--no-relative', '-a', '--text', '--ignore-cr-at-eol', '--ignore-space-at-eol', '-b', '--ignore-space-change', '-w', '--ignore-all-space', '--ignore-blank-lines', '-I', '--ignore-matching-lines=', '--inter-hunk-context=', '-W', '--function-context', '--exit-code', '--quiet', '--ext-diff', '--no-ext-diff', '--textconv', '--no-textconv', '--ignore-submodules', '--ignore-submodules=', '--src-prefix=', '--dst-prefix=', '--no-prefix', '--default-prefix', '--line-prefix=', '--ita-invisible-in-index'
          break
        }
        break
      }
      'for-each-ref' {
        if ($wordToComplete.StartsWith('-')) {
          '--stdin', '--count=', '--sort=', '--format=', '--color', '--color=', '--shell', '--perl', '--python', '--tcl', '--points-at=', '--merged', '--merged=', '--no-merged', '--no-merged=', '--contains', '--contains=', '--no-contains', '--no-contains=', '--ignore-case', '--omit-empty', '--exclude=', '--include-root-refs'
          break
        }
        break
      }
      'for-each-repo' {
        if ($wordToComplete.StartsWith('-')) {
          '--config=', '--keep-going'
          break
        }
        break
      }
      'ls-files' {
        if ($wordToComplete.StartsWith('-')) {
          '-c', '--cached', '-d', '--deleted', '-m', '--modified', '-o', '--others', '-i', '--ignored', '-s', '--stage', '--directory', '--no-empty-directory', '-u', '--unmerged', '-k', '--killed', '--resolve-undo', '-z', '--deduplicate', '-x', '--exclude=', '-X', '--exclude-from=', '--exclude-per-directory=', '--exclude-standard', '--error-unmatch', '--with-tree=', '-t', '-v', '-f', '--full-name', '--recurse-submodules', '--abbrev', '--abbrev=', '--debug', '--eol', '--sparse', '--format='
          break
        }
        break
      }
      'ls-remote' {
        if ($wordToComplete.StartsWith('-')) {
          '-b', '--branches', '-t', '--tags', '--refs', '-q', '--quiet', '--upload-pack=', '--exit-code', '--get-url', '--symref', '--sort=', '-o', '--server-option='
          break
        }
        break
      }
      'ls-tree' {
        if ($wordToComplete.StartsWith('-')) {
          '<tree-ish>', '-d', '-r', '-t', '-l', '--long', '-z', '--name-only', '--name-status', '--object-only', '--abbrev', '--abbrev=', '--full-name', '--full-tree', '--format='
          break
        }
        break
      }
      'merge-base' {
        if ($wordToComplete.StartsWith('-')) {
          '--octopus', '--independent', '--is-ancestor', '--fork-point'
          break
        }
        break
      }
      'name-rev' {
        if ($wordToComplete.StartsWith('-')) {
          '--tags', '--refs=', '--exclude=', '--all', '--annotate-stdin', '--name-only', '--no-undefined', '--always'
          break
        }
        break
      }
      'rev-parse' {
        if ($wordToComplete.StartsWith('-')) {
          '--parseopt', '--sq-quote', '--keep-dashdash', '--stop-at-non-option', '--stuck-long', '--revs-only', '--no-revs', '--flags', '--no-flags', '--default', '--prefix', '--verify', '-q', '--quiet', '--sq', '--short', '--short=', '--not', '--abbrev-ref', '--abbrev-ref=strict', '--abbrev-ref=loose', '--symbolic', '--symbolic-full-name', '--output-object-format=sha1', '--output-object-format=sha256', '--output-object-format=storage', '--all', '--branches', '--branches=', '--tags', '--tags=', '--remotes', '--remotes=', '--glob=', '--exclude=', '--exclude-hidden=fetch', '--exclude-hidden=receive', '--exclude-hidden=uploadpack', '--disambiguate=', '--local-env-vars', '--path-format=absolute', '--path-format=relative', '--git-dir', '--git-common-dir', '--resolve-git-dir', '--git-path', '--show-toplevel', '--show-superproject-working-tree', '--shared-index-path', '--since=', '--after=', '--until=', '--before='
          break
        }
        break
      }
      'show-ref' {
        if ($wordToComplete.StartsWith('-')) {
          '--head', '--branches', '--tags', '-d', '--dereference', '-s', '--hash', '--hash=', '--verify', '--exists', '--abbrev', '--abbrev=', '-q', '--quiet', '--exclude-existing', '--exclude-existing='
          break
        }
        break
      }
      'var' {
        if ($wordToComplete.StartsWith('-')) {
          '-l'
          break
        }
        break
      }
      'verify-pack' {
        if ($wordToComplete.StartsWith('-')) {
          '.idx', '-v', '--verbose', '-s', '--stat-only'
          break
        }
        break
      }
      'daemon' {
        if ($wordToComplete.StartsWith('-')) {
          '--strict-paths', '--base-path=', '--base-path-relaxed', '--interpolated-path=', '--export-all', '--inetd', '--listen=', '--port=', '--init-timeout=', '--timeout=', '--max-connections=', '--syslog', '--log-destination=', '--user-path', '--user-path=', '--verbose', '--reuseaddr', '--detach', '--pid-file=', '--user=', '--group=', '--enable=', '--disable=', '--allow-override=', '--forbid-override=', '--informative-errors', '--no-informative-errors', '--access-hook='
          break
        }
        break
      }
      'fetch-pack' {
        if ($wordToComplete.StartsWith('-')) {
          '--all', '--stdin', '-q', '--quiet', '-k', '--keep', '--thin', '--include-tag', '--upload-pack=', '--exec=', '--depth=', '--shallow-since=', '--shallow-exclude=', '--deepen-relative', '--refetch', '--no-progress', '--check-self-contained-and-connected', '-v'
          break
        }
        break
      }
      'send-pack' {
        if ($wordToComplete.StartsWith('-')) {
          '--receive-pack=', '--exec=', '--all', '--stdin', '--dry-run', '--force', '--verbose', '--thin', '--atomic', '--signed', '--no-signed', '--signed=true', '--signed=false', '--signed=if-asked', '--push-option='
          break
        }
        break
      }
      'update-server-info' {
        if ($wordToComplete.StartsWith('-')) {
          '-f', '--force'
          break
        }
        break
      }
      'check-attr' {
        if ($wordToComplete.StartsWith('-')) {
          '-a,', '--cached', '--stdin', '-z', '--source='
          break
        }
        break
      }
      'check-ignore' {
        if ($wordToComplete.StartsWith('-')) {
          '-q,', '-v,', '--stdin', '-z', '-n,', '--no-index'
          break
        }
        break
      }
      'check-mailmap' {
        if ($wordToComplete.StartsWith('-')) {
          '--stdin', '--mailmap-file=', '--mailmap-blob='
          break
        }
        break
      }
      'check-ref-format' {
        if ($wordToComplete.StartsWith('-')) {
          '--allow-onelevel', '--no-allow-onelevel', '--refspec-pattern', '--normalize'
          break
        }
        break
      }
      'column' {
        if ($wordToComplete.StartsWith('-')) {
          '--command=', '--mode=', '--raw-mode=', '--width=', '--indent=', '--nl=', '--padding='
          break
        }
        break
      }
      'credential' { break }
      'credential-cache' {
        if ($wordToComplete.StartsWith('-')) {
          '--timeout', '--socket'
          break
        }
        break
      }
      'credential-store' {
        if ($wordToComplete.StartsWith('-')) {
          '--file='
          break
        }
        break
      }
      'fmt-merge-msg' {
        if ($wordToComplete.StartsWith('-')) {
          '--log', '--log=', '--no-log', '--summary', '--no-summary', '-m', '--message', '--into-name', '-F', '--file'
          break
        }
        break
      }
      'hook' {
        if ($wordToComplete.StartsWith('-')) {
          '--to-stdin', '--ignore-missing'
          break
        }
        'run'
        break
      }
      'interpret-trailers' {
        if ($wordToComplete.StartsWith('-')) {
          '--in-place', '--trim-empty', '--trailer', '--where', '--no-where', '--if-exists', '--no-if-exists', '--if-missing', '--no-if-missing', '--only-trailers', '--only-input', '--unfold', '--parse', '--no-divider'
          break
        }
        break
      }
      'mailinfo' {
        if ($wordToComplete.StartsWith('-')) {
          '-k', '-b', '-u', '--encoding=', '-n', '-m', '--message-id', '--scissors', '--no-scissors', '--quoted-cr='
          break
        }
        break
      }
      'mailsplit' {
        if ($wordToComplete.StartsWith('-')) {
          '-o', '-b', '-d', '-f', '--keep-cr', '--mboxrd'
          break
        }
        break
      }
      'patch-id' {
        if ($wordToComplete.StartsWith('-')) {
          '--verbatim', '--stable', '--unstable'
          break
        }
        break
      }
      'sh-i18n' {
        if ($wordToComplete.StartsWith('-')) {
          break
        }
        'gettext', 'eval_gettext'
        break
      }
      'sh-setup' {
        if ($wordToComplete.StartsWith('-')) {
          break
        }
        'die', 'usage', 'set_reflog_action', 'git_editor', 'is_bare_repository', 'cd_to_toplevel', 'require_work_tree', 'require_work_tree_exists', 'require_clean_work_tree', 'get_author_ident_from_commit', 'create_virtual_base'
        break
      }
      'stripspace' {
        if ($wordToComplete.StartsWith('-')) {
          '-s', '--strip-comments', '-c', '--comment-lines'
          break
        }
        break
      }
      'credential-manager' {
        if ($wordToComplete.StartsWith('-')) {
          '--no-ui', '--version', '-h', '-?', '--help'
          break
        }
        'get', 'store', 'erase', 'configure', 'unconfigure', 'diagnose', 'azure-repos', 'github'
        break
      }
      'flow' {
        if ($wordToComplete.StartsWith('-')) {
          break
        }
        'init', 'feature', 'bugfix', 'release', 'hotfix', 'support', 'version', 'config', 'log'
        break
      }
      'flow init' {
        if ($wordToComplete.StartsWith('-')) {
          '-h', '--help', '--showcommands', '-d', '--defaults', '--nodefaults', '-f', '--force', '--noforce', '-p', '--feature', '-b', '--bugfix', '-r', '--release', '-x', '--hotfix', '-s', '--support', '-t', '--tag', '--Use', '--no-Use', '--local', '--global', '--system', '--file', '--no-file'
          break
        }
        break
      }
      { $_.StartsWith('flow ') } {
        if ($wordToComplete.StartsWith('-')) {
          '-h', '--help', '-v', '--verbose', '--no-verbose'
          break
        }
        'list', 'start'
        break
      }
      'lfs' {
        if ($wordToComplete.StartsWith('-')) {
          break
        }
        'checkout', 'completion', 'dedup', 'env', 'ext', 'fetch', 'fsck', 'install', 'lock', 'locks', 'logs', 'ls-files', 'migrate', 'prune', 'pull', 'push', 'status', 'track', 'uninstall', 'unlock', 'untrack', 'update', 'version'
        break
      }
      # 'archimport' { break }
      # 'attributes' { break }
      # 'citool' { break } # GUI tool
      # 'cli' { break }
      # 'credential-helper-selector' { break }
      # 'cvsexportcommit' { break }
      # 'cvsimport' { break }
      # 'cvsserver' { break }
      # 'get-tar-commit-id' { break }
      # 'gitweb' { break }
      # 'hook run' { break }
      # 'hooks' { break }
      # 'http-backend' { break }
      # 'ignore' { break }
      # 'mailmap' { break }
      # 'merge-one-file' { break }
      # 'modules' { break }
      # 'pack-redundant' { break }
      # 'remote' { break }
      # 'repository-layout' { break }
      # 'rev-list' { break }
      # 'show-index' { break }
      # 'unpack-file' { break }
      # 'update-git-for-windows' { break }
      # 'whatchanged' { break }
    }).Where{ $_ -like "$wordToComplete*" }
}
