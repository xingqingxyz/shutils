using namespace System.Management.Automation
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
  $command = $commands -join ' '
  @(switch ($command) {
      '' {
        if ($wordToComplete.StartsWith('-')) {
          @('-v', '--version', '-h', '--help', '-C', '-c', '--exec-path=', '--html-path', '--man-path', '--info-path', '-p', '--paginate', '-P', '--no-pager', '--no-replace-objects', '--no-lazy-fetch', '--no-optional-locks', '--no-advice', '--bare', '--git-dir=', '--work-tree=', '--namespace=', '--config-env=').ForEach{ [CompletionResult]::new($_) }
          break
        }
        [CompletionResult]::new('add', 'add', [CompletionResultType]::ParameterName, 'Add file contents to the index')
        [CompletionResult]::new('am', 'am', [CompletionResultType]::ParameterName, 'Apply a series of patches from a mailbox')
        [CompletionResult]::new('archive', 'archive', [CompletionResultType]::ParameterName, 'Create an archive of files from a named tree')
        [CompletionResult]::new('bisect', 'bisect', [CompletionResultType]::ParameterName, 'Use binary search to find the commit that introduced a bug')
        [CompletionResult]::new('branch', 'branch', [CompletionResultType]::ParameterName, 'List, create, or delete branches')
        [CompletionResult]::new('bundle', 'bundle', [CompletionResultType]::ParameterName, 'Move objects and refs by archive')
        [CompletionResult]::new('checkout', 'checkout', [CompletionResultType]::ParameterName, 'Switch branches or restore working tree files')
        [CompletionResult]::new('cherry-pick', 'cherry-pick', [CompletionResultType]::ParameterName, 'Apply the changes introduced by some existing commits')
        [CompletionResult]::new('citool', 'citool', [CompletionResultType]::ParameterName, 'Graphical alternative to git-commit')
        [CompletionResult]::new('clean', 'clean', [CompletionResultType]::ParameterName, 'Remove untracked files from the working tree')
        [CompletionResult]::new('clone', 'clone', [CompletionResultType]::ParameterName, 'Clone a repository into a new directory')
        [CompletionResult]::new('commit', 'commit', [CompletionResultType]::ParameterName, 'Record changes to the repository')
        [CompletionResult]::new('describe', 'describe', [CompletionResultType]::ParameterName, 'Give an object a human readable name based on an available ref')
        [CompletionResult]::new('diff', 'diff', [CompletionResultType]::ParameterName, 'Show changes between commits, commit and working tree, etc')
        [CompletionResult]::new('fetch', 'fetch', [CompletionResultType]::ParameterName, 'Download objects and refs from another repository')
        [CompletionResult]::new('format-patch', 'format-patch', [CompletionResultType]::ParameterName, 'Prepare patches for e-mail submission')
        [CompletionResult]::new('gc', 'gc', [CompletionResultType]::ParameterName, 'Cleanup unnecessary files and optimize the local repository')
        [CompletionResult]::new('gitk', 'gitk', [CompletionResultType]::ParameterName, 'The Git repository browser')
        [CompletionResult]::new('grep', 'grep', [CompletionResultType]::ParameterName, 'Print lines matching a pattern')
        [CompletionResult]::new('gui', 'gui', [CompletionResultType]::ParameterName, 'A portable graphical interface to Git')
        [CompletionResult]::new('init', 'init', [CompletionResultType]::ParameterName, 'Create an empty Git repository or reinitialize an existing one')
        [CompletionResult]::new('log', 'log', [CompletionResultType]::ParameterName, 'Show commit logs')
        [CompletionResult]::new('maintenance', 'maintenance', [CompletionResultType]::ParameterName, 'Run tasks to optimize Git repository data')
        [CompletionResult]::new('merge', 'merge', [CompletionResultType]::ParameterName, 'Join two or more development histories together')
        [CompletionResult]::new('mv', 'mv', [CompletionResultType]::ParameterName, 'Move or rename a file, a directory, or a symlink')
        [CompletionResult]::new('notes', 'notes', [CompletionResultType]::ParameterName, 'Add or inspect object notes')
        [CompletionResult]::new('pull', 'pull', [CompletionResultType]::ParameterName, 'Fetch from and integrate with another repository or a local branch')
        [CompletionResult]::new('push', 'push', [CompletionResultType]::ParameterName, 'Update remote refs along with associated objects')
        [CompletionResult]::new('range-diff', 'range-diff', [CompletionResultType]::ParameterName, 'Compare two commit ranges (e.g. two versions of a branch)')
        [CompletionResult]::new('rebase', 'rebase', [CompletionResultType]::ParameterName, 'Reapply commits on top of another base tip')
        [CompletionResult]::new('reset', 'reset', [CompletionResultType]::ParameterName, 'Reset current HEAD to the specified state')
        [CompletionResult]::new('restore', 'restore', [CompletionResultType]::ParameterName, 'Restore working tree files')
        [CompletionResult]::new('revert', 'revert', [CompletionResultType]::ParameterName, 'Revert some existing commits')
        [CompletionResult]::new('rm', 'rm', [CompletionResultType]::ParameterName, 'Remove files from the working tree and from the index')
        [CompletionResult]::new('scalar', 'scalar', [CompletionResultType]::ParameterName, 'A tool for managing large Git repositories')
        [CompletionResult]::new('shortlog', 'shortlog', [CompletionResultType]::ParameterName, "Summarize 'git log' output")
        [CompletionResult]::new('show', 'show', [CompletionResultType]::ParameterName, 'Show various types of objects')
        [CompletionResult]::new('sparse-checkout', 'sparse-checkout', [CompletionResultType]::ParameterName, 'Reduce your working tree to a subset of tracked files')
        [CompletionResult]::new('stash', 'stash', [CompletionResultType]::ParameterName, 'Stash the changes in a dirty working directory away')
        [CompletionResult]::new('status', 'status', [CompletionResultType]::ParameterName, 'Show the working tree status')
        [CompletionResult]::new('submodule', 'submodule', [CompletionResultType]::ParameterName, 'Initialize, update or inspect submodules')
        [CompletionResult]::new('subtree', 'subtree', [CompletionResultType]::ParameterName, 'Merge subtrees together and split repository into subtrees')
        [CompletionResult]::new('switch', 'switch', [CompletionResultType]::ParameterName, 'Switch branches')
        [CompletionResult]::new('tag', 'tag', [CompletionResultType]::ParameterName, 'Create, list, delete or verify a tag object signed with GPG')
        [CompletionResult]::new('worktree', 'worktree', [CompletionResultType]::ParameterName, 'Manage multiple working trees')
        [CompletionResult]::new('config', 'config', [CompletionResultType]::ParameterName, 'Get and set repository or global options')
        [CompletionResult]::new('fast-export', 'fast-export', [CompletionResultType]::ParameterName, 'Git data exporter')
        [CompletionResult]::new('fast-import', 'fast-import', [CompletionResultType]::ParameterName, 'Backend for fast Git data importers')
        [CompletionResult]::new('filter-branch', 'filter-branch', [CompletionResultType]::ParameterName, 'Rewrite branches')
        [CompletionResult]::new('mergetool', 'mergetool', [CompletionResultType]::ParameterName, 'Run merge conflict resolution tools to resolve merge conflicts')
        [CompletionResult]::new('pack-refs', 'pack-refs', [CompletionResultType]::ParameterName, 'Pack heads and tags for efficient repository access')
        [CompletionResult]::new('prune', 'prune', [CompletionResultType]::ParameterName, 'Prune all unreachable objects from the object database')
        [CompletionResult]::new('reflog', 'reflog', [CompletionResultType]::ParameterName, 'Manage reflog information')
        [CompletionResult]::new('refs', 'refs', [CompletionResultType]::ParameterName, 'Low-level access to refs')
        [CompletionResult]::new('remote', 'remote', [CompletionResultType]::ParameterName, 'Manage set of tracked repositories')
        [CompletionResult]::new('repack', 'repack', [CompletionResultType]::ParameterName, 'Pack unpacked objects in a repository')
        [CompletionResult]::new('replace', 'replace', [CompletionResultType]::ParameterName, 'Create, list, delete refs to replace objects')
        [CompletionResult]::new('annotate', 'annotate', [CompletionResultType]::ParameterName, 'Annotate file lines with commit information')
        [CompletionResult]::new('blame', 'blame', [CompletionResultType]::ParameterName, 'Show what revision and author last modified each line of a file')
        [CompletionResult]::new('bugreport', 'bugreport', [CompletionResultType]::ParameterName, 'Collect information for user to file a bug report')
        [CompletionResult]::new('count-objects', 'count-objects', [CompletionResultType]::ParameterName, 'Count unpacked number of objects and their disk consumption')
        [CompletionResult]::new('diagnose', 'diagnose', [CompletionResultType]::ParameterName, 'Generate a zip archive of diagnostic information')
        [CompletionResult]::new('difftool', 'difftool', [CompletionResultType]::ParameterName, 'Show changes using common diff tools')
        [CompletionResult]::new('fsck', 'fsck', [CompletionResultType]::ParameterName, 'Verifies the connectivity and validity of the objects in the database')
        [CompletionResult]::new('gitweb', 'gitweb', [CompletionResultType]::ParameterName, 'Git web interface (web frontend to Git repositories)')
        [CompletionResult]::new('help', 'help', [CompletionResultType]::ParameterName, 'Display help information about Git')
        [CompletionResult]::new('instaweb', 'instaweb', [CompletionResultType]::ParameterName, 'Instantly browse your working repository in gitweb')
        [CompletionResult]::new('merge-tree', 'merge-tree', [CompletionResultType]::ParameterName, 'Perform merge without touching index or working tree')
        [CompletionResult]::new('rerere', 'rerere', [CompletionResultType]::ParameterName, 'Reuse recorded resolution of conflicted merges')
        [CompletionResult]::new('show-branch', 'show-branch', [CompletionResultType]::ParameterName, 'Show branches and their commits')
        [CompletionResult]::new('verify-commit', 'verify-commit', [CompletionResultType]::ParameterName, 'Check the GPG signature of commits')
        [CompletionResult]::new('verify-tag', 'verify-tag', [CompletionResultType]::ParameterName, 'Check the GPG signature of tags')
        [CompletionResult]::new('version', 'version', [CompletionResultType]::ParameterName, 'Display version information about Git')
        [CompletionResult]::new('whatchanged', 'whatchanged', [CompletionResultType]::ParameterName, 'Show logs with differences each commit introduces')
        [CompletionResult]::new('archimport', 'archimport', [CompletionResultType]::ParameterName, 'Import a GNU Arch repository into Git')
        [CompletionResult]::new('cvsexportcommit', 'cvsexportcommit', [CompletionResultType]::ParameterName, 'Export a single commit to a CVS checkout')
        [CompletionResult]::new('cvsimport', 'cvsimport', [CompletionResultType]::ParameterName, 'Salvage your data out of another SCM people love to hate')
        [CompletionResult]::new('cvsserver', 'cvsserver', [CompletionResultType]::ParameterName, 'A CVS server emulator for Git')
        [CompletionResult]::new('imap-send', 'imap-send', [CompletionResultType]::ParameterName, 'Send a collection of patches from stdin to an IMAP folder')
        [CompletionResult]::new('p4', 'p4', [CompletionResultType]::ParameterName, 'Import from and submit to Perforce repositories')
        [CompletionResult]::new('quiltimport', 'quiltimport', [CompletionResultType]::ParameterName, 'Applies a quilt patchset onto the current branch')
        [CompletionResult]::new('request-pull', 'request-pull', [CompletionResultType]::ParameterName, 'Generates a summary of pending changes')
        [CompletionResult]::new('send-email', 'send-email', [CompletionResultType]::ParameterName, 'Send a collection of patches as emails')
        [CompletionResult]::new('svn', 'svn', [CompletionResultType]::ParameterName, 'Bidirectional operation between a Subversion repository and Git')
        [CompletionResult]::new('apply', 'apply', [CompletionResultType]::ParameterName, 'Apply a patch to files and/or to the index')
        [CompletionResult]::new('checkout-index', 'checkout-index', [CompletionResultType]::ParameterName, 'Copy files from the index to the working tree')
        [CompletionResult]::new('commit-graph', 'commit-graph', [CompletionResultType]::ParameterName, 'Write and verify Git commit-graph files')
        [CompletionResult]::new('commit-tree', 'commit-tree', [CompletionResultType]::ParameterName, 'Create a new commit object')
        [CompletionResult]::new('hash-object', 'hash-object', [CompletionResultType]::ParameterName, 'Compute object ID and optionally create an object from a file')
        [CompletionResult]::new('index-pack', 'index-pack', [CompletionResultType]::ParameterName, 'Build pack index file for an existing packed archive')
        [CompletionResult]::new('merge-file', 'merge-file', [CompletionResultType]::ParameterName, 'Run a three-way file merge')
        [CompletionResult]::new('merge-index', 'merge-index', [CompletionResultType]::ParameterName, 'Run a merge for files needing merging')
        [CompletionResult]::new('mktag', 'mktag', [CompletionResultType]::ParameterName, 'Creates a tag object with extra validation')
        [CompletionResult]::new('mktree', 'mktree', [CompletionResultType]::ParameterName, 'Build a tree-object from ls-tree formatted text')
        [CompletionResult]::new('multi-pack-index', 'multi-pack-index', [CompletionResultType]::ParameterName, 'Write and verify multi-pack-indexes')
        [CompletionResult]::new('pack-objects', 'pack-objects', [CompletionResultType]::ParameterName, 'Create a packed archive of objects')
        [CompletionResult]::new('prune-packed', 'prune-packed', [CompletionResultType]::ParameterName, 'Remove extra objects that are already in pack files')
        [CompletionResult]::new('read-tree', 'read-tree', [CompletionResultType]::ParameterName, 'Reads tree information into the index')
        [CompletionResult]::new('replay', 'replay', [CompletionResultType]::ParameterName, 'EXPERIMENTAL: Replay commits on a new base, works with bare repos too')
        [CompletionResult]::new('symbolic-ref', 'symbolic-ref', [CompletionResultType]::ParameterName, 'Read, modify and delete symbolic refs')
        [CompletionResult]::new('unpack-objects', 'unpack-objects', [CompletionResultType]::ParameterName, 'Unpack objects from a packed archive')
        [CompletionResult]::new('update-index', 'update-index', [CompletionResultType]::ParameterName, 'Register file contents in the working tree to the index')
        [CompletionResult]::new('update-ref', 'update-ref', [CompletionResultType]::ParameterName, 'Update the object name stored in a ref safely')
        [CompletionResult]::new('write-tree', 'write-tree', [CompletionResultType]::ParameterName, 'Create a tree object from the current index')
        [CompletionResult]::new('cat-file', 'cat-file', [CompletionResultType]::ParameterName, 'Provide contents or details of repository objects')
        [CompletionResult]::new('cherry', 'cherry', [CompletionResultType]::ParameterName, 'Find commits yet to be applied to upstream')
        [CompletionResult]::new('diff-files', 'diff-files', [CompletionResultType]::ParameterName, 'Compares files in the working tree and the index')
        [CompletionResult]::new('diff-index', 'diff-index', [CompletionResultType]::ParameterName, 'Compare a tree to the working tree or index')
        [CompletionResult]::new('diff-tree', 'diff-tree', [CompletionResultType]::ParameterName, 'Compares the content and mode of blobs found via two tree objects')
        [CompletionResult]::new('for-each-ref', 'for-each-ref', [CompletionResultType]::ParameterName, 'Output information on each ref')
        [CompletionResult]::new('for-each-repo', 'for-each-repo', [CompletionResultType]::ParameterName, 'Run a Git command on a list of repositories')
        [CompletionResult]::new('get-tar-commit-id', 'get-tar-commit-id', [CompletionResultType]::ParameterName, 'Extract commit ID from an archive created using git-archive')
        [CompletionResult]::new('ls-files', 'ls-files', [CompletionResultType]::ParameterName, 'Show information about files in the index and the working tree')
        [CompletionResult]::new('ls-remote', 'ls-remote', [CompletionResultType]::ParameterName, 'List references in a remote repository')
        [CompletionResult]::new('ls-tree', 'ls-tree', [CompletionResultType]::ParameterName, 'List the contents of a tree object')
        [CompletionResult]::new('merge-base', 'merge-base', [CompletionResultType]::ParameterName, 'Find as good common ancestors as possible for a merge')
        [CompletionResult]::new('name-rev', 'name-rev', [CompletionResultType]::ParameterName, 'Find symbolic names for given revs')
        [CompletionResult]::new('pack-redundant', 'pack-redundant', [CompletionResultType]::ParameterName, 'Find redundant pack files')
        [CompletionResult]::new('rev-list', 'rev-list', [CompletionResultType]::ParameterName, 'Lists commit objects in reverse chronological order')
        [CompletionResult]::new('rev-parse', 'rev-parse', [CompletionResultType]::ParameterName, 'Pick out and massage parameters')
        [CompletionResult]::new('show-index', 'show-index', [CompletionResultType]::ParameterName, 'Show packed archive index')
        [CompletionResult]::new('show-ref', 'show-ref', [CompletionResultType]::ParameterName, 'List references in a local repository')
        [CompletionResult]::new('unpack-file', 'unpack-file', [CompletionResultType]::ParameterName, "Creates a temporary file with a blob's contents")
        [CompletionResult]::new('var', 'var', [CompletionResultType]::ParameterName, 'Show a Git logical variable')
        [CompletionResult]::new('verify-pack', 'verify-pack', [CompletionResultType]::ParameterName, 'Validate packed Git archive files')
        [CompletionResult]::new('daemon', 'daemon', [CompletionResultType]::ParameterName, 'A really simple server for Git repositories')
        [CompletionResult]::new('fetch-pack', 'fetch-pack', [CompletionResultType]::ParameterName, 'Receive missing objects from another repository')
        [CompletionResult]::new('http-backend', 'http-backend', [CompletionResultType]::ParameterName, 'Server side implementation of Git over HTTP')
        [CompletionResult]::new('send-pack', 'send-pack', [CompletionResultType]::ParameterName, 'Push objects over Git protocol to another repository')
        [CompletionResult]::new('update-server-info', 'update-server-info', [CompletionResultType]::ParameterName, 'Update auxiliary info file to help dumb servers')
        [CompletionResult]::new('check-attr', 'check-attr', [CompletionResultType]::ParameterName, 'Display gitattributes information')
        [CompletionResult]::new('check-ignore', 'check-ignore', [CompletionResultType]::ParameterName, 'Debug gitignore / exclude files')
        [CompletionResult]::new('check-mailmap', 'check-mailmap', [CompletionResultType]::ParameterName, 'Show canonical names and email addresses of contacts')
        [CompletionResult]::new('check-ref-format', 'check-ref-format', [CompletionResultType]::ParameterName, 'Ensures that a reference name is well formed')
        [CompletionResult]::new('column', 'column', [CompletionResultType]::ParameterName, 'Display data in columns')
        [CompletionResult]::new('credential', 'credential', [CompletionResultType]::ParameterName, 'Retrieve and store user credentials')
        [CompletionResult]::new('credential-cache', 'credential-cache', [CompletionResultType]::ParameterName, 'Helper to temporarily store passwords in memory')
        [CompletionResult]::new('credential-store', 'credential-store', [CompletionResultType]::ParameterName, 'Helper to store credentials on disk')
        [CompletionResult]::new('fmt-merge-msg', 'fmt-merge-msg', [CompletionResultType]::ParameterName, 'Produce a merge commit message')
        [CompletionResult]::new('hook', 'hook', [CompletionResultType]::ParameterName, 'Run git hooks')
        [CompletionResult]::new('interpret-trailers', 'interpret-trailers', [CompletionResultType]::ParameterName, 'Add or parse structured information in commit messages')
        [CompletionResult]::new('mailinfo', 'mailinfo', [CompletionResultType]::ParameterName, 'Extracts patch and authorship from a single e-mail message')
        [CompletionResult]::new('mailsplit', 'mailsplit', [CompletionResultType]::ParameterName, 'Simple UNIX mbox splitter program')
        [CompletionResult]::new('merge-one-file', 'merge-one-file', [CompletionResultType]::ParameterName, 'The standard helper program to use with git-merge-index')
        [CompletionResult]::new('patch-id', 'patch-id', [CompletionResultType]::ParameterName, 'Compute unique ID for a patch')
        [CompletionResult]::new('sh-i18n', 'sh-i18n', [CompletionResultType]::ParameterName, "Git's i18n setup code for shell scripts")
        [CompletionResult]::new('sh-setup', 'sh-setup', [CompletionResultType]::ParameterName, 'Common Git shell script setup code')
        [CompletionResult]::new('stripspace', 'stripspace', [CompletionResultType]::ParameterName, 'Remove unnecessary whitespace')
        [CompletionResult]::new('attributes', 'attributes', [CompletionResultType]::ParameterName, 'Defining attributes per path')
        [CompletionResult]::new('cli', 'cli', [CompletionResultType]::ParameterName, 'Git command-line interface and conventions')
        [CompletionResult]::new('hooks', 'hooks', [CompletionResultType]::ParameterName, 'Hooks used by Git')
        [CompletionResult]::new('ignore', 'ignore', [CompletionResultType]::ParameterName, 'Specifies intentionally untracked files to ignore')
        [CompletionResult]::new('mailmap', 'mailmap', [CompletionResultType]::ParameterName, 'Map author/committer names and/or E-Mail addresses')
        [CompletionResult]::new('modules', 'modules', [CompletionResultType]::ParameterName, 'Defining submodule properties')
        [CompletionResult]::new('repository-layout', 'repository-layout', [CompletionResultType]::ParameterName, 'Git Repository Layout')
        [CompletionResult]::new('askpass', 'askpass', [CompletionResultType]::ParameterName, 'unknown')
        [CompletionResult]::new('askyesno', 'askyesno', [CompletionResultType]::ParameterName, 'unknown')
        [CompletionResult]::new('credential-helper-selector', 'credential-helper-selector', [CompletionResultType]::ParameterName, 'unknown')
        [CompletionResult]::new('credential-manager', 'credential-manager', [CompletionResultType]::ParameterName, 'unknown')
        [CompletionResult]::new('flow', 'flow', [CompletionResultType]::ParameterName, 'unknown')
        [CompletionResult]::new('lfs', 'lfs', [CompletionResultType]::ParameterName, 'unknown')
        [CompletionResult]::new('update-git-for-windows', 'update-git-for-windows', [CompletionResultType]::ParameterName, 'unknown')
        break
      }
      'help' {
        if ($commandAst.CommandElements.Count -gt 3) {
          break
        }
        [CompletionResult]::new('add', 'add', [CompletionResultType]::ParameterName, 'Add file contents to the index')
        [CompletionResult]::new('am', 'am', [CompletionResultType]::ParameterName, 'Apply a series of patches from a mailbox')
        [CompletionResult]::new('archive', 'archive', [CompletionResultType]::ParameterName, 'Create an archive of files from a named tree')
        [CompletionResult]::new('bisect', 'bisect', [CompletionResultType]::ParameterName, 'Use binary search to find the commit that introduced a bug')
        [CompletionResult]::new('branch', 'branch', [CompletionResultType]::ParameterName, 'List, create, or delete branches')
        [CompletionResult]::new('bundle', 'bundle', [CompletionResultType]::ParameterName, 'Move objects and refs by archive')
        [CompletionResult]::new('checkout', 'checkout', [CompletionResultType]::ParameterName, 'Switch branches or restore working tree files')
        [CompletionResult]::new('cherry-pick', 'cherry-pick', [CompletionResultType]::ParameterName, 'Apply the changes introduced by some existing commits')
        [CompletionResult]::new('citool', 'citool', [CompletionResultType]::ParameterName, 'Graphical alternative to git-commit')
        [CompletionResult]::new('clean', 'clean', [CompletionResultType]::ParameterName, 'Remove untracked files from the working tree')
        [CompletionResult]::new('clone', 'clone', [CompletionResultType]::ParameterName, 'Clone a repository into a new directory')
        [CompletionResult]::new('commit', 'commit', [CompletionResultType]::ParameterName, 'Record changes to the repository')
        [CompletionResult]::new('describe', 'describe', [CompletionResultType]::ParameterName, 'Give an object a human readable name based on an available ref')
        [CompletionResult]::new('diff', 'diff', [CompletionResultType]::ParameterName, 'Show changes between commits, commit and working tree, etc')
        [CompletionResult]::new('fetch', 'fetch', [CompletionResultType]::ParameterName, 'Download objects and refs from another repository')
        [CompletionResult]::new('format-patch', 'format-patch', [CompletionResultType]::ParameterName, 'Prepare patches for e-mail submission')
        [CompletionResult]::new('gc', 'gc', [CompletionResultType]::ParameterName, 'Cleanup unnecessary files and optimize the local repository')
        [CompletionResult]::new('gitk', 'gitk', [CompletionResultType]::ParameterName, 'The Git repository browser')
        [CompletionResult]::new('grep', 'grep', [CompletionResultType]::ParameterName, 'Print lines matching a pattern')
        [CompletionResult]::new('gui', 'gui', [CompletionResultType]::ParameterName, 'A portable graphical interface to Git')
        [CompletionResult]::new('init', 'init', [CompletionResultType]::ParameterName, 'Create an empty Git repository or reinitialize an existing one')
        [CompletionResult]::new('log', 'log', [CompletionResultType]::ParameterName, 'Show commit logs')
        [CompletionResult]::new('maintenance', 'maintenance', [CompletionResultType]::ParameterName, 'Run tasks to optimize Git repository data')
        [CompletionResult]::new('merge', 'merge', [CompletionResultType]::ParameterName, 'Join two or more development histories together')
        [CompletionResult]::new('mv', 'mv', [CompletionResultType]::ParameterName, 'Move or rename a file, a directory, or a symlink')
        [CompletionResult]::new('notes', 'notes', [CompletionResultType]::ParameterName, 'Add or inspect object notes')
        [CompletionResult]::new('pull', 'pull', [CompletionResultType]::ParameterName, 'Fetch from and integrate with another repository or a local branch')
        [CompletionResult]::new('push', 'push', [CompletionResultType]::ParameterName, 'Update remote refs along with associated objects')
        [CompletionResult]::new('range-diff', 'range-diff', [CompletionResultType]::ParameterName, 'Compare two commit ranges (e.g. two versions of a branch)')
        [CompletionResult]::new('rebase', 'rebase', [CompletionResultType]::ParameterName, 'Reapply commits on top of another base tip')
        [CompletionResult]::new('reset', 'reset', [CompletionResultType]::ParameterName, 'Reset current HEAD to the specified state')
        [CompletionResult]::new('restore', 'restore', [CompletionResultType]::ParameterName, 'Restore working tree files')
        [CompletionResult]::new('revert', 'revert', [CompletionResultType]::ParameterName, 'Revert some existing commits')
        [CompletionResult]::new('rm', 'rm', [CompletionResultType]::ParameterName, 'Remove files from the working tree and from the index')
        [CompletionResult]::new('scalar', 'scalar', [CompletionResultType]::ParameterName, 'A tool for managing large Git repositories')
        [CompletionResult]::new('shortlog', 'shortlog', [CompletionResultType]::ParameterName, "Summarize 'git log' output")
        [CompletionResult]::new('show', 'show', [CompletionResultType]::ParameterName, 'Show various types of objects')
        [CompletionResult]::new('sparse-checkout', 'sparse-checkout', [CompletionResultType]::ParameterName, 'Reduce your working tree to a subset of tracked files')
        [CompletionResult]::new('stash', 'stash', [CompletionResultType]::ParameterName, 'Stash the changes in a dirty working directory away')
        [CompletionResult]::new('status', 'status', [CompletionResultType]::ParameterName, 'Show the working tree status')
        [CompletionResult]::new('submodule', 'submodule', [CompletionResultType]::ParameterName, 'Initialize, update or inspect submodules')
        [CompletionResult]::new('switch', 'switch', [CompletionResultType]::ParameterName, 'Switch branches')
        [CompletionResult]::new('tag', 'tag', [CompletionResultType]::ParameterName, 'Create, list, delete or verify a tag object signed with GPG')
        [CompletionResult]::new('worktree', 'worktree', [CompletionResultType]::ParameterName, 'Manage multiple working trees')
        [CompletionResult]::new('config', 'config', [CompletionResultType]::ParameterName, 'Get and set repository or global options')
        [CompletionResult]::new('fast-export', 'fast-export', [CompletionResultType]::ParameterName, 'Git data exporter')
        [CompletionResult]::new('fast-import', 'fast-import', [CompletionResultType]::ParameterName, 'Backend for fast Git data importers')
        [CompletionResult]::new('filter-branch', 'filter-branch', [CompletionResultType]::ParameterName, 'Rewrite branches')
        [CompletionResult]::new('mergetool', 'mergetool', [CompletionResultType]::ParameterName, 'Run merge conflict resolution tools to resolve merge conflicts')
        [CompletionResult]::new('pack-refs', 'pack-refs', [CompletionResultType]::ParameterName, 'Pack heads and tags for efficient repository access')
        [CompletionResult]::new('prune', 'prune', [CompletionResultType]::ParameterName, 'Prune all unreachable objects from the object database')
        [CompletionResult]::new('reflog', 'reflog', [CompletionResultType]::ParameterName, 'Manage reflog information')
        [CompletionResult]::new('refs', 'refs', [CompletionResultType]::ParameterName, 'Low-level access to refs')
        [CompletionResult]::new('remote', 'remote', [CompletionResultType]::ParameterName, 'Manage set of tracked repositories')
        [CompletionResult]::new('repack', 'repack', [CompletionResultType]::ParameterName, 'Pack unpacked objects in a repository')
        [CompletionResult]::new('replace', 'replace', [CompletionResultType]::ParameterName, 'Create, list, delete refs to replace objects')
        [CompletionResult]::new('annotate', 'annotate', [CompletionResultType]::ParameterName, 'Annotate file lines with commit information')
        [CompletionResult]::new('blame', 'blame', [CompletionResultType]::ParameterName, 'Show what revision and author last modified each line of a file')
        [CompletionResult]::new('bugreport', 'bugreport', [CompletionResultType]::ParameterName, 'Collect information for user to file a bug report')
        [CompletionResult]::new('count-objects', 'count-objects', [CompletionResultType]::ParameterName, 'Count unpacked number of objects and their disk consumption')
        [CompletionResult]::new('diagnose', 'diagnose', [CompletionResultType]::ParameterName, 'Generate a zip archive of diagnostic information')
        [CompletionResult]::new('difftool', 'difftool', [CompletionResultType]::ParameterName, 'Show changes using common diff tools')
        [CompletionResult]::new('fsck', 'fsck', [CompletionResultType]::ParameterName, 'Verifies the connectivity and validity of the objects in the database')
        [CompletionResult]::new('gitweb', 'gitweb', [CompletionResultType]::ParameterName, 'Git web interface (web frontend to Git repositories)')
        [CompletionResult]::new('help', 'help', [CompletionResultType]::ParameterName, 'Display help information about Git')
        [CompletionResult]::new('instaweb', 'instaweb', [CompletionResultType]::ParameterName, 'Instantly browse your working repository in gitweb')
        [CompletionResult]::new('merge-tree', 'merge-tree', [CompletionResultType]::ParameterName, 'Perform merge without touching index or working tree')
        [CompletionResult]::new('rerere', 'rerere', [CompletionResultType]::ParameterName, 'Reuse recorded resolution of conflicted merges')
        [CompletionResult]::new('show-branch', 'show-branch', [CompletionResultType]::ParameterName, 'Show branches and their commits')
        [CompletionResult]::new('verify-commit', 'verify-commit', [CompletionResultType]::ParameterName, 'Check the GPG signature of commits')
        [CompletionResult]::new('verify-tag', 'verify-tag', [CompletionResultType]::ParameterName, 'Check the GPG signature of tags')
        [CompletionResult]::new('version', 'version', [CompletionResultType]::ParameterName, 'Display version information about Git')
        [CompletionResult]::new('whatchanged', 'whatchanged', [CompletionResultType]::ParameterName, 'Show logs with differences each commit introduces')
        [CompletionResult]::new('archimport', 'archimport', [CompletionResultType]::ParameterName, 'Import a GNU Arch repository into Git')
        [CompletionResult]::new('cvsexportcommit', 'cvsexportcommit', [CompletionResultType]::ParameterName, 'Export a single commit to a CVS checkout')
        [CompletionResult]::new('cvsimport', 'cvsimport', [CompletionResultType]::ParameterName, 'Salvage your data out of another SCM people love to hate')
        [CompletionResult]::new('cvsserver', 'cvsserver', [CompletionResultType]::ParameterName, 'A CVS server emulator for Git')
        [CompletionResult]::new('imap-send', 'imap-send', [CompletionResultType]::ParameterName, 'Send a collection of patches from stdin to an IMAP folder')
        [CompletionResult]::new('p4', 'p4', [CompletionResultType]::ParameterName, 'Import from and submit to Perforce repositories')
        [CompletionResult]::new('quiltimport', 'quiltimport', [CompletionResultType]::ParameterName, 'Applies a quilt patchset onto the current branch')
        [CompletionResult]::new('request-pull', 'request-pull', [CompletionResultType]::ParameterName, 'Generates a summary of pending changes')
        [CompletionResult]::new('send-email', 'send-email', [CompletionResultType]::ParameterName, 'Send a collection of patches as emails')
        [CompletionResult]::new('svn', 'svn', [CompletionResultType]::ParameterName, 'Bidirectional operation between a Subversion repository and Git')
        [CompletionResult]::new('apply', 'apply', [CompletionResultType]::ParameterName, 'Apply a patch to files and/or to the index')
        [CompletionResult]::new('checkout-index', 'checkout-index', [CompletionResultType]::ParameterName, 'Copy files from the index to the working tree')
        [CompletionResult]::new('commit-graph', 'commit-graph', [CompletionResultType]::ParameterName, 'Write and verify Git commit-graph files')
        [CompletionResult]::new('commit-tree', 'commit-tree', [CompletionResultType]::ParameterName, 'Create a new commit object')
        [CompletionResult]::new('hash-object', 'hash-object', [CompletionResultType]::ParameterName, 'Compute object ID and optionally create an object from a file')
        [CompletionResult]::new('index-pack', 'index-pack', [CompletionResultType]::ParameterName, 'Build pack index file for an existing packed archive')
        [CompletionResult]::new('merge-file', 'merge-file', [CompletionResultType]::ParameterName, 'Run a three-way file merge')
        [CompletionResult]::new('merge-index', 'merge-index', [CompletionResultType]::ParameterName, 'Run a merge for files needing merging')
        [CompletionResult]::new('mktag', 'mktag', [CompletionResultType]::ParameterName, 'Creates a tag object with extra validation')
        [CompletionResult]::new('mktree', 'mktree', [CompletionResultType]::ParameterName, 'Build a tree-object from ls-tree formatted text')
        [CompletionResult]::new('multi-pack-index', 'multi-pack-index', [CompletionResultType]::ParameterName, 'Write and verify multi-pack-indexes')
        [CompletionResult]::new('pack-objects', 'pack-objects', [CompletionResultType]::ParameterName, 'Create a packed archive of objects')
        [CompletionResult]::new('prune-packed', 'prune-packed', [CompletionResultType]::ParameterName, 'Remove extra objects that are already in pack files')
        [CompletionResult]::new('read-tree', 'read-tree', [CompletionResultType]::ParameterName, 'Reads tree information into the index')
        [CompletionResult]::new('replay', 'replay', [CompletionResultType]::ParameterName, 'EXPERIMENTAL: Replay commits on a new base, works with bare repos too')
        [CompletionResult]::new('symbolic-ref', 'symbolic-ref', [CompletionResultType]::ParameterName, 'Read, modify and delete symbolic refs')
        [CompletionResult]::new('unpack-objects', 'unpack-objects', [CompletionResultType]::ParameterName, 'Unpack objects from a packed archive')
        [CompletionResult]::new('update-index', 'update-index', [CompletionResultType]::ParameterName, 'Register file contents in the working tree to the index')
        [CompletionResult]::new('update-ref', 'update-ref', [CompletionResultType]::ParameterName, 'Update the object name stored in a ref safely')
        [CompletionResult]::new('write-tree', 'write-tree', [CompletionResultType]::ParameterName, 'Create a tree object from the current index')
        [CompletionResult]::new('cat-file', 'cat-file', [CompletionResultType]::ParameterName, 'Provide contents or details of repository objects')
        [CompletionResult]::new('cherry', 'cherry', [CompletionResultType]::ParameterName, 'Find commits yet to be applied to upstream')
        [CompletionResult]::new('diff-files', 'diff-files', [CompletionResultType]::ParameterName, 'Compares files in the working tree and the index')
        [CompletionResult]::new('diff-index', 'diff-index', [CompletionResultType]::ParameterName, 'Compare a tree to the working tree or index')
        [CompletionResult]::new('diff-tree', 'diff-tree', [CompletionResultType]::ParameterName, 'Compares the content and mode of blobs found via two tree objects')
        [CompletionResult]::new('for-each-ref', 'for-each-ref', [CompletionResultType]::ParameterName, 'Output information on each ref')
        [CompletionResult]::new('for-each-repo', 'for-each-repo', [CompletionResultType]::ParameterName, 'Run a Git command on a list of repositories')
        [CompletionResult]::new('get-tar-commit-id', 'get-tar-commit-id', [CompletionResultType]::ParameterName, 'Extract commit ID from an archive created using git-archive')
        [CompletionResult]::new('ls-files', 'ls-files', [CompletionResultType]::ParameterName, 'Show information about files in the index and the working tree')
        [CompletionResult]::new('ls-remote', 'ls-remote', [CompletionResultType]::ParameterName, 'List references in a remote repository')
        [CompletionResult]::new('ls-tree', 'ls-tree', [CompletionResultType]::ParameterName, 'List the contents of a tree object')
        [CompletionResult]::new('merge-base', 'merge-base', [CompletionResultType]::ParameterName, 'Find as good common ancestors as possible for a merge')
        [CompletionResult]::new('name-rev', 'name-rev', [CompletionResultType]::ParameterName, 'Find symbolic names for given revs')
        [CompletionResult]::new('pack-redundant', 'pack-redundant', [CompletionResultType]::ParameterName, 'Find redundant pack files')
        [CompletionResult]::new('rev-list', 'rev-list', [CompletionResultType]::ParameterName, 'Lists commit objects in reverse chronological order')
        [CompletionResult]::new('rev-parse', 'rev-parse', [CompletionResultType]::ParameterName, 'Pick out and massage parameters')
        [CompletionResult]::new('show-index', 'show-index', [CompletionResultType]::ParameterName, 'Show packed archive index')
        [CompletionResult]::new('show-ref', 'show-ref', [CompletionResultType]::ParameterName, 'List references in a local repository')
        [CompletionResult]::new('unpack-file', 'unpack-file', [CompletionResultType]::ParameterName, "Creates a temporary file with a blob's contents")
        [CompletionResult]::new('var', 'var', [CompletionResultType]::ParameterName, 'Show a Git logical variable')
        [CompletionResult]::new('verify-pack', 'verify-pack', [CompletionResultType]::ParameterName, 'Validate packed Git archive files')
        [CompletionResult]::new('daemon', 'daemon', [CompletionResultType]::ParameterName, 'A really simple server for Git repositories')
        [CompletionResult]::new('fetch-pack', 'fetch-pack', [CompletionResultType]::ParameterName, 'Receive missing objects from another repository')
        [CompletionResult]::new('http-backend', 'http-backend', [CompletionResultType]::ParameterName, 'Server side implementation of Git over HTTP')
        [CompletionResult]::new('send-pack', 'send-pack', [CompletionResultType]::ParameterName, 'Push objects over Git protocol to another repository')
        [CompletionResult]::new('update-server-info', 'update-server-info', [CompletionResultType]::ParameterName, 'Update auxiliary info file to help dumb servers')
        [CompletionResult]::new('check-attr', 'check-attr', [CompletionResultType]::ParameterName, 'Display gitattributes information')
        [CompletionResult]::new('check-ignore', 'check-ignore', [CompletionResultType]::ParameterName, 'Debug gitignore / exclude files')
        [CompletionResult]::new('check-mailmap', 'check-mailmap', [CompletionResultType]::ParameterName, 'Show canonical names and email addresses of contacts')
        [CompletionResult]::new('check-ref-format', 'check-ref-format', [CompletionResultType]::ParameterName, 'Ensures that a reference name is well formed')
        [CompletionResult]::new('column', 'column', [CompletionResultType]::ParameterName, 'Display data in columns')
        [CompletionResult]::new('credential', 'credential', [CompletionResultType]::ParameterName, 'Retrieve and store user credentials')
        [CompletionResult]::new('credential-cache', 'credential-cache', [CompletionResultType]::ParameterName, 'Helper to temporarily store passwords in memory')
        [CompletionResult]::new('credential-store', 'credential-store', [CompletionResultType]::ParameterName, 'Helper to store credentials on disk')
        [CompletionResult]::new('fmt-merge-msg', 'fmt-merge-msg', [CompletionResultType]::ParameterName, 'Produce a merge commit message')
        [CompletionResult]::new('hook', 'hook', [CompletionResultType]::ParameterName, 'Run git hooks')
        [CompletionResult]::new('interpret-trailers', 'interpret-trailers', [CompletionResultType]::ParameterName, 'Add or parse structured information in commit messages')
        [CompletionResult]::new('mailinfo', 'mailinfo', [CompletionResultType]::ParameterName, 'Extracts patch and authorship from a single e-mail message')
        [CompletionResult]::new('mailsplit', 'mailsplit', [CompletionResultType]::ParameterName, 'Simple UNIX mbox splitter program')
        [CompletionResult]::new('merge-one-file', 'merge-one-file', [CompletionResultType]::ParameterName, 'The standard helper program to use with git-merge-index')
        [CompletionResult]::new('patch-id', 'patch-id', [CompletionResultType]::ParameterName, 'Compute unique ID for a patch')
        [CompletionResult]::new('sh-i18n', 'sh-i18n', [CompletionResultType]::ParameterName, "Git's i18n setup code for shell scripts")
        [CompletionResult]::new('sh-setup', 'sh-setup', [CompletionResultType]::ParameterName, 'Common Git shell script setup code')
        [CompletionResult]::new('stripspace', 'stripspace', [CompletionResultType]::ParameterName, 'Remove unnecessary whitespace')
        [CompletionResult]::new('attributes', 'attributes', [CompletionResultType]::ParameterName, 'Defining attributes per path')
        [CompletionResult]::new('cli', 'cli', [CompletionResultType]::ParameterName, 'Git command-line interface and conventions')
        [CompletionResult]::new('hooks', 'hooks', [CompletionResultType]::ParameterName, 'Hooks used by Git')
        [CompletionResult]::new('ignore', 'ignore', [CompletionResultType]::ParameterName, 'Specifies intentionally untracked files to ignore')
        [CompletionResult]::new('mailmap', 'mailmap', [CompletionResultType]::ParameterName, 'Map author/committer names and/or E-Mail addresses')
        [CompletionResult]::new('modules', 'modules', [CompletionResultType]::ParameterName, 'Defining submodule properties')
        [CompletionResult]::new('repository-layout', 'repository-layout', [CompletionResultType]::ParameterName, 'Git Repository Layout')
        [CompletionResult]::new('revisions', 'revisions', [CompletionResultType]::ParameterName, 'Specifying revisions and ranges for Git')
        [CompletionResult]::new('format-bundle', 'format-bundle', [CompletionResultType]::ParameterName, 'The bundle file format')
        [CompletionResult]::new('format-chunk', 'format-chunk', [CompletionResultType]::ParameterName, 'Chunk-based file formats')
        [CompletionResult]::new('format-commit-graph', 'format-commit-graph', [CompletionResultType]::ParameterName, 'Git commit-graph format')
        [CompletionResult]::new('format-index', 'format-index', [CompletionResultType]::ParameterName, 'Git index format')
        [CompletionResult]::new('format-pack', 'format-pack', [CompletionResultType]::ParameterName, 'Git pack format')
        [CompletionResult]::new('format-signature', 'format-signature', [CompletionResultType]::ParameterName, 'Git cryptographic signature formats')
        [CompletionResult]::new('protocol-capabilities', 'protocol-capabilities', [CompletionResultType]::ParameterName, 'Protocol v0 and v1 capabilities')
        [CompletionResult]::new('protocol-common', 'protocol-common', [CompletionResultType]::ParameterName, 'Things common to various protocols')
        [CompletionResult]::new('protocol-http', 'protocol-http', [CompletionResultType]::ParameterName, 'Git HTTP-based protocols')
        [CompletionResult]::new('protocol-pack', 'protocol-pack', [CompletionResultType]::ParameterName, 'How packs are transferred over-the-wire')
        [CompletionResult]::new('protocol-v2', 'protocol-v2', [CompletionResultType]::ParameterName, 'Git Wire Protocol, Version 2')
        [CompletionResult]::new('askpass', 'askpass', [CompletionResultType]::ParameterName, 'unknown')
        [CompletionResult]::new('askyesno', 'askyesno', [CompletionResultType]::ParameterName, 'unknown')
        [CompletionResult]::new('credential-helper-selector', 'credential-helper-selector', [CompletionResultType]::ParameterName, 'unknown')
        [CompletionResult]::new('credential-manager', 'credential-manager', [CompletionResultType]::ParameterName, 'unknown')
        [CompletionResult]::new('flow', 'flow', [CompletionResultType]::ParameterName, 'unknown')
        [CompletionResult]::new('lfs', 'lfs', [CompletionResultType]::ParameterName, 'unknown')
        [CompletionResult]::new('update-git-for-windows', 'update-git-for-windows', [CompletionResultType]::ParameterName, 'unknown')
        [CompletionResult]::new('git-lfs-checkout(1)', 'git-lfs-checkout(1)', [CompletionResultType]::ParameterName, 'Populate working copy with real content from Git LFS files')
        [CompletionResult]::new('git-lfs-completion(1)', 'git-lfs-completion(1)', [CompletionResultType]::ParameterName, 'Generate shell scripts for command-line tab-completion of Git LFS commands')
        [CompletionResult]::new('git-lfs-dedup(1)', 'git-lfs-dedup(1)', [CompletionResultType]::ParameterName, 'De-duplicate Git LFS files')
        [CompletionResult]::new('git-lfs-env(1)', 'git-lfs-env(1)', [CompletionResultType]::ParameterName, 'Display the Git LFS environment')
        [CompletionResult]::new('git-lfs-ext(1)', 'git-lfs-ext(1)', [CompletionResultType]::ParameterName, 'Display Git LFS extension details')
        [CompletionResult]::new('git-lfs-fetch(1)', 'git-lfs-fetch(1)', [CompletionResultType]::ParameterName, 'Download Git LFS files from a remote')
        [CompletionResult]::new('git-lfs-fsck(1)', 'git-lfs-fsck(1)', [CompletionResultType]::ParameterName, 'Check Git LFS files for consistency')
        [CompletionResult]::new('git-lfs-install(1)', 'git-lfs-install(1)', [CompletionResultType]::ParameterName, 'Install Git LFS configuration')
        [CompletionResult]::new('git-lfs-lock(1)', 'git-lfs-lock(1)', [CompletionResultType]::ParameterName, 'Set a file as "locked" on the Git LFS server')
        [CompletionResult]::new('git-lfs-locks(1)', 'git-lfs-locks(1)', [CompletionResultType]::ParameterName, 'List currently "locked" files from the Git LFS server')
        [CompletionResult]::new('git-lfs-logs(1)', 'git-lfs-logs(1)', [CompletionResultType]::ParameterName, 'Show errors from the Git LFS command')
        [CompletionResult]::new('git-lfs-ls-files(1)', 'git-lfs-ls-files(1)', [CompletionResultType]::ParameterName, 'Show information about Git LFS files in the index and working tree')
        [CompletionResult]::new('git-lfs-migrate(1)', 'git-lfs-migrate(1)', [CompletionResultType]::ParameterName, 'Migrate history to or from Git LFS')
        [CompletionResult]::new('git-lfs-prune(1)', 'git-lfs-prune(1)', [CompletionResultType]::ParameterName, 'Delete old Git LFS files from local storage')
        [CompletionResult]::new('git-lfs-pull(1)', 'git-lfs-pull(1)', [CompletionResultType]::ParameterName, 'Fetch Git LFS changes from the remote & checkout any required working tree files')
        [CompletionResult]::new('git-lfs-push(1)', 'git-lfs-push(1)', [CompletionResultType]::ParameterName, 'Push queued large files to the Git LFS endpoint')
        [CompletionResult]::new('git-lfs-status(1)', 'git-lfs-status(1)', [CompletionResultType]::ParameterName, 'Show the status of Git LFS files in the working tree')
        [CompletionResult]::new('git-lfs-track(1)', 'git-lfs-track(1)', [CompletionResultType]::ParameterName, 'View or add Git LFS paths to Git attributes')
        [CompletionResult]::new('git-lfs-uninstall(1)', 'git-lfs-uninstall(1)', [CompletionResultType]::ParameterName, 'Uninstall Git LFS by removing hooks and smudge/clean filter configuration')
        [CompletionResult]::new('git-lfs-unlock(1)', 'git-lfs-unlock(1)', [CompletionResultType]::ParameterName, 'Remove "locked" setting for a file on the Git LFS server')
        [CompletionResult]::new('git-lfs-untrack(1)', 'git-lfs-untrack(1)', [CompletionResultType]::ParameterName, 'Remove Git LFS paths from Git Attributes')
        [CompletionResult]::new('git-lfs-update(1)', 'git-lfs-update(1)', [CompletionResultType]::ParameterName, 'Update Git hooks for the current Git repository')
        [CompletionResult]::new('git-lfs-version(1)', 'git-lfs-version(1)', [CompletionResultType]::ParameterName, 'Report the version number')
        break
      }
      'add' {
        if ($wordToComplete.StartsWith('-')) {
          [CompletionResult]::new('<pathspec>…​', '<pathspec>…​', [CompletionResultType]::ParameterName, 'Files to add content from')
          [CompletionResult]::new('-n', '-n', [CompletionResultType]::ParameterName, "Don't actually add the file(s), just show if they exist and/or will be ignored")
          [CompletionResult]::new('--dry-run', '--dry-run', [CompletionResultType]::ParameterName, "Don't actually add the file(s), just show if they exist and/or will be ignored")
          [CompletionResult]::new('-v', '-v', [CompletionResultType]::ParameterName, 'Be verbose')
          [CompletionResult]::new('--verbose', '--verbose', [CompletionResultType]::ParameterName, 'Be verbose')
          [CompletionResult]::new('-f', '-f', [CompletionResultType]::ParameterName, 'Allow adding otherwise ignored files')
          [CompletionResult]::new('--force', '--force', [CompletionResultType]::ParameterName, 'Allow adding otherwise ignored files')
          [CompletionResult]::new('--sparse', '--sparse', [CompletionResultType]::ParameterName, 'Allow updating index entries outside of the sparse-checkout cone')
          [CompletionResult]::new('-i', '-i', [CompletionResultType]::ParameterName, 'Add modified contents in the working tree interactively to the index')
          [CompletionResult]::new('--interactive', '--interactive', [CompletionResultType]::ParameterName, 'Add modified contents in the working tree interactively to the index')
          [CompletionResult]::new('-p', '-p', [CompletionResultType]::ParameterName, 'Interactively choose hunks of patch between the index and the work tree and add them to the index')
          [CompletionResult]::new('--patch', '--patch', [CompletionResultType]::ParameterName, 'Interactively choose hunks of patch between the index and the work tree and add them to the index')
          [CompletionResult]::new('-e', '-e', [CompletionResultType]::ParameterName, 'Open the diff vs')
          [CompletionResult]::new('--edit', '--edit', [CompletionResultType]::ParameterName, 'Open the diff vs')
          [CompletionResult]::new('-u', '-u', [CompletionResultType]::ParameterName, 'Update the index just where it already has an entry matching <pathspec>')
          [CompletionResult]::new('--update', '--update', [CompletionResultType]::ParameterName, 'Update the index just where it already has an entry matching <pathspec>')
          [CompletionResult]::new('-A', '-A', [CompletionResultType]::ParameterName, 'Update the index not only where the working tree has a file matching <pathspec> but also where the index already has an entry')
          [CompletionResult]::new('--all', '--all', [CompletionResultType]::ParameterName, 'Update the index not only where the working tree has a file matching <pathspec> but also where the index already has an entry')
          [CompletionResult]::new('--no-ignore-removal', '--no-ignore-removal', [CompletionResultType]::ParameterName, 'Update the index not only where the working tree has a file matching <pathspec> but also where the index already has an entry')
          [CompletionResult]::new('--no-all', '--no-all', [CompletionResultType]::ParameterName, 'Update the index by adding new files that are unknown to the index and files modified in the working tree, but ignore files that have been removed from the working tree')
          [CompletionResult]::new('--ignore-removal', '--ignore-removal', [CompletionResultType]::ParameterName, 'Update the index by adding new files that are unknown to the index and files modified in the working tree, but ignore files that have been removed from the working tree')
          [CompletionResult]::new('-N', '-N', [CompletionResultType]::ParameterName, 'Record only the fact that the path will be added later')
          [CompletionResult]::new('--intent-to-add', '--intent-to-add', [CompletionResultType]::ParameterName, 'Record only the fact that the path will be added later')
          [CompletionResult]::new('--refresh', '--refresh', [CompletionResultType]::ParameterName, "Don't add the file(s), but only refresh their stat() information in the index")
          [CompletionResult]::new('--ignore-errors', '--ignore-errors', [CompletionResultType]::ParameterName, 'If some files could not be added because of errors indexing them, do not abort the operation, but continue adding the others')
          [CompletionResult]::new('--ignore-missing', '--ignore-missing', [CompletionResultType]::ParameterName, 'This option can only be used together with --dry-run')
          [CompletionResult]::new('--no-warn-embedded-repo', '--no-warn-embedded-repo', [CompletionResultType]::ParameterName, 'By default, git add will warn when adding an embedded repository to the index without using git submodule add to create an entry in')
          [CompletionResult]::new('--renormalize', '--renormalize', [CompletionResultType]::ParameterName, 'Apply the "clean" process freshly to all tracked files to forcibly add them again to the index')
          [CompletionResult]::new('--chmod=(+|-)x', '--chmod=(+|-)x', [CompletionResultType]::ParameterName, 'Override the executable bit of the added files')
          [CompletionResult]::new('--pathspec-from-file=<file>', '--pathspec-from-file=<file>', [CompletionResultType]::ParameterName, 'Pathspec is passed in <file> instead of commandline args')
          [CompletionResult]::new('--pathspec-file-nul', '--pathspec-file-nul', [CompletionResultType]::ParameterName, 'Only meaningful with --pathspec-from-file')
          [CompletionResult]::new('--', '--', [CompletionResultType]::ParameterName, 'This option can be used to separate command-line options from the list of files, (useful when filenames might be mistaken for command-line options)')
        }
        break
      }
      'remote' {
        if ($wordToComplete.StartsWith('-')) {
        }
        break
      }
      'am' {
        if ($wordToComplete.StartsWith('-')) {
          [CompletionResult]::new('(<mbox>|<Maildir>)…​', '(<mbox>|<Maildir>)…​', [CompletionResultType]::ParameterName, 'The list of mailbox files to read patches from')
          [CompletionResult]::new('-s', '-s', [CompletionResultType]::ParameterName, 'Add a Signed-off-by trailer to the commit message, using the committer identity of yourself')
          [CompletionResult]::new('--signoff', '--signoff', [CompletionResultType]::ParameterName, 'Add a Signed-off-by trailer to the commit message, using the committer identity of yourself')
          [CompletionResult]::new('-k', '-k', [CompletionResultType]::ParameterName, 'Pass -k flag to git mailinfo (see git-mailinfo(1))')
          [CompletionResult]::new('--keep', '--keep', [CompletionResultType]::ParameterName, 'Pass -k flag to git mailinfo (see git-mailinfo(1))')
          [CompletionResult]::new('--keep-non-patch', '--keep-non-patch', [CompletionResultType]::ParameterName, 'Pass -b flag to git mailinfo (see git-mailinfo(1))')
          [CompletionResult]::new('--[no-]keep-cr', '--[no-]keep-cr', [CompletionResultType]::ParameterName, 'With --keep-cr, call git mailsplit (see git-mailsplit(1)) with the same option, to prevent it from stripping CR at the end of lines')
          [CompletionResult]::new('-c', '-c', [CompletionResultType]::ParameterName, 'Remove everything in body before a scissors line (see git-mailinfo(1))')
          [CompletionResult]::new('--scissors', '--scissors', [CompletionResultType]::ParameterName, 'Remove everything in body before a scissors line (see git-mailinfo(1))')
          [CompletionResult]::new('--no-scissors', '--no-scissors', [CompletionResultType]::ParameterName, 'Ignore scissors lines (see git-mailinfo(1))')
          [CompletionResult]::new('--quoted-cr=<action>', '--quoted-cr=<action>', [CompletionResultType]::ParameterName, 'This flag will be passed down to git mailinfo (see git-mailinfo(1))')
          [CompletionResult]::new('--empty=(drop|keep|stop)', '--empty=(drop|keep|stop)', [CompletionResultType]::ParameterName, 'How to handle an e-mail message lacking a patch:     drop  The e-mail message will be skipped')
          [CompletionResult]::new('-m', '-m', [CompletionResultType]::ParameterName, 'Pass the -m flag to git mailinfo (see git-mailinfo(1)), so that the Message-ID header is added to the commit message')
          [CompletionResult]::new('--message-id', '--message-id', [CompletionResultType]::ParameterName, 'Pass the -m flag to git mailinfo (see git-mailinfo(1)), so that the Message-ID header is added to the commit message')
          [CompletionResult]::new('--no-message-id', '--no-message-id', [CompletionResultType]::ParameterName, 'Do not add the Message-ID header to the commit message')
          [CompletionResult]::new('-q', '-q', [CompletionResultType]::ParameterName, 'Be quiet')
          [CompletionResult]::new('--quiet', '--quiet', [CompletionResultType]::ParameterName, 'Be quiet')
          [CompletionResult]::new('-u', '-u', [CompletionResultType]::ParameterName, 'Pass -u flag to git mailinfo (see git-mailinfo(1))')
          [CompletionResult]::new('--utf8', '--utf8', [CompletionResultType]::ParameterName, 'Pass -u flag to git mailinfo (see git-mailinfo(1))')
          [CompletionResult]::new('--no-utf8', '--no-utf8', [CompletionResultType]::ParameterName, 'Pass -n flag to git mailinfo (see git-mailinfo(1))')
          [CompletionResult]::new('-3', '-3', [CompletionResultType]::ParameterName, 'When the patch does not apply cleanly, fall back on 3-way merge if the patch records the identity of blobs it is supposed to apply to and we have those blobs available locally')
          [CompletionResult]::new('--3way', '--3way', [CompletionResultType]::ParameterName, 'When the patch does not apply cleanly, fall back on 3-way merge if the patch records the identity of blobs it is supposed to apply to and we have those blobs available locally')
          [CompletionResult]::new('--no-3way', '--no-3way', [CompletionResultType]::ParameterName, 'When the patch does not apply cleanly, fall back on 3-way merge if the patch records the identity of blobs it is supposed to apply to and we have those blobs available locally')
          [CompletionResult]::new('--rerere-autoupdate', '--rerere-autoupdate', [CompletionResultType]::ParameterName, 'After the rerere mechanism reuses a recorded resolution on the current conflict to update the files in the working tree, allow it to also update the index with the result of resolution')
          [CompletionResult]::new('--no-rerere-autoupdate', '--no-rerere-autoupdate', [CompletionResultType]::ParameterName, 'After the rerere mechanism reuses a recorded resolution on the current conflict to update the files in the working tree, allow it to also update the index with the result of resolution')
          [CompletionResult]::new('--ignore-space-change', '--ignore-space-change', [CompletionResultType]::ParameterName, 'These flags are passed to the git apply (see git-apply(1)) program that applies the patch')
          [CompletionResult]::new('--ignore-whitespace', '--ignore-whitespace', [CompletionResultType]::ParameterName, 'These flags are passed to the git apply (see git-apply(1)) program that applies the patch')
          [CompletionResult]::new('--whitespace=<action>', '--whitespace=<action>', [CompletionResultType]::ParameterName, 'These flags are passed to the git apply (see git-apply(1)) program that applies the patch')
          [CompletionResult]::new('-C<n>', '-C<n>', [CompletionResultType]::ParameterName, 'These flags are passed to the git apply (see git-apply(1)) program that applies the patch')
          [CompletionResult]::new('-p<n>', '-p<n>', [CompletionResultType]::ParameterName, 'These flags are passed to the git apply (see git-apply(1)) program that applies the patch')
          [CompletionResult]::new('--directory=<dir>', '--directory=<dir>', [CompletionResultType]::ParameterName, 'These flags are passed to the git apply (see git-apply(1)) program that applies the patch')
          [CompletionResult]::new('--exclude=<path>', '--exclude=<path>', [CompletionResultType]::ParameterName, 'These flags are passed to the git apply (see git-apply(1)) program that applies the patch')
          [CompletionResult]::new('--include=<path>', '--include=<path>', [CompletionResultType]::ParameterName, 'These flags are passed to the git apply (see git-apply(1)) program that applies the patch')
          [CompletionResult]::new('--reject', '--reject', [CompletionResultType]::ParameterName, 'These flags are passed to the git apply (see git-apply(1)) program that applies the patch')
          [CompletionResult]::new('--patch-format', '--patch-format', [CompletionResultType]::ParameterName, 'By default the command will try to detect the patch format automatically')
          [CompletionResult]::new('-i', '-i', [CompletionResultType]::ParameterName, 'Run interactively')
          [CompletionResult]::new('--interactive', '--interactive', [CompletionResultType]::ParameterName, 'Run interactively')
          [CompletionResult]::new('-n', '-n', [CompletionResultType]::ParameterName, 'By default, the pre-applypatch and applypatch-msg hooks are run')
          [CompletionResult]::new('--no-verify', '--no-verify', [CompletionResultType]::ParameterName, 'By default, the pre-applypatch and applypatch-msg hooks are run')
          [CompletionResult]::new('--committer-date-is-author-date', '--committer-date-is-author-date', [CompletionResultType]::ParameterName, 'By default the command records the date from the e-mail message as the commit author date, and uses the time of commit creation as the committer date')
          [CompletionResult]::new('--ignore-date', '--ignore-date', [CompletionResultType]::ParameterName, 'By default the command records the date from the e-mail message as the commit author date, and uses the time of commit creation as the committer date')
          [CompletionResult]::new('--skip', '--skip', [CompletionResultType]::ParameterName, 'Skip the current patch')
          [CompletionResult]::new('-S[<keyid>]', '-S[<keyid>]', [CompletionResultType]::ParameterName, 'GPG-sign commits')
          [CompletionResult]::new('--gpg-sign[=<keyid>]', '--gpg-sign[=<keyid>]', [CompletionResultType]::ParameterName, 'GPG-sign commits')
          [CompletionResult]::new('--no-gpg-sign', '--no-gpg-sign', [CompletionResultType]::ParameterName, 'GPG-sign commits')
          [CompletionResult]::new('--continue', '--continue', [CompletionResultType]::ParameterName, 'After a patch failure (e')
          [CompletionResult]::new('-r', '-r', [CompletionResultType]::ParameterName, 'After a patch failure (e')
          [CompletionResult]::new('--resolved', '--resolved', [CompletionResultType]::ParameterName, 'After a patch failure (e')
          [CompletionResult]::new('--resolvemsg=<msg>', '--resolvemsg=<msg>', [CompletionResultType]::ParameterName, 'When a patch failure occurs, <msg> will be printed to the screen before exiting')
          [CompletionResult]::new('--abort', '--abort', [CompletionResultType]::ParameterName, 'Restore the original branch and abort the patching operation')
          [CompletionResult]::new('--quit', '--quit', [CompletionResultType]::ParameterName, 'Abort the patching operation but keep HEAD and the index untouched')
          [CompletionResult]::new('--retry', '--retry', [CompletionResultType]::ParameterName, 'Try to apply the last conflicting patch again')
          [CompletionResult]::new('--show-current-patch[=(diff|raw)]', '--show-current-patch[=(diff|raw)]', [CompletionResultType]::ParameterName, 'Show the message at which git am has stopped due to conflicts')
          [CompletionResult]::new('--allow-empty', '--allow-empty', [CompletionResultType]::ParameterName, 'After a patch failure on an input e-mail message lacking a patch, create an empty commit with the contents of the e-mail message as its log message')
        }
        break
      }
      'archive' {
        if ($wordToComplete.StartsWith('-')) {
          [CompletionResult]::new('--format=<fmt>', '--format=<fmt>', [CompletionResultType]::ParameterName, 'Format of the resulting archive')
          [CompletionResult]::new('-l', '-l', [CompletionResultType]::ParameterName, 'Show all available formats')
          [CompletionResult]::new('--list', '--list', [CompletionResultType]::ParameterName, 'Show all available formats')
          [CompletionResult]::new('-v', '-v', [CompletionResultType]::ParameterName, 'Report progress to stderr')
          [CompletionResult]::new('--verbose', '--verbose', [CompletionResultType]::ParameterName, 'Report progress to stderr')
          [CompletionResult]::new('--prefix=<prefix>/', '--prefix=<prefix>/', [CompletionResultType]::ParameterName, 'Prepend <prefix>/ to paths in the archive')
          [CompletionResult]::new('-o', '-o', [CompletionResultType]::ParameterName, 'Write the archive to <file> instead of stdout')
          [CompletionResult]::new('--output=<file>', '--output=<file>', [CompletionResultType]::ParameterName, 'Write the archive to <file> instead of stdout')
          [CompletionResult]::new('--add-file=<file>', '--add-file=<file>', [CompletionResultType]::ParameterName, 'Add a non-tracked file to the archive')
          [CompletionResult]::new('--add-virtual-file=<path>:<content>', '--add-virtual-file=<path>:<content>', [CompletionResultType]::ParameterName, 'Add the specified contents to the archive')
          [CompletionResult]::new('--worktree-attributes', '--worktree-attributes', [CompletionResultType]::ParameterName, 'Look for attributes in')
          [CompletionResult]::new('--mtime=<time>', '--mtime=<time>', [CompletionResultType]::ParameterName, 'Set modification time of archive entries')
          [CompletionResult]::new('<extra>', '<extra>', [CompletionResultType]::ParameterName, 'This can be any options that the archiver backend understands')
          [CompletionResult]::new('--remote=<repo>', '--remote=<repo>', [CompletionResultType]::ParameterName, 'Instead of making a tar archive from the local repository, retrieve a tar archive from a remote repository')
          [CompletionResult]::new('--exec=<git-upload-archive>', '--exec=<git-upload-archive>', [CompletionResultType]::ParameterName, 'Used with --remote to specify the path to the git-upload-archive on the remote side')
          [CompletionResult]::new('<tree-ish>', '<tree-ish>', [CompletionResultType]::ParameterName, 'The tree or commit to produce an archive for')
          [CompletionResult]::new('<path>', '<path>', [CompletionResultType]::ParameterName, 'Without an optional path parameter, all files and subdirectories of the current working directory are included in the archive')
        }
        break
      }
      'bisect' {
        if ($wordToComplete.StartsWith('-')) {
          [CompletionResult]::new('--no-checkout', '--no-checkout', [CompletionResultType]::ParameterName, 'Do not checkout the new working tree at each iteration of the bisection process')
          [CompletionResult]::new('--first-parent', '--first-parent', [CompletionResultType]::ParameterName, 'Follow only the first parent commit upon seeing a merge commit')
        }
        break
      }
      'branch' {
        if ($wordToComplete.StartsWith('-')) {
          [CompletionResult]::new('-d', '-d', [CompletionResultType]::ParameterName, 'Delete a branch')
          [CompletionResult]::new('--delete', '--delete', [CompletionResultType]::ParameterName, 'Delete a branch')
          [CompletionResult]::new('-D', '-D', [CompletionResultType]::ParameterName, 'Shortcut for --delete --force')
          [CompletionResult]::new('--create-reflog', '--create-reflog', [CompletionResultType]::ParameterName, "Create the branch's reflog")
          [CompletionResult]::new('-f', '-f', [CompletionResultType]::ParameterName, 'Reset <branchname> to <start-point>, even if <branchname> exists already')
          [CompletionResult]::new('--force', '--force', [CompletionResultType]::ParameterName, 'Reset <branchname> to <start-point>, even if <branchname> exists already')
          [CompletionResult]::new('-m', '-m', [CompletionResultType]::ParameterName, 'Move/rename a branch, together with its config and reflog')
          [CompletionResult]::new('--move', '--move', [CompletionResultType]::ParameterName, 'Move/rename a branch, together with its config and reflog')
          [CompletionResult]::new('-M', '-M', [CompletionResultType]::ParameterName, 'Shortcut for --move --force')
          [CompletionResult]::new('-c', '-c', [CompletionResultType]::ParameterName, 'Copy a branch, together with its config and reflog')
          [CompletionResult]::new('--copy', '--copy', [CompletionResultType]::ParameterName, 'Copy a branch, together with its config and reflog')
          [CompletionResult]::new('-C', '-C', [CompletionResultType]::ParameterName, 'Shortcut for --copy --force')
          [CompletionResult]::new('--color[=<when>]', '--color[=<when>]', [CompletionResultType]::ParameterName, 'Color branches to highlight current, local, and remote-tracking branches')
          [CompletionResult]::new('--no-color', '--no-color', [CompletionResultType]::ParameterName, 'Turn off branch colors, even when the configuration file gives the default to color output')
          [CompletionResult]::new('-i', '-i', [CompletionResultType]::ParameterName, 'Sorting and filtering branches are case insensitive')
          [CompletionResult]::new('--ignore-case', '--ignore-case', [CompletionResultType]::ParameterName, 'Sorting and filtering branches are case insensitive')
          [CompletionResult]::new('--omit-empty', '--omit-empty', [CompletionResultType]::ParameterName, 'Do not print a newline after formatted refs where the format expands to the empty string')
          [CompletionResult]::new('--column[=<options>]', '--column[=<options>]', [CompletionResultType]::ParameterName, 'Display branch listing in columns')
          [CompletionResult]::new('--no-column', '--no-column', [CompletionResultType]::ParameterName, 'Display branch listing in columns')
          [CompletionResult]::new('-r', '-r', [CompletionResultType]::ParameterName, 'List or delete (if used with -d) the remote-tracking branches')
          [CompletionResult]::new('--remotes', '--remotes', [CompletionResultType]::ParameterName, 'List or delete (if used with -d) the remote-tracking branches')
          [CompletionResult]::new('-a', '-a', [CompletionResultType]::ParameterName, 'List both remote-tracking branches and local branches')
          [CompletionResult]::new('--all', '--all', [CompletionResultType]::ParameterName, 'List both remote-tracking branches and local branches')
          [CompletionResult]::new('-l', '-l', [CompletionResultType]::ParameterName, 'List branches')
          [CompletionResult]::new('--list', '--list', [CompletionResultType]::ParameterName, 'List branches')
          [CompletionResult]::new('--show-current', '--show-current', [CompletionResultType]::ParameterName, 'Print the name of the current branch')
          [CompletionResult]::new('-v', '-v', [CompletionResultType]::ParameterName, 'When in list mode, show sha1 and commit subject line for each head, along with relationship to upstream branch (if any)')
          [CompletionResult]::new('-vv', '-vv', [CompletionResultType]::ParameterName, 'When in list mode, show sha1 and commit subject line for each head, along with relationship to upstream branch (if any)')
          [CompletionResult]::new('--verbose', '--verbose', [CompletionResultType]::ParameterName, 'When in list mode, show sha1 and commit subject line for each head, along with relationship to upstream branch (if any)')
          [CompletionResult]::new('-q', '-q', [CompletionResultType]::ParameterName, 'Be more quiet when creating or deleting a branch, suppressing non-error messages')
          [CompletionResult]::new('--quiet', '--quiet', [CompletionResultType]::ParameterName, 'Be more quiet when creating or deleting a branch, suppressing non-error messages')
          [CompletionResult]::new('--abbrev=<n>', '--abbrev=<n>', [CompletionResultType]::ParameterName, 'In the verbose listing that show the commit object name, show the shortest prefix that is at least <n> hexdigits long that uniquely refers the object')
          [CompletionResult]::new('--no-abbrev', '--no-abbrev', [CompletionResultType]::ParameterName, 'Display the full sha1s in the output listing rather than abbreviating them')
          [CompletionResult]::new('-t', '-t', [CompletionResultType]::ParameterName, 'When creating a new branch, set up branch')
          [CompletionResult]::new('--track[=(direct|inherit)]', '--track[=(direct|inherit)]', [CompletionResultType]::ParameterName, 'When creating a new branch, set up branch')
          [CompletionResult]::new('--no-track', '--no-track', [CompletionResultType]::ParameterName, 'Do not set up "upstream" configuration, even if the branch')
          [CompletionResult]::new('--recurse-submodules', '--recurse-submodules', [CompletionResultType]::ParameterName, 'THIS OPTION IS EXPERIMENTAL! Causes the current command to recurse into submodules if submodule')
          [CompletionResult]::new('--set-upstream', '--set-upstream', [CompletionResultType]::ParameterName, 'As this option had confusing syntax, it is no longer supported')
          [CompletionResult]::new('-u', '-u', [CompletionResultType]::ParameterName, "Set up <branchname>'s tracking information so <upstream> is considered <branchname>'s upstream branch")
          [CompletionResult]::new('--set-upstream-to=<upstream>', '--set-upstream-to=<upstream>', [CompletionResultType]::ParameterName, "Set up <branchname>'s tracking information so <upstream> is considered <branchname>'s upstream branch")
          [CompletionResult]::new('--unset-upstream', '--unset-upstream', [CompletionResultType]::ParameterName, 'Remove the upstream information for <branchname>')
          [CompletionResult]::new('--edit-description', '--edit-description', [CompletionResultType]::ParameterName, 'Open an editor and edit the text to explain what the branch is for, to be used by various other commands (e')
          [CompletionResult]::new('--contains', '--contains', [CompletionResultType]::ParameterName, 'Only list branches which contain the specified commit (HEAD if not specified)')
          [CompletionResult]::new('--no-contains', '--no-contains', [CompletionResultType]::ParameterName, "Only list branches which don't contain the specified commit (HEAD if not specified)")
          [CompletionResult]::new('--merged', '--merged', [CompletionResultType]::ParameterName, 'Only list branches whose tips are reachable from the specified commit (HEAD if not specified)')
          [CompletionResult]::new('--no-merged', '--no-merged', [CompletionResultType]::ParameterName, 'Only list branches whose tips are not reachable from the specified commit (HEAD if not specified)')
          [CompletionResult]::new('<branchname>', '<branchname>', [CompletionResultType]::ParameterName, 'The name of the branch to create or delete')
          [CompletionResult]::new('<start-point>', '<start-point>', [CompletionResultType]::ParameterName, 'The new branch head will point to this commit')
          [CompletionResult]::new('<oldbranch>', '<oldbranch>', [CompletionResultType]::ParameterName, 'The name of an existing branch')
          [CompletionResult]::new('<newbranch>', '<newbranch>', [CompletionResultType]::ParameterName, 'The new name for an existing branch')
          [CompletionResult]::new('--sort=<key>', '--sort=<key>', [CompletionResultType]::ParameterName, 'Sort based on the key given')
          [CompletionResult]::new('--points-at', '--points-at', [CompletionResultType]::ParameterName, 'Only list branches of the given object')
          [CompletionResult]::new('--format', '--format', [CompletionResultType]::ParameterName, 'A string that interpolates %(fieldname) from a branch ref being shown and the object it points at')
        }
        break
      }
      'bundle' {
        if ($wordToComplete.StartsWith('-')) {
          [CompletionResult]::new('create', 'create', [CompletionResultType]::ParameterName, 'Used to create a bundle named file')
          [CompletionResult]::new('verify', 'verify', [CompletionResultType]::ParameterName, 'Used to check that a bundle file is valid and will apply cleanly to the current repository')
          [CompletionResult]::new('list-heads', 'list-heads', [CompletionResultType]::ParameterName, 'Lists the references defined in the bundle')
          [CompletionResult]::new('unbundle', 'unbundle', [CompletionResultType]::ParameterName, 'Passes the objects in the bundle to git index-pack for storage in the repository, then prints the names of all defined references')
          [CompletionResult]::new('<git-rev-list-args>', '<git-rev-list-args>', [CompletionResultType]::ParameterName, 'A list of arguments, acceptable to git rev-parse and git rev-list (and containing a named ref, see SPECIFYING REFERENCES below), that specifies the specific objects and references to transport')
          [CompletionResult]::new('[<refname>…​]', '[<refname>…​]', [CompletionResultType]::ParameterName, 'A list of references used to limit the references reported as available')
          [CompletionResult]::new('--progress', '--progress', [CompletionResultType]::ParameterName, 'Progress status is reported on the standard error stream by default when it is attached to a terminal, unless -q is specified')
          [CompletionResult]::new('--version=<version>', '--version=<version>', [CompletionResultType]::ParameterName, 'Specify the bundle version')
          [CompletionResult]::new('-q', '-q', [CompletionResultType]::ParameterName, 'This flag makes the command not to report its progress on the standard error stream')
          [CompletionResult]::new('--quiet', '--quiet', [CompletionResultType]::ParameterName, 'This flag makes the command not to report its progress on the standard error stream')
        }
        break
      }
      'checkout' {
        if ($wordToComplete.StartsWith('-')) {
          [CompletionResult]::new('-q', '-q', [CompletionResultType]::ParameterName, 'Quiet, suppress feedback messages')
          [CompletionResult]::new('--quiet', '--quiet', [CompletionResultType]::ParameterName, 'Quiet, suppress feedback messages')
          [CompletionResult]::new('--progress', '--progress', [CompletionResultType]::ParameterName, 'Progress status is reported on the standard error stream by default when it is attached to a terminal, unless --quiet is specified')
          [CompletionResult]::new('--no-progress', '--no-progress', [CompletionResultType]::ParameterName, 'Progress status is reported on the standard error stream by default when it is attached to a terminal, unless --quiet is specified')
          [CompletionResult]::new('-f', '-f', [CompletionResultType]::ParameterName, 'When switching branches, proceed even if the index or the working tree differs from HEAD, and even if there are untracked files in the way')
          [CompletionResult]::new('--force', '--force', [CompletionResultType]::ParameterName, 'When switching branches, proceed even if the index or the working tree differs from HEAD, and even if there are untracked files in the way')
          [CompletionResult]::new('--ours', '--ours', [CompletionResultType]::ParameterName, 'When checking out paths from the index, check out stage #2 (ours) or #3 (theirs) for unmerged paths')
          [CompletionResult]::new('--theirs', '--theirs', [CompletionResultType]::ParameterName, 'When checking out paths from the index, check out stage #2 (ours) or #3 (theirs) for unmerged paths')
          [CompletionResult]::new('-b', '-b', [CompletionResultType]::ParameterName, 'Create a new branch named <new-branch>, start it at <start-point>, and check the resulting branch out; see git-branch(1) for details')
          [CompletionResult]::new('-B', '-B', [CompletionResultType]::ParameterName, 'Creates the branch <new-branch>, start it at <start-point>; if it already exists, then reset it to <start-point>')
          [CompletionResult]::new('-t', '-t', [CompletionResultType]::ParameterName, 'When creating a new branch, set up "upstream" configuration')
          [CompletionResult]::new('--track[=(direct|inherit)]', '--track[=(direct|inherit)]', [CompletionResultType]::ParameterName, 'When creating a new branch, set up "upstream" configuration')
          [CompletionResult]::new('--no-track', '--no-track', [CompletionResultType]::ParameterName, 'Do not set up "upstream" configuration, even if the branch')
          [CompletionResult]::new('--guess', '--guess', [CompletionResultType]::ParameterName, 'If <branch> is not found but there does exist a tracking branch in exactly one remote (call it <remote>) with a matching name, treat as equivalent to   $ git checkout -b <branch> --track <remote>/<branch>    If the branch exists in multiple remotes and one of them is named by the checkout')
          [CompletionResult]::new('--no-guess', '--no-guess', [CompletionResultType]::ParameterName, 'If <branch> is not found but there does exist a tracking branch in exactly one remote (call it <remote>) with a matching name, treat as equivalent to   $ git checkout -b <branch> --track <remote>/<branch>    If the branch exists in multiple remotes and one of them is named by the checkout')
          [CompletionResult]::new('-l', '-l', [CompletionResultType]::ParameterName, "Create the new branch's reflog; see git-branch(1) for details")
          [CompletionResult]::new('-d', '-d', [CompletionResultType]::ParameterName, 'Rather than checking out a branch to work on it, check out a commit for inspection and discardable experiments')
          [CompletionResult]::new('--detach', '--detach', [CompletionResultType]::ParameterName, 'Rather than checking out a branch to work on it, check out a commit for inspection and discardable experiments')
          [CompletionResult]::new('--orphan', '--orphan', [CompletionResultType]::ParameterName, 'Create a new unborn branch, named <new-branch>, started from <start-point> and switch to it')
          [CompletionResult]::new('--ignore-skip-worktree-bits', '--ignore-skip-worktree-bits', [CompletionResultType]::ParameterName, 'In sparse checkout mode, git checkout -- <paths> would update only entries matched by <paths> and sparse patterns in $GIT_DIR/info/sparse-checkout')
          [CompletionResult]::new('-m', '-m', [CompletionResultType]::ParameterName, 'When switching branches, if you have local modifications to one or more files that are different between the current branch and the branch to which you are switching, the command refuses to switch branches in order to preserve your modifications in context')
          [CompletionResult]::new('--merge', '--merge', [CompletionResultType]::ParameterName, 'When switching branches, if you have local modifications to one or more files that are different between the current branch and the branch to which you are switching, the command refuses to switch branches in order to preserve your modifications in context')
          [CompletionResult]::new('--conflict=<style>', '--conflict=<style>', [CompletionResultType]::ParameterName, 'The same as --merge option above, but changes the way the conflicting hunks are presented, overriding the merge')
          [CompletionResult]::new('-p', '-p', [CompletionResultType]::ParameterName, 'Interactively select hunks in the difference between the <tree-ish> (or the index, if unspecified) and the working tree')
          [CompletionResult]::new('--patch', '--patch', [CompletionResultType]::ParameterName, 'Interactively select hunks in the difference between the <tree-ish> (or the index, if unspecified) and the working tree')
          [CompletionResult]::new('--ignore-other-worktrees', '--ignore-other-worktrees', [CompletionResultType]::ParameterName, 'git checkout refuses when the wanted branch is already checked out or otherwise in use by another worktree')
          [CompletionResult]::new('--overwrite-ignore', '--overwrite-ignore', [CompletionResultType]::ParameterName, 'Silently overwrite ignored files when switching branches')
          [CompletionResult]::new('--no-overwrite-ignore', '--no-overwrite-ignore', [CompletionResultType]::ParameterName, 'Silently overwrite ignored files when switching branches')
          [CompletionResult]::new('--recurse-submodules', '--recurse-submodules', [CompletionResultType]::ParameterName, 'Using --recurse-submodules will update the content of all active submodules according to the commit recorded in the superproject')
          [CompletionResult]::new('--no-recurse-submodules', '--no-recurse-submodules', [CompletionResultType]::ParameterName, 'Using --recurse-submodules will update the content of all active submodules according to the commit recorded in the superproject')
          [CompletionResult]::new('--overlay', '--overlay', [CompletionResultType]::ParameterName, 'In the default overlay mode, git checkout never removes files from the index or the working tree')
          [CompletionResult]::new('--no-overlay', '--no-overlay', [CompletionResultType]::ParameterName, 'In the default overlay mode, git checkout never removes files from the index or the working tree')
          [CompletionResult]::new('--pathspec-from-file=<file>', '--pathspec-from-file=<file>', [CompletionResultType]::ParameterName, 'Pathspec is passed in <file> instead of commandline args')
          [CompletionResult]::new('--pathspec-file-nul', '--pathspec-file-nul', [CompletionResultType]::ParameterName, 'Only meaningful with --pathspec-from-file')
          [CompletionResult]::new('<branch>', '<branch>', [CompletionResultType]::ParameterName, 'Branch to checkout; if it refers to a branch (i')
          [CompletionResult]::new('<new-branch>', '<new-branch>', [CompletionResultType]::ParameterName, 'Name for the new branch')
          [CompletionResult]::new('<start-point>', '<start-point>', [CompletionResultType]::ParameterName, 'The name of a commit at which to start the new branch; see git-branch(1) for details')
          [CompletionResult]::new('<tree-ish>', '<tree-ish>', [CompletionResultType]::ParameterName, 'Tree to checkout from (when paths are given)')
          [CompletionResult]::new('--', '--', [CompletionResultType]::ParameterName, 'Do not interpret any more arguments as options')
          [CompletionResult]::new('<pathspec>…​', '<pathspec>…​', [CompletionResultType]::ParameterName, 'Limits the paths affected by the operation')
        }
        break
      }
      'cherry-pick' {
        if ($wordToComplete.StartsWith('-')) {
          [CompletionResult]::new('<commit>…​', '<commit>…​', [CompletionResultType]::ParameterName, 'Commits to cherry-pick')
          [CompletionResult]::new('-e', '-e', [CompletionResultType]::ParameterName, 'With this option, git cherry-pick will let you edit the commit message prior to committing')
          [CompletionResult]::new('--edit', '--edit', [CompletionResultType]::ParameterName, 'With this option, git cherry-pick will let you edit the commit message prior to committing')
          [CompletionResult]::new('--cleanup=<mode>', '--cleanup=<mode>', [CompletionResultType]::ParameterName, 'This option determines how the commit message will be cleaned up before being passed on to the commit machinery')
          [CompletionResult]::new('-x', '-x', [CompletionResultType]::ParameterName, 'When recording the commit, append a line that says "(cherry picked from commit …​)" to the original commit message in order to indicate which commit this change was cherry-picked from')
          [CompletionResult]::new('-r', '-r', [CompletionResultType]::ParameterName, 'It used to be that the command defaulted to do -x described above, and -r was to disable it')
          [CompletionResult]::new('-m', '-m', [CompletionResultType]::ParameterName, 'Usually you cannot cherry-pick a merge because you do not know which side of the merge should be considered the mainline')
          [CompletionResult]::new('--mainline', '--mainline', [CompletionResultType]::ParameterName, 'Usually you cannot cherry-pick a merge because you do not know which side of the merge should be considered the mainline')
          [CompletionResult]::new('-n', '-n', [CompletionResultType]::ParameterName, 'Usually the command automatically creates a sequence of commits')
          [CompletionResult]::new('--no-commit', '--no-commit', [CompletionResultType]::ParameterName, 'Usually the command automatically creates a sequence of commits')
          [CompletionResult]::new('-s', '-s', [CompletionResultType]::ParameterName, 'Add a Signed-off-by trailer at the end of the commit message')
          [CompletionResult]::new('--signoff', '--signoff', [CompletionResultType]::ParameterName, 'Add a Signed-off-by trailer at the end of the commit message')
          [CompletionResult]::new('-S[<keyid>]', '-S[<keyid>]', [CompletionResultType]::ParameterName, 'GPG-sign commits')
          [CompletionResult]::new('--gpg-sign[=<keyid>]', '--gpg-sign[=<keyid>]', [CompletionResultType]::ParameterName, 'GPG-sign commits')
          [CompletionResult]::new('--no-gpg-sign', '--no-gpg-sign', [CompletionResultType]::ParameterName, 'GPG-sign commits')
          [CompletionResult]::new('--ff', '--ff', [CompletionResultType]::ParameterName, "If the current HEAD is the same as the parent of the cherry-pick'ed commit, then a fast forward to this commit will be performed")
          [CompletionResult]::new('--allow-empty', '--allow-empty', [CompletionResultType]::ParameterName, 'By default, cherry-picking an empty commit will fail, indicating that an explicit invocation of git commit --allow-empty is required')
          [CompletionResult]::new('--allow-empty-message', '--allow-empty-message', [CompletionResultType]::ParameterName, 'By default, cherry-picking a commit with an empty message will fail')
          [CompletionResult]::new('--empty=(drop|keep|stop)', '--empty=(drop|keep|stop)', [CompletionResultType]::ParameterName, 'How to handle commits being cherry-picked that are redundant with changes already in the current history')
          [CompletionResult]::new('--keep-redundant-commits', '--keep-redundant-commits', [CompletionResultType]::ParameterName, 'Deprecated synonym for --empty=keep')
          [CompletionResult]::new('--strategy=<strategy>', '--strategy=<strategy>', [CompletionResultType]::ParameterName, 'Use the given merge strategy')
          [CompletionResult]::new('-X<option>', '-X<option>', [CompletionResultType]::ParameterName, 'Pass the merge strategy-specific option through to the merge strategy')
          [CompletionResult]::new('--strategy-option=<option>', '--strategy-option=<option>', [CompletionResultType]::ParameterName, 'Pass the merge strategy-specific option through to the merge strategy')
          [CompletionResult]::new('--rerere-autoupdate', '--rerere-autoupdate', [CompletionResultType]::ParameterName, 'After the rerere mechanism reuses a recorded resolution on the current conflict to update the files in the working tree, allow it to also update the index with the result of resolution')
          [CompletionResult]::new('--no-rerere-autoupdate', '--no-rerere-autoupdate', [CompletionResultType]::ParameterName, 'After the rerere mechanism reuses a recorded resolution on the current conflict to update the files in the working tree, allow it to also update the index with the result of resolution')
        }
        break
      }
      'citool' { break } # GUI tool
      'clean' {
        if ($wordToComplete.StartsWith('-')) {
          [CompletionResult]::new('-d', '-d', [CompletionResultType]::ParameterName, 'Normally, when no <pathspec> is specified, git clean will not recurse into untracked directories to avoid removing too much')
          [CompletionResult]::new('-f', '-f', [CompletionResultType]::ParameterName, 'If the Git configuration variable clean')
          [CompletionResult]::new('--force', '--force', [CompletionResultType]::ParameterName, 'If the Git configuration variable clean')
          [CompletionResult]::new('-i', '-i', [CompletionResultType]::ParameterName, 'Show what would be done and clean files interactively')
          [CompletionResult]::new('--interactive', '--interactive', [CompletionResultType]::ParameterName, 'Show what would be done and clean files interactively')
          [CompletionResult]::new('-n', '-n', [CompletionResultType]::ParameterName, "Don't actually remove anything, just show what would be done")
          [CompletionResult]::new('--dry-run', '--dry-run', [CompletionResultType]::ParameterName, "Don't actually remove anything, just show what would be done")
          [CompletionResult]::new('-q', '-q', [CompletionResultType]::ParameterName, 'Be quiet, only report errors, but not the files that are successfully removed')
          [CompletionResult]::new('--quiet', '--quiet', [CompletionResultType]::ParameterName, 'Be quiet, only report errors, but not the files that are successfully removed')
          [CompletionResult]::new('-e', '-e', [CompletionResultType]::ParameterName, 'Use the given exclude pattern in addition to the standard ignore rules (see gitignore(5))')
          [CompletionResult]::new('--exclude=<pattern>', '--exclude=<pattern>', [CompletionResultType]::ParameterName, 'Use the given exclude pattern in addition to the standard ignore rules (see gitignore(5))')
          [CompletionResult]::new('-x', '-x', [CompletionResultType]::ParameterName, "Don't use the standard ignore rules (see gitignore(5)), but still use the ignore rules given with -e options from the command line")
          [CompletionResult]::new('-X', '-X', [CompletionResultType]::ParameterName, 'Remove only files ignored by Git')
        }
        break
      }
      'clone' {
        if ($wordToComplete.StartsWith('-')) {
          [CompletionResult]::new('-l', '-l', [CompletionResultType]::ParameterName, 'When the repository to clone from is on a local machine, this flag bypasses the normal "Git aware" transport mechanism and clones the repository by making a copy of HEAD and everything under objects and refs directories')
          [CompletionResult]::new('--local', '--local', [CompletionResultType]::ParameterName, 'When the repository to clone from is on a local machine, this flag bypasses the normal "Git aware" transport mechanism and clones the repository by making a copy of HEAD and everything under objects and refs directories')
          [CompletionResult]::new('--no-hardlinks', '--no-hardlinks', [CompletionResultType]::ParameterName, 'Force the cloning process from a repository on a local filesystem to copy the files under the')
          [CompletionResult]::new('-s', '-s', [CompletionResultType]::ParameterName, 'When the repository to clone is on the local machine, instead of using hard links, automatically setup')
          [CompletionResult]::new('--shared', '--shared', [CompletionResultType]::ParameterName, 'When the repository to clone is on the local machine, instead of using hard links, automatically setup')
          [CompletionResult]::new('--reference[-if-able]', '--reference[-if-able]', [CompletionResultType]::ParameterName, 'If the reference <repository> is on the local machine, automatically setup')
          [CompletionResult]::new('--dissociate', '--dissociate', [CompletionResultType]::ParameterName, 'Borrow the objects from reference repositories specified with the --reference options only to reduce network transfer, and stop borrowing from them after a clone is made by making necessary local copies of borrowed objects')
          [CompletionResult]::new('-q', '-q', [CompletionResultType]::ParameterName, 'Operate quietly')
          [CompletionResult]::new('--quiet', '--quiet', [CompletionResultType]::ParameterName, 'Operate quietly')
          [CompletionResult]::new('-v', '-v', [CompletionResultType]::ParameterName, 'Run verbosely')
          [CompletionResult]::new('--verbose', '--verbose', [CompletionResultType]::ParameterName, 'Run verbosely')
          [CompletionResult]::new('--progress', '--progress', [CompletionResultType]::ParameterName, 'Progress status is reported on the standard error stream by default when it is attached to a terminal, unless --quiet is specified')
          [CompletionResult]::new('--server-option=<option>', '--server-option=<option>', [CompletionResultType]::ParameterName, 'Transmit the given string to the server when communicating using protocol version 2')
          [CompletionResult]::new('-n', '-n', [CompletionResultType]::ParameterName, 'No checkout of HEAD is performed after the clone is complete')
          [CompletionResult]::new('--no-checkout', '--no-checkout', [CompletionResultType]::ParameterName, 'No checkout of HEAD is performed after the clone is complete')
          [CompletionResult]::new('--[no-]reject-shallow', '--[no-]reject-shallow', [CompletionResultType]::ParameterName, 'Fail if the source repository is a shallow repository')
          [CompletionResult]::new('--bare', '--bare', [CompletionResultType]::ParameterName, 'Make a bare Git repository')
          [CompletionResult]::new('--sparse', '--sparse', [CompletionResultType]::ParameterName, 'Employ a sparse-checkout, with only files in the toplevel directory initially being present')
          [CompletionResult]::new('--filter=<filter-spec>', '--filter=<filter-spec>', [CompletionResultType]::ParameterName, 'Use the partial clone feature and request that the server sends a subset of reachable objects according to a given object filter')
          [CompletionResult]::new('--also-filter-submodules', '--also-filter-submodules', [CompletionResultType]::ParameterName, 'Also apply the partial clone filter to any submodules in the repository')
          [CompletionResult]::new('--mirror', '--mirror', [CompletionResultType]::ParameterName, 'Set up a mirror of the source repository')
          [CompletionResult]::new('-o', '-o', [CompletionResultType]::ParameterName, 'Instead of using the remote name origin to keep track of the upstream repository, use <name>')
          [CompletionResult]::new('--origin', '--origin', [CompletionResultType]::ParameterName, 'Instead of using the remote name origin to keep track of the upstream repository, use <name>')
          [CompletionResult]::new('-b', '-b', [CompletionResultType]::ParameterName, "Instead of pointing the newly created HEAD to the branch pointed to by the cloned repository's HEAD, point to <name> branch instead")
          [CompletionResult]::new('--branch', '--branch', [CompletionResultType]::ParameterName, "Instead of pointing the newly created HEAD to the branch pointed to by the cloned repository's HEAD, point to <name> branch instead")
          [CompletionResult]::new('-u', '-u', [CompletionResultType]::ParameterName, 'When given, and the repository to clone from is accessed via ssh, this specifies a non-default path for the command run on the other end')
          [CompletionResult]::new('--upload-pack', '--upload-pack', [CompletionResultType]::ParameterName, 'When given, and the repository to clone from is accessed via ssh, this specifies a non-default path for the command run on the other end')
          [CompletionResult]::new('--template=<template-directory>', '--template=<template-directory>', [CompletionResultType]::ParameterName, 'Specify the directory from which templates will be used; (See the "TEMPLATE DIRECTORY" section of git-init(1)')
          [CompletionResult]::new('-c', '-c', [CompletionResultType]::ParameterName, 'Set a configuration variable in the newly-created repository; this takes effect immediately after the repository is initialized, but before the remote history is fetched or any files checked out')
          [CompletionResult]::new('--config', '--config', [CompletionResultType]::ParameterName, 'Set a configuration variable in the newly-created repository; this takes effect immediately after the repository is initialized, but before the remote history is fetched or any files checked out')
          [CompletionResult]::new('--depth', '--depth', [CompletionResultType]::ParameterName, 'Create a shallow clone with a history truncated to the specified number of commits')
          [CompletionResult]::new('--shallow-since=<date>', '--shallow-since=<date>', [CompletionResultType]::ParameterName, 'Create a shallow clone with a history after the specified time')
          [CompletionResult]::new('--shallow-exclude=<revision>', '--shallow-exclude=<revision>', [CompletionResultType]::ParameterName, 'Create a shallow clone with a history, excluding commits reachable from a specified remote branch or tag')
          [CompletionResult]::new('--[no-]single-branch', '--[no-]single-branch', [CompletionResultType]::ParameterName, "Clone only the history leading to the tip of a single branch, either specified by the --branch option or the primary branch remote's HEAD points at")
          [CompletionResult]::new('--no-tags', '--no-tags', [CompletionResultType]::ParameterName, "Don't clone any tags, and set remote")
          [CompletionResult]::new('--recurse-submodules[=<pathspec>]', '--recurse-submodules[=<pathspec>]', [CompletionResultType]::ParameterName, 'After the clone is created, initialize and clone submodules within based on the provided <pathspec>')
          [CompletionResult]::new('--[no-]shallow-submodules', '--[no-]shallow-submodules', [CompletionResultType]::ParameterName, 'All submodules which are cloned will be shallow with a depth of 1')
          [CompletionResult]::new('--[no-]remote-submodules', '--[no-]remote-submodules', [CompletionResultType]::ParameterName, "All submodules which are cloned will use the status of the submodule's remote-tracking branch to update the submodule, rather than the superproject's recorded SHA-1")
          [CompletionResult]::new('--separate-git-dir=<git-dir>', '--separate-git-dir=<git-dir>', [CompletionResultType]::ParameterName, 'Instead of placing the cloned repository where it is supposed to be, place the cloned repository at the specified directory, then make a filesystem-agnostic Git symbolic link to there')
          [CompletionResult]::new('--ref-format=<ref-format>', '--ref-format=<ref-format>', [CompletionResultType]::ParameterName, 'Specify the given ref storage format for the repository')
          [CompletionResult]::new('-j', '-j', [CompletionResultType]::ParameterName, 'The number of submodules fetched at the same time')
          [CompletionResult]::new('--jobs', '--jobs', [CompletionResultType]::ParameterName, 'The number of submodules fetched at the same time')
          [CompletionResult]::new('<repository>', '<repository>', [CompletionResultType]::ParameterName, 'The (possibly remote) <repository> to clone from')
          [CompletionResult]::new('<directory>', '<directory>', [CompletionResultType]::ParameterName, 'The name of a new directory to clone into')
          [CompletionResult]::new('--bundle-uri=<uri>', '--bundle-uri=<uri>', [CompletionResultType]::ParameterName, 'Before fetching from the remote, fetch a bundle from the given <uri> and unbundle the data into the local repository')
        }
        break
      }
      'commit' {
        if ($wordToComplete.StartsWith('-')) {
          [CompletionResult]::new('-a', '-a', [CompletionResultType]::ParameterName, 'Tell the command to automatically stage files that have been modified and deleted, but new files you have not told Git about are not affected')
          [CompletionResult]::new('--all', '--all', [CompletionResultType]::ParameterName, 'Tell the command to automatically stage files that have been modified and deleted, but new files you have not told Git about are not affected')
          [CompletionResult]::new('-p', '-p', [CompletionResultType]::ParameterName, 'Use the interactive patch selection interface to choose which changes to commit')
          [CompletionResult]::new('--patch', '--patch', [CompletionResultType]::ParameterName, 'Use the interactive patch selection interface to choose which changes to commit')
          [CompletionResult]::new('-C', '-C', [CompletionResultType]::ParameterName, 'Take an existing commit object, and reuse the log message and the authorship information (including the timestamp) when creating the commit')
          [CompletionResult]::new('--reuse-message', '--reuse-message', [CompletionResultType]::ParameterName, 'Take an existing commit object, and reuse the log message and the authorship information (including the timestamp) when creating the commit')
          [CompletionResult]::new('-c', '-c', [CompletionResultType]::ParameterName, 'Like -C, but with -c the editor is invoked, so that the user can further edit the commit message')
          [CompletionResult]::new('--reedit-message', '--reedit-message', [CompletionResultType]::ParameterName, 'Like -C, but with -c the editor is invoked, so that the user can further edit the commit message')
          [CompletionResult]::new('--fixup', '--fixup', [CompletionResultType]::ParameterName, 'Create a new commit which "fixes up" <commit> when applied with git rebase --autosquash')
          [CompletionResult]::new('--squash', '--squash', [CompletionResultType]::ParameterName, 'Construct a commit message for use with rebase --autosquash')
          [CompletionResult]::new('--reset-author', '--reset-author', [CompletionResultType]::ParameterName, 'When used with -C/-c/--amend options, or when committing after a conflicting cherry-pick, declare that the authorship of the resulting commit now belongs to the committer')
          [CompletionResult]::new('--short', '--short', [CompletionResultType]::ParameterName, 'When doing a dry-run, give the output in the short-format')
          [CompletionResult]::new('--branch', '--branch', [CompletionResultType]::ParameterName, 'Show the branch and tracking info even in short-format')
          [CompletionResult]::new('--porcelain', '--porcelain', [CompletionResultType]::ParameterName, 'When doing a dry-run, give the output in a porcelain-ready format')
          [CompletionResult]::new('--long', '--long', [CompletionResultType]::ParameterName, 'When doing a dry-run, give the output in the long-format')
          [CompletionResult]::new('-z', '-z', [CompletionResultType]::ParameterName, 'When showing short or porcelain status output, print the filename verbatim and terminate the entries with NUL, instead of LF')
          [CompletionResult]::new('--null', '--null', [CompletionResultType]::ParameterName, 'When showing short or porcelain status output, print the filename verbatim and terminate the entries with NUL, instead of LF')
          [CompletionResult]::new('-F', '-F', [CompletionResultType]::ParameterName, 'Take the commit message from the given file')
          [CompletionResult]::new('--file', '--file', [CompletionResultType]::ParameterName, 'Take the commit message from the given file')
          [CompletionResult]::new('--author', '--author', [CompletionResultType]::ParameterName, 'Override the commit author')
          [CompletionResult]::new('--date', '--date', [CompletionResultType]::ParameterName, 'Override the author date used in the commit')
          [CompletionResult]::new('-m', '-m', [CompletionResultType]::ParameterName, 'Use the given <msg> as the commit message')
          [CompletionResult]::new('--message', '--message', [CompletionResultType]::ParameterName, 'Use the given <msg> as the commit message')
          [CompletionResult]::new('-t', '-t', [CompletionResultType]::ParameterName, 'When editing the commit message, start the editor with the contents in the given file')
          [CompletionResult]::new('--template', '--template', [CompletionResultType]::ParameterName, 'When editing the commit message, start the editor with the contents in the given file')
          [CompletionResult]::new('-s', '-s', [CompletionResultType]::ParameterName, 'Add a Signed-off-by trailer by the committer at the end of the commit log message')
          [CompletionResult]::new('--signoff', '--signoff', [CompletionResultType]::ParameterName, 'Add a Signed-off-by trailer by the committer at the end of the commit log message')
          [CompletionResult]::new('--no-signoff', '--no-signoff', [CompletionResultType]::ParameterName, 'Add a Signed-off-by trailer by the committer at the end of the commit log message')
          [CompletionResult]::new('--trailer', '--trailer', [CompletionResultType]::ParameterName, 'Specify a (<token>, <value>) pair that should be applied as a trailer')
          [CompletionResult]::new('-n', '-n', [CompletionResultType]::ParameterName, 'By default, the pre-commit and commit-msg hooks are run')
          [CompletionResult]::new('--verify', '--verify', [CompletionResultType]::ParameterName, 'By default, the pre-commit and commit-msg hooks are run')
          [CompletionResult]::new('--no-verify', '--no-verify', [CompletionResultType]::ParameterName, 'By default, the pre-commit and commit-msg hooks are run')
          [CompletionResult]::new('--allow-empty', '--allow-empty', [CompletionResultType]::ParameterName, 'Usually recording a commit that has the exact same tree as its sole parent commit is a mistake, and the command prevents you from making such a commit')
          [CompletionResult]::new('--allow-empty-message', '--allow-empty-message', [CompletionResultType]::ParameterName, 'Like --allow-empty this command is primarily for use by foreign SCM interface scripts')
          [CompletionResult]::new('--cleanup', '--cleanup', [CompletionResultType]::ParameterName, 'This option determines how the supplied commit message should be cleaned up before committing')
          [CompletionResult]::new('-e', '-e', [CompletionResultType]::ParameterName, 'The message taken from file with -F, command line with -m, and from commit object with -C are usually used as the commit log message unmodified')
          [CompletionResult]::new('--edit', '--edit', [CompletionResultType]::ParameterName, 'The message taken from file with -F, command line with -m, and from commit object with -C are usually used as the commit log message unmodified')
          [CompletionResult]::new('--no-edit', '--no-edit', [CompletionResultType]::ParameterName, 'Use the selected commit message without launching an editor')
          [CompletionResult]::new('--amend', '--amend', [CompletionResultType]::ParameterName, 'Replace the tip of the current branch by creating a new commit')
          [CompletionResult]::new('--no-post-rewrite', '--no-post-rewrite', [CompletionResultType]::ParameterName, 'Bypass the post-rewrite hook')
          [CompletionResult]::new('-i', '-i', [CompletionResultType]::ParameterName, 'Before making a commit out of staged contents so far, stage the contents of paths given on the command line as well')
          [CompletionResult]::new('--include', '--include', [CompletionResultType]::ParameterName, 'Before making a commit out of staged contents so far, stage the contents of paths given on the command line as well')
          [CompletionResult]::new('-o', '-o', [CompletionResultType]::ParameterName, 'Make a commit by taking the updated working tree contents of the paths specified on the command line, disregarding any contents that have been staged for other paths')
          [CompletionResult]::new('--only', '--only', [CompletionResultType]::ParameterName, 'Make a commit by taking the updated working tree contents of the paths specified on the command line, disregarding any contents that have been staged for other paths')
          [CompletionResult]::new('--pathspec-from-file', '--pathspec-from-file', [CompletionResultType]::ParameterName, 'Pathspec is passed in <file> instead of commandline args')
          [CompletionResult]::new('--pathspec-file-nul', '--pathspec-file-nul', [CompletionResultType]::ParameterName, 'Only meaningful with --pathspec-from-file')
          [CompletionResult]::new('-u', '-u', [CompletionResultType]::ParameterName, 'Show untracked files')
          [CompletionResult]::new('--untracked-files', '--untracked-files', [CompletionResultType]::ParameterName, 'Show untracked files')
          [CompletionResult]::new('-v', '-v', [CompletionResultType]::ParameterName, 'Show unified diff between the HEAD commit and what would be committed at the bottom of the commit message template to help the user describe the commit by reminding what changes the commit has')
          [CompletionResult]::new('--verbose', '--verbose', [CompletionResultType]::ParameterName, 'Show unified diff between the HEAD commit and what would be committed at the bottom of the commit message template to help the user describe the commit by reminding what changes the commit has')
          [CompletionResult]::new('-q', '-q', [CompletionResultType]::ParameterName, 'Suppress commit summary message')
          [CompletionResult]::new('--quiet', '--quiet', [CompletionResultType]::ParameterName, 'Suppress commit summary message')
          [CompletionResult]::new('--dry-run', '--dry-run', [CompletionResultType]::ParameterName, 'Do not create a commit, but show a list of paths that are to be committed, paths with local changes that will be left uncommitted and paths that are untracked')
          [CompletionResult]::new('--status', '--status', [CompletionResultType]::ParameterName, 'Include the output of git-status(1) in the commit message template when using an editor to prepare the commit message')
          [CompletionResult]::new('--no-status', '--no-status', [CompletionResultType]::ParameterName, 'Do not include the output of git-status(1) in the commit message template when using an editor to prepare the default commit message')
          [CompletionResult]::new('-S', '-S', [CompletionResultType]::ParameterName, 'GPG-sign commits')
          [CompletionResult]::new('--gpg-sign', '--gpg-sign', [CompletionResultType]::ParameterName, 'GPG-sign commits')
          [CompletionResult]::new('--no-gpg-sign', '--no-gpg-sign', [CompletionResultType]::ParameterName, 'GPG-sign commits')
          [CompletionResult]::new('--', '--', [CompletionResultType]::ParameterName, 'Do not interpret any more arguments as options')
          [CompletionResult]::new('<pathspec>…​', '<pathspec>…​', [CompletionResultType]::ParameterName, 'When pathspec is given on the command line, commit the contents of the files that match the pathspec without recording the changes already added to the index')
        }
        break
      }
      'describe' {
        if ($wordToComplete.StartsWith('-')) {
          [CompletionResult]::new('<commit-ish>…​', '<commit-ish>…​', [CompletionResultType]::ParameterName, 'Commit-ish object names to describe')
          [CompletionResult]::new('--dirty[=<mark>]', '--dirty[=<mark>]', [CompletionResultType]::ParameterName, 'Describe the state of the working tree')
          [CompletionResult]::new('--broken[=<mark>]', '--broken[=<mark>]', [CompletionResultType]::ParameterName, 'Describe the state of the working tree')
          [CompletionResult]::new('--all', '--all', [CompletionResultType]::ParameterName, 'Instead of using only the annotated tags, use any ref found in refs/ namespace')
          [CompletionResult]::new('--tags', '--tags', [CompletionResultType]::ParameterName, 'Instead of using only the annotated tags, use any tag found in refs/tags namespace')
          [CompletionResult]::new('--contains', '--contains', [CompletionResultType]::ParameterName, 'Instead of finding the tag that predates the commit, find the tag that comes after the commit, and thus contains it')
          [CompletionResult]::new('--abbrev=<n>', '--abbrev=<n>', [CompletionResultType]::ParameterName, 'Instead of using the default number of hexadecimal digits (which will vary according to the number of objects in the repository with a default of 7) of the abbreviated object name, use <n> digits, or as many digits as needed to form a unique object name')
          [CompletionResult]::new('--candidates=<n>', '--candidates=<n>', [CompletionResultType]::ParameterName, 'Instead of considering only the 10 most recent tags as candidates to describe the input commit-ish consider up to <n> candidates')
          [CompletionResult]::new('--exact-match', '--exact-match', [CompletionResultType]::ParameterName, 'Only output exact matches (a tag directly references the supplied commit)')
          [CompletionResult]::new('--debug', '--debug', [CompletionResultType]::ParameterName, 'Verbosely display information about the searching strategy being employed to standard error')
          [CompletionResult]::new('--long', '--long', [CompletionResultType]::ParameterName, 'Always output the long format (the tag, the number of commits and the abbreviated commit name) even when it matches a tag')
          [CompletionResult]::new('--match', '--match', [CompletionResultType]::ParameterName, 'Only consider tags matching the given glob(7) pattern, excluding the "refs/tags/" prefix')
          [CompletionResult]::new('--exclude', '--exclude', [CompletionResultType]::ParameterName, 'Do not consider tags matching the given glob(7) pattern, excluding the "refs/tags/" prefix')
          [CompletionResult]::new('--always', '--always', [CompletionResultType]::ParameterName, 'Show uniquely abbreviated commit object as fallback')
          [CompletionResult]::new('--first-parent', '--first-parent', [CompletionResultType]::ParameterName, 'Follow only the first parent commit upon seeing a merge commit')
        }
        break
      }
      'diff' {
        if ($wordToComplete.StartsWith('-')) {
          [CompletionResult]::new('-p', '-p', [CompletionResultType]::ParameterName, 'Generate patch (see Generating patch text with -p)')
          [CompletionResult]::new('-u', '-u', [CompletionResultType]::ParameterName, 'Generate patch (see Generating patch text with -p)')
          [CompletionResult]::new('--patch', '--patch', [CompletionResultType]::ParameterName, 'Generate patch (see Generating patch text with -p)')
          [CompletionResult]::new('-s', '-s', [CompletionResultType]::ParameterName, 'Suppress all output from the diff machinery')
          [CompletionResult]::new('--no-patch', '--no-patch', [CompletionResultType]::ParameterName, 'Suppress all output from the diff machinery')
          [CompletionResult]::new('-U<n>', '-U<n>', [CompletionResultType]::ParameterName, 'Generate diffs with <n> lines of context instead of the usual three')
          [CompletionResult]::new('--unified=<n>', '--unified=<n>', [CompletionResultType]::ParameterName, 'Generate diffs with <n> lines of context instead of the usual three')
          [CompletionResult]::new('--output=<file>', '--output=<file>', [CompletionResultType]::ParameterName, 'Output to a specific file instead of stdout')
          [CompletionResult]::new('--output-indicator-new=<char>', '--output-indicator-new=<char>', [CompletionResultType]::ParameterName, 'Specify the character used to indicate new, old or context lines in the generated patch')
          [CompletionResult]::new('--output-indicator-old=<char>', '--output-indicator-old=<char>', [CompletionResultType]::ParameterName, 'Specify the character used to indicate new, old or context lines in the generated patch')
          [CompletionResult]::new('--output-indicator-context=<char>', '--output-indicator-context=<char>', [CompletionResultType]::ParameterName, 'Specify the character used to indicate new, old or context lines in the generated patch')
          [CompletionResult]::new('--raw', '--raw', [CompletionResultType]::ParameterName, 'Generate the diff in raw format')
          [CompletionResult]::new('--patch-with-raw', '--patch-with-raw', [CompletionResultType]::ParameterName, 'Synonym for -p --raw')
          [CompletionResult]::new('--indent-heuristic', '--indent-heuristic', [CompletionResultType]::ParameterName, 'Enable the heuristic that shifts diff hunk boundaries to make patches easier to read')
          [CompletionResult]::new('--no-indent-heuristic', '--no-indent-heuristic', [CompletionResultType]::ParameterName, 'Disable the indent heuristic')
          [CompletionResult]::new('--minimal', '--minimal', [CompletionResultType]::ParameterName, 'Spend extra time to make sure the smallest possible diff is produced')
          [CompletionResult]::new('--patience', '--patience', [CompletionResultType]::ParameterName, 'Generate a diff using the "patience diff" algorithm')
          [CompletionResult]::new('--histogram', '--histogram', [CompletionResultType]::ParameterName, 'Generate a diff using the "histogram diff" algorithm')
          [CompletionResult]::new('--anchored=<text>', '--anchored=<text>', [CompletionResultType]::ParameterName, 'Generate a diff using the "anchored diff" algorithm')
          [CompletionResult]::new('--diff-algorithm={patience|minimal|histogram|myers}', '--diff-algorithm={patience|minimal|histogram|myers}', [CompletionResultType]::ParameterName, 'Choose a diff algorithm')
          [CompletionResult]::new('--stat[=<width>[,<name-width>[,<count>]]]', '--stat[=<width>[,<name-width>[,<count>]]]', [CompletionResultType]::ParameterName, 'Generate a diffstat')
          [CompletionResult]::new('--compact-summary', '--compact-summary', [CompletionResultType]::ParameterName, 'Output a condensed summary of extended header information such as file creations or deletions ("new" or "gone", optionally "+l" if it' + "'" + 's a symlink) and mode changes ("+x" or "-x" for adding or removing executable bit respectively) in diffstat')
          [CompletionResult]::new('--numstat', '--numstat', [CompletionResultType]::ParameterName, 'Similar to --stat, but shows number of added and deleted lines in decimal notation and pathname without abbreviation, to make it more machine friendly')
          [CompletionResult]::new('--shortstat', '--shortstat', [CompletionResultType]::ParameterName, 'Output only the last line of the --stat format containing total number of modified files, as well as number of added and deleted lines')
          [CompletionResult]::new('-X[<param1,param2,…​>]', '-X[<param1,param2,…​>]', [CompletionResultType]::ParameterName, 'Output the distribution of relative amount of changes for each sub-directory')
          [CompletionResult]::new('--dirstat[=<param1,param2,…​>]', '--dirstat[=<param1,param2,…​>]', [CompletionResultType]::ParameterName, 'Output the distribution of relative amount of changes for each sub-directory')
          [CompletionResult]::new('--cumulative', '--cumulative', [CompletionResultType]::ParameterName, 'Synonym for --dirstat=cumulative')
          [CompletionResult]::new('--dirstat-by-file[=<param1,param2>…​]', '--dirstat-by-file[=<param1,param2>…​]', [CompletionResultType]::ParameterName, 'Synonym for --dirstat=files,<param1>,<param2>…​')
          [CompletionResult]::new('--summary', '--summary', [CompletionResultType]::ParameterName, 'Output a condensed summary of extended header information such as creations, renames and mode changes')
          [CompletionResult]::new('--patch-with-stat', '--patch-with-stat', [CompletionResultType]::ParameterName, 'Synonym for -p --stat')
          [CompletionResult]::new('-z', '-z', [CompletionResultType]::ParameterName, 'When --raw, --numstat, --name-only or --name-status has been given, do not munge pathnames and use NULs as output field terminators')
          [CompletionResult]::new('--name-only', '--name-only', [CompletionResultType]::ParameterName, 'Show only the name of each changed file in the post-image tree')
          [CompletionResult]::new('--name-status', '--name-status', [CompletionResultType]::ParameterName, 'Show only the name(s) and status of each changed file')
          [CompletionResult]::new('--submodule[=<format>]', '--submodule[=<format>]', [CompletionResultType]::ParameterName, 'Specify how differences in submodules are shown')
          [CompletionResult]::new('--color[=<when>]', '--color[=<when>]', [CompletionResultType]::ParameterName, 'Show colored diff')
          [CompletionResult]::new('--no-color', '--no-color', [CompletionResultType]::ParameterName, 'Turn off colored diff')
          [CompletionResult]::new('--color-moved[=<mode>]', '--color-moved[=<mode>]', [CompletionResultType]::ParameterName, 'Moved lines of code are colored differently')
          [CompletionResult]::new('--no-color-moved', '--no-color-moved', [CompletionResultType]::ParameterName, 'Turn off move detection')
          [CompletionResult]::new('--color-moved-ws=<modes>', '--color-moved-ws=<modes>', [CompletionResultType]::ParameterName, 'This configures how whitespace is ignored when performing the move detection for --color-moved')
          [CompletionResult]::new('--no-color-moved-ws', '--no-color-moved-ws', [CompletionResultType]::ParameterName, 'Do not ignore whitespace when performing move detection')
          [CompletionResult]::new('--word-diff[=<mode>]', '--word-diff[=<mode>]', [CompletionResultType]::ParameterName, 'Show a word diff, using the <mode> to delimit changed words')
          [CompletionResult]::new('--word-diff-regex=<regex>', '--word-diff-regex=<regex>', [CompletionResultType]::ParameterName, 'Use <regex> to decide what a word is, instead of considering runs of non-whitespace to be a word')
          [CompletionResult]::new('--color-words[=<regex>]', '--color-words[=<regex>]', [CompletionResultType]::ParameterName, 'Equivalent to --word-diff=color plus (if a regex was specified) --word-diff-regex=<regex>')
          [CompletionResult]::new('--no-renames', '--no-renames', [CompletionResultType]::ParameterName, 'Turn off rename detection, even when the configuration file gives the default to do so')
          [CompletionResult]::new('--[no-]rename-empty', '--[no-]rename-empty', [CompletionResultType]::ParameterName, 'Whether to use empty blobs as rename source')
          [CompletionResult]::new('--check', '--check', [CompletionResultType]::ParameterName, 'Warn if changes introduce conflict markers or whitespace errors')
          [CompletionResult]::new('--ws-error-highlight=<kind>', '--ws-error-highlight=<kind>', [CompletionResultType]::ParameterName, 'Highlight whitespace errors in the context, old or new lines of the diff')
          [CompletionResult]::new('--full-index', '--full-index', [CompletionResultType]::ParameterName, 'Instead of the first handful of characters, show the full pre- and post-image blob object names on the "index" line when generating patch format output')
          [CompletionResult]::new('--binary', '--binary', [CompletionResultType]::ParameterName, 'In addition to --full-index, output a binary diff that can be applied with git-apply')
          [CompletionResult]::new('--abbrev[=<n>]', '--abbrev[=<n>]', [CompletionResultType]::ParameterName, 'Instead of showing the full 40-byte hexadecimal object name in diff-raw format output and diff-tree header lines, show the shortest prefix that is at least <n> hexdigits long that uniquely refers the object')
          [CompletionResult]::new('-B[<n>][/<m>]', '-B[<n>][/<m>]', [CompletionResultType]::ParameterName, 'Break complete rewrite changes into pairs of delete and create')
          [CompletionResult]::new('--break-rewrites[=[<n>][/<m>]]', '--break-rewrites[=[<n>][/<m>]]', [CompletionResultType]::ParameterName, 'Break complete rewrite changes into pairs of delete and create')
          [CompletionResult]::new('-M[<n>]', '-M[<n>]', [CompletionResultType]::ParameterName, 'Detect renames')
          [CompletionResult]::new('--find-renames[=<n>]', '--find-renames[=<n>]', [CompletionResultType]::ParameterName, 'Detect renames')
          [CompletionResult]::new('-C[<n>]', '-C[<n>]', [CompletionResultType]::ParameterName, 'Detect copies as well as renames')
          [CompletionResult]::new('--find-copies[=<n>]', '--find-copies[=<n>]', [CompletionResultType]::ParameterName, 'Detect copies as well as renames')
          [CompletionResult]::new('--find-copies-harder', '--find-copies-harder', [CompletionResultType]::ParameterName, 'For performance reasons, by default, -C option finds copies only if the original file of the copy was modified in the same changeset')
          [CompletionResult]::new('-D', '-D', [CompletionResultType]::ParameterName, 'Omit the preimage for deletes, i')
          [CompletionResult]::new('--irreversible-delete', '--irreversible-delete', [CompletionResultType]::ParameterName, 'Omit the preimage for deletes, i')
          [CompletionResult]::new('-l<num>', '-l<num>', [CompletionResultType]::ParameterName, 'The -M and -C options involve some preliminary steps that can detect subsets of renames/copies cheaply, followed by an exhaustive fallback portion that compares all remaining unpaired destinations to all relevant sources')
          [CompletionResult]::new('--diff-filter=[(A|C|D|M|R|T|U|X|B)…​[*]]', '--diff-filter=[(A|C|D|M|R|T|U|X|B)…​[*]]', [CompletionResultType]::ParameterName, 'Select only files that are Added (A), Copied (C), Deleted (D), Modified (M), Renamed (R), have their type (i')
          [CompletionResult]::new('-S<string>', '-S<string>', [CompletionResultType]::ParameterName, 'Look for differences that change the number of occurrences of the specified string (i')
          [CompletionResult]::new('-G<regex>', '-G<regex>', [CompletionResultType]::ParameterName, 'Look for differences whose patch text contains added/removed lines that match <regex>')
          [CompletionResult]::new('--find-object=<object-id>', '--find-object=<object-id>', [CompletionResultType]::ParameterName, 'Look for differences that change the number of occurrences of the specified object')
          [CompletionResult]::new('--pickaxe-all', '--pickaxe-all', [CompletionResultType]::ParameterName, 'When -S or -G finds a change, show all the changes in that changeset, not just the files that contain the change in <string>')
          [CompletionResult]::new('--pickaxe-regex', '--pickaxe-regex', [CompletionResultType]::ParameterName, 'Treat the <string> given to -S as an extended POSIX regular expression to match')
          [CompletionResult]::new('-O<orderfile>', '-O<orderfile>', [CompletionResultType]::ParameterName, 'Control the order in which files appear in the output')
          [CompletionResult]::new('--skip-to=<file>', '--skip-to=<file>', [CompletionResultType]::ParameterName, 'Discard the files before the named <file> from the output (i')
          [CompletionResult]::new('--rotate-to=<file>', '--rotate-to=<file>', [CompletionResultType]::ParameterName, 'Discard the files before the named <file> from the output (i')
          [CompletionResult]::new('-R', '-R', [CompletionResultType]::ParameterName, 'Swap two inputs; that is, show differences from index or on-disk file to tree contents')
          [CompletionResult]::new('--relative[=<path>]', '--relative[=<path>]', [CompletionResultType]::ParameterName, 'When run from a subdirectory of the project, it can be told to exclude changes outside the directory and show pathnames relative to it with this option')
          [CompletionResult]::new('--no-relative', '--no-relative', [CompletionResultType]::ParameterName, 'When run from a subdirectory of the project, it can be told to exclude changes outside the directory and show pathnames relative to it with this option')
          [CompletionResult]::new('-a', '-a', [CompletionResultType]::ParameterName, 'Treat all files as text')
          [CompletionResult]::new('--text', '--text', [CompletionResultType]::ParameterName, 'Treat all files as text')
          [CompletionResult]::new('--ignore-cr-at-eol', '--ignore-cr-at-eol', [CompletionResultType]::ParameterName, 'Ignore carriage-return at the end of line when doing a comparison')
          [CompletionResult]::new('--ignore-space-at-eol', '--ignore-space-at-eol', [CompletionResultType]::ParameterName, 'Ignore changes in whitespace at EOL')
          [CompletionResult]::new('-b', '-b', [CompletionResultType]::ParameterName, 'Ignore changes in amount of whitespace')
          [CompletionResult]::new('--ignore-space-change', '--ignore-space-change', [CompletionResultType]::ParameterName, 'Ignore changes in amount of whitespace')
          [CompletionResult]::new('-w', '-w', [CompletionResultType]::ParameterName, 'Ignore whitespace when comparing lines')
          [CompletionResult]::new('--ignore-all-space', '--ignore-all-space', [CompletionResultType]::ParameterName, 'Ignore whitespace when comparing lines')
          [CompletionResult]::new('--ignore-blank-lines', '--ignore-blank-lines', [CompletionResultType]::ParameterName, 'Ignore changes whose lines are all blank')
          [CompletionResult]::new('-I<regex>', '-I<regex>', [CompletionResultType]::ParameterName, 'Ignore changes whose all lines match <regex>')
          [CompletionResult]::new('--ignore-matching-lines=<regex>', '--ignore-matching-lines=<regex>', [CompletionResultType]::ParameterName, 'Ignore changes whose all lines match <regex>')
          [CompletionResult]::new('--inter-hunk-context=<lines>', '--inter-hunk-context=<lines>', [CompletionResultType]::ParameterName, 'Show the context between diff hunks, up to the specified number of lines, thereby fusing hunks that are close to each other')
          [CompletionResult]::new('-W', '-W', [CompletionResultType]::ParameterName, 'Show whole function as context lines for each change')
          [CompletionResult]::new('--function-context', '--function-context', [CompletionResultType]::ParameterName, 'Show whole function as context lines for each change')
          [CompletionResult]::new('--exit-code', '--exit-code', [CompletionResultType]::ParameterName, 'Make the program exit with codes similar to diff(1)')
          [CompletionResult]::new('--quiet', '--quiet', [CompletionResultType]::ParameterName, 'Disable all output of the program')
          [CompletionResult]::new('--ext-diff', '--ext-diff', [CompletionResultType]::ParameterName, 'Allow an external diff helper to be executed')
          [CompletionResult]::new('--no-ext-diff', '--no-ext-diff', [CompletionResultType]::ParameterName, 'Disallow external diff drivers')
          [CompletionResult]::new('--textconv', '--textconv', [CompletionResultType]::ParameterName, 'Allow (or disallow) external text conversion filters to be run when comparing binary files')
          [CompletionResult]::new('--no-textconv', '--no-textconv', [CompletionResultType]::ParameterName, 'Allow (or disallow) external text conversion filters to be run when comparing binary files')
          [CompletionResult]::new('--ignore-submodules[=<when>]', '--ignore-submodules[=<when>]', [CompletionResultType]::ParameterName, 'Ignore changes to submodules in the diff generation')
          [CompletionResult]::new('--src-prefix=<prefix>', '--src-prefix=<prefix>', [CompletionResultType]::ParameterName, 'Show the given source prefix instead of "a/"')
          [CompletionResult]::new('--dst-prefix=<prefix>', '--dst-prefix=<prefix>', [CompletionResultType]::ParameterName, 'Show the given destination prefix instead of "b/"')
          [CompletionResult]::new('--no-prefix', '--no-prefix', [CompletionResultType]::ParameterName, 'Do not show any source or destination prefix')
          [CompletionResult]::new('--default-prefix', '--default-prefix', [CompletionResultType]::ParameterName, 'Use the default source and destination prefixes ("a/" and "b/")')
          [CompletionResult]::new('--line-prefix=<prefix>', '--line-prefix=<prefix>', [CompletionResultType]::ParameterName, 'Prepend an additional prefix to every line of output')
          [CompletionResult]::new('--ita-invisible-in-index', '--ita-invisible-in-index', [CompletionResultType]::ParameterName, 'By default entries added by "git add -N" appear as an existing empty file in "git diff" and a new file in "git diff --cached"')
        }
        break
      }
      'fetch' {
        if ($wordToComplete.StartsWith('-')) {
          [CompletionResult]::new('--[no-]all', '--[no-]all', [CompletionResultType]::ParameterName, 'Fetch all remotes, except for the ones that has the remote')
          [CompletionResult]::new('-a', '-a', [CompletionResultType]::ParameterName, 'Append ref names and object names of fetched refs to the existing contents of')
          [CompletionResult]::new('--append', '--append', [CompletionResultType]::ParameterName, 'Append ref names and object names of fetched refs to the existing contents of')
          [CompletionResult]::new('--atomic', '--atomic', [CompletionResultType]::ParameterName, 'Use an atomic transaction to update local refs')
          [CompletionResult]::new('--depth=<depth>', '--depth=<depth>', [CompletionResultType]::ParameterName, 'Limit fetching to the specified number of commits from the tip of each remote branch history')
          [CompletionResult]::new('--deepen=<depth>', '--deepen=<depth>', [CompletionResultType]::ParameterName, 'Similar to --depth, except it specifies the number of commits from the current shallow boundary instead of from the tip of each remote branch history')
          [CompletionResult]::new('--shallow-since=<date>', '--shallow-since=<date>', [CompletionResultType]::ParameterName, 'Deepen or shorten the history of a shallow repository to include all reachable commits after <date>')
          [CompletionResult]::new('--shallow-exclude=<revision>', '--shallow-exclude=<revision>', [CompletionResultType]::ParameterName, 'Deepen or shorten the history of a shallow repository to exclude commits reachable from a specified remote branch or tag')
          [CompletionResult]::new('--unshallow', '--unshallow', [CompletionResultType]::ParameterName, 'If the source repository is complete, convert a shallow repository to a complete one, removing all the limitations imposed by shallow repositories')
          [CompletionResult]::new('--update-shallow', '--update-shallow', [CompletionResultType]::ParameterName, 'By default when fetching from a shallow repository, git fetch refuses refs that require updating')
          [CompletionResult]::new('--negotiation-tip=<commit|glob>', '--negotiation-tip=<commit|glob>', [CompletionResultType]::ParameterName, 'By default, Git will report, to the server, commits reachable from all local refs to find common commits in an attempt to reduce the size of the to-be-received packfile')
          [CompletionResult]::new('--negotiate-only', '--negotiate-only', [CompletionResultType]::ParameterName, 'Do not fetch anything from the server, and instead print the ancestors of the provided --negotiation-tip=* arguments, which we have in common with the server')
          [CompletionResult]::new('--dry-run', '--dry-run', [CompletionResultType]::ParameterName, 'Show what would be done, without making any changes')
          [CompletionResult]::new('--porcelain', '--porcelain', [CompletionResultType]::ParameterName, 'Print the output to standard output in an easy-to-parse format for scripts')
          [CompletionResult]::new('--[no-]write-fetch-head', '--[no-]write-fetch-head', [CompletionResultType]::ParameterName, 'Write the list of remote refs fetched in the FETCH_HEAD file directly under $GIT_DIR')
          [CompletionResult]::new('-f', '-f', [CompletionResultType]::ParameterName, 'When git fetch is used with <src>:<dst> refspec, it may refuse to update the local branch as discussed in the <refspec> part below')
          [CompletionResult]::new('--force', '--force', [CompletionResultType]::ParameterName, 'When git fetch is used with <src>:<dst> refspec, it may refuse to update the local branch as discussed in the <refspec> part below')
          [CompletionResult]::new('-k', '-k', [CompletionResultType]::ParameterName, 'Keep downloaded pack')
          [CompletionResult]::new('--keep', '--keep', [CompletionResultType]::ParameterName, 'Keep downloaded pack')
          [CompletionResult]::new('--multiple', '--multiple', [CompletionResultType]::ParameterName, 'Allow several <repository> and <group> arguments to be specified')
          [CompletionResult]::new('--[no-]auto-maintenance', '--[no-]auto-maintenance', [CompletionResultType]::ParameterName, 'Run git maintenance run --auto at the end to perform automatic repository maintenance if needed')
          [CompletionResult]::new('--[no-]auto-gc', '--[no-]auto-gc', [CompletionResultType]::ParameterName, 'Run git maintenance run --auto at the end to perform automatic repository maintenance if needed')
          [CompletionResult]::new('--[no-]write-commit-graph', '--[no-]write-commit-graph', [CompletionResultType]::ParameterName, 'Write a commit-graph after fetching')
          [CompletionResult]::new('--prefetch', '--prefetch', [CompletionResultType]::ParameterName, 'Modify the configured refspec to place all refs into the refs/prefetch/ namespace')
          [CompletionResult]::new('-p', '-p', [CompletionResultType]::ParameterName, 'Before fetching, remove any remote-tracking references that no longer exist on the remote')
          [CompletionResult]::new('--prune', '--prune', [CompletionResultType]::ParameterName, 'Before fetching, remove any remote-tracking references that no longer exist on the remote')
          [CompletionResult]::new('-P', '-P', [CompletionResultType]::ParameterName, 'Before fetching, remove any local tags that no longer exist on the remote if --prune is enabled')
          [CompletionResult]::new('--prune-tags', '--prune-tags', [CompletionResultType]::ParameterName, 'Before fetching, remove any local tags that no longer exist on the remote if --prune is enabled')
          [CompletionResult]::new('-n', '-n', [CompletionResultType]::ParameterName, 'By default, tags that point at objects that are downloaded from the remote repository are fetched and stored locally')
          [CompletionResult]::new('--no-tags', '--no-tags', [CompletionResultType]::ParameterName, 'By default, tags that point at objects that are downloaded from the remote repository are fetched and stored locally')
          [CompletionResult]::new('--refetch', '--refetch', [CompletionResultType]::ParameterName, 'Instead of negotiating with the server to avoid transferring commits and associated objects that are already present locally, this option fetches all objects as a fresh clone would')
          [CompletionResult]::new('--refmap=<refspec>', '--refmap=<refspec>', [CompletionResultType]::ParameterName, 'When fetching refs listed on the command line, use the specified refspec (can be given more than once) to map the refs to remote-tracking branches, instead of the values of remote')
          [CompletionResult]::new('-t', '-t', [CompletionResultType]::ParameterName, 'Fetch all tags from the remote (i')
          [CompletionResult]::new('--tags', '--tags', [CompletionResultType]::ParameterName, 'Fetch all tags from the remote (i')
          [CompletionResult]::new('--recurse-submodules[=(yes|on-demand|no)]', '--recurse-submodules[=(yes|on-demand|no)]', [CompletionResultType]::ParameterName, 'This option controls if and under what conditions new commits of submodules should be fetched too')
          [CompletionResult]::new('-j', '-j', [CompletionResultType]::ParameterName, 'Number of parallel children to be used for all forms of fetching')
          [CompletionResult]::new('--jobs=<n>', '--jobs=<n>', [CompletionResultType]::ParameterName, 'Number of parallel children to be used for all forms of fetching')
          [CompletionResult]::new('--no-recurse-submodules', '--no-recurse-submodules', [CompletionResultType]::ParameterName, 'Disable recursive fetching of submodules (this has the same effect as using the --recurse-submodules=no option)')
          [CompletionResult]::new('--set-upstream', '--set-upstream', [CompletionResultType]::ParameterName, 'If the remote is fetched successfully, add upstream (tracking) reference, used by argument-less git-pull(1) and other commands')
          [CompletionResult]::new('--submodule-prefix=<path>', '--submodule-prefix=<path>', [CompletionResultType]::ParameterName, 'Prepend <path> to paths printed in informative messages such as "Fetching submodule foo"')
          [CompletionResult]::new('--recurse-submodules-default=[yes|on-demand]', '--recurse-submodules-default=[yes|on-demand]', [CompletionResultType]::ParameterName, 'This option is used internally to temporarily provide a non-negative default value for the --recurse-submodules option')
          [CompletionResult]::new('-u', '-u', [CompletionResultType]::ParameterName, 'By default git fetch refuses to update the head which corresponds to the current branch')
          [CompletionResult]::new('--update-head-ok', '--update-head-ok', [CompletionResultType]::ParameterName, 'By default git fetch refuses to update the head which corresponds to the current branch')
          [CompletionResult]::new('--upload-pack', '--upload-pack', [CompletionResultType]::ParameterName, 'When given, and the repository to fetch from is handled by git fetch-pack, --exec=<upload-pack> is passed to the command to specify non-default path for the command run on the other end')
          [CompletionResult]::new('-q', '-q', [CompletionResultType]::ParameterName, 'Pass --quiet to git-fetch-pack and silence any other internally used git commands')
          [CompletionResult]::new('--quiet', '--quiet', [CompletionResultType]::ParameterName, 'Pass --quiet to git-fetch-pack and silence any other internally used git commands')
          [CompletionResult]::new('-v', '-v', [CompletionResultType]::ParameterName, 'Be verbose')
          [CompletionResult]::new('--verbose', '--verbose', [CompletionResultType]::ParameterName, 'Be verbose')
          [CompletionResult]::new('--progress', '--progress', [CompletionResultType]::ParameterName, 'Progress status is reported on the standard error stream by default when it is attached to a terminal, unless -q is specified')
          [CompletionResult]::new('-o', '-o', [CompletionResultType]::ParameterName, 'Transmit the given string to the server when communicating using protocol version 2')
          [CompletionResult]::new('--server-option=<option>', '--server-option=<option>', [CompletionResultType]::ParameterName, 'Transmit the given string to the server when communicating using protocol version 2')
          [CompletionResult]::new('--show-forced-updates', '--show-forced-updates', [CompletionResultType]::ParameterName, 'By default, git checks if a branch is force-updated during fetch')
          [CompletionResult]::new('--no-show-forced-updates', '--no-show-forced-updates', [CompletionResultType]::ParameterName, 'By default, git checks if a branch is force-updated during fetch')
          [CompletionResult]::new('-4', '-4', [CompletionResultType]::ParameterName, 'Use IPv4 addresses only, ignoring IPv6 addresses')
          [CompletionResult]::new('--ipv4', '--ipv4', [CompletionResultType]::ParameterName, 'Use IPv4 addresses only, ignoring IPv6 addresses')
          [CompletionResult]::new('-6', '-6', [CompletionResultType]::ParameterName, 'Use IPv6 addresses only, ignoring IPv4 addresses')
          [CompletionResult]::new('--ipv6', '--ipv6', [CompletionResultType]::ParameterName, 'Use IPv6 addresses only, ignoring IPv4 addresses')
          [CompletionResult]::new('<repository>', '<repository>', [CompletionResultType]::ParameterName, 'The "remote" repository that is the source of a fetch or pull operation')
          [CompletionResult]::new('<group>', '<group>', [CompletionResultType]::ParameterName, 'A name referring to a list of repositories as the value of remotes')
          [CompletionResult]::new('<refspec>', '<refspec>', [CompletionResultType]::ParameterName, 'Specifies which refs to fetch and which local refs to update')
          [CompletionResult]::new('--stdin', '--stdin', [CompletionResultType]::ParameterName, 'Read refspecs, one per line, from stdin in addition to those provided as arguments')
        }
        break
      }
      'format-patch' {
        if ($wordToComplete.StartsWith('-')) {
          [CompletionResult]::new('-p', '-p', [CompletionResultType]::ParameterName, 'Generate plain patches without any diffstats')
          [CompletionResult]::new('--no-stat', '--no-stat', [CompletionResultType]::ParameterName, 'Generate plain patches without any diffstats')
          [CompletionResult]::new('-U<n>', '-U<n>', [CompletionResultType]::ParameterName, 'Generate diffs with <n> lines of context instead of the usual three')
          [CompletionResult]::new('--unified=<n>', '--unified=<n>', [CompletionResultType]::ParameterName, 'Generate diffs with <n> lines of context instead of the usual three')
          [CompletionResult]::new('--output=<file>', '--output=<file>', [CompletionResultType]::ParameterName, 'Output to a specific file instead of stdout')
          [CompletionResult]::new('--output-indicator-new=<char>', '--output-indicator-new=<char>', [CompletionResultType]::ParameterName, 'Specify the character used to indicate new, old or context lines in the generated patch')
          [CompletionResult]::new('--output-indicator-old=<char>', '--output-indicator-old=<char>', [CompletionResultType]::ParameterName, 'Specify the character used to indicate new, old or context lines in the generated patch')
          [CompletionResult]::new('--output-indicator-context=<char>', '--output-indicator-context=<char>', [CompletionResultType]::ParameterName, 'Specify the character used to indicate new, old or context lines in the generated patch')
          [CompletionResult]::new('--indent-heuristic', '--indent-heuristic', [CompletionResultType]::ParameterName, 'Enable the heuristic that shifts diff hunk boundaries to make patches easier to read')
          [CompletionResult]::new('--no-indent-heuristic', '--no-indent-heuristic', [CompletionResultType]::ParameterName, 'Disable the indent heuristic')
          [CompletionResult]::new('--minimal', '--minimal', [CompletionResultType]::ParameterName, 'Spend extra time to make sure the smallest possible diff is produced')
          [CompletionResult]::new('--patience', '--patience', [CompletionResultType]::ParameterName, 'Generate a diff using the "patience diff" algorithm')
          [CompletionResult]::new('--histogram', '--histogram', [CompletionResultType]::ParameterName, 'Generate a diff using the "histogram diff" algorithm')
          [CompletionResult]::new('--anchored=<text>', '--anchored=<text>', [CompletionResultType]::ParameterName, 'Generate a diff using the "anchored diff" algorithm')
          [CompletionResult]::new('--diff-algorithm={patience|minimal|histogram|myers}', '--diff-algorithm={patience|minimal|histogram|myers}', [CompletionResultType]::ParameterName, 'Choose a diff algorithm')
          [CompletionResult]::new('--stat[=<width>[,<name-width>[,<count>]]]', '--stat[=<width>[,<name-width>[,<count>]]]', [CompletionResultType]::ParameterName, 'Generate a diffstat')
          [CompletionResult]::new('--compact-summary', '--compact-summary', [CompletionResultType]::ParameterName, 'Output a condensed summary of extended header information such as file creations or deletions ("new" or "gone", optionally "+l" if it' + "'" + 's a symlink) and mode changes ("+x" or "-x" for adding or removing executable bit respectively) in diffstat')
          [CompletionResult]::new('--numstat', '--numstat', [CompletionResultType]::ParameterName, 'Similar to --stat, but shows number of added and deleted lines in decimal notation and pathname without abbreviation, to make it more machine friendly')
          [CompletionResult]::new('--shortstat', '--shortstat', [CompletionResultType]::ParameterName, 'Output only the last line of the --stat format containing total number of modified files, as well as number of added and deleted lines')
          [CompletionResult]::new('-X[<param1,param2,…​>]', '-X[<param1,param2,…​>]', [CompletionResultType]::ParameterName, 'Output the distribution of relative amount of changes for each sub-directory')
          [CompletionResult]::new('--dirstat[=<param1,param2,…​>]', '--dirstat[=<param1,param2,…​>]', [CompletionResultType]::ParameterName, 'Output the distribution of relative amount of changes for each sub-directory')
          [CompletionResult]::new('--cumulative', '--cumulative', [CompletionResultType]::ParameterName, 'Synonym for --dirstat=cumulative')
          [CompletionResult]::new('--dirstat-by-file[=<param1,param2>…​]', '--dirstat-by-file[=<param1,param2>…​]', [CompletionResultType]::ParameterName, 'Synonym for --dirstat=files,<param1>,<param2>…​')
          [CompletionResult]::new('--summary', '--summary', [CompletionResultType]::ParameterName, 'Output a condensed summary of extended header information such as creations, renames and mode changes')
          [CompletionResult]::new('--no-renames', '--no-renames', [CompletionResultType]::ParameterName, 'Turn off rename detection, even when the configuration file gives the default to do so')
          [CompletionResult]::new('--[no-]rename-empty', '--[no-]rename-empty', [CompletionResultType]::ParameterName, 'Whether to use empty blobs as rename source')
          [CompletionResult]::new('--full-index', '--full-index', [CompletionResultType]::ParameterName, 'Instead of the first handful of characters, show the full pre- and post-image blob object names on the "index" line when generating patch format output')
          [CompletionResult]::new('--binary', '--binary', [CompletionResultType]::ParameterName, 'In addition to --full-index, output a binary diff that can be applied with git-apply')
          [CompletionResult]::new('--abbrev[=<n>]', '--abbrev[=<n>]', [CompletionResultType]::ParameterName, 'Instead of showing the full 40-byte hexadecimal object name in diff-raw format output and diff-tree header lines, show the shortest prefix that is at least <n> hexdigits long that uniquely refers the object')
          [CompletionResult]::new('-B[<n>][/<m>]', '-B[<n>][/<m>]', [CompletionResultType]::ParameterName, 'Break complete rewrite changes into pairs of delete and create')
          [CompletionResult]::new('--break-rewrites[=[<n>][/<m>]]', '--break-rewrites[=[<n>][/<m>]]', [CompletionResultType]::ParameterName, 'Break complete rewrite changes into pairs of delete and create')
          [CompletionResult]::new('-M[<n>]', '-M[<n>]', [CompletionResultType]::ParameterName, 'Detect renames')
          [CompletionResult]::new('--find-renames[=<n>]', '--find-renames[=<n>]', [CompletionResultType]::ParameterName, 'Detect renames')
          [CompletionResult]::new('-C[<n>]', '-C[<n>]', [CompletionResultType]::ParameterName, 'Detect copies as well as renames')
          [CompletionResult]::new('--find-copies[=<n>]', '--find-copies[=<n>]', [CompletionResultType]::ParameterName, 'Detect copies as well as renames')
          [CompletionResult]::new('--find-copies-harder', '--find-copies-harder', [CompletionResultType]::ParameterName, 'For performance reasons, by default, -C option finds copies only if the original file of the copy was modified in the same changeset')
          [CompletionResult]::new('-D', '-D', [CompletionResultType]::ParameterName, 'Omit the preimage for deletes, i')
          [CompletionResult]::new('--irreversible-delete', '--irreversible-delete', [CompletionResultType]::ParameterName, 'Omit the preimage for deletes, i')
          [CompletionResult]::new('-l<num>', '-l<num>', [CompletionResultType]::ParameterName, 'The -M and -C options involve some preliminary steps that can detect subsets of renames/copies cheaply, followed by an exhaustive fallback portion that compares all remaining unpaired destinations to all relevant sources')
          [CompletionResult]::new('-O<orderfile>', '-O<orderfile>', [CompletionResultType]::ParameterName, 'Control the order in which files appear in the output')
          [CompletionResult]::new('--skip-to=<file>', '--skip-to=<file>', [CompletionResultType]::ParameterName, 'Discard the files before the named <file> from the output (i')
          [CompletionResult]::new('--rotate-to=<file>', '--rotate-to=<file>', [CompletionResultType]::ParameterName, 'Discard the files before the named <file> from the output (i')
          [CompletionResult]::new('--relative[=<path>]', '--relative[=<path>]', [CompletionResultType]::ParameterName, 'When run from a subdirectory of the project, it can be told to exclude changes outside the directory and show pathnames relative to it with this option')
          [CompletionResult]::new('--no-relative', '--no-relative', [CompletionResultType]::ParameterName, 'When run from a subdirectory of the project, it can be told to exclude changes outside the directory and show pathnames relative to it with this option')
          [CompletionResult]::new('-a', '-a', [CompletionResultType]::ParameterName, 'Treat all files as text')
          [CompletionResult]::new('--text', '--text', [CompletionResultType]::ParameterName, 'Treat all files as text')
          [CompletionResult]::new('--ignore-cr-at-eol', '--ignore-cr-at-eol', [CompletionResultType]::ParameterName, 'Ignore carriage-return at the end of line when doing a comparison')
          [CompletionResult]::new('--ignore-space-at-eol', '--ignore-space-at-eol', [CompletionResultType]::ParameterName, 'Ignore changes in whitespace at EOL')
          [CompletionResult]::new('-b', '-b', [CompletionResultType]::ParameterName, 'Ignore changes in amount of whitespace')
          [CompletionResult]::new('--ignore-space-change', '--ignore-space-change', [CompletionResultType]::ParameterName, 'Ignore changes in amount of whitespace')
          [CompletionResult]::new('-w', '-w', [CompletionResultType]::ParameterName, 'Ignore whitespace when comparing lines')
          [CompletionResult]::new('--ignore-all-space', '--ignore-all-space', [CompletionResultType]::ParameterName, 'Ignore whitespace when comparing lines')
          [CompletionResult]::new('--ignore-blank-lines', '--ignore-blank-lines', [CompletionResultType]::ParameterName, 'Ignore changes whose lines are all blank')
          [CompletionResult]::new('-I<regex>', '-I<regex>', [CompletionResultType]::ParameterName, 'Ignore changes whose all lines match <regex>')
          [CompletionResult]::new('--ignore-matching-lines=<regex>', '--ignore-matching-lines=<regex>', [CompletionResultType]::ParameterName, 'Ignore changes whose all lines match <regex>')
          [CompletionResult]::new('--inter-hunk-context=<lines>', '--inter-hunk-context=<lines>', [CompletionResultType]::ParameterName, 'Show the context between diff hunks, up to the specified number of lines, thereby fusing hunks that are close to each other')
          [CompletionResult]::new('-W', '-W', [CompletionResultType]::ParameterName, 'Show whole function as context lines for each change')
          [CompletionResult]::new('--function-context', '--function-context', [CompletionResultType]::ParameterName, 'Show whole function as context lines for each change')
          [CompletionResult]::new('--ext-diff', '--ext-diff', [CompletionResultType]::ParameterName, 'Allow an external diff helper to be executed')
          [CompletionResult]::new('--no-ext-diff', '--no-ext-diff', [CompletionResultType]::ParameterName, 'Disallow external diff drivers')
          [CompletionResult]::new('--textconv', '--textconv', [CompletionResultType]::ParameterName, 'Allow (or disallow) external text conversion filters to be run when comparing binary files')
          [CompletionResult]::new('--no-textconv', '--no-textconv', [CompletionResultType]::ParameterName, 'Allow (or disallow) external text conversion filters to be run when comparing binary files')
          [CompletionResult]::new('--ignore-submodules[=<when>]', '--ignore-submodules[=<when>]', [CompletionResultType]::ParameterName, 'Ignore changes to submodules in the diff generation')
          [CompletionResult]::new('--src-prefix=<prefix>', '--src-prefix=<prefix>', [CompletionResultType]::ParameterName, 'Show the given source prefix instead of "a/"')
          [CompletionResult]::new('--dst-prefix=<prefix>', '--dst-prefix=<prefix>', [CompletionResultType]::ParameterName, 'Show the given destination prefix instead of "b/"')
          [CompletionResult]::new('--no-prefix', '--no-prefix', [CompletionResultType]::ParameterName, 'Do not show any source or destination prefix')
          [CompletionResult]::new('--default-prefix', '--default-prefix', [CompletionResultType]::ParameterName, 'Use the default source and destination prefixes ("a/" and "b/")')
          [CompletionResult]::new('--line-prefix=<prefix>', '--line-prefix=<prefix>', [CompletionResultType]::ParameterName, 'Prepend an additional prefix to every line of output')
          [CompletionResult]::new('--ita-invisible-in-index', '--ita-invisible-in-index', [CompletionResultType]::ParameterName, 'By default entries added by "git add -N" appear as an existing empty file in "git diff" and a new file in "git diff --cached"')
        }
        break
      }
      'gc' {
        if ($wordToComplete.StartsWith('-')) {
          [CompletionResult]::new('--aggressive', '--aggressive', [CompletionResultType]::ParameterName, 'Usually git gc runs very quickly while providing good disk space utilization and performance')
          [CompletionResult]::new('--auto', '--auto', [CompletionResultType]::ParameterName, 'With this option, git gc checks whether any housekeeping is required; if not, it exits without performing any work')
          [CompletionResult]::new('--[no-]detach', '--[no-]detach', [CompletionResultType]::ParameterName, 'Run in the background if the system supports it')
          [CompletionResult]::new('--[no-]cruft', '--[no-]cruft', [CompletionResultType]::ParameterName, 'When expiring unreachable objects, pack them separately into a cruft pack instead of storing them as loose objects')
          [CompletionResult]::new('--max-cruft-size=<n>', '--max-cruft-size=<n>', [CompletionResultType]::ParameterName, 'When packing unreachable objects into a cruft pack, limit the size of new cruft packs to be at most <n> bytes')
          [CompletionResult]::new('--prune=<date>', '--prune=<date>', [CompletionResultType]::ParameterName, 'Prune loose objects older than date (default is 2 weeks ago, overridable by the config variable gc')
          [CompletionResult]::new('--no-prune', '--no-prune', [CompletionResultType]::ParameterName, 'Do not prune any loose objects')
          [CompletionResult]::new('--quiet', '--quiet', [CompletionResultType]::ParameterName, 'Suppress all progress reports')
          [CompletionResult]::new('--force', '--force', [CompletionResultType]::ParameterName, 'Force git gc to run even if there may be another git gc instance running on this repository')
          [CompletionResult]::new('--keep-largest-pack', '--keep-largest-pack', [CompletionResultType]::ParameterName, 'All packs except the largest non-cruft pack, any packs marked with a')
        }
        break
      }
      'grep' {
        if ($wordToComplete.StartsWith('-')) {
          [CompletionResult]::new('--cached', '--cached', [CompletionResultType]::ParameterName, 'Instead of searching tracked files in the working tree, search blobs registered in the index file')
          [CompletionResult]::new('--untracked', '--untracked', [CompletionResultType]::ParameterName, 'In addition to searching in the tracked files in the working tree, search also in untracked files')
          [CompletionResult]::new('--no-index', '--no-index', [CompletionResultType]::ParameterName, 'Search files in the current directory that is not managed by Git, or by ignoring that the current directory is managed by Git')
          [CompletionResult]::new('--no-exclude-standard', '--no-exclude-standard', [CompletionResultType]::ParameterName, 'Also search in ignored files by not honoring the')
          [CompletionResult]::new('--exclude-standard', '--exclude-standard', [CompletionResultType]::ParameterName, 'Do not pay attention to ignored files specified via the')
          [CompletionResult]::new('--recurse-submodules', '--recurse-submodules', [CompletionResultType]::ParameterName, 'Recursively search in each submodule that is active and checked out in the repository')
          [CompletionResult]::new('-a', '-a', [CompletionResultType]::ParameterName, 'Process binary files as if they were text')
          [CompletionResult]::new('--text', '--text', [CompletionResultType]::ParameterName, 'Process binary files as if they were text')
          [CompletionResult]::new('--textconv', '--textconv', [CompletionResultType]::ParameterName, 'Honor textconv filter settings')
          [CompletionResult]::new('--no-textconv', '--no-textconv', [CompletionResultType]::ParameterName, 'Do not honor textconv filter settings')
          [CompletionResult]::new('-i', '-i', [CompletionResultType]::ParameterName, 'Ignore case differences between the patterns and the files')
          [CompletionResult]::new('--ignore-case', '--ignore-case', [CompletionResultType]::ParameterName, 'Ignore case differences between the patterns and the files')
          [CompletionResult]::new('-I', '-I', [CompletionResultType]::ParameterName, "Don't match the pattern in binary files")
          [CompletionResult]::new('--max-depth', '--max-depth', [CompletionResultType]::ParameterName, 'For each <pathspec> given on command line, descend at most <depth> levels of directories')
          [CompletionResult]::new('-r', '-r', [CompletionResultType]::ParameterName, 'Same as --max-depth=-1; this is the default')
          [CompletionResult]::new('--recursive', '--recursive', [CompletionResultType]::ParameterName, 'Same as --max-depth=-1; this is the default')
          [CompletionResult]::new('--no-recursive', '--no-recursive', [CompletionResultType]::ParameterName, 'Same as --max-depth=0')
          [CompletionResult]::new('-w', '-w', [CompletionResultType]::ParameterName, 'Match the pattern only at word boundary (either begin at the beginning of a line, or preceded by a non-word character; end at the end of a line or followed by a non-word character)')
          [CompletionResult]::new('--word-regexp', '--word-regexp', [CompletionResultType]::ParameterName, 'Match the pattern only at word boundary (either begin at the beginning of a line, or preceded by a non-word character; end at the end of a line or followed by a non-word character)')
          [CompletionResult]::new('-v', '-v', [CompletionResultType]::ParameterName, 'Select non-matching lines')
          [CompletionResult]::new('--invert-match', '--invert-match', [CompletionResultType]::ParameterName, 'Select non-matching lines')
          [CompletionResult]::new('-h', '-h', [CompletionResultType]::ParameterName, 'By default, the command shows the filename for each match')
          [CompletionResult]::new('-H', '-H', [CompletionResultType]::ParameterName, 'By default, the command shows the filename for each match')
          [CompletionResult]::new('--full-name', '--full-name', [CompletionResultType]::ParameterName, 'When run from a subdirectory, the command usually outputs paths relative to the current directory')
          [CompletionResult]::new('-E', '-E', [CompletionResultType]::ParameterName, 'Use POSIX extended/basic regexp for patterns')
          [CompletionResult]::new('--extended-regexp', '--extended-regexp', [CompletionResultType]::ParameterName, 'Use POSIX extended/basic regexp for patterns')
          [CompletionResult]::new('-G', '-G', [CompletionResultType]::ParameterName, 'Use POSIX extended/basic regexp for patterns')
          [CompletionResult]::new('--basic-regexp', '--basic-regexp', [CompletionResultType]::ParameterName, 'Use POSIX extended/basic regexp for patterns')
          [CompletionResult]::new('-P', '-P', [CompletionResultType]::ParameterName, 'Use Perl-compatible regular expressions for patterns')
          [CompletionResult]::new('--perl-regexp', '--perl-regexp', [CompletionResultType]::ParameterName, 'Use Perl-compatible regular expressions for patterns')
          [CompletionResult]::new('-F', '-F', [CompletionResultType]::ParameterName, "Use fixed strings for patterns (don't interpret pattern as a regex)")
          [CompletionResult]::new('--fixed-strings', '--fixed-strings', [CompletionResultType]::ParameterName, "Use fixed strings for patterns (don't interpret pattern as a regex)")
          [CompletionResult]::new('-n', '-n', [CompletionResultType]::ParameterName, 'Prefix the line number to matching lines')
          [CompletionResult]::new('--line-number', '--line-number', [CompletionResultType]::ParameterName, 'Prefix the line number to matching lines')
          [CompletionResult]::new('--column', '--column', [CompletionResultType]::ParameterName, 'Prefix the 1-indexed byte-offset of the first match from the start of the matching line')
          [CompletionResult]::new('-l', '-l', [CompletionResultType]::ParameterName, 'Instead of showing every matched line, show only the names of files that contain (or do not contain) matches')
          [CompletionResult]::new('--files-with-matches', '--files-with-matches', [CompletionResultType]::ParameterName, 'Instead of showing every matched line, show only the names of files that contain (or do not contain) matches')
          [CompletionResult]::new('--name-only', '--name-only', [CompletionResultType]::ParameterName, 'Instead of showing every matched line, show only the names of files that contain (or do not contain) matches')
          [CompletionResult]::new('-L', '-L', [CompletionResultType]::ParameterName, 'Instead of showing every matched line, show only the names of files that contain (or do not contain) matches')
          [CompletionResult]::new('--files-without-match', '--files-without-match', [CompletionResultType]::ParameterName, 'Instead of showing every matched line, show only the names of files that contain (or do not contain) matches')
          [CompletionResult]::new('-O[<pager>]', '-O[<pager>]', [CompletionResultType]::ParameterName, 'Open the matching files in the pager (not the output of grep)')
          [CompletionResult]::new('--open-files-in-pager[=<pager>]', '--open-files-in-pager[=<pager>]', [CompletionResultType]::ParameterName, 'Open the matching files in the pager (not the output of grep)')
          [CompletionResult]::new('-z', '-z', [CompletionResultType]::ParameterName, 'Use \0 as the delimiter for pathnames in the output, and print them verbatim')
          [CompletionResult]::new('--null', '--null', [CompletionResultType]::ParameterName, 'Use \0 as the delimiter for pathnames in the output, and print them verbatim')
          [CompletionResult]::new('-o', '-o', [CompletionResultType]::ParameterName, 'Print only the matched (non-empty) parts of a matching line, with each such part on a separate output line')
          [CompletionResult]::new('--only-matching', '--only-matching', [CompletionResultType]::ParameterName, 'Print only the matched (non-empty) parts of a matching line, with each such part on a separate output line')
          [CompletionResult]::new('-c', '-c', [CompletionResultType]::ParameterName, 'Instead of showing every matched line, show the number of lines that match')
          [CompletionResult]::new('--count', '--count', [CompletionResultType]::ParameterName, 'Instead of showing every matched line, show the number of lines that match')
          [CompletionResult]::new('--color[=<when>]', '--color[=<when>]', [CompletionResultType]::ParameterName, 'Show colored matches')
          [CompletionResult]::new('--no-color', '--no-color', [CompletionResultType]::ParameterName, 'Turn off match highlighting, even when the configuration file gives the default to color output')
          [CompletionResult]::new('--break', '--break', [CompletionResultType]::ParameterName, 'Print an empty line between matches from different files')
          [CompletionResult]::new('--heading', '--heading', [CompletionResultType]::ParameterName, 'Show the filename above the matches in that file instead of at the start of each shown line')
          [CompletionResult]::new('-p', '-p', [CompletionResultType]::ParameterName, 'Show the preceding line that contains the function name of the match, unless the matching line is a function name itself')
          [CompletionResult]::new('--show-function', '--show-function', [CompletionResultType]::ParameterName, 'Show the preceding line that contains the function name of the match, unless the matching line is a function name itself')
          [CompletionResult]::new('-<num>', '-<num>', [CompletionResultType]::ParameterName, 'Show <num> leading and trailing lines, and place a line containing -- between contiguous groups of matches')
          [CompletionResult]::new('-C', '-C', [CompletionResultType]::ParameterName, 'Show <num> leading and trailing lines, and place a line containing -- between contiguous groups of matches')
          [CompletionResult]::new('--context', '--context', [CompletionResultType]::ParameterName, 'Show <num> leading and trailing lines, and place a line containing -- between contiguous groups of matches')
          [CompletionResult]::new('-A', '-A', [CompletionResultType]::ParameterName, 'Show <num> trailing lines, and place a line containing -- between contiguous groups of matches')
          [CompletionResult]::new('--after-context', '--after-context', [CompletionResultType]::ParameterName, 'Show <num> trailing lines, and place a line containing -- between contiguous groups of matches')
          [CompletionResult]::new('-B', '-B', [CompletionResultType]::ParameterName, 'Show <num> leading lines, and place a line containing -- between contiguous groups of matches')
          [CompletionResult]::new('--before-context', '--before-context', [CompletionResultType]::ParameterName, 'Show <num> leading lines, and place a line containing -- between contiguous groups of matches')
          [CompletionResult]::new('-W', '-W', [CompletionResultType]::ParameterName, 'Show the surrounding text from the previous line containing a function name up to the one before the next function name, effectively showing the whole function in which the match was found')
          [CompletionResult]::new('--function-context', '--function-context', [CompletionResultType]::ParameterName, 'Show the surrounding text from the previous line containing a function name up to the one before the next function name, effectively showing the whole function in which the match was found')
          [CompletionResult]::new('-m', '-m', [CompletionResultType]::ParameterName, 'Limit the amount of matches per file')
          [CompletionResult]::new('--max-count', '--max-count', [CompletionResultType]::ParameterName, 'Limit the amount of matches per file')
          [CompletionResult]::new('--threads', '--threads', [CompletionResultType]::ParameterName, 'Number of grep worker threads to use')
          [CompletionResult]::new('-f', '-f', [CompletionResultType]::ParameterName, 'Read patterns from <file>, one per line')
          [CompletionResult]::new('-e', '-e', [CompletionResultType]::ParameterName, 'The next parameter is the pattern')
          [CompletionResult]::new('--and', '--and', [CompletionResultType]::ParameterName, 'Specify how multiple patterns are combined using Boolean expressions')
          [CompletionResult]::new('--or', '--or', [CompletionResultType]::ParameterName, 'Specify how multiple patterns are combined using Boolean expressions')
          [CompletionResult]::new('--not', '--not', [CompletionResultType]::ParameterName, 'Specify how multiple patterns are combined using Boolean expressions')
          [CompletionResult]::new('(', '(', [CompletionResultType]::ParameterName, 'Specify how multiple patterns are combined using Boolean expressions')
          [CompletionResult]::new('--all-match', '--all-match', [CompletionResultType]::ParameterName, 'When giving multiple pattern expressions combined with --or, this flag is specified to limit the match to files that have lines to match all of them')
          [CompletionResult]::new('-q', '-q', [CompletionResultType]::ParameterName, "Do not output matched lines; instead, exit with status 0 when there is a match and with non-zero status when there isn't")
          [CompletionResult]::new('--quiet', '--quiet', [CompletionResultType]::ParameterName, "Do not output matched lines; instead, exit with status 0 when there is a match and with non-zero status when there isn't")
          [CompletionResult]::new('<tree>…​', '<tree>…​', [CompletionResultType]::ParameterName, 'Instead of searching tracked files in the working tree, search blobs in the given trees')
          [CompletionResult]::new('--', '--', [CompletionResultType]::ParameterName, 'Signals the end of options; the rest of the parameters are <pathspec> limiters')
          [CompletionResult]::new('<pathspec>…​', '<pathspec>…​', [CompletionResultType]::ParameterName, 'If given, limit the search to paths matching at least one pattern')
        }
        break
      }
      'gui' {
        if ($commandAst.CommandElements.Count -le 3) {
          [CompletionResult]::new('blame', 'blame', [CompletionResultType]::ParameterName, 'Start a blame viewer on the specified file on the given version (or working directory if not specified)')
          [CompletionResult]::new('browser', 'browser', [CompletionResultType]::ParameterName, 'Start a tree browser showing all files in the specified commit')
          [CompletionResult]::new('citool', 'citool', [CompletionResultType]::ParameterName, 'Start git gui and arrange to make exactly one commit before exiting and returning to the shell')
          [CompletionResult]::new('version', 'version', [CompletionResultType]::ParameterName, 'Display the currently running version of git gui')
        }
        break
      }
      'init' {
        if ($wordToComplete.StartsWith('-')) {
          [CompletionResult]::new('-q', '-q', [CompletionResultType]::ParameterName, 'Only print error and warning messages; all other output will be suppressed')
          [CompletionResult]::new('--quiet', '--quiet', [CompletionResultType]::ParameterName, 'Only print error and warning messages; all other output will be suppressed')
          [CompletionResult]::new('--bare', '--bare', [CompletionResultType]::ParameterName, 'Create a bare repository')
          [CompletionResult]::new('--object-format=<format>', '--object-format=<format>', [CompletionResultType]::ParameterName, 'Specify the given object <format> (hash algorithm) for the repository')
        }
        break
      }
      'log' {
        if ($wordToComplete.StartsWith('-')) {
          [CompletionResult]::new('--follow', '--follow', [CompletionResultType]::ParameterName, 'Continue listing the history of a file beyond renames (works only for a single file)')
          [CompletionResult]::new('--no-decorate', '--no-decorate', [CompletionResultType]::ParameterName, 'Print out the ref names of any commits that are shown')
          [CompletionResult]::new('--decorate[=short|full|auto|no]', '--decorate[=short|full|auto|no]', [CompletionResultType]::ParameterName, 'Print out the ref names of any commits that are shown')
          [CompletionResult]::new('--decorate-refs=<pattern>', '--decorate-refs=<pattern>', [CompletionResultType]::ParameterName, "For each candidate reference, do not use it for decoration if it matches any patterns given to --decorate-refs-exclude or if it doesn't match any of the patterns given to --decorate-refs")
          [CompletionResult]::new('--decorate-refs-exclude=<pattern>', '--decorate-refs-exclude=<pattern>', [CompletionResultType]::ParameterName, "For each candidate reference, do not use it for decoration if it matches any patterns given to --decorate-refs-exclude or if it doesn't match any of the patterns given to --decorate-refs")
          [CompletionResult]::new('--clear-decorations', '--clear-decorations', [CompletionResultType]::ParameterName, 'When specified, this option clears all previous --decorate-refs or --decorate-refs-exclude options and relaxes the default decoration filter to include all references')
          [CompletionResult]::new('--source', '--source', [CompletionResultType]::ParameterName, 'Print out the ref name given on the command line by which each commit was reached')
          [CompletionResult]::new('--[no-]mailmap', '--[no-]mailmap', [CompletionResultType]::ParameterName, 'Use mailmap file to map author and committer names and email addresses to canonical real names and email addresses')
          [CompletionResult]::new('--[no-]use-mailmap', '--[no-]use-mailmap', [CompletionResultType]::ParameterName, 'Use mailmap file to map author and committer names and email addresses to canonical real names and email addresses')
          [CompletionResult]::new('--full-diff', '--full-diff', [CompletionResultType]::ParameterName, 'Without this flag, git log -p <path>')
          [CompletionResult]::new('--log-size', '--log-size', [CompletionResultType]::ParameterName, "Include a line `“log size <number>`” in the output for each commit, where <number> is the length of that commit's message in bytes")
          [CompletionResult]::new('-L<start>,<end>:<file>', '-L<start>,<end>:<file>', [CompletionResultType]::ParameterName, 'Trace the evolution of the line range given by <start>,<end>, or by the function name regex <funcname>, within the <file>')
          [CompletionResult]::new('-L:<funcname>:<file>', '-L:<funcname>:<file>', [CompletionResultType]::ParameterName, 'Trace the evolution of the line range given by <start>,<end>, or by the function name regex <funcname>, within the <file>')
          [CompletionResult]::new('<revision-range>', '<revision-range>', [CompletionResultType]::ParameterName, 'Show only commits in the specified revision range')
          [CompletionResult]::new('[--]', '[--]', [CompletionResultType]::ParameterName, 'Show only commits that are enough to explain how the files that match the specified paths came to be')
        }
        break
      }
      'maintanance' {
        if ($wordToComplete.StartsWith('-')) {
          [CompletionResult]::new('--auto', '--auto', [CompletionResultType]::ParameterName, 'When combined with the run subcommand, run maintenance tasks only if certain thresholds are met')
          [CompletionResult]::new('--schedule', '--schedule', [CompletionResultType]::ParameterName, 'When combined with the run subcommand, run maintenance tasks only if certain time conditions are met, as specified by the maintenance')
          [CompletionResult]::new('--quiet', '--quiet', [CompletionResultType]::ParameterName, 'Do not report progress or other information over stderr')
          [CompletionResult]::new('--task=<task>', '--task=<task>', [CompletionResultType]::ParameterName, 'If this option is specified one or more times, then only run the specified tasks in the specified order')
          [CompletionResult]::new('--scheduler=auto|crontab|systemd-timer|launchctl|schtasks', '--scheduler=auto|crontab|systemd-timer|launchctl|schtasks', [CompletionResultType]::ParameterName, 'When combined with the start subcommand, specify the scheduler for running the hourly, daily and weekly executions of git maintenance run')
        }
        elseif ($commandAst.CommandElements.Count -le 3) {
          [CompletionResult]::new('run', 'run', [CompletionResultType]::ParameterName, 'Run one or more maintenance tasks')
          [CompletionResult]::new('start', 'start', [CompletionResultType]::ParameterName, 'Start running maintenance on the current repository')
          [CompletionResult]::new('stop', 'stop', [CompletionResultType]::ParameterName, 'Halt the background maintenance schedule')
          [CompletionResult]::new('register', 'register', [CompletionResultType]::ParameterName, 'Initialize Git config values so any scheduled maintenance will start running on this repository')
          [CompletionResult]::new('unregister', 'unregister', [CompletionResultType]::ParameterName, 'Remove the current repository from background maintenance')
        }
        break
      }
      'merge' {
        if ($wordToComplete.StartsWith('-')) {
          [CompletionResult]::new('--commit', '--commit', [CompletionResultType]::ParameterName, 'Perform the merge and commit the result')
          [CompletionResult]::new('--no-commit', '--no-commit', [CompletionResultType]::ParameterName, 'Perform the merge and commit the result')
          [CompletionResult]::new('--edit', '--edit', [CompletionResultType]::ParameterName, 'Invoke an editor before committing successful mechanical merge to 	further edit the auto-generated merge message, so that the user 	can explain and justify the merge')
          [CompletionResult]::new('-e', '-e', [CompletionResultType]::ParameterName, 'Invoke an editor before committing successful mechanical merge to 	further edit the auto-generated merge message, so that the user 	can explain and justify the merge')
          [CompletionResult]::new('--no-edit', '--no-edit', [CompletionResultType]::ParameterName, 'Invoke an editor before committing successful mechanical merge to 	further edit the auto-generated merge message, so that the user 	can explain and justify the merge')
          [CompletionResult]::new('--cleanup=<mode>', '--cleanup=<mode>', [CompletionResultType]::ParameterName, 'This option determines how the merge message will be cleaned up before committing')
          [CompletionResult]::new('--ff', '--ff', [CompletionResultType]::ParameterName, 'Specifies how a merge is handled when the merged-in history is already a descendant of the current history')
          [CompletionResult]::new('--no-ff', '--no-ff', [CompletionResultType]::ParameterName, 'Specifies how a merge is handled when the merged-in history is already a descendant of the current history')
          [CompletionResult]::new('--ff-only', '--ff-only', [CompletionResultType]::ParameterName, 'Specifies how a merge is handled when the merged-in history is already a descendant of the current history')
          [CompletionResult]::new('-S[<keyid>]', '-S[<keyid>]', [CompletionResultType]::ParameterName, 'GPG-sign the resulting merge commit')
          [CompletionResult]::new('--gpg-sign[=<keyid>]', '--gpg-sign[=<keyid>]', [CompletionResultType]::ParameterName, 'GPG-sign the resulting merge commit')
          [CompletionResult]::new('--no-gpg-sign', '--no-gpg-sign', [CompletionResultType]::ParameterName, 'GPG-sign the resulting merge commit')
          [CompletionResult]::new('--log[=<n>]', '--log[=<n>]', [CompletionResultType]::ParameterName, 'In addition to branch names, populate the log message with one-line descriptions from at most <n> actual commits that are being merged')
          [CompletionResult]::new('--no-log', '--no-log', [CompletionResultType]::ParameterName, 'In addition to branch names, populate the log message with one-line descriptions from at most <n> actual commits that are being merged')
          [CompletionResult]::new('--signoff', '--signoff', [CompletionResultType]::ParameterName, 'Add a Signed-off-by trailer by the committer at the end of the commit log message')
          [CompletionResult]::new('--no-signoff', '--no-signoff', [CompletionResultType]::ParameterName, 'Add a Signed-off-by trailer by the committer at the end of the commit log message')
          [CompletionResult]::new('--stat', '--stat', [CompletionResultType]::ParameterName, 'Show a diffstat at the end of the merge')
          [CompletionResult]::new('-n', '-n', [CompletionResultType]::ParameterName, 'Show a diffstat at the end of the merge')
          [CompletionResult]::new('--no-stat', '--no-stat', [CompletionResultType]::ParameterName, 'Show a diffstat at the end of the merge')
          [CompletionResult]::new('--squash', '--squash', [CompletionResultType]::ParameterName, 'Produce the working tree and index state as if a real merge happened (except for the merge information), but do not actually make a commit, move the HEAD, or record $GIT_DIR/MERGE_HEAD (to cause the next git commit command to create a merge commit)')
          [CompletionResult]::new('--no-squash', '--no-squash', [CompletionResultType]::ParameterName, 'Produce the working tree and index state as if a real merge happened (except for the merge information), but do not actually make a commit, move the HEAD, or record $GIT_DIR/MERGE_HEAD (to cause the next git commit command to create a merge commit)')
          [CompletionResult]::new('--[no-]verify', '--[no-]verify', [CompletionResultType]::ParameterName, 'By default, the pre-merge and commit-msg hooks are run')
          [CompletionResult]::new('-s', '-s', [CompletionResultType]::ParameterName, 'Use the given merge strategy; can be supplied more than once to specify them in the order they should be tried')
          [CompletionResult]::new('--strategy=<strategy>', '--strategy=<strategy>', [CompletionResultType]::ParameterName, 'Use the given merge strategy; can be supplied more than once to specify them in the order they should be tried')
          [CompletionResult]::new('-X', '-X', [CompletionResultType]::ParameterName, 'Pass merge strategy specific option through to the merge strategy')
          [CompletionResult]::new('--strategy-option=<option>', '--strategy-option=<option>', [CompletionResultType]::ParameterName, 'Pass merge strategy specific option through to the merge strategy')
          [CompletionResult]::new('--verify-signatures', '--verify-signatures', [CompletionResultType]::ParameterName, 'Verify that the tip commit of the side branch being merged is signed with a valid key, i')
          [CompletionResult]::new('--no-verify-signatures', '--no-verify-signatures', [CompletionResultType]::ParameterName, 'Verify that the tip commit of the side branch being merged is signed with a valid key, i')
          [CompletionResult]::new('--summary', '--summary', [CompletionResultType]::ParameterName, 'Synonyms to --stat and --no-stat; these are deprecated and will be removed in the future')
          [CompletionResult]::new('--no-summary', '--no-summary', [CompletionResultType]::ParameterName, 'Synonyms to --stat and --no-stat; these are deprecated and will be removed in the future')
          [CompletionResult]::new('-q', '-q', [CompletionResultType]::ParameterName, 'Operate quietly')
          [CompletionResult]::new('--quiet', '--quiet', [CompletionResultType]::ParameterName, 'Operate quietly')
          [CompletionResult]::new('-v', '-v', [CompletionResultType]::ParameterName, 'Be verbose')
          [CompletionResult]::new('--verbose', '--verbose', [CompletionResultType]::ParameterName, 'Be verbose')
          [CompletionResult]::new('--progress', '--progress', [CompletionResultType]::ParameterName, 'Turn progress on/off explicitly')
          [CompletionResult]::new('--no-progress', '--no-progress', [CompletionResultType]::ParameterName, 'Turn progress on/off explicitly')
          [CompletionResult]::new('--autostash', '--autostash', [CompletionResultType]::ParameterName, 'Automatically create a temporary stash entry before the operation begins, record it in the ref MERGE_AUTOSTASH and apply it after the operation ends')
          [CompletionResult]::new('--no-autostash', '--no-autostash', [CompletionResultType]::ParameterName, 'Automatically create a temporary stash entry before the operation begins, record it in the ref MERGE_AUTOSTASH and apply it after the operation ends')
          [CompletionResult]::new('--allow-unrelated-histories', '--allow-unrelated-histories', [CompletionResultType]::ParameterName, 'By default, git merge command refuses to merge histories that do not share a common ancestor')
          [CompletionResult]::new('-m', '-m', [CompletionResultType]::ParameterName, 'Set the commit message to be used for the merge commit (in case one is created)')
          [CompletionResult]::new('--into-name', '--into-name', [CompletionResultType]::ParameterName, 'Prepare the default merge message as if merging to the branch <branch>, instead of the name of the real branch to which the merge is made')
          [CompletionResult]::new('-F', '-F', [CompletionResultType]::ParameterName, 'Read the commit message to be used for the merge commit (in case one is created)')
          [CompletionResult]::new('--file=<file>', '--file=<file>', [CompletionResultType]::ParameterName, 'Read the commit message to be used for the merge commit (in case one is created)')
          [CompletionResult]::new('--rerere-autoupdate', '--rerere-autoupdate', [CompletionResultType]::ParameterName, 'After the rerere mechanism reuses a recorded resolution on the current conflict to update the files in the working tree, allow it to also update the index with the result of resolution')
          [CompletionResult]::new('--no-rerere-autoupdate', '--no-rerere-autoupdate', [CompletionResultType]::ParameterName, 'After the rerere mechanism reuses a recorded resolution on the current conflict to update the files in the working tree, allow it to also update the index with the result of resolution')
          [CompletionResult]::new('--overwrite-ignore', '--overwrite-ignore', [CompletionResultType]::ParameterName, 'Silently overwrite ignored files from the merge result')
          [CompletionResult]::new('--no-overwrite-ignore', '--no-overwrite-ignore', [CompletionResultType]::ParameterName, 'Silently overwrite ignored files from the merge result')
          [CompletionResult]::new('--abort', '--abort', [CompletionResultType]::ParameterName, 'Abort the current conflict resolution process, and try to reconstruct the pre-merge state')
          [CompletionResult]::new('--quit', '--quit', [CompletionResultType]::ParameterName, 'Forget about the current merge in progress')
          [CompletionResult]::new('--continue', '--continue', [CompletionResultType]::ParameterName, 'After a git merge stops due to conflicts you can conclude the merge by running git merge --continue (see "HOW TO RESOLVE CONFLICTS" section below)')
          [CompletionResult]::new('<commit>…​', '<commit>…​', [CompletionResultType]::ParameterName, 'Commits, usually other branch heads, to merge into our branch')
        }
        break
      }
      'mv' {
        if ($wordToComplete.StartsWith('-')) {
          [CompletionResult]::new('-f', '-f', [CompletionResultType]::ParameterName, 'Force renaming or moving of a file even if the <destination> exists')
          [CompletionResult]::new('--force', '--force', [CompletionResultType]::ParameterName, 'Force renaming or moving of a file even if the <destination> exists')
          [CompletionResult]::new('-k', '-k', [CompletionResultType]::ParameterName, 'Skip move or rename actions which would lead to an error condition')
          [CompletionResult]::new('-n', '-n', [CompletionResultType]::ParameterName, 'Do nothing; only show what would happen')
          [CompletionResult]::new('--dry-run', '--dry-run', [CompletionResultType]::ParameterName, 'Do nothing; only show what would happen')
          [CompletionResult]::new('-v', '-v', [CompletionResultType]::ParameterName, 'Report the names of files as they are moved')
          [CompletionResult]::new('--verbose', '--verbose', [CompletionResultType]::ParameterName, 'Report the names of files as they are moved')
        }
        break
      }
      'notes' {
        if ($wordToComplete.StartsWith('-')) {
          [CompletionResult]::new('-f', '-f', [CompletionResultType]::ParameterName, 'When adding notes to an object that already has notes, overwrite the existing notes (instead of aborting)')
          [CompletionResult]::new('--force', '--force', [CompletionResultType]::ParameterName, 'When adding notes to an object that already has notes, overwrite the existing notes (instead of aborting)')
          [CompletionResult]::new('-m', '-m', [CompletionResultType]::ParameterName, 'Use the given note message (instead of prompting)')
          [CompletionResult]::new('--message=<msg>', '--message=<msg>', [CompletionResultType]::ParameterName, 'Use the given note message (instead of prompting)')
          [CompletionResult]::new('-F', '-F', [CompletionResultType]::ParameterName, 'Take the note message from the given file')
          [CompletionResult]::new('--file=<file>', '--file=<file>', [CompletionResultType]::ParameterName, 'Take the note message from the given file')
          [CompletionResult]::new('-C', '-C', [CompletionResultType]::ParameterName, 'Take the given blob object (for example, another note) as the note message')
          [CompletionResult]::new('--reuse-message=<object>', '--reuse-message=<object>', [CompletionResultType]::ParameterName, 'Take the given blob object (for example, another note) as the note message')
          [CompletionResult]::new('-c', '-c', [CompletionResultType]::ParameterName, 'Like -C, but with -c the editor is invoked, so that the user can further edit the note message')
          [CompletionResult]::new('--reedit-message=<object>', '--reedit-message=<object>', [CompletionResultType]::ParameterName, 'Like -C, but with -c the editor is invoked, so that the user can further edit the note message')
          [CompletionResult]::new('--allow-empty', '--allow-empty', [CompletionResultType]::ParameterName, 'Allow an empty note object to be stored')
          [CompletionResult]::new('--[no-]separator,', '--[no-]separator,', [CompletionResultType]::ParameterName, 'Specify a string used as a custom inter-paragraph separator (a newline is added at the end as needed)')
          [CompletionResult]::new('--[no-]stripspace', '--[no-]stripspace', [CompletionResultType]::ParameterName, 'Strip leading and trailing whitespace from the note message')
          [CompletionResult]::new('--ref', '--ref', [CompletionResultType]::ParameterName, 'Manipulate the notes tree in <ref>')
          [CompletionResult]::new('--ignore-missing', '--ignore-missing', [CompletionResultType]::ParameterName, 'Do not consider it an error to request removing notes from an object that does not have notes attached to it')
          [CompletionResult]::new('--stdin', '--stdin', [CompletionResultType]::ParameterName, 'Also read the object names to remove notes from the standard input (there is no reason you cannot combine this with object names from the command line)')
          [CompletionResult]::new('-n', '-n', [CompletionResultType]::ParameterName, 'Do not remove anything; just report the object names whose notes would be removed')
          [CompletionResult]::new('--dry-run', '--dry-run', [CompletionResultType]::ParameterName, 'Do not remove anything; just report the object names whose notes would be removed')
          [CompletionResult]::new('-s', '-s', [CompletionResultType]::ParameterName, 'When merging notes, resolve notes conflicts using the given strategy')
          [CompletionResult]::new('--strategy=<strategy>', '--strategy=<strategy>', [CompletionResultType]::ParameterName, 'When merging notes, resolve notes conflicts using the given strategy')
          [CompletionResult]::new('--commit', '--commit', [CompletionResultType]::ParameterName, 'Finalize an in-progress git notes merge')
          [CompletionResult]::new('--abort', '--abort', [CompletionResultType]::ParameterName, 'Abort/reset an in-progress git notes merge, i')
          [CompletionResult]::new('-q', '-q', [CompletionResultType]::ParameterName, 'When merging notes, operate quietly')
          [CompletionResult]::new('--quiet', '--quiet', [CompletionResultType]::ParameterName, 'When merging notes, operate quietly')
          [CompletionResult]::new('-v', '-v', [CompletionResultType]::ParameterName, 'When merging notes, be more verbose')
          [CompletionResult]::new('--verbose', '--verbose', [CompletionResultType]::ParameterName, 'When merging notes, be more verbose')
        }
        elseif ($commandAst.CommandElements.Count -le 3) {
          [CompletionResult]::new('list', 'list', [CompletionResultType]::ParameterName, 'List the notes object for a given object')
          [CompletionResult]::new('add', 'add', [CompletionResultType]::ParameterName, 'Add notes for a given object (defaults to HEAD)')
          [CompletionResult]::new('copy', 'copy', [CompletionResultType]::ParameterName, 'Copy the notes for the first object onto the second object (defaults to HEAD)')
          [CompletionResult]::new('append', 'append', [CompletionResultType]::ParameterName, 'Append new message(s) given by -m or -F options to an existing note, or add them as a new note if one does not exist, for the object (defaults to HEAD)')
          [CompletionResult]::new('edit', 'edit', [CompletionResultType]::ParameterName, 'Edit the notes for a given object (defaults to HEAD)')
          [CompletionResult]::new('show', 'show', [CompletionResultType]::ParameterName, 'Show the notes for a given object (defaults to HEAD)')
          [CompletionResult]::new('merge', 'merge', [CompletionResultType]::ParameterName, 'Merge the given notes ref into the current notes ref')
          [CompletionResult]::new('remove', 'remove', [CompletionResultType]::ParameterName, 'Remove the notes for given objects (defaults to HEAD)')
          [CompletionResult]::new('prune', 'prune', [CompletionResultType]::ParameterName, 'Remove all notes for non-existing/unreachable objects')
          [CompletionResult]::new('get-ref', 'get-ref', [CompletionResultType]::ParameterName, 'Print the current notes ref')
        }
        break
      }
      'pull' {
        if ($wordToComplete.StartsWith('-')) {
          [CompletionResult]::new('-q', '-q', [CompletionResultType]::ParameterName, 'This is passed to both underlying git-fetch to squelch reporting of during transfer, and underlying git-merge to squelch output during merging')
          [CompletionResult]::new('--quiet', '--quiet', [CompletionResultType]::ParameterName, 'This is passed to both underlying git-fetch to squelch reporting of during transfer, and underlying git-merge to squelch output during merging')
          [CompletionResult]::new('-v', '-v', [CompletionResultType]::ParameterName, 'Pass --verbose to git-fetch and git-merge')
          [CompletionResult]::new('--verbose', '--verbose', [CompletionResultType]::ParameterName, 'Pass --verbose to git-fetch and git-merge')
          [CompletionResult]::new('--[no-]recurse-submodules[=(yes|on-demand|no)]', '--[no-]recurse-submodules[=(yes|on-demand|no)]', [CompletionResultType]::ParameterName, 'This option controls if new commits of populated submodules should be fetched, and if the working trees of active submodules should be updated, too (see git-fetch(1), git-config(1) and gitmodules(5))')
        }
        break
      }
      'push' {
        if ($wordToComplete.StartsWith('-')) {
          [CompletionResult]::new('<repository>', '<repository>', [CompletionResultType]::ParameterName, 'The "remote" repository that is the destination of a push operation')
          [CompletionResult]::new('<refspec>…​', '<refspec>…​', [CompletionResultType]::ParameterName, 'Specify what destination ref to update with what source object')
          [CompletionResult]::new('--all', '--all', [CompletionResultType]::ParameterName, 'Push all branches (i')
          [CompletionResult]::new('--branches', '--branches', [CompletionResultType]::ParameterName, 'Push all branches (i')
          [CompletionResult]::new('--prune', '--prune', [CompletionResultType]::ParameterName, "Remove remote branches that don't have a local counterpart")
          [CompletionResult]::new('--mirror', '--mirror', [CompletionResultType]::ParameterName, 'Instead of naming each ref to push, specifies that all refs under refs/ (which includes but is not limited to refs/heads/, refs/remotes/, and refs/tags/) be mirrored to the remote repository')
          [CompletionResult]::new('-n', '-n', [CompletionResultType]::ParameterName, 'Do everything except actually send the updates')
          [CompletionResult]::new('--dry-run', '--dry-run', [CompletionResultType]::ParameterName, 'Do everything except actually send the updates')
          [CompletionResult]::new('--porcelain', '--porcelain', [CompletionResultType]::ParameterName, 'Produce machine-readable output')
          [CompletionResult]::new('-d', '-d', [CompletionResultType]::ParameterName, 'All listed refs are deleted from the remote repository')
          [CompletionResult]::new('--delete', '--delete', [CompletionResultType]::ParameterName, 'All listed refs are deleted from the remote repository')
          [CompletionResult]::new('--tags', '--tags', [CompletionResultType]::ParameterName, 'All refs under refs/tags are pushed, in addition to refspecs explicitly listed on the command line')
          [CompletionResult]::new('--follow-tags', '--follow-tags', [CompletionResultType]::ParameterName, 'Push all the refs that would be pushed without this option, and also push annotated tags in refs/tags that are missing from the remote but are pointing at commit-ish that are reachable from the refs being pushed')
          [CompletionResult]::new('--[no-]signed', '--[no-]signed', [CompletionResultType]::ParameterName, 'GPG-sign the push request to update refs on the receiving side, to allow it to be checked by the hooks and/or be logged')
          [CompletionResult]::new('--signed=(true|false|if-asked)', '--signed=(true|false|if-asked)', [CompletionResultType]::ParameterName, 'GPG-sign the push request to update refs on the receiving side, to allow it to be checked by the hooks and/or be logged')
          [CompletionResult]::new('--[no-]atomic', '--[no-]atomic', [CompletionResultType]::ParameterName, 'Use an atomic transaction on the remote side if available')
          [CompletionResult]::new('-o', '-o', [CompletionResultType]::ParameterName, 'Transmit the given string to the server, which passes them to the pre-receive as well as the post-receive hook')
          [CompletionResult]::new('--push-option=<option>', '--push-option=<option>', [CompletionResultType]::ParameterName, 'Transmit the given string to the server, which passes them to the pre-receive as well as the post-receive hook')
          [CompletionResult]::new('--receive-pack=<git-receive-pack>', '--receive-pack=<git-receive-pack>', [CompletionResultType]::ParameterName, 'Path to the git-receive-pack program on the remote end')
          [CompletionResult]::new('--exec=<git-receive-pack>', '--exec=<git-receive-pack>', [CompletionResultType]::ParameterName, 'Path to the git-receive-pack program on the remote end')
          [CompletionResult]::new('--[no-]force-with-lease', '--[no-]force-with-lease', [CompletionResultType]::ParameterName, 'Usually, "git push" refuses to update a remote ref that is not an ancestor of the local ref used to overwrite it')
          [CompletionResult]::new('--force-with-lease=<refname>', '--force-with-lease=<refname>', [CompletionResultType]::ParameterName, 'Usually, "git push" refuses to update a remote ref that is not an ancestor of the local ref used to overwrite it')
          [CompletionResult]::new('--force-with-lease=<refname>:<expect>', '--force-with-lease=<refname>:<expect>', [CompletionResultType]::ParameterName, 'Usually, "git push" refuses to update a remote ref that is not an ancestor of the local ref used to overwrite it')
          [CompletionResult]::new('-f', '-f', [CompletionResultType]::ParameterName, 'Usually, the command refuses to update a remote ref that is not an ancestor of the local ref used to overwrite it')
          [CompletionResult]::new('--force', '--force', [CompletionResultType]::ParameterName, 'Usually, the command refuses to update a remote ref that is not an ancestor of the local ref used to overwrite it')
          [CompletionResult]::new('--[no-]force-if-includes', '--[no-]force-if-includes', [CompletionResultType]::ParameterName, 'Force an update only if the tip of the remote-tracking ref has been integrated locally')
          [CompletionResult]::new('--repo=<repository>', '--repo=<repository>', [CompletionResultType]::ParameterName, 'This option is equivalent to the <repository> argument')
          [CompletionResult]::new('-u', '-u', [CompletionResultType]::ParameterName, 'For every branch that is up to date or successfully pushed, add upstream (tracking) reference, used by argument-less git-pull(1) and other commands')
          [CompletionResult]::new('--set-upstream', '--set-upstream', [CompletionResultType]::ParameterName, 'For every branch that is up to date or successfully pushed, add upstream (tracking) reference, used by argument-less git-pull(1) and other commands')
          [CompletionResult]::new('--[no-]thin', '--[no-]thin', [CompletionResultType]::ParameterName, 'These options are passed to git-send-pack(1)')
          [CompletionResult]::new('-q', '-q', [CompletionResultType]::ParameterName, 'Suppress all output, including the listing of updated refs, unless an error occurs')
          [CompletionResult]::new('--quiet', '--quiet', [CompletionResultType]::ParameterName, 'Suppress all output, including the listing of updated refs, unless an error occurs')
          [CompletionResult]::new('-v', '-v', [CompletionResultType]::ParameterName, 'Run verbosely')
          [CompletionResult]::new('--verbose', '--verbose', [CompletionResultType]::ParameterName, 'Run verbosely')
          [CompletionResult]::new('--progress', '--progress', [CompletionResultType]::ParameterName, 'Progress status is reported on the standard error stream by default when it is attached to a terminal, unless -q is specified')
          [CompletionResult]::new('--no-recurse-submodules', '--no-recurse-submodules', [CompletionResultType]::ParameterName, 'May be used to make sure all submodule commits used by the revisions to be pushed are available on a remote-tracking branch')
          [CompletionResult]::new('--recurse-submodules=check|on-demand|only|no', '--recurse-submodules=check|on-demand|only|no', [CompletionResultType]::ParameterName, 'May be used to make sure all submodule commits used by the revisions to be pushed are available on a remote-tracking branch')
          [CompletionResult]::new('--[no-]verify', '--[no-]verify', [CompletionResultType]::ParameterName, 'Toggle the pre-push hook (see githooks(5))')
          [CompletionResult]::new('-4', '-4', [CompletionResultType]::ParameterName, 'Use IPv4 addresses only, ignoring IPv6 addresses')
          [CompletionResult]::new('--ipv4', '--ipv4', [CompletionResultType]::ParameterName, 'Use IPv4 addresses only, ignoring IPv6 addresses')
          [CompletionResult]::new('-6', '-6', [CompletionResultType]::ParameterName, 'Use IPv6 addresses only, ignoring IPv4 addresses')
          [CompletionResult]::new('--ipv6', '--ipv6', [CompletionResultType]::ParameterName, 'Use IPv6 addresses only, ignoring IPv4 addresses')
        }
        break
      }
      'range-diff' {
        if ($wordToComplete.StartsWith('-')) {
          [CompletionResult]::new('--no-dual-color', '--no-dual-color', [CompletionResultType]::ParameterName, "When the commit diffs differ, git range-diff recreates the original diffs' coloring, and adds outer -/+ diff markers with the background being red/green to make it easier to see e")
          [CompletionResult]::new('--creation-factor=<percent>', '--creation-factor=<percent>', [CompletionResultType]::ParameterName, 'Set the creation/deletion cost fudge factor to <percent>')
          [CompletionResult]::new('--left-only', '--left-only', [CompletionResultType]::ParameterName, 'Suppress commits that are missing from the first specified range (or the "left range" when using the <rev1>')
          [CompletionResult]::new('--right-only', '--right-only', [CompletionResultType]::ParameterName, 'Suppress commits that are missing from the second specified range (or the "right range" when using the <rev1>')
          [CompletionResult]::new('--[no-]notes[=<ref>]', '--[no-]notes[=<ref>]', [CompletionResultType]::ParameterName, 'This flag is passed to the git log program (see git-log(1)) that generates the patches')
          [CompletionResult]::new('<range1>', '<range1>', [CompletionResultType]::ParameterName, 'Compare the commits specified by the two ranges, where <range1> is considered an older version of <range2>')
          [CompletionResult]::new('<rev1>…​<rev2>', '<rev1>…​<rev2>', [CompletionResultType]::ParameterName, 'Equivalent to passing <rev2>')
          [CompletionResult]::new('<base>', '<base>', [CompletionResultType]::ParameterName, 'Equivalent to passing <base>')
        }
        break
      }
      'rebase' {
        if ($wordToComplete.StartsWith('-')) {
          [CompletionResult]::new('--continue', '--continue', [CompletionResultType]::ParameterName, 'Restart the rebasing process after having resolved a merge conflict')
          [CompletionResult]::new('--skip', '--skip', [CompletionResultType]::ParameterName, 'Restart the rebasing process by skipping the current patch')
          [CompletionResult]::new('--abort', '--abort', [CompletionResultType]::ParameterName, 'Abort the rebase operation and reset HEAD to the original branch')
          [CompletionResult]::new('--quit', '--quit', [CompletionResultType]::ParameterName, 'Abort the rebase operation but HEAD is not reset back to the original branch')
          [CompletionResult]::new('--edit-todo', '--edit-todo', [CompletionResultType]::ParameterName, 'Edit the todo list during an interactive rebase')
          [CompletionResult]::new('--show-current-patch', '--show-current-patch', [CompletionResultType]::ParameterName, 'Show the current patch in an interactive rebase or when rebase is stopped because of conflicts')
        }
        break
      }
      'reset' {
        if ($wordToComplete.StartsWith('-')) {
          [CompletionResult]::new('-q', '-q', [CompletionResultType]::ParameterName, 'Be quiet, only report errors')
          [CompletionResult]::new('--quiet', '--quiet', [CompletionResultType]::ParameterName, 'Be quiet, only report errors')
          [CompletionResult]::new('--refresh', '--refresh', [CompletionResultType]::ParameterName, 'Refresh the index after a mixed reset')
          [CompletionResult]::new('--no-refresh', '--no-refresh', [CompletionResultType]::ParameterName, 'Refresh the index after a mixed reset')
          [CompletionResult]::new('--pathspec-from-file=<file>', '--pathspec-from-file=<file>', [CompletionResultType]::ParameterName, 'Pathspec is passed in <file> instead of commandline args')
          [CompletionResult]::new('--pathspec-file-nul', '--pathspec-file-nul', [CompletionResultType]::ParameterName, 'Only meaningful with --pathspec-from-file')
          [CompletionResult]::new('--', '--', [CompletionResultType]::ParameterName, 'Do not interpret any more arguments as options')
          [CompletionResult]::new('<pathspec>…​', '<pathspec>…​', [CompletionResultType]::ParameterName, 'Limits the paths affected by the operation')
          [CompletionResult]::new('--stdin', '--stdin', [CompletionResultType]::ParameterName, 'DEPRECATED (use --pathspec-from-file=- instead): Instead of taking list of paths from the command line, read list of paths from the standard input')
          [CompletionResult]::new('-z', '-z', [CompletionResultType]::ParameterName, 'DEPRECATED (use --pathspec-file-nul instead): Only meaningful with --stdin; paths are separated with NUL character instead of LF')
        }
        break
      }
      'restore' {
        if ($wordToComplete.StartsWith('-')) {
          [CompletionResult]::new('-s', '-s', [CompletionResultType]::ParameterName, 'Restore the working tree files with the content from the given tree')
          [CompletionResult]::new('--source=<tree>', '--source=<tree>', [CompletionResultType]::ParameterName, 'Restore the working tree files with the content from the given tree')
          [CompletionResult]::new('-p', '-p', [CompletionResultType]::ParameterName, 'Interactively select hunks in the difference between the restore source and the restore location')
          [CompletionResult]::new('--patch', '--patch', [CompletionResultType]::ParameterName, 'Interactively select hunks in the difference between the restore source and the restore location')
          [CompletionResult]::new('-W', '-W', [CompletionResultType]::ParameterName, 'Specify the restore location')
          [CompletionResult]::new('--worktree', '--worktree', [CompletionResultType]::ParameterName, 'Specify the restore location')
          [CompletionResult]::new('-S', '-S', [CompletionResultType]::ParameterName, 'Specify the restore location')
          [CompletionResult]::new('--staged', '--staged', [CompletionResultType]::ParameterName, 'Specify the restore location')
          [CompletionResult]::new('-q', '-q', [CompletionResultType]::ParameterName, 'Quiet, suppress feedback messages')
          [CompletionResult]::new('--quiet', '--quiet', [CompletionResultType]::ParameterName, 'Quiet, suppress feedback messages')
          [CompletionResult]::new('--progress', '--progress', [CompletionResultType]::ParameterName, 'Progress status is reported on the standard error stream by default when it is attached to a terminal, unless --quiet is specified')
          [CompletionResult]::new('--no-progress', '--no-progress', [CompletionResultType]::ParameterName, 'Progress status is reported on the standard error stream by default when it is attached to a terminal, unless --quiet is specified')
          [CompletionResult]::new('--ours', '--ours', [CompletionResultType]::ParameterName, 'When restoring files in the working tree from the index, use stage #2 (ours) or #3 (theirs) for unmerged paths')
          [CompletionResult]::new('--theirs', '--theirs', [CompletionResultType]::ParameterName, 'When restoring files in the working tree from the index, use stage #2 (ours) or #3 (theirs) for unmerged paths')
          [CompletionResult]::new('-m', '-m', [CompletionResultType]::ParameterName, 'When restoring files on the working tree from the index, recreate the conflicted merge in the unmerged paths')
          [CompletionResult]::new('--merge', '--merge', [CompletionResultType]::ParameterName, 'When restoring files on the working tree from the index, recreate the conflicted merge in the unmerged paths')
          [CompletionResult]::new('--conflict=<style>', '--conflict=<style>', [CompletionResultType]::ParameterName, 'The same as --merge option above, but changes the way the conflicting hunks are presented, overriding the merge')
          [CompletionResult]::new('--ignore-unmerged', '--ignore-unmerged', [CompletionResultType]::ParameterName, 'When restoring files on the working tree from the index, do not abort the operation if there are unmerged entries and neither --ours, --theirs, --merge or --conflict is specified')
          [CompletionResult]::new('--ignore-skip-worktree-bits', '--ignore-skip-worktree-bits', [CompletionResultType]::ParameterName, 'In sparse checkout mode, the default is to only update entries matched by <pathspec> and sparse patterns in $GIT_DIR/info/sparse-checkout')
          [CompletionResult]::new('--recurse-submodules', '--recurse-submodules', [CompletionResultType]::ParameterName, 'If <pathspec> names an active submodule and the restore location includes the working tree, the submodule will only be updated if this option is given, in which case its working tree will be restored to the commit recorded in the superproject, and any local modifications overwritten')
          [CompletionResult]::new('--no-recurse-submodules', '--no-recurse-submodules', [CompletionResultType]::ParameterName, 'If <pathspec> names an active submodule and the restore location includes the working tree, the submodule will only be updated if this option is given, in which case its working tree will be restored to the commit recorded in the superproject, and any local modifications overwritten')
          [CompletionResult]::new('--overlay', '--overlay', [CompletionResultType]::ParameterName, 'In overlay mode, the command never removes files when restoring')
          [CompletionResult]::new('--no-overlay', '--no-overlay', [CompletionResultType]::ParameterName, 'In overlay mode, the command never removes files when restoring')
          [CompletionResult]::new('--pathspec-from-file=<file>', '--pathspec-from-file=<file>', [CompletionResultType]::ParameterName, 'Pathspec is passed in <file> instead of commandline args')
          [CompletionResult]::new('--pathspec-file-nul', '--pathspec-file-nul', [CompletionResultType]::ParameterName, 'Only meaningful with --pathspec-from-file')
          [CompletionResult]::new('--', '--', [CompletionResultType]::ParameterName, 'Do not interpret any more arguments as options')
          [CompletionResult]::new('<pathspec>…​', '<pathspec>…​', [CompletionResultType]::ParameterName, 'Limits the paths affected by the operation')
        }
        break
      }
      'revert' {
        if ($wordToComplete.StartsWith('-')) {
          [CompletionResult]::new('<commit>…​', '<commit>…​', [CompletionResultType]::ParameterName, 'Commits to revert')
          [CompletionResult]::new('-e', '-e', [CompletionResultType]::ParameterName, 'With this option, git revert will let you edit the commit message prior to committing the revert')
          [CompletionResult]::new('--edit', '--edit', [CompletionResultType]::ParameterName, 'With this option, git revert will let you edit the commit message prior to committing the revert')
          [CompletionResult]::new('-m', '-m', [CompletionResultType]::ParameterName, 'Usually you cannot revert a merge because you do not know which side of the merge should be considered the mainline')
          [CompletionResult]::new('--mainline', '--mainline', [CompletionResultType]::ParameterName, 'Usually you cannot revert a merge because you do not know which side of the merge should be considered the mainline')
          [CompletionResult]::new('--no-edit', '--no-edit', [CompletionResultType]::ParameterName, 'With this option, git revert will not start the commit message editor')
          [CompletionResult]::new('--cleanup=<mode>', '--cleanup=<mode>', [CompletionResultType]::ParameterName, 'This option determines how the commit message will be cleaned up before being passed on to the commit machinery')
          [CompletionResult]::new('-n', '-n', [CompletionResultType]::ParameterName, 'Usually the command automatically creates some commits with commit log messages stating which commits were reverted')
          [CompletionResult]::new('--no-commit', '--no-commit', [CompletionResultType]::ParameterName, 'Usually the command automatically creates some commits with commit log messages stating which commits were reverted')
          [CompletionResult]::new('-S[<keyid>]', '-S[<keyid>]', [CompletionResultType]::ParameterName, 'GPG-sign commits')
          [CompletionResult]::new('--gpg-sign[=<keyid>]', '--gpg-sign[=<keyid>]', [CompletionResultType]::ParameterName, 'GPG-sign commits')
          [CompletionResult]::new('--no-gpg-sign', '--no-gpg-sign', [CompletionResultType]::ParameterName, 'GPG-sign commits')
          [CompletionResult]::new('-s', '-s', [CompletionResultType]::ParameterName, 'Add a Signed-off-by trailer at the end of the commit message')
          [CompletionResult]::new('--signoff', '--signoff', [CompletionResultType]::ParameterName, 'Add a Signed-off-by trailer at the end of the commit message')
          [CompletionResult]::new('--strategy=<strategy>', '--strategy=<strategy>', [CompletionResultType]::ParameterName, 'Use the given merge strategy')
          [CompletionResult]::new('-X<option>', '-X<option>', [CompletionResultType]::ParameterName, 'Pass the merge strategy-specific option through to the merge strategy')
          [CompletionResult]::new('--strategy-option=<option>', '--strategy-option=<option>', [CompletionResultType]::ParameterName, 'Pass the merge strategy-specific option through to the merge strategy')
          [CompletionResult]::new('--rerere-autoupdate', '--rerere-autoupdate', [CompletionResultType]::ParameterName, 'After the rerere mechanism reuses a recorded resolution on the current conflict to update the files in the working tree, allow it to also update the index with the result of resolution')
          [CompletionResult]::new('--no-rerere-autoupdate', '--no-rerere-autoupdate', [CompletionResultType]::ParameterName, 'After the rerere mechanism reuses a recorded resolution on the current conflict to update the files in the working tree, allow it to also update the index with the result of resolution')
          [CompletionResult]::new('--reference', '--reference', [CompletionResultType]::ParameterName, 'Instead of starting the body of the log message with "This reverts <full-object-name-of-the-commit-being-reverted>')
        }
        break
      }
      'rm' {
        if ($wordToComplete.StartsWith('-')) {
          [CompletionResult]::new('<pathspec>…​', '<pathspec>…​', [CompletionResultType]::ParameterName, 'Files to remove')
          [CompletionResult]::new('-f', '-f', [CompletionResultType]::ParameterName, 'Override the up-to-date check')
          [CompletionResult]::new('--force', '--force', [CompletionResultType]::ParameterName, 'Override the up-to-date check')
          [CompletionResult]::new('-n', '-n', [CompletionResultType]::ParameterName, "Don't actually remove any file(s)")
          [CompletionResult]::new('--dry-run', '--dry-run', [CompletionResultType]::ParameterName, "Don't actually remove any file(s)")
          [CompletionResult]::new('-r', '-r', [CompletionResultType]::ParameterName, 'Allow recursive removal when a leading directory name is given')
          [CompletionResult]::new('--', '--', [CompletionResultType]::ParameterName, 'This option can be used to separate command-line options from the list of files, (useful when filenames might be mistaken for command-line options)')
          [CompletionResult]::new('--cached', '--cached', [CompletionResultType]::ParameterName, 'Use this option to unstage and remove paths only from the index')
          [CompletionResult]::new('--ignore-unmatch', '--ignore-unmatch', [CompletionResultType]::ParameterName, 'Exit with a zero status even if no files matched')
          [CompletionResult]::new('--sparse', '--sparse', [CompletionResultType]::ParameterName, 'Allow updating index entries outside of the sparse-checkout cone')
          [CompletionResult]::new('-q', '-q', [CompletionResultType]::ParameterName, 'git rm normally outputs one line (in the form of an rm command) for each file removed')
          [CompletionResult]::new('--quiet', '--quiet', [CompletionResultType]::ParameterName, 'git rm normally outputs one line (in the form of an rm command) for each file removed')
          [CompletionResult]::new('--pathspec-from-file=<file>', '--pathspec-from-file=<file>', [CompletionResultType]::ParameterName, 'Pathspec is passed in <file> instead of commandline args')
          [CompletionResult]::new('--pathspec-file-nul', '--pathspec-file-nul', [CompletionResultType]::ParameterName, 'Only meaningful with --pathspec-from-file')
        }
        break
      }
      'scalar' {
        if ($wordToComplete.StartsWith('-')) {
        }
        break
      }
      'shortlog' {
        if ($wordToComplete.StartsWith('-')) {
          [CompletionResult]::new('-n', '-n', [CompletionResultType]::ParameterName, 'Sort output according to the number of commits per author instead of author alphabetic order')
          [CompletionResult]::new('--numbered', '--numbered', [CompletionResultType]::ParameterName, 'Sort output according to the number of commits per author instead of author alphabetic order')
          [CompletionResult]::new('-s', '-s', [CompletionResultType]::ParameterName, 'Suppress commit description and provide a commit count summary only')
          [CompletionResult]::new('--summary', '--summary', [CompletionResultType]::ParameterName, 'Suppress commit description and provide a commit count summary only')
          [CompletionResult]::new('-e', '-e', [CompletionResultType]::ParameterName, 'Show the email address of each author')
          [CompletionResult]::new('--email', '--email', [CompletionResultType]::ParameterName, 'Show the email address of each author')
          [CompletionResult]::new('--format[=<format>]', '--format[=<format>]', [CompletionResultType]::ParameterName, 'Instead of the commit subject, use some other information to describe each commit')
          [CompletionResult]::new('--date=<format>', '--date=<format>', [CompletionResultType]::ParameterName, 'Show dates formatted according to the given date string')
          [CompletionResult]::new('--group=<type>', '--group=<type>', [CompletionResultType]::ParameterName, 'Group commits based on <type>')
          [CompletionResult]::new('-c', '-c', [CompletionResultType]::ParameterName, 'This is an alias for --group=committer')
          [CompletionResult]::new('--committer', '--committer', [CompletionResultType]::ParameterName, 'This is an alias for --group=committer')
          [CompletionResult]::new('-w[<width>[,<indent1>[,<indent2>]]]', '-w[<width>[,<indent1>[,<indent2>]]]', [CompletionResultType]::ParameterName, 'Linewrap the output by wrapping each line at width')
          [CompletionResult]::new('<revision-range>', '<revision-range>', [CompletionResultType]::ParameterName, 'Show only commits in the specified revision range')
          [CompletionResult]::new('[--]', '[--]', [CompletionResultType]::ParameterName, 'Consider only commits that are enough to explain how the files that match the specified paths came to be')
        }
        break
      }
      'show' {
        if ($wordToComplete.StartsWith('-')) {
          [CompletionResult]::new('<object>…​', '<object>…​', [CompletionResultType]::ParameterName, 'The names of objects to show (defaults to HEAD)')
          [CompletionResult]::new('--pretty[=<format>]', '--pretty[=<format>]', [CompletionResultType]::ParameterName, 'Pretty-print the contents of the commit logs in a given format, where <format> can be one of oneline, short, medium, full, fuller, reference, email, raw, format:<string> and tformat:<string>')
          [CompletionResult]::new('--format=<format>', '--format=<format>', [CompletionResultType]::ParameterName, 'Pretty-print the contents of the commit logs in a given format, where <format> can be one of oneline, short, medium, full, fuller, reference, email, raw, format:<string> and tformat:<string>')
          [CompletionResult]::new('--abbrev-commit', '--abbrev-commit', [CompletionResultType]::ParameterName, 'Instead of showing the full 40-byte hexadecimal commit object name, show a prefix that names the object uniquely')
          [CompletionResult]::new('--no-abbrev-commit', '--no-abbrev-commit', [CompletionResultType]::ParameterName, 'Show the full 40-byte hexadecimal commit object name')
          [CompletionResult]::new('--oneline', '--oneline', [CompletionResultType]::ParameterName, 'This is a shorthand for "--pretty=oneline --abbrev-commit" used together')
          [CompletionResult]::new('--encoding=<encoding>', '--encoding=<encoding>', [CompletionResultType]::ParameterName, 'Commit objects record the character encoding used for the log message in their encoding header; this option can be used to tell the command to re-code the commit log message in the encoding preferred by the user')
          [CompletionResult]::new('--expand-tabs=<n>', '--expand-tabs=<n>', [CompletionResultType]::ParameterName, 'Perform a tab expansion (replace each tab with enough spaces to fill to the next display column that is a multiple of <n>) in the log message before showing it in the output')
          [CompletionResult]::new('--expand-tabs', '--expand-tabs', [CompletionResultType]::ParameterName, 'Perform a tab expansion (replace each tab with enough spaces to fill to the next display column that is a multiple of <n>) in the log message before showing it in the output')
          [CompletionResult]::new('--no-expand-tabs', '--no-expand-tabs', [CompletionResultType]::ParameterName, 'Perform a tab expansion (replace each tab with enough spaces to fill to the next display column that is a multiple of <n>) in the log message before showing it in the output')
          [CompletionResult]::new('--notes[=<ref>]', '--notes[=<ref>]', [CompletionResultType]::ParameterName, 'Show the notes (see git-notes(1)) that annotate the commit, when showing the commit log message')
          [CompletionResult]::new('--no-notes', '--no-notes', [CompletionResultType]::ParameterName, 'Do not show notes')
          [CompletionResult]::new('--show-notes-by-default', '--show-notes-by-default', [CompletionResultType]::ParameterName, 'Show the default notes unless options for displaying specific notes are given')
          [CompletionResult]::new('--show-notes[=<ref>]', '--show-notes[=<ref>]', [CompletionResultType]::ParameterName, 'These options are deprecated')
          [CompletionResult]::new('--[no-]standard-notes', '--[no-]standard-notes', [CompletionResultType]::ParameterName, 'These options are deprecated')
          [CompletionResult]::new('--show-signature', '--show-signature', [CompletionResultType]::ParameterName, 'Check the validity of a signed commit object by passing the signature to gpg --verify and show the output')
        }
        break
      }
      'sparse-checkout' {
        if ($commandAst.CommandElements.Count -le 3) {
          [CompletionResult]::new('list', 'list', [CompletionResultType]::ParameterName, 'Describe the directories or patterns in the sparse-checkout file')
          [CompletionResult]::new('set', 'set', [CompletionResultType]::ParameterName, 'Enable the necessary sparse-checkout config settings (core')
          [CompletionResult]::new('add', 'add', [CompletionResultType]::ParameterName, 'Update the sparse-checkout file to include additional directories (in cone mode) or patterns (in non-cone mode)')
          [CompletionResult]::new('reapply', 'reapply', [CompletionResultType]::ParameterName, 'Reapply the sparsity pattern rules to paths in the working tree')
          [CompletionResult]::new('disable', 'disable', [CompletionResultType]::ParameterName, 'Disable the core')
          [CompletionResult]::new('init', 'init', [CompletionResultType]::ParameterName, 'Deprecated command that behaves like set with no specified paths')
          [CompletionResult]::new('check-rules', 'check-rules', [CompletionResultType]::ParameterName, 'Check whether sparsity rules match one or more paths')
        }
        break
      }
      'stash' {
        if ($wordToComplete.StartsWith('-')) {
          [CompletionResult]::new('-a', '-a', [CompletionResultType]::ParameterName, 'This option is only valid for push and save commands')
          [CompletionResult]::new('--all', '--all', [CompletionResultType]::ParameterName, 'This option is only valid for push and save commands')
          [CompletionResult]::new('-u', '-u', [CompletionResultType]::ParameterName, 'When used with the push and save commands, all untracked files are also stashed and then cleaned up with git clean')
          [CompletionResult]::new('--include-untracked', '--include-untracked', [CompletionResultType]::ParameterName, 'When used with the push and save commands, all untracked files are also stashed and then cleaned up with git clean')
          [CompletionResult]::new('--no-include-untracked', '--no-include-untracked', [CompletionResultType]::ParameterName, 'When used with the push and save commands, all untracked files are also stashed and then cleaned up with git clean')
          [CompletionResult]::new('--only-untracked', '--only-untracked', [CompletionResultType]::ParameterName, 'This option is only valid for the show command')
          [CompletionResult]::new('--index', '--index', [CompletionResultType]::ParameterName, 'This option is only valid for pop and apply commands')
          [CompletionResult]::new('-k', '-k', [CompletionResultType]::ParameterName, 'This option is only valid for push and save commands')
          [CompletionResult]::new('--keep-index', '--keep-index', [CompletionResultType]::ParameterName, 'This option is only valid for push and save commands')
          [CompletionResult]::new('--no-keep-index', '--no-keep-index', [CompletionResultType]::ParameterName, 'This option is only valid for push and save commands')
          [CompletionResult]::new('-p', '-p', [CompletionResultType]::ParameterName, 'This option is only valid for push and save commands')
          [CompletionResult]::new('--patch', '--patch', [CompletionResultType]::ParameterName, 'This option is only valid for push and save commands')
          [CompletionResult]::new('-S', '-S', [CompletionResultType]::ParameterName, 'This option is only valid for push and save commands')
          [CompletionResult]::new('--staged', '--staged', [CompletionResultType]::ParameterName, 'This option is only valid for push and save commands')
          [CompletionResult]::new('--pathspec-from-file=<file>', '--pathspec-from-file=<file>', [CompletionResultType]::ParameterName, 'This option is only valid for push command')
          [CompletionResult]::new('--pathspec-file-nul', '--pathspec-file-nul', [CompletionResultType]::ParameterName, 'This option is only valid for push command')
          [CompletionResult]::new('-q', '-q', [CompletionResultType]::ParameterName, 'This option is only valid for apply, drop, pop, push, save, store commands')
          [CompletionResult]::new('--quiet', '--quiet', [CompletionResultType]::ParameterName, 'This option is only valid for apply, drop, pop, push, save, store commands')
          [CompletionResult]::new('--', '--', [CompletionResultType]::ParameterName, 'This option is only valid for push command')
          [CompletionResult]::new('<pathspec>…​', '<pathspec>…​', [CompletionResultType]::ParameterName, 'This option is only valid for push command')
          [CompletionResult]::new('<stash>', '<stash>', [CompletionResultType]::ParameterName, 'This option is only valid for apply, branch, drop, pop, show commands')
        }
        elseif ($commandAst.CommandElements.Count -le 3) {
          [CompletionResult]::new('push', 'push', [CompletionResultType]::ParameterName, 'Save your local modifications to a new stash entry and roll them back to HEAD (in the working tree and in the index)')
          [CompletionResult]::new('save', 'save', [CompletionResultType]::ParameterName, 'This option is deprecated in favour of git stash push')
          [CompletionResult]::new('list', 'list', [CompletionResultType]::ParameterName, 'List the stash entries that you currently have')
          [CompletionResult]::new('show', 'show', [CompletionResultType]::ParameterName, 'Show the changes recorded in the stash entry as a diff between the stashed contents and the commit back when the stash entry was first created')
          [CompletionResult]::new('pop', 'pop', [CompletionResultType]::ParameterName, 'Remove a single stashed state from the stash list and apply it on top of the current working tree state, i')
          [CompletionResult]::new('apply', 'apply', [CompletionResultType]::ParameterName, 'Like pop, but do not remove the state from the stash list')
          [CompletionResult]::new('branch', 'branch', [CompletionResultType]::ParameterName, 'Creates and checks out a new branch named <branchname> starting from the commit at which the <stash> was originally created, applies the changes recorded in <stash> to the new working tree and index')
          [CompletionResult]::new('clear', 'clear', [CompletionResultType]::ParameterName, 'Remove all the stash entries')
          [CompletionResult]::new('drop', 'drop', [CompletionResultType]::ParameterName, 'Remove a single stash entry from the list of stash entries')
          [CompletionResult]::new('create', 'create', [CompletionResultType]::ParameterName, 'Create a stash entry (which is a regular commit object) and return its object name, without storing it anywhere in the ref namespace')
          [CompletionResult]::new('store', 'store', [CompletionResultType]::ParameterName, 'Store a given stash created via git stash create (which is a dangling merge commit) in the stash ref, updating the stash reflog')
        }
        break
      }
      'status' {
        if ($wordToComplete.StartsWith('-')) {
          [CompletionResult]::new('-s', '-s', [CompletionResultType]::ParameterName, 'Give the output in the short-format')
          [CompletionResult]::new('--short', '--short', [CompletionResultType]::ParameterName, 'Give the output in the short-format')
          [CompletionResult]::new('-b', '-b', [CompletionResultType]::ParameterName, 'Show the branch and tracking info even in short-format')
          [CompletionResult]::new('--branch', '--branch', [CompletionResultType]::ParameterName, 'Show the branch and tracking info even in short-format')
          [CompletionResult]::new('--show-stash', '--show-stash', [CompletionResultType]::ParameterName, 'Show the number of entries currently stashed away')
          [CompletionResult]::new('--porcelain[=<version>]', '--porcelain[=<version>]', [CompletionResultType]::ParameterName, 'Give the output in an easy-to-parse format for scripts')
          [CompletionResult]::new('--long', '--long', [CompletionResultType]::ParameterName, 'Give the output in the long-format')
          [CompletionResult]::new('-v', '-v', [CompletionResultType]::ParameterName, 'In addition to the names of files that have been changed, also show the textual changes that are staged to be committed (i')
          [CompletionResult]::new('--verbose', '--verbose', [CompletionResultType]::ParameterName, 'In addition to the names of files that have been changed, also show the textual changes that are staged to be committed (i')
          [CompletionResult]::new('-u[<mode>]', '-u[<mode>]', [CompletionResultType]::ParameterName, 'Show untracked files')
          [CompletionResult]::new('--untracked-files[=<mode>]', '--untracked-files[=<mode>]', [CompletionResultType]::ParameterName, 'Show untracked files')
          [CompletionResult]::new('--ignore-submodules[=<when>]', '--ignore-submodules[=<when>]', [CompletionResultType]::ParameterName, 'Ignore changes to submodules when looking for changes')
          [CompletionResult]::new('--ignored[=<mode>]', '--ignored[=<mode>]', [CompletionResultType]::ParameterName, 'Show ignored files as well')
          [CompletionResult]::new('-z', '-z', [CompletionResultType]::ParameterName, 'Terminate entries with NUL, instead of LF')
          [CompletionResult]::new('--column[=<options>]', '--column[=<options>]', [CompletionResultType]::ParameterName, 'Display untracked files in columns')
          [CompletionResult]::new('--no-column', '--no-column', [CompletionResultType]::ParameterName, 'Display untracked files in columns')
          [CompletionResult]::new('--ahead-behind', '--ahead-behind', [CompletionResultType]::ParameterName, 'Display or do not display detailed ahead/behind counts for the branch relative to its upstream branch')
          [CompletionResult]::new('--no-ahead-behind', '--no-ahead-behind', [CompletionResultType]::ParameterName, 'Display or do not display detailed ahead/behind counts for the branch relative to its upstream branch')
          [CompletionResult]::new('--renames', '--renames', [CompletionResultType]::ParameterName, 'Turn on/off rename detection regardless of user configuration')
          [CompletionResult]::new('--no-renames', '--no-renames', [CompletionResultType]::ParameterName, 'Turn on/off rename detection regardless of user configuration')
          [CompletionResult]::new('--find-renames[=<n>]', '--find-renames[=<n>]', [CompletionResultType]::ParameterName, 'Turn on rename detection, optionally setting the similarity threshold')
          [CompletionResult]::new('<pathspec>…​', '<pathspec>…​', [CompletionResultType]::ParameterName, 'See the pathspec entry in gitglossary(7)')
        }
        break
      }
      'submodule' {
        if ($wordToComplete.StartsWith('-')) {
          [CompletionResult]::new('-q', '-q', [CompletionResultType]::ParameterName, 'Only print error messages')
          [CompletionResult]::new('--quiet', '--quiet', [CompletionResultType]::ParameterName, 'Only print error messages')
          [CompletionResult]::new('--progress', '--progress', [CompletionResultType]::ParameterName, 'This option is only valid for add and update commands')
          [CompletionResult]::new('--all', '--all', [CompletionResultType]::ParameterName, 'This option is only valid for the deinit command')
          [CompletionResult]::new('-b', '-b', [CompletionResultType]::ParameterName, 'Branch of repository to add as submodule')
          [CompletionResult]::new('--branch', '--branch', [CompletionResultType]::ParameterName, 'Branch of repository to add as submodule')
          [CompletionResult]::new('-f', '-f', [CompletionResultType]::ParameterName, 'This option is only valid for add, deinit and update commands')
          [CompletionResult]::new('--force', '--force', [CompletionResultType]::ParameterName, 'This option is only valid for add, deinit and update commands')
          [CompletionResult]::new('--cached', '--cached', [CompletionResultType]::ParameterName, 'This option is only valid for status and summary commands')
          [CompletionResult]::new('--files', '--files', [CompletionResultType]::ParameterName, 'This option is only valid for the summary command')
          [CompletionResult]::new('-n', '-n', [CompletionResultType]::ParameterName, 'This option is only valid for the summary command')
          [CompletionResult]::new('--summary-limit', '--summary-limit', [CompletionResultType]::ParameterName, 'This option is only valid for the summary command')
          [CompletionResult]::new('--remote', '--remote', [CompletionResultType]::ParameterName, 'This option is only valid for the update command')
          [CompletionResult]::new('-N', '-N', [CompletionResultType]::ParameterName, 'This option is only valid for the update command')
          [CompletionResult]::new('--no-fetch', '--no-fetch', [CompletionResultType]::ParameterName, 'This option is only valid for the update command')
          [CompletionResult]::new('--checkout', '--checkout', [CompletionResultType]::ParameterName, 'This option is only valid for the update command')
          [CompletionResult]::new('--merge', '--merge', [CompletionResultType]::ParameterName, 'This option is only valid for the update command')
          [CompletionResult]::new('--rebase', '--rebase', [CompletionResultType]::ParameterName, 'This option is only valid for the update command')
          [CompletionResult]::new('--init', '--init', [CompletionResultType]::ParameterName, 'This option is only valid for the update command')
          [CompletionResult]::new('--name', '--name', [CompletionResultType]::ParameterName, 'This option is only valid for the add command')
          [CompletionResult]::new('--reference', '--reference', [CompletionResultType]::ParameterName, 'This option is only valid for add and update commands')
          [CompletionResult]::new('--dissociate', '--dissociate', [CompletionResultType]::ParameterName, 'This option is only valid for add and update commands')
          [CompletionResult]::new('--recursive', '--recursive', [CompletionResultType]::ParameterName, 'This option is only valid for foreach, update, status and sync commands')
          [CompletionResult]::new('--depth', '--depth', [CompletionResultType]::ParameterName, 'This option is valid for add and update commands')
          [CompletionResult]::new('--[no-]recommend-shallow', '--[no-]recommend-shallow', [CompletionResultType]::ParameterName, 'This option is only valid for the update command')
          [CompletionResult]::new('-j', '-j', [CompletionResultType]::ParameterName, 'This option is only valid for the update command')
          [CompletionResult]::new('--jobs', '--jobs', [CompletionResultType]::ParameterName, 'This option is only valid for the update command')
          [CompletionResult]::new('--[no-]single-branch', '--[no-]single-branch', [CompletionResultType]::ParameterName, 'This option is only valid for the update command')
          [CompletionResult]::new('<path>…​', '<path>…​', [CompletionResultType]::ParameterName, 'Paths to submodule(s)')
        }
        elseif ($commandAst.CommandElements.Count -le 3) {
          [CompletionResult]::new('add', 'add', [CompletionResultType]::ParameterName, 'Add the given repository as a submodule at the given path to the changeset to be committed next to the current project: the current project is termed the "superproject"')
          [CompletionResult]::new('status', 'status', [CompletionResultType]::ParameterName, 'Show the status of the submodules')
          [CompletionResult]::new('init', 'init', [CompletionResultType]::ParameterName, 'Initialize the submodules recorded in the index (which were added and committed elsewhere) by setting submodule')
          [CompletionResult]::new('deinit', 'deinit', [CompletionResultType]::ParameterName, 'Unregister the given submodules, i')
          [CompletionResult]::new('update', 'update', [CompletionResultType]::ParameterName, 'Update the registered submodules to match what the superproject expects by cloning missing submodules, fetching missing commits in submodules and updating the working tree of the submodules')
          [CompletionResult]::new('set-branch', 'set-branch', [CompletionResultType]::ParameterName, 'Sets the default remote tracking branch for the submodule')
          [CompletionResult]::new('set-branch', 'set-branch', [CompletionResultType]::ParameterName, 'Sets the default remote tracking branch for the submodule')
          [CompletionResult]::new('set-url', 'set-url', [CompletionResultType]::ParameterName, 'Sets the URL of the specified submodule to <newurl>')
          [CompletionResult]::new('summary', 'summary', [CompletionResultType]::ParameterName, 'Show commit summary between the given commit (defaults to HEAD) and working tree/index')
          [CompletionResult]::new('foreach', 'foreach', [CompletionResultType]::ParameterName, 'Evaluates an arbitrary shell command in each checked out submodule')
          [CompletionResult]::new('sync', 'sync', [CompletionResultType]::ParameterName, "Synchronizes submodules' remote URL configuration setting to the value specified in")
          [CompletionResult]::new('absorbgitdirs', 'absorbgitdirs', [CompletionResultType]::ParameterName, "If a git directory of a submodule is inside the submodule, move the git directory of the submodule into its superproject's $GIT_DIR/modules path and then connect the git directory and its working directory by setting the core")
        }
        break
      }
      'subtree' {
        if ($wordToComplete.StartsWith('-')) {
          [CompletionResult]::new('-h', '-h', [CompletionResultType]::ParameterName, 'show the help')
          [CompletionResult]::new('--help', '--help', [CompletionResultType]::ParameterName, 'show the help')
          [CompletionResult]::new('-q', '-q', [CompletionResultType]::ParameterName, 'quiet mode')
          [CompletionResult]::new('--quiet', '--quiet', [CompletionResultType]::ParameterName, 'quiet mode')
          [CompletionResult]::new('-d', '-d', [CompletionResultType]::ParameterName, 'show debug messages')
          [CompletionResult]::new('--debug', '--debug', [CompletionResultType]::ParameterName, 'show debug messages')
          [CompletionResult]::new('-P', '-P', [CompletionResultType]::ParameterName, 'the name of the subdir to split out')
          [CompletionResult]::new('--prefix', '--prefix', [CompletionResultType]::ParameterName, 'the name of the subdir to split out')
          [CompletionResult]::new('--no-prefix', '--no-prefix', [CompletionResultType]::ParameterName, 'the name of the subdir to split out')
          break
        }
        [CompletionResult]::new('add', 'add', [CompletionResultType]::ParameterName, 'add subtree')
        [CompletionResult]::new('merge', 'merge', [CompletionResultType]::ParameterName, 'merge subtree')
        [CompletionResult]::new('split', 'split', [CompletionResultType]::ParameterName, 'split into subtrees')
        [CompletionResult]::new('pull', 'pull', [CompletionResultType]::ParameterName, 'pull from subtrees')
        [CompletionResult]::new('push', 'push', [CompletionResultType]::ParameterName, 'push to subtrees')
        break
      }
      { $_ -ceq 'subtree split' -or $_ -ceq 'subtree push' } {
        if ($wordToComplete.StartsWith('-')) {
          [CompletionResult]::new('--annotate', '--annotate', [CompletionResultType]::ParameterName, 'add a prefix to commit message of new commits')
          [CompletionResult]::new('--no-annotate', '--no-annotate', [CompletionResultType]::ParameterName, 'add a prefix to commit message of new commits')
          [CompletionResult]::new('-b', '-b', [CompletionResultType]::ParameterName, 'create a new branch from the split subtree')
          [CompletionResult]::new('--branch', '--branch', [CompletionResultType]::ParameterName, 'create a new branch from the split subtree')
          [CompletionResult]::new('--ignore-joins', '--ignore-joins', [CompletionResultType]::ParameterName, 'ignore prior --rejoin commits')
          [CompletionResult]::new('--no-ignore-joins', '--no-ignore-joins', [CompletionResultType]::ParameterName, 'ignore prior --rejoin commits')
          [CompletionResult]::new('--onto', '--onto', [CompletionResultType]::ParameterName, 'try connecting new tree to an existing one')
          [CompletionResult]::new('--no-onto', '--no-onto', [CompletionResultType]::ParameterName, 'try connecting new tree to an existing one')
          [CompletionResult]::new('--rejoin', '--rejoin', [CompletionResultType]::ParameterName, 'merge the new branch back into HEAD')
          [CompletionResult]::new('--no-rejoin', '--no-rejoin', [CompletionResultType]::ParameterName, 'merge the new branch back into HEAD')
          [CompletionResult]::new('--squash', '--squash', [CompletionResultType]::ParameterName, 'merge subtree changes as a single commit')
          [CompletionResult]::new('--no-squash', '--no-squash', [CompletionResultType]::ParameterName, 'merge subtree changes as a single commit')
          [CompletionResult]::new('-m', '-m', [CompletionResultType]::ParameterName, 'use the given message as the commit message for the merge commit')
          [CompletionResult]::new('--message', '--message', [CompletionResultType]::ParameterName, 'use the given message as the commit message for the merge commit')
          [CompletionResult]::new('-S', '-S', [CompletionResultType]::ParameterName, 'GPG-sign commits. The keyid argument is optional and defaults to the committer identity')
          [CompletionResult]::new('--gpg-sign', '--gpg-sign', [CompletionResultType]::ParameterName, 'GPG-sign commits. The keyid argument is optional and defaults to the committer identity')
          [CompletionResult]::new('--no-gpg-sign', '--no-gpg-sign', [CompletionResultType]::ParameterName, 'GPG-sign commits. The keyid argument is optional and defaults to the committer identity')
          break
        }
        break
      }
      { $_ -ceq 'subtree add' -or $_ -ceq 'subtree merge' } {
        if ($wordToComplete.StartsWith('-')) {
          [CompletionResult]::new('--squash', '--squash', [CompletionResultType]::ParameterName, 'merge subtree changes as a single commit')
          [CompletionResult]::new('--no-squash', '--no-squash', [CompletionResultType]::ParameterName, 'merge subtree changes as a single commit')
          [CompletionResult]::new('-m', '-m', [CompletionResultType]::ParameterName, 'use the given message as the commit message for the merge commit')
          [CompletionResult]::new('--message', '--message', [CompletionResultType]::ParameterName, 'use the given message as the commit message for the merge commit')
          [CompletionResult]::new('-S', '-S', [CompletionResultType]::ParameterName, 'GPG-sign commits. The keyid argument is optional and defaults to the committer identity')
          [CompletionResult]::new('--gpg-sign', '--gpg-sign', [CompletionResultType]::ParameterName, 'GPG-sign commits. The keyid argument is optional and defaults to the committer identity')
          [CompletionResult]::new('--no-gpg-sign', '--no-gpg-sign', [CompletionResultType]::ParameterName, 'GPG-sign commits. The keyid argument is optional and defaults to the committer identity')
          break
        }
        break
      }
      'switch' {
        if ($wordToComplete.StartsWith('-')) {
          [CompletionResult]::new('<branch>', '<branch>', [CompletionResultType]::ParameterName, 'Branch to switch to')
          [CompletionResult]::new('<new-branch>', '<new-branch>', [CompletionResultType]::ParameterName, 'Name for the new branch')
          [CompletionResult]::new('<start-point>', '<start-point>', [CompletionResultType]::ParameterName, 'The starting point for the new branch')
          [CompletionResult]::new('-c', '-c', [CompletionResultType]::ParameterName, 'Create a new branch named <new-branch> starting at <start-point> before switching to the branch')
          [CompletionResult]::new('--create', '--create', [CompletionResultType]::ParameterName, 'Create a new branch named <new-branch> starting at <start-point> before switching to the branch')
          [CompletionResult]::new('-C', '-C', [CompletionResultType]::ParameterName, 'Similar to --create except that if <new-branch> already exists, it will be reset to <start-point>')
          [CompletionResult]::new('--force-create', '--force-create', [CompletionResultType]::ParameterName, 'Similar to --create except that if <new-branch> already exists, it will be reset to <start-point>')
          [CompletionResult]::new('-d', '-d', [CompletionResultType]::ParameterName, 'Switch to a commit for inspection and discardable experiments')
          [CompletionResult]::new('--detach', '--detach', [CompletionResultType]::ParameterName, 'Switch to a commit for inspection and discardable experiments')
          [CompletionResult]::new('--guess', '--guess', [CompletionResultType]::ParameterName, 'If <branch> is not found but there does exist a tracking branch in exactly one remote (call it <remote>) with a matching name, treat as equivalent to   $ git switch -c <branch> --track <remote>/<branch>    If the branch exists in multiple remotes and one of them is named by the checkout')
          [CompletionResult]::new('--no-guess', '--no-guess', [CompletionResultType]::ParameterName, 'If <branch> is not found but there does exist a tracking branch in exactly one remote (call it <remote>) with a matching name, treat as equivalent to   $ git switch -c <branch> --track <remote>/<branch>    If the branch exists in multiple remotes and one of them is named by the checkout')
          [CompletionResult]::new('-f', '-f', [CompletionResultType]::ParameterName, 'An alias for --discard-changes')
          [CompletionResult]::new('--force', '--force', [CompletionResultType]::ParameterName, 'An alias for --discard-changes')
          [CompletionResult]::new('--discard-changes', '--discard-changes', [CompletionResultType]::ParameterName, 'Proceed even if the index or the working tree differs from HEAD')
          [CompletionResult]::new('-m', '-m', [CompletionResultType]::ParameterName, 'If you have local modifications to one or more files that are different between the current branch and the branch to which you are switching, the command refuses to switch branches in order to preserve your modifications in context')
          [CompletionResult]::new('--merge', '--merge', [CompletionResultType]::ParameterName, 'If you have local modifications to one or more files that are different between the current branch and the branch to which you are switching, the command refuses to switch branches in order to preserve your modifications in context')
          [CompletionResult]::new('--conflict=<style>', '--conflict=<style>', [CompletionResultType]::ParameterName, 'The same as --merge option above, but changes the way the conflicting hunks are presented, overriding the merge')
          [CompletionResult]::new('-q', '-q', [CompletionResultType]::ParameterName, 'Quiet, suppress feedback messages')
          [CompletionResult]::new('--quiet', '--quiet', [CompletionResultType]::ParameterName, 'Quiet, suppress feedback messages')
          [CompletionResult]::new('--progress', '--progress', [CompletionResultType]::ParameterName, 'Progress status is reported on the standard error stream by default when it is attached to a terminal, unless --quiet is specified')
          [CompletionResult]::new('--no-progress', '--no-progress', [CompletionResultType]::ParameterName, 'Progress status is reported on the standard error stream by default when it is attached to a terminal, unless --quiet is specified')
          [CompletionResult]::new('-t', '-t', [CompletionResultType]::ParameterName, 'When creating a new branch, set up "upstream" configuration')
          [CompletionResult]::new('--track', '--track', [CompletionResultType]::ParameterName, 'When creating a new branch, set up "upstream" configuration')
          [CompletionResult]::new('--no-track', '--no-track', [CompletionResultType]::ParameterName, 'Do not set up "upstream" configuration, even if the branch')
          [CompletionResult]::new('--orphan', '--orphan', [CompletionResultType]::ParameterName, 'Create a new unborn branch, named <new-branch>')
          [CompletionResult]::new('--ignore-other-worktrees', '--ignore-other-worktrees', [CompletionResultType]::ParameterName, 'git switch refuses when the wanted ref is already checked out by another worktree')
          [CompletionResult]::new('--recurse-submodules', '--recurse-submodules', [CompletionResultType]::ParameterName, 'Using --recurse-submodules will update the content of all active submodules according to the commit recorded in the superproject')
          [CompletionResult]::new('--no-recurse-submodules', '--no-recurse-submodules', [CompletionResultType]::ParameterName, 'Using --recurse-submodules will update the content of all active submodules according to the commit recorded in the superproject')
        }
        break
      }
      'tag' {
        if ($wordToComplete.StartsWith('-')) {
          [CompletionResult]::new('-a', '-a', [CompletionResultType]::ParameterName, 'Make an unsigned, annotated tag object')
          [CompletionResult]::new('--annotate', '--annotate', [CompletionResultType]::ParameterName, 'Make an unsigned, annotated tag object')
          [CompletionResult]::new('-s', '-s', [CompletionResultType]::ParameterName, "Make a GPG-signed tag, using the default e-mail address's key")
          [CompletionResult]::new('--sign', '--sign', [CompletionResultType]::ParameterName, "Make a GPG-signed tag, using the default e-mail address's key")
          [CompletionResult]::new('--no-sign', '--no-sign', [CompletionResultType]::ParameterName, 'Override tag')
          [CompletionResult]::new('-u', '-u', [CompletionResultType]::ParameterName, 'Make a GPG-signed tag, using the given key')
          [CompletionResult]::new('--local-user=<key-id>', '--local-user=<key-id>', [CompletionResultType]::ParameterName, 'Make a GPG-signed tag, using the given key')
          [CompletionResult]::new('-f', '-f', [CompletionResultType]::ParameterName, 'Replace an existing tag with the given name (instead of failing)')
          [CompletionResult]::new('--force', '--force', [CompletionResultType]::ParameterName, 'Replace an existing tag with the given name (instead of failing)')
          [CompletionResult]::new('-d', '-d', [CompletionResultType]::ParameterName, 'Delete existing tags with the given names')
          [CompletionResult]::new('--delete', '--delete', [CompletionResultType]::ParameterName, 'Delete existing tags with the given names')
          [CompletionResult]::new('-v', '-v', [CompletionResultType]::ParameterName, 'Verify the GPG signature of the given tag names')
          [CompletionResult]::new('--verify', '--verify', [CompletionResultType]::ParameterName, 'Verify the GPG signature of the given tag names')
          [CompletionResult]::new('-n<num>', '-n<num>', [CompletionResultType]::ParameterName, '<num> specifies how many lines from the annotation, if any, are printed when using -l')
          [CompletionResult]::new('-l', '-l', [CompletionResultType]::ParameterName, 'List tags')
          [CompletionResult]::new('--list', '--list', [CompletionResultType]::ParameterName, 'List tags')
          [CompletionResult]::new('--sort=<key>', '--sort=<key>', [CompletionResultType]::ParameterName, 'Sort based on the key given')
          [CompletionResult]::new('--color[=<when>]', '--color[=<when>]', [CompletionResultType]::ParameterName, 'Respect any colors specified in the --format option')
          [CompletionResult]::new('-i', '-i', [CompletionResultType]::ParameterName, 'Sorting and filtering tags are case insensitive')
          [CompletionResult]::new('--ignore-case', '--ignore-case', [CompletionResultType]::ParameterName, 'Sorting and filtering tags are case insensitive')
          [CompletionResult]::new('--omit-empty', '--omit-empty', [CompletionResultType]::ParameterName, 'Do not print a newline after formatted refs where the format expands to the empty string')
          [CompletionResult]::new('--column[=<options>]', '--column[=<options>]', [CompletionResultType]::ParameterName, 'Display tag listing in columns')
          [CompletionResult]::new('--no-column', '--no-column', [CompletionResultType]::ParameterName, 'Display tag listing in columns')
          [CompletionResult]::new('--contains', '--contains', [CompletionResultType]::ParameterName, 'Only list tags which contain the specified commit (HEAD if not specified)')
          [CompletionResult]::new('--no-contains', '--no-contains', [CompletionResultType]::ParameterName, "Only list tags which don't contain the specified commit (HEAD if not specified)")
          [CompletionResult]::new('--merged', '--merged', [CompletionResultType]::ParameterName, 'Only list tags whose commits are reachable from the specified commit (HEAD if not specified)')
          [CompletionResult]::new('--no-merged', '--no-merged', [CompletionResultType]::ParameterName, 'Only list tags whose commits are not reachable from the specified commit (HEAD if not specified)')
          [CompletionResult]::new('--points-at', '--points-at', [CompletionResultType]::ParameterName, 'Only list tags of the given object (HEAD if not specified)')
          [CompletionResult]::new('-m', '-m', [CompletionResultType]::ParameterName, 'Use the given tag message (instead of prompting)')
          [CompletionResult]::new('--message=<msg>', '--message=<msg>', [CompletionResultType]::ParameterName, 'Use the given tag message (instead of prompting)')
          [CompletionResult]::new('-F', '-F', [CompletionResultType]::ParameterName, 'Take the tag message from the given file')
          [CompletionResult]::new('--file=<file>', '--file=<file>', [CompletionResultType]::ParameterName, 'Take the tag message from the given file')
          [CompletionResult]::new('--trailer', '--trailer', [CompletionResultType]::ParameterName, 'Specify a (<token>, <value>) pair that should be applied as a trailer')
          [CompletionResult]::new('-e', '-e', [CompletionResultType]::ParameterName, 'The message taken from file with -F and command line with -m are usually used as the tag message unmodified')
          [CompletionResult]::new('--edit', '--edit', [CompletionResultType]::ParameterName, 'The message taken from file with -F and command line with -m are usually used as the tag message unmodified')
          [CompletionResult]::new('--cleanup=<mode>', '--cleanup=<mode>', [CompletionResultType]::ParameterName, 'This option sets how the tag message is cleaned up')
          [CompletionResult]::new('--create-reflog', '--create-reflog', [CompletionResultType]::ParameterName, 'Create a reflog for the tag')
          [CompletionResult]::new('--format=<format>', '--format=<format>', [CompletionResultType]::ParameterName, 'A string that interpolates %(fieldname) from a tag ref being shown and the object it points at')
          [CompletionResult]::new('<tagname>', '<tagname>', [CompletionResultType]::ParameterName, 'The name of the tag to create, delete, or describe')
          [CompletionResult]::new('<commit>', '<commit>', [CompletionResultType]::ParameterName, 'The object that the new tag will refer to, usually a commit')
          [CompletionResult]::new('<object>', '<object>', [CompletionResultType]::ParameterName, 'The object that the new tag will refer to, usually a commit')
        }
        break
      }
      'worktree' {
        if ($wordToComplete.StartsWith('-')) {
          [CompletionResult]::new('-f', '-f', [CompletionResultType]::ParameterName, 'By default, add refuses to create a new worktree when <commit-ish> is a branch name and is already checked out by another worktree, or if <path> is already assigned to some worktree but is missing (for instance, if <path> was deleted manually)')
          [CompletionResult]::new('--force', '--force', [CompletionResultType]::ParameterName, 'By default, add refuses to create a new worktree when <commit-ish> is a branch name and is already checked out by another worktree, or if <path> is already assigned to some worktree but is missing (for instance, if <path> was deleted manually)')
          [CompletionResult]::new('-b', '-b', [CompletionResultType]::ParameterName, 'With add, create a new branch named <new-branch> starting at <commit-ish>, and check out <new-branch> into the new worktree')
          [CompletionResult]::new('-B', '-B', [CompletionResultType]::ParameterName, 'With add, create a new branch named <new-branch> starting at <commit-ish>, and check out <new-branch> into the new worktree')
          [CompletionResult]::new('-d', '-d', [CompletionResultType]::ParameterName, 'With add, detach HEAD in the new worktree')
          [CompletionResult]::new('--detach', '--detach', [CompletionResultType]::ParameterName, 'With add, detach HEAD in the new worktree')
          [CompletionResult]::new('--[no-]checkout', '--[no-]checkout', [CompletionResultType]::ParameterName, 'By default, add checks out <commit-ish>, however, --no-checkout can be used to suppress checkout in order to make customizations, such as configuring sparse-checkout')
          [CompletionResult]::new('--[no-]guess-remote', '--[no-]guess-remote', [CompletionResultType]::ParameterName, 'With worktree add <path>, without <commit-ish>, instead of creating a new branch from HEAD, if there exists a tracking branch in exactly one remote matching the basename of <path>, base the new branch on the remote-tracking branch, and mark the remote-tracking branch as "upstream" from the new branch')
          [CompletionResult]::new('--[no-]track', '--[no-]track', [CompletionResultType]::ParameterName, 'When creating a new branch, if <commit-ish> is a branch, mark it as "upstream" from the new branch')
          [CompletionResult]::new('--lock', '--lock', [CompletionResultType]::ParameterName, 'Keep the worktree locked after creation')
          [CompletionResult]::new('-n', '-n', [CompletionResultType]::ParameterName, 'With prune, do not remove anything; just report what it would remove')
          [CompletionResult]::new('--dry-run', '--dry-run', [CompletionResultType]::ParameterName, 'With prune, do not remove anything; just report what it would remove')
          [CompletionResult]::new('--orphan', '--orphan', [CompletionResultType]::ParameterName, 'With add, make the new worktree and index empty, associating the worktree with a new unborn branch named <new-branch>')
          [CompletionResult]::new('--porcelain', '--porcelain', [CompletionResultType]::ParameterName, 'With list, output in an easy-to-parse format for scripts')
          [CompletionResult]::new('-z', '-z', [CompletionResultType]::ParameterName, 'Terminate each line with a NUL rather than a newline when --porcelain is specified with list')
          [CompletionResult]::new('-q', '-q', [CompletionResultType]::ParameterName, 'With add, suppress feedback messages')
          [CompletionResult]::new('--quiet', '--quiet', [CompletionResultType]::ParameterName, 'With add, suppress feedback messages')
          [CompletionResult]::new('-v', '-v', [CompletionResultType]::ParameterName, 'With prune, report all removals')
          [CompletionResult]::new('--verbose', '--verbose', [CompletionResultType]::ParameterName, 'With prune, report all removals')
          [CompletionResult]::new('--expire', '--expire', [CompletionResultType]::ParameterName, 'With prune, only expire unused worktrees older than <time>')
          [CompletionResult]::new('--reason', '--reason', [CompletionResultType]::ParameterName, 'With lock or with add --lock, an explanation why the worktree is locked')
          [CompletionResult]::new('<worktree>', '<worktree>', [CompletionResultType]::ParameterName, 'Worktrees can be identified by path, either relative or absolute')
        }
        elseif ($commandAst.CommandElements.Count -le 3) {
          [CompletionResult]::new('add', 'add', [CompletionResultType]::ParameterName, 'Create a worktree at <path> and checkout <commit-ish> into it')
          [CompletionResult]::new('list', 'list', [CompletionResultType]::ParameterName, 'List details of each worktree')
          [CompletionResult]::new('lock', 'lock', [CompletionResultType]::ParameterName, 'If a worktree is on a portable device or network share which is not always mounted, lock it to prevent its administrative files from being pruned automatically')
          [CompletionResult]::new('move', 'move', [CompletionResultType]::ParameterName, 'Move a worktree to a new location')
          [CompletionResult]::new('prune', 'prune', [CompletionResultType]::ParameterName, 'Prune worktree information in $GIT_DIR/worktrees')
          [CompletionResult]::new('remove', 'remove', [CompletionResultType]::ParameterName, 'Remove a worktree')
          [CompletionResult]::new('repair', 'repair', [CompletionResultType]::ParameterName, 'Repair worktree administrative files, if possible, if they have become corrupted or outdated due to external factors')
          [CompletionResult]::new('unlock', 'unlock', [CompletionResultType]::ParameterName, 'Unlock a worktree, allowing it to be pruned, moved or deleted')
        }
        break
      }
      'config' {
        if ($wordToComplete.StartsWith('-')) {
          [CompletionResult]::new('--replace-all', '--replace-all', [CompletionResultType]::ParameterName, 'Default behavior is to replace at most one line')
          [CompletionResult]::new('--append', '--append', [CompletionResultType]::ParameterName, 'Adds a new line to the option without altering any existing values')
          [CompletionResult]::new('--comment', '--comment', [CompletionResultType]::ParameterName, 'Append a comment at the end of new or modified lines')
          [CompletionResult]::new('--all', '--all', [CompletionResultType]::ParameterName, 'With get, return all values for a multi-valued key')
          [CompletionResult]::new('--regexp', '--regexp', [CompletionResultType]::ParameterName, 'With get, interpret the name as a regular expression')
          [CompletionResult]::new('--url=<URL>', '--url=<URL>', [CompletionResultType]::ParameterName, 'When given a two-part <name> as <section>')
          [CompletionResult]::new('--global', '--global', [CompletionResultType]::ParameterName, 'For writing options: write to global ~/')
          [CompletionResult]::new('--system', '--system', [CompletionResultType]::ParameterName, 'For writing options: write to system-wide $(prefix)/etc/gitconfig rather than the repository')
          [CompletionResult]::new('--local', '--local', [CompletionResultType]::ParameterName, 'For writing options: write to the repository')
          [CompletionResult]::new('--worktree', '--worktree', [CompletionResultType]::ParameterName, 'Similar to --local except that $GIT_DIR/config')
          [CompletionResult]::new('-f', '-f', [CompletionResultType]::ParameterName, 'For writing options: write to the specified file rather than the repository')
          [CompletionResult]::new('--file', '--file', [CompletionResultType]::ParameterName, 'For writing options: write to the specified file rather than the repository')
          [CompletionResult]::new('--blob', '--blob', [CompletionResultType]::ParameterName, 'Similar to --file but use the given blob instead of a file')
          [CompletionResult]::new('--fixed-value', '--fixed-value', [CompletionResultType]::ParameterName, 'When used with the value-pattern argument, treat value-pattern as an exact string instead of a regular expression')
          [CompletionResult]::new('--type', '--type', [CompletionResultType]::ParameterName, "git config will ensure that any input or output is valid under the given type constraint(s), and will canonicalize outgoing values in <type>'s canonical form")
          [CompletionResult]::new('--bool', '--bool', [CompletionResultType]::ParameterName, 'Historical options for selecting a type specifier')
          [CompletionResult]::new('--int', '--int', [CompletionResultType]::ParameterName, 'Historical options for selecting a type specifier')
          [CompletionResult]::new('--bool-or-int', '--bool-or-int', [CompletionResultType]::ParameterName, 'Historical options for selecting a type specifier')
          [CompletionResult]::new('--path', '--path', [CompletionResultType]::ParameterName, 'Historical options for selecting a type specifier')
          [CompletionResult]::new('--expiry-date', '--expiry-date', [CompletionResultType]::ParameterName, 'Historical options for selecting a type specifier')
          [CompletionResult]::new('--no-type', '--no-type', [CompletionResultType]::ParameterName, 'Un-sets the previously set type specifier (if one was previously set)')
          [CompletionResult]::new('-z', '-z', [CompletionResultType]::ParameterName, 'For all options that output values and/or keys, always end values with the null character (instead of a newline)')
          [CompletionResult]::new('--null', '--null', [CompletionResultType]::ParameterName, 'For all options that output values and/or keys, always end values with the null character (instead of a newline)')
          [CompletionResult]::new('--name-only', '--name-only', [CompletionResultType]::ParameterName, 'Output only the names of config variables for list or get')
          [CompletionResult]::new('--show-origin', '--show-origin', [CompletionResultType]::ParameterName, 'Augment the output of all queried config options with the origin type (file, standard input, blob, command line) and the actual origin (config file path, ref, or blob id if applicable)')
          [CompletionResult]::new('--show-scope', '--show-scope', [CompletionResultType]::ParameterName, 'Similar to --show-origin in that it augments the output of all queried config options with the scope of that value (worktree, local, global, system, command)')
          [CompletionResult]::new('--get-colorbool', '--get-colorbool', [CompletionResultType]::ParameterName, 'Find the color setting for <name> (e')
          [CompletionResult]::new('--[no-]includes', '--[no-]includes', [CompletionResultType]::ParameterName, 'Respect include')
          [CompletionResult]::new('--default', '--default', [CompletionResultType]::ParameterName, 'When using get, and the requested variable is not found, behave as if <value> were the value assigned to that variable')
        }
        elseif ($commandAst.CommandElements.Count -le 3) {
          [CompletionResult]::new('list', 'list', [CompletionResultType]::ParameterName, 'List all variables set in config file, along with their values')
          [CompletionResult]::new('get', 'get', [CompletionResultType]::ParameterName, 'Emits the value of the specified key')
          [CompletionResult]::new('set', 'set', [CompletionResultType]::ParameterName, 'Set value for one or more config options')
          [CompletionResult]::new('unset', 'unset', [CompletionResultType]::ParameterName, 'Unset value for one or more config options')
          [CompletionResult]::new('rename-section', 'rename-section', [CompletionResultType]::ParameterName, 'Rename the given section to a new name')
          [CompletionResult]::new('remove-section', 'remove-section', [CompletionResultType]::ParameterName, 'Remove the given section from the configuration file')
          [CompletionResult]::new('edit', 'edit', [CompletionResultType]::ParameterName, 'Opens an editor to modify the specified config file; either --system, --global, --local (default), --worktree, or --file <config-file>')
        }
        break
      }
      'fast-export' {
        if ($wordToComplete.StartsWith('-')) {
          [CompletionResult]::new('--progress=<n>', '--progress=<n>', [CompletionResultType]::ParameterName, 'Insert progress statements every <n> objects, to be shown by git fast-import during import')
          [CompletionResult]::new('--signed-tags=(verbatim|warn|warn-strip|strip|abort)', '--signed-tags=(verbatim|warn|warn-strip|strip|abort)', [CompletionResultType]::ParameterName, 'Specify how to handle signed tags')
          [CompletionResult]::new('--tag-of-filtered-object=(abort|drop|rewrite)', '--tag-of-filtered-object=(abort|drop|rewrite)', [CompletionResultType]::ParameterName, 'Specify how to handle tags whose tagged object is filtered out')
          [CompletionResult]::new('-M', '-M', [CompletionResultType]::ParameterName, 'Perform move and/or copy detection, as described in the git-diff(1) manual page, and use it to generate rename and copy commands in the output dump')
          [CompletionResult]::new('-C', '-C', [CompletionResultType]::ParameterName, 'Perform move and/or copy detection, as described in the git-diff(1) manual page, and use it to generate rename and copy commands in the output dump')
          [CompletionResult]::new('--export-marks=<file>', '--export-marks=<file>', [CompletionResultType]::ParameterName, 'Dumps the internal marks table to <file> when complete')
          [CompletionResult]::new('--import-marks=<file>', '--import-marks=<file>', [CompletionResultType]::ParameterName, 'Before processing any input, load the marks specified in <file>')
          [CompletionResult]::new('--mark-tags', '--mark-tags', [CompletionResultType]::ParameterName, 'In addition to labelling blobs and commits with mark ids, also label tags')
          [CompletionResult]::new('--fake-missing-tagger', '--fake-missing-tagger', [CompletionResultType]::ParameterName, 'Some old repositories have tags without a tagger')
          [CompletionResult]::new('--use-done-feature', '--use-done-feature', [CompletionResultType]::ParameterName, 'Start the stream with a feature done stanza, and terminate it with a done command')
          [CompletionResult]::new('--no-data', '--no-data', [CompletionResultType]::ParameterName, 'Skip output of blob objects and instead refer to blobs via their original SHA-1 hash')
          [CompletionResult]::new('--full-tree', '--full-tree', [CompletionResultType]::ParameterName, "This option will cause fast-export to issue a `"deleteall`" directive for each commit followed by a full list of all files in the commit (as opposed to just listing the files which are different from the commit's first parent)")
          [CompletionResult]::new('--anonymize', '--anonymize', [CompletionResultType]::ParameterName, 'Anonymize the contents of the repository while still retaining the shape of the history and stored tree')
          [CompletionResult]::new('--anonymize-map=<from>[:<to>]', '--anonymize-map=<from>[:<to>]', [CompletionResultType]::ParameterName, 'Convert token <from> to <to> in the anonymized output')
          [CompletionResult]::new('--reference-excluded-parents', '--reference-excluded-parents', [CompletionResultType]::ParameterName, 'By default, running a command such as git fast-export master~5')
          [CompletionResult]::new('--show-original-ids', '--show-original-ids', [CompletionResultType]::ParameterName, 'Add an extra directive to the output for commits and blobs, original-oid <SHA1SUM>')
          [CompletionResult]::new('--reencode=(yes|no|abort)', '--reencode=(yes|no|abort)', [CompletionResultType]::ParameterName, 'Specify how to handle encoding header in commit objects')
          [CompletionResult]::new('--refspec', '--refspec', [CompletionResultType]::ParameterName, 'Apply the specified refspec to each ref exported')
          [CompletionResult]::new('[<git-rev-list-args>…​]', '[<git-rev-list-args>…​]', [CompletionResultType]::ParameterName, 'A list of arguments, acceptable to git rev-parse and git rev-list, that specifies the specific objects and references to export')
        }
        break
      }
      'fast-import' {
        if ($wordToComplete.StartsWith('-')) {
          [CompletionResult]::new('--force', '--force', [CompletionResultType]::ParameterName, 'Force updating modified existing branches, even if doing so would cause commits to be lost (as the new commit does not contain the old commit)')
          [CompletionResult]::new('--quiet', '--quiet', [CompletionResultType]::ParameterName, 'Disable the output shown by --stats, making fast-import usually be silent when it is successful')
          [CompletionResult]::new('--stats', '--stats', [CompletionResultType]::ParameterName, 'Display some basic statistics about the objects fast-import has created, the packfiles they were stored into, and the memory used by fast-import during this run')
          [CompletionResult]::new('--allow-unsafe-features', '--allow-unsafe-features', [CompletionResultType]::ParameterName, 'Many command-line options can be provided as part of the fast-import stream itself by using the feature or option commands')
        }
        break
      }
      'filter-branch' {
        if ($wordToComplete.StartsWith('-')) {
          [CompletionResult]::new('--setup', '--setup', [CompletionResultType]::ParameterName, 'This is not a real filter executed for each commit but a one time setup just before the loop')
          [CompletionResult]::new('--subdirectory-filter', '--subdirectory-filter', [CompletionResultType]::ParameterName, 'Only look at the history which touches the given subdirectory')
          [CompletionResult]::new('--env-filter', '--env-filter', [CompletionResultType]::ParameterName, 'This filter may be used if you only need to modify the environment in which the commit will be performed')
          [CompletionResult]::new('--tree-filter', '--tree-filter', [CompletionResultType]::ParameterName, 'This is the filter for rewriting the tree and its contents')
          [CompletionResult]::new('--index-filter', '--index-filter', [CompletionResultType]::ParameterName, 'This is the filter for rewriting the index')
          [CompletionResult]::new('--parent-filter', '--parent-filter', [CompletionResultType]::ParameterName, "This is the filter for rewriting the commit's parent list")
          [CompletionResult]::new('--msg-filter', '--msg-filter', [CompletionResultType]::ParameterName, 'This is the filter for rewriting the commit messages')
          [CompletionResult]::new('--commit-filter', '--commit-filter', [CompletionResultType]::ParameterName, 'This is the filter for performing the commit')
          [CompletionResult]::new('--tag-name-filter', '--tag-name-filter', [CompletionResultType]::ParameterName, 'This is the filter for rewriting tag names')
          [CompletionResult]::new('--prune-empty', '--prune-empty', [CompletionResultType]::ParameterName, 'Some filters will generate empty commits that leave the tree untouched')
          [CompletionResult]::new('--original', '--original', [CompletionResultType]::ParameterName, 'Use this option to set the namespace where the original commits will be stored')
          [CompletionResult]::new('-d', '-d', [CompletionResultType]::ParameterName, 'Use this option to set the path to the temporary directory used for rewriting')
          [CompletionResult]::new('-f', '-f', [CompletionResultType]::ParameterName, 'git filter-branch refuses to start with an existing temporary directory or when there are already refs starting with refs/original/, unless forced')
          [CompletionResult]::new('--force', '--force', [CompletionResultType]::ParameterName, 'git filter-branch refuses to start with an existing temporary directory or when there are already refs starting with refs/original/, unless forced')
          [CompletionResult]::new('--state-branch', '--state-branch', [CompletionResultType]::ParameterName, 'This option will cause the mapping from old to new objects to be loaded from named branch upon startup and saved as a new commit to that branch upon exit, enabling incremental of large trees')
          [CompletionResult]::new('<rev-list', '<rev-list', [CompletionResultType]::ParameterName, 'Arguments for git rev-list')
        }
        break
      }
      'mergetool' {
        if ($wordToComplete.StartsWith('-')) {
          [CompletionResult]::new('-t', '-t', [CompletionResultType]::ParameterName, 'Use the merge resolution program specified by <tool>')
          [CompletionResult]::new('--tool=<tool>', '--tool=<tool>', [CompletionResultType]::ParameterName, 'Use the merge resolution program specified by <tool>')
          [CompletionResult]::new('--tool-help', '--tool-help', [CompletionResultType]::ParameterName, 'Print a list of merge tools that may be used with --tool')
          [CompletionResult]::new('-y', '-y', [CompletionResultType]::ParameterName, "Don't prompt before each invocation of the merge resolution program")
          [CompletionResult]::new('--no-prompt', '--no-prompt', [CompletionResultType]::ParameterName, "Don't prompt before each invocation of the merge resolution program")
          [CompletionResult]::new('--prompt', '--prompt', [CompletionResultType]::ParameterName, 'Prompt before each invocation of the merge resolution program to give the user a chance to skip the path')
          [CompletionResult]::new('-g', '-g', [CompletionResultType]::ParameterName, 'When git-mergetool is invoked with the -g or --gui option, the default merge tool will be read from the configured merge')
          [CompletionResult]::new('--gui', '--gui', [CompletionResultType]::ParameterName, 'When git-mergetool is invoked with the -g or --gui option, the default merge tool will be read from the configured merge')
          [CompletionResult]::new('--no-gui', '--no-gui', [CompletionResultType]::ParameterName, 'This overrides a previous -g or --gui setting or mergetool')
          [CompletionResult]::new('-O<orderfile>', '-O<orderfile>', [CompletionResultType]::ParameterName, 'Process files in the order specified in the <orderfile>, which has one shell glob pattern per line')
        }
        break
      }
      'pack-refs' {
        if ($wordToComplete.StartsWith('-')) {
          [CompletionResult]::new('--all', '--all', [CompletionResultType]::ParameterName, 'The command by default packs all tags and refs that are already packed, and leaves other refs alone')
          [CompletionResult]::new('--no-prune', '--no-prune', [CompletionResultType]::ParameterName, 'The command usually removes loose refs under $GIT_DIR/refs hierarchy after packing them')
          [CompletionResult]::new('--auto', '--auto', [CompletionResultType]::ParameterName, 'Pack refs as needed depending on the current state of the ref database')
          [CompletionResult]::new('--include', '--include', [CompletionResultType]::ParameterName, 'Pack refs based on a glob(7) pattern')
          [CompletionResult]::new('--exclude', '--exclude', [CompletionResultType]::ParameterName, 'Do not pack refs matching the given glob(7) pattern')
        }
        break
      }
      'prune' {
        if ($wordToComplete.StartsWith('-')) {
          [CompletionResult]::new('-n', '-n', [CompletionResultType]::ParameterName, 'Do not remove anything; just report what it would remove')
          [CompletionResult]::new('--dry-run', '--dry-run', [CompletionResultType]::ParameterName, 'Do not remove anything; just report what it would remove')
          [CompletionResult]::new('-v', '-v', [CompletionResultType]::ParameterName, 'Report all removed objects')
          [CompletionResult]::new('--verbose', '--verbose', [CompletionResultType]::ParameterName, 'Report all removed objects')
          [CompletionResult]::new('--progress', '--progress', [CompletionResultType]::ParameterName, 'Show progress')
          [CompletionResult]::new('--expire', '--expire', [CompletionResultType]::ParameterName, 'Only expire loose objects older than <time>')
          [CompletionResult]::new('--', '--', [CompletionResultType]::ParameterName, 'Do not interpret any more arguments as options')
          [CompletionResult]::new('<head>…​', '<head>…​', [CompletionResultType]::ParameterName, 'In addition to objects reachable from any of our references, keep objects reachable from listed <head>s')
        }
        break
      }
      'reflog' {
        if ($wordToComplete.StartsWith('-')) {
          [CompletionResult]::new('--all', '--all', [CompletionResultType]::ParameterName, 'Process the reflogs of all references')
          [CompletionResult]::new('--single-worktree', '--single-worktree', [CompletionResultType]::ParameterName, 'By default when --all is specified, reflogs from all working trees are processed')
          [CompletionResult]::new('--expire=<time>', '--expire=<time>', [CompletionResultType]::ParameterName, 'Prune entries older than the specified time')
          [CompletionResult]::new('--expire-unreachable=<time>', '--expire-unreachable=<time>', [CompletionResultType]::ParameterName, 'Prune entries older than <time> that are not reachable from the current tip of the branch')
          [CompletionResult]::new('--updateref', '--updateref', [CompletionResultType]::ParameterName, 'Update the reference to the value of the top reflog entry (i')
          [CompletionResult]::new('--rewrite', '--rewrite', [CompletionResultType]::ParameterName, "If a reflog entry's predecessor is pruned, adjust its `"old`" SHA-1 to be equal to the `"new`" SHA-1 field of the entry that now precedes it")
          [CompletionResult]::new('--stale-fix', '--stale-fix', [CompletionResultType]::ParameterName, 'Prune any reflog entries that point to "broken commits"')
          [CompletionResult]::new('-n', '-n', [CompletionResultType]::ParameterName, 'Do not actually prune any entries; just show what would have been pruned')
          [CompletionResult]::new('--dry-run', '--dry-run', [CompletionResultType]::ParameterName, 'Do not actually prune any entries; just show what would have been pruned')
          [CompletionResult]::new('--verbose', '--verbose', [CompletionResultType]::ParameterName, 'Print extra information on screen')
        }
        break
      }
      'refs' {
        if ($wordToComplete.StartsWith('-')) {
          [CompletionResult]::new('--ref-format=<format>', '--ref-format=<format>', [CompletionResultType]::ParameterName, 'The ref format to migrate the ref store to')
          [CompletionResult]::new('--dry-run', '--dry-run', [CompletionResultType]::ParameterName, 'Perform the migration, but do not modify the repository')
        }
        elseif ($commandAst.CommandElements.Count -le 3) {
          [CompletionResult]::new('migrate', 'migrate', [CompletionResultType]::ParameterName, 'Migrate ref store between different formats')
          [CompletionResult]::new('verify', 'verify', [CompletionResultType]::ParameterName, 'Verify reference database consistency')
        }
        break
      }
      'remote' {
        if ($wordToComplete.StartsWith('-')) {
          [CompletionResult]::new('-v', '-v', [CompletionResultType]::ParameterName, 'Be a little more verbose and show remote url after name')
          [CompletionResult]::new('--verbose', '--verbose', [CompletionResultType]::ParameterName, 'Be a little more verbose and show remote url after name')
        }
        elseif ($commandAst.CommandElements.Count -le 3) {
          [CompletionResult]::new('add', 'add', [CompletionResultType]::ParameterName, 'Add a remote named <name> for the repository at <URL>')
          [CompletionResult]::new('rename', 'rename', [CompletionResultType]::ParameterName, 'Rename the remote named <old> to <new>')
          [CompletionResult]::new('remove', 'remove', [CompletionResultType]::ParameterName, 'Remove the remote named <name>')
          [CompletionResult]::new('rm', 'rm', [CompletionResultType]::ParameterName, 'Remove the remote named <name>')
          [CompletionResult]::new('set-head', 'set-head', [CompletionResultType]::ParameterName, 'Sets or deletes the default branch (i')
          [CompletionResult]::new('set-branches', 'set-branches', [CompletionResultType]::ParameterName, 'Changes the list of branches tracked by the named remote')
          [CompletionResult]::new('get-url', 'get-url', [CompletionResultType]::ParameterName, 'Retrieves the URLs for a remote')
          [CompletionResult]::new('set-url', 'set-url', [CompletionResultType]::ParameterName, 'Changes URLs for the remote')
          [CompletionResult]::new('show', 'show', [CompletionResultType]::ParameterName, 'Gives some information about the remote <name>')
          [CompletionResult]::new('prune', 'prune', [CompletionResultType]::ParameterName, 'Deletes stale references associated with <name>')
          [CompletionResult]::new('update', 'update', [CompletionResultType]::ParameterName, 'Fetch updates for remotes or remote groups in the repository as defined by remotes')
        }
        break
      }
      'repack' {
        if ($wordToComplete.StartsWith('-')) {
          [CompletionResult]::new('-a', '-a', [CompletionResultType]::ParameterName, 'Instead of incrementally packing the unpacked objects, pack everything referenced into a single pack')
          [CompletionResult]::new('-A', '-A', [CompletionResultType]::ParameterName, 'Same as -a, unless -d is used')
          [CompletionResult]::new('-d', '-d', [CompletionResultType]::ParameterName, 'After packing, if the newly created packs make some existing packs redundant, remove the redundant packs')
          [CompletionResult]::new('--cruft', '--cruft', [CompletionResultType]::ParameterName, 'Same as -a, unless -d is used')
          [CompletionResult]::new('--cruft-expiration=<approxidate>', '--cruft-expiration=<approxidate>', [CompletionResultType]::ParameterName, 'Expire unreachable objects older than <approxidate> immediately instead of waiting for the next git gc invocation')
          [CompletionResult]::new('--max-cruft-size=<n>', '--max-cruft-size=<n>', [CompletionResultType]::ParameterName, 'Repack cruft objects into packs as large as <n> bytes before creating new packs')
          [CompletionResult]::new('--expire-to=<dir>', '--expire-to=<dir>', [CompletionResultType]::ParameterName, 'Write a cruft pack containing pruned objects (if any) to the directory <dir>')
          [CompletionResult]::new('-l', '-l', [CompletionResultType]::ParameterName, 'Pass the --local option to git pack-objects')
          [CompletionResult]::new('-f', '-f', [CompletionResultType]::ParameterName, 'Pass the --no-reuse-delta option to git-pack-objects, see git-pack-objects(1)')
          [CompletionResult]::new('-F', '-F', [CompletionResultType]::ParameterName, 'Pass the --no-reuse-object option to git-pack-objects, see git-pack-objects(1)')
          [CompletionResult]::new('-q', '-q', [CompletionResultType]::ParameterName, 'Show no progress over the standard error stream and pass the -q option to git pack-objects')
          [CompletionResult]::new('--quiet', '--quiet', [CompletionResultType]::ParameterName, 'Show no progress over the standard error stream and pass the -q option to git pack-objects')
          [CompletionResult]::new('-n', '-n', [CompletionResultType]::ParameterName, 'Do not update the server information with git update-server-info')
          [CompletionResult]::new('--window=<n>', '--window=<n>', [CompletionResultType]::ParameterName, 'These two options affect how the objects contained in the pack are stored using delta compression')
          [CompletionResult]::new('--depth=<n>', '--depth=<n>', [CompletionResultType]::ParameterName, 'These two options affect how the objects contained in the pack are stored using delta compression')
          [CompletionResult]::new('--threads=<n>', '--threads=<n>', [CompletionResultType]::ParameterName, 'This option is passed through to git pack-objects')
          [CompletionResult]::new('--window-memory=<n>', '--window-memory=<n>', [CompletionResultType]::ParameterName, 'This option provides an additional limit on top of --window; the window size will dynamically scale down so as to not take up more than <n> bytes in memory')
          [CompletionResult]::new('--max-pack-size=<n>', '--max-pack-size=<n>', [CompletionResultType]::ParameterName, 'Maximum size of each output pack file')
          [CompletionResult]::new('--filter=<filter-spec>', '--filter=<filter-spec>', [CompletionResultType]::ParameterName, 'Remove objects matching the filter specification from the resulting packfile and put them into a separate packfile')
          [CompletionResult]::new('--filter-to=<dir>', '--filter-to=<dir>', [CompletionResultType]::ParameterName, 'Write the pack containing filtered out objects to the directory <dir>')
          [CompletionResult]::new('-b', '-b', [CompletionResultType]::ParameterName, 'Write a reachability bitmap index as part of the repack')
          [CompletionResult]::new('--write-bitmap-index', '--write-bitmap-index', [CompletionResultType]::ParameterName, 'Write a reachability bitmap index as part of the repack')
          [CompletionResult]::new('--pack-kept-objects', '--pack-kept-objects', [CompletionResultType]::ParameterName, 'Include objects in')
          [CompletionResult]::new('--keep-pack=<pack-name>', '--keep-pack=<pack-name>', [CompletionResultType]::ParameterName, 'Exclude the given pack from repacking')
          [CompletionResult]::new('--unpack-unreachable=<when>', '--unpack-unreachable=<when>', [CompletionResultType]::ParameterName, 'When loosening unreachable objects, do not bother loosening any objects older than <when>')
          [CompletionResult]::new('-k', '-k', [CompletionResultType]::ParameterName, 'When used with -ad, any unreachable objects from existing packs will be appended to the end of the packfile instead of being removed')
          [CompletionResult]::new('--keep-unreachable', '--keep-unreachable', [CompletionResultType]::ParameterName, 'When used with -ad, any unreachable objects from existing packs will be appended to the end of the packfile instead of being removed')
          [CompletionResult]::new('-i', '-i', [CompletionResultType]::ParameterName, 'Pass the --delta-islands option to git-pack-objects, see git-pack-objects(1)')
          [CompletionResult]::new('--delta-islands', '--delta-islands', [CompletionResultType]::ParameterName, 'Pass the --delta-islands option to git-pack-objects, see git-pack-objects(1)')
          [CompletionResult]::new('-g<factor>', '-g<factor>', [CompletionResultType]::ParameterName, 'Arrange resulting pack structure so that each successive pack contains at least <factor> times the number of objects as the next-largest pack')
          [CompletionResult]::new('--geometric=<factor>', '--geometric=<factor>', [CompletionResultType]::ParameterName, 'Arrange resulting pack structure so that each successive pack contains at least <factor> times the number of objects as the next-largest pack')
          [CompletionResult]::new('-m', '-m', [CompletionResultType]::ParameterName, 'Write a multi-pack index (see git-multi-pack-index(1)) containing the non-redundant packs')
          [CompletionResult]::new('--write-midx', '--write-midx', [CompletionResultType]::ParameterName, 'Write a multi-pack index (see git-multi-pack-index(1)) containing the non-redundant packs')
          [CompletionResult]::new('--path-walk', '--path-walk', [CompletionResultType]::ParameterName, 'This option passes the --path-walk option to the underlying git pack-options process (see git-pack-objects(1))')
        }
        break
      }
      'replace' {
        if ($wordToComplete.StartsWith('-')) {
          [CompletionResult]::new('-f', '-f', [CompletionResultType]::ParameterName, 'If an existing replace ref for the same object exists, it will be overwritten (instead of failing)')
          [CompletionResult]::new('--force', '--force', [CompletionResultType]::ParameterName, 'If an existing replace ref for the same object exists, it will be overwritten (instead of failing)')
          [CompletionResult]::new('-d', '-d', [CompletionResultType]::ParameterName, 'Delete existing replace refs for the given objects')
          [CompletionResult]::new('--delete', '--delete', [CompletionResultType]::ParameterName, 'Delete existing replace refs for the given objects')
          [CompletionResult]::new('--edit', '--edit', [CompletionResultType]::ParameterName, "Edit an object's content interactively")
          [CompletionResult]::new('--raw', '--raw', [CompletionResultType]::ParameterName, 'When editing, provide the raw object contents rather than pretty-printed ones')
          [CompletionResult]::new('--graft', '--graft', [CompletionResultType]::ParameterName, 'Create a graft commit')
          [CompletionResult]::new('--convert-graft-file', '--convert-graft-file', [CompletionResultType]::ParameterName, 'Creates graft commits for all entries in $GIT_DIR/info/grafts and deletes that file upon success')
          [CompletionResult]::new('-l', '-l', [CompletionResultType]::ParameterName, 'List replace refs for objects that match the given pattern (or all if no pattern is given)')
          [CompletionResult]::new('--list', '--list', [CompletionResultType]::ParameterName, 'List replace refs for objects that match the given pattern (or all if no pattern is given)')
          [CompletionResult]::new('--format=<format>', '--format=<format>', [CompletionResultType]::ParameterName, 'When listing, use the specified <format>, which can be one of short, medium and long')
        }
        break
      }
      'annotate' {
        if ($wordToComplete.StartsWith('-')) {
          [CompletionResult]::new('-b', '-b', [CompletionResultType]::ParameterName, 'Show blank SHA-1 for boundary commits')
          [CompletionResult]::new('--root', '--root', [CompletionResultType]::ParameterName, 'Do not treat root commits as boundaries')
          [CompletionResult]::new('--show-stats', '--show-stats', [CompletionResultType]::ParameterName, 'Include additional statistics at the end of blame output')
          [CompletionResult]::new('-L', '-L', [CompletionResultType]::ParameterName, 'Annotate only the line range given by <start>,<end>, or by the function name regex <funcname>')
          [CompletionResult]::new('-L', '-L', [CompletionResultType]::ParameterName, 'Annotate only the line range given by <start>,<end>, or by the function name regex <funcname>')
          [CompletionResult]::new('-l', '-l', [CompletionResultType]::ParameterName, 'Show long rev (Default: off)')
          [CompletionResult]::new('-t', '-t', [CompletionResultType]::ParameterName, 'Show raw timestamp (Default: off)')
          [CompletionResult]::new('-S', '-S', [CompletionResultType]::ParameterName, 'Use revisions from revs-file instead of calling git-rev-list(1)')
          [CompletionResult]::new('--reverse', '--reverse', [CompletionResultType]::ParameterName, 'Walk history forward instead of backward')
          [CompletionResult]::new('--first-parent', '--first-parent', [CompletionResultType]::ParameterName, 'Follow only the first parent commit upon seeing a merge commit')
          [CompletionResult]::new('-p', '-p', [CompletionResultType]::ParameterName, 'Show in a format designed for machine consumption')
          [CompletionResult]::new('--porcelain', '--porcelain', [CompletionResultType]::ParameterName, 'Show in a format designed for machine consumption')
          [CompletionResult]::new('--line-porcelain', '--line-porcelain', [CompletionResultType]::ParameterName, 'Show the porcelain format, but output commit information for each line, not just the first time a commit is referenced')
          [CompletionResult]::new('--incremental', '--incremental', [CompletionResultType]::ParameterName, 'Show the result incrementally in a format designed for machine consumption')
          [CompletionResult]::new('--encoding=<encoding>', '--encoding=<encoding>', [CompletionResultType]::ParameterName, 'Specifies the encoding used to output author names and commit summaries')
          [CompletionResult]::new('--contents', '--contents', [CompletionResultType]::ParameterName, 'Annotate using the contents from the named file, starting from <rev> if it is specified, and HEAD otherwise')
          [CompletionResult]::new('--date', '--date', [CompletionResultType]::ParameterName, 'Specifies the format used to output dates')
          [CompletionResult]::new('--[no-]progress', '--[no-]progress', [CompletionResultType]::ParameterName, 'Progress status is reported on the standard error stream by default when it is attached to a terminal')
          [CompletionResult]::new('-M[<num>]', '-M[<num>]', [CompletionResultType]::ParameterName, 'Detect moved or copied lines within a file')
          [CompletionResult]::new('-C[<num>]', '-C[<num>]', [CompletionResultType]::ParameterName, 'In addition to -M, detect lines moved or copied from other files that were modified in the same commit')
          [CompletionResult]::new('--ignore-rev', '--ignore-rev', [CompletionResultType]::ParameterName, 'Ignore changes made by the revision when assigning blame, as if the change never happened')
          [CompletionResult]::new('--ignore-revs-file', '--ignore-revs-file', [CompletionResultType]::ParameterName, 'Ignore revisions listed in file, which must be in the same format as an fsck')
          [CompletionResult]::new('--color-lines', '--color-lines', [CompletionResultType]::ParameterName, 'Color line annotations in the default format differently if they come from the same commit as the preceding line')
          [CompletionResult]::new('--color-by-age', '--color-by-age', [CompletionResultType]::ParameterName, 'Color line annotations depending on the age of the line in the default format')
          [CompletionResult]::new('-h', '-h', [CompletionResultType]::ParameterName, 'Show help message')
        }
        break
      }
      'blame' {
        if ($wordToComplete.StartsWith('-')) {
          [CompletionResult]::new('-b', '-b', [CompletionResultType]::ParameterName, 'Show blank SHA-1 for boundary commits')
          [CompletionResult]::new('--root', '--root', [CompletionResultType]::ParameterName, 'Do not treat root commits as boundaries')
          [CompletionResult]::new('--show-stats', '--show-stats', [CompletionResultType]::ParameterName, 'Include additional statistics at the end of blame output')
          [CompletionResult]::new('-L', '-L', [CompletionResultType]::ParameterName, 'Annotate only the line range given by <start>,<end>, or by the function name regex <funcname>')
          [CompletionResult]::new('-L', '-L', [CompletionResultType]::ParameterName, 'Annotate only the line range given by <start>,<end>, or by the function name regex <funcname>')
          [CompletionResult]::new('-l', '-l', [CompletionResultType]::ParameterName, 'Show long rev (Default: off)')
          [CompletionResult]::new('-t', '-t', [CompletionResultType]::ParameterName, 'Show raw timestamp (Default: off)')
          [CompletionResult]::new('-S', '-S', [CompletionResultType]::ParameterName, 'Use revisions from revs-file instead of calling git-rev-list(1)')
          [CompletionResult]::new('--reverse', '--reverse', [CompletionResultType]::ParameterName, 'Walk history forward instead of backward')
          [CompletionResult]::new('--first-parent', '--first-parent', [CompletionResultType]::ParameterName, 'Follow only the first parent commit upon seeing a merge commit')
          [CompletionResult]::new('-p', '-p', [CompletionResultType]::ParameterName, 'Show in a format designed for machine consumption')
          [CompletionResult]::new('--porcelain', '--porcelain', [CompletionResultType]::ParameterName, 'Show in a format designed for machine consumption')
          [CompletionResult]::new('--line-porcelain', '--line-porcelain', [CompletionResultType]::ParameterName, 'Show the porcelain format, but output commit information for each line, not just the first time a commit is referenced')
          [CompletionResult]::new('--incremental', '--incremental', [CompletionResultType]::ParameterName, 'Show the result incrementally in a format designed for machine consumption')
          [CompletionResult]::new('--encoding=<encoding>', '--encoding=<encoding>', [CompletionResultType]::ParameterName, 'Specifies the encoding used to output author names and commit summaries')
          [CompletionResult]::new('--contents', '--contents', [CompletionResultType]::ParameterName, 'Annotate using the contents from the named file, starting from <rev> if it is specified, and HEAD otherwise')
          [CompletionResult]::new('--date', '--date', [CompletionResultType]::ParameterName, 'Specifies the format used to output dates')
          [CompletionResult]::new('--[no-]progress', '--[no-]progress', [CompletionResultType]::ParameterName, 'Progress status is reported on the standard error stream by default when it is attached to a terminal')
          [CompletionResult]::new('-M[<num>]', '-M[<num>]', [CompletionResultType]::ParameterName, 'Detect moved or copied lines within a file')
          [CompletionResult]::new('-C[<num>]', '-C[<num>]', [CompletionResultType]::ParameterName, 'In addition to -M, detect lines moved or copied from other files that were modified in the same commit')
          [CompletionResult]::new('--ignore-rev', '--ignore-rev', [CompletionResultType]::ParameterName, 'Ignore changes made by the revision when assigning blame, as if the change never happened')
          [CompletionResult]::new('--ignore-revs-file', '--ignore-revs-file', [CompletionResultType]::ParameterName, 'Ignore revisions listed in file, which must be in the same format as an fsck')
          [CompletionResult]::new('--color-lines', '--color-lines', [CompletionResultType]::ParameterName, 'Color line annotations in the default format differently if they come from the same commit as the preceding line')
          [CompletionResult]::new('--color-by-age', '--color-by-age', [CompletionResultType]::ParameterName, 'Color line annotations depending on the age of the line in the default format')
          [CompletionResult]::new('-h', '-h', [CompletionResultType]::ParameterName, 'Show help message')
          [CompletionResult]::new('-c', '-c', [CompletionResultType]::ParameterName, 'Use the same output mode as git-annotate(1) (Default: off)')
          [CompletionResult]::new('--score-debug', '--score-debug', [CompletionResultType]::ParameterName, 'Include debugging information related to the movement of lines between files (see -C) and lines moved within a file (see -M)')
          [CompletionResult]::new('-f', '-f', [CompletionResultType]::ParameterName, 'Show the filename in the original commit')
          [CompletionResult]::new('--show-name', '--show-name', [CompletionResultType]::ParameterName, 'Show the filename in the original commit')
          [CompletionResult]::new('-n', '-n', [CompletionResultType]::ParameterName, 'Show the line number in the original commit (Default: off)')
          [CompletionResult]::new('--show-number', '--show-number', [CompletionResultType]::ParameterName, 'Show the line number in the original commit (Default: off)')
          [CompletionResult]::new('-s', '-s', [CompletionResultType]::ParameterName, 'Suppress the author name and timestamp from the output')
          [CompletionResult]::new('-e', '-e', [CompletionResultType]::ParameterName, 'Show the author email instead of the author name (Default: off)')
          [CompletionResult]::new('--show-email', '--show-email', [CompletionResultType]::ParameterName, 'Show the author email instead of the author name (Default: off)')
          [CompletionResult]::new('-w', '-w', [CompletionResultType]::ParameterName, "Ignore whitespace when comparing the parent's version and the child's to find where the lines came from")
          [CompletionResult]::new('--abbrev=<n>', '--abbrev=<n>', [CompletionResultType]::ParameterName, 'Instead of using the default 7+1 hexadecimal digits as the abbreviated object name, use <m>+1 digits, where <m> is at least <n> but ensures the commit object names are unique')
        }
        break
      }
      'bugreport' {
        if ($wordToComplete.StartsWith('-')) {
          [CompletionResult]::new('-o', '-o', [CompletionResultType]::ParameterName, 'Place the resulting bug report file in <path> instead of the current directory')
          [CompletionResult]::new('--output-directory', '--output-directory', [CompletionResultType]::ParameterName, 'Place the resulting bug report file in <path> instead of the current directory')
          [CompletionResult]::new('-s', '-s', [CompletionResultType]::ParameterName, 'Specify an alternate suffix for the bugreport name, to create a file named git-bugreport-<formatted-suffix>')
          [CompletionResult]::new('--suffix', '--suffix', [CompletionResultType]::ParameterName, 'Specify an alternate suffix for the bugreport name, to create a file named git-bugreport-<formatted-suffix>')
          [CompletionResult]::new('--no-suffix', '--no-suffix', [CompletionResultType]::ParameterName, 'Specify an alternate suffix for the bugreport name, to create a file named git-bugreport-<formatted-suffix>')
          [CompletionResult]::new('--no-diagnose', '--no-diagnose', [CompletionResultType]::ParameterName, "Create a zip archive of supplemental information about the user's machine, Git client, and repository state")
          [CompletionResult]::new('--diagnose[=<mode>]', '--diagnose[=<mode>]', [CompletionResultType]::ParameterName, "Create a zip archive of supplemental information about the user's machine, Git client, and repository state")
        }
        break
      }
      'count-objects' {
        if ($wordToComplete.StartsWith('-')) {
          [CompletionResult]::new('-v', '-v', [CompletionResultType]::ParameterName, 'Provide more detailed reports:  count: the number of loose objects   size: disk space consumed by loose objects, in KiB (unless -H is specified)   in-pack: the number of in-pack objects   size-pack: disk space consumed by the packs, in KiB (unless -H is specified)   prune-packable: the number of loose objects that are also present in the packs')
          [CompletionResult]::new('--verbose', '--verbose', [CompletionResultType]::ParameterName, 'Provide more detailed reports:  count: the number of loose objects   size: disk space consumed by loose objects, in KiB (unless -H is specified)   in-pack: the number of in-pack objects   size-pack: disk space consumed by the packs, in KiB (unless -H is specified)   prune-packable: the number of loose objects that are also present in the packs')
          [CompletionResult]::new('-H', '-H', [CompletionResultType]::ParameterName, 'Print sizes in human readable format')
          [CompletionResult]::new('--human-readable', '--human-readable', [CompletionResultType]::ParameterName, 'Print sizes in human readable format')
        }
        break
      }
      'diagnose' {
        if ($wordToComplete.StartsWith('-')) {
          [CompletionResult]::new('-o', '-o', [CompletionResultType]::ParameterName, 'Place the resulting diagnostics archive in <path> instead of the current directory')
          [CompletionResult]::new('--output-directory', '--output-directory', [CompletionResultType]::ParameterName, 'Place the resulting diagnostics archive in <path> instead of the current directory')
          [CompletionResult]::new('-s', '-s', [CompletionResultType]::ParameterName, 'Specify an alternate suffix for the diagnostics archive name, to create a file named git-diagnostics-<formatted-suffix>')
          [CompletionResult]::new('--suffix', '--suffix', [CompletionResultType]::ParameterName, 'Specify an alternate suffix for the diagnostics archive name, to create a file named git-diagnostics-<formatted-suffix>')
          [CompletionResult]::new('--mode=(stats|all)', '--mode=(stats|all)', [CompletionResultType]::ParameterName, 'Specify the type of diagnostics that should be collected')
        }
        break
      }
      'difftool' {
        if ($wordToComplete.StartsWith('-')) {
          [CompletionResult]::new('-d', '-d', [CompletionResultType]::ParameterName, 'Copy the modified files to a temporary location and perform a directory diff on them')
          [CompletionResult]::new('--dir-diff', '--dir-diff', [CompletionResultType]::ParameterName, 'Copy the modified files to a temporary location and perform a directory diff on them')
          [CompletionResult]::new('-y', '-y', [CompletionResultType]::ParameterName, 'Do not prompt before launching a diff tool')
          [CompletionResult]::new('--no-prompt', '--no-prompt', [CompletionResultType]::ParameterName, 'Do not prompt before launching a diff tool')
          [CompletionResult]::new('--prompt', '--prompt', [CompletionResultType]::ParameterName, 'Prompt before each invocation of the diff tool')
          [CompletionResult]::new('--rotate-to=<file>', '--rotate-to=<file>', [CompletionResultType]::ParameterName, 'Start showing the diff for the given path, the paths before it will move to the end and output')
          [CompletionResult]::new('--skip-to=<file>', '--skip-to=<file>', [CompletionResultType]::ParameterName, 'Start showing the diff for the given path, skipping all the paths before it')
          [CompletionResult]::new('-t', '-t', [CompletionResultType]::ParameterName, 'Use the diff tool specified by <tool>')
          [CompletionResult]::new('--tool=<tool>', '--tool=<tool>', [CompletionResultType]::ParameterName, 'Use the diff tool specified by <tool>')
          [CompletionResult]::new('--tool-help', '--tool-help', [CompletionResultType]::ParameterName, 'Print a list of diff tools that may be used with --tool')
          [CompletionResult]::new('--[no-]symlinks', '--[no-]symlinks', [CompletionResultType]::ParameterName, "git difftool's default behavior is to create symlinks to the working tree when run in --dir-diff mode and the right-hand side of the comparison yields the same content as the file in the working tree")
          [CompletionResult]::new('-x', '-x', [CompletionResultType]::ParameterName, 'Specify a custom command for viewing diffs')
          [CompletionResult]::new('--extcmd=<command>', '--extcmd=<command>', [CompletionResultType]::ParameterName, 'Specify a custom command for viewing diffs')
          [CompletionResult]::new('-g', '-g', [CompletionResultType]::ParameterName, 'When git-difftool is invoked with the -g or --gui option the default diff tool will be read from the configured diff')
          [CompletionResult]::new('--[no-]gui', '--[no-]gui', [CompletionResultType]::ParameterName, 'When git-difftool is invoked with the -g or --gui option the default diff tool will be read from the configured diff')
          [CompletionResult]::new('--[no-]trust-exit-code', '--[no-]trust-exit-code', [CompletionResultType]::ParameterName, 'Errors reported by the diff tool are ignored by default')
        }
        break
      }
      'fsck' {
        if ($wordToComplete.StartsWith('-')) {
          [CompletionResult]::new('<object>', '<object>', [CompletionResultType]::ParameterName, 'An object to treat as the head of an unreachability trace')
          [CompletionResult]::new('--unreachable', '--unreachable', [CompletionResultType]::ParameterName, "Print out objects that exist but that aren't reachable from any of the reference nodes")
          [CompletionResult]::new('--[no-]dangling', '--[no-]dangling', [CompletionResultType]::ParameterName, 'Print objects that exist but that are never directly used (default)')
          [CompletionResult]::new('--root', '--root', [CompletionResultType]::ParameterName, 'Report root nodes')
          [CompletionResult]::new('--tags', '--tags', [CompletionResultType]::ParameterName, 'Report tags')
          [CompletionResult]::new('--cache', '--cache', [CompletionResultType]::ParameterName, 'Consider any object recorded in the index also as a head node for an unreachability trace')
          [CompletionResult]::new('--no-reflogs', '--no-reflogs', [CompletionResultType]::ParameterName, 'Do not consider commits that are referenced only by an entry in a reflog to be reachable')
          [CompletionResult]::new('--full', '--full', [CompletionResultType]::ParameterName, 'Check not just objects in GIT_OBJECT_DIRECTORY ($GIT_DIR/objects), but also the ones found in alternate object pools listed in GIT_ALTERNATE_OBJECT_DIRECTORIES or $GIT_DIR/objects/info/alternates, and in packed Git archives found in $GIT_DIR/objects/pack and corresponding pack subdirectories in alternate object pools')
          [CompletionResult]::new('--connectivity-only', '--connectivity-only', [CompletionResultType]::ParameterName, 'Check only the connectivity of reachable objects, making sure that any objects referenced by a reachable tag, commit, or tree are present')
          [CompletionResult]::new('--strict', '--strict', [CompletionResultType]::ParameterName, 'Enable more strict checking, namely to catch a file mode recorded with g+w bit set, which was created by older versions of Git')
          [CompletionResult]::new('--verbose', '--verbose', [CompletionResultType]::ParameterName, 'Be chatty')
          [CompletionResult]::new('--lost-found', '--lost-found', [CompletionResultType]::ParameterName, 'Write dangling objects into')
          [CompletionResult]::new('--name-objects', '--name-objects', [CompletionResultType]::ParameterName, 'When displaying names of reachable objects, in addition to the SHA-1 also display a name that describes how they are reachable, compatible with git-rev-parse(1), e')
          [CompletionResult]::new('--[no-]progress', '--[no-]progress', [CompletionResultType]::ParameterName, 'Progress status is reported on the standard error stream by default when it is attached to a terminal, unless --no-progress or --verbose is specified')
        }
        break
      }
      'gitweb' { break }
      'help' {
        if ($wordToComplete.StartsWith('-')) {
          [CompletionResult]::new('-a', '-a', [CompletionResultType]::ParameterName, 'Print all the available commands on the standard output')
          [CompletionResult]::new('--all', '--all', [CompletionResultType]::ParameterName, 'Print all the available commands on the standard output')
          [CompletionResult]::new('--no-external-commands', '--no-external-commands', [CompletionResultType]::ParameterName, 'When used with --all, exclude the listing of external "git-*" commands found in the $PATH')
          [CompletionResult]::new('--no-aliases', '--no-aliases', [CompletionResultType]::ParameterName, 'When used with --all, exclude the listing of configured aliases')
          [CompletionResult]::new('--verbose', '--verbose', [CompletionResultType]::ParameterName, 'When used with --all, print description for all recognized commands')
          [CompletionResult]::new('-c', '-c', [CompletionResultType]::ParameterName, 'List all available configuration variables')
          [CompletionResult]::new('--config', '--config', [CompletionResultType]::ParameterName, 'List all available configuration variables')
          [CompletionResult]::new('-g', '-g', [CompletionResultType]::ParameterName, 'Print a list of the Git concept guides on the standard output')
          [CompletionResult]::new('--guides', '--guides', [CompletionResultType]::ParameterName, 'Print a list of the Git concept guides on the standard output')
          [CompletionResult]::new('--user-interfaces', '--user-interfaces', [CompletionResultType]::ParameterName, 'Print a list of the repository, command and file interfaces documentation on the standard output')
          [CompletionResult]::new('--developer-interfaces', '--developer-interfaces', [CompletionResultType]::ParameterName, 'Print a list of file formats, protocols and other developer interfaces documentation on the standard output')
          [CompletionResult]::new('-i', '-i', [CompletionResultType]::ParameterName, 'Display manual page for the command in the info format')
          [CompletionResult]::new('--info', '--info', [CompletionResultType]::ParameterName, 'Display manual page for the command in the info format')
          [CompletionResult]::new('-m', '-m', [CompletionResultType]::ParameterName, 'Display manual page for the command in the man format')
          [CompletionResult]::new('--man', '--man', [CompletionResultType]::ParameterName, 'Display manual page for the command in the man format')
          [CompletionResult]::new('-w', '-w', [CompletionResultType]::ParameterName, 'Display manual page for the command in the web (HTML) format')
          [CompletionResult]::new('--web', '--web', [CompletionResultType]::ParameterName, 'Display manual page for the command in the web (HTML) format')
        }
        break
      }
      'instaweb' {
        if ($wordToComplete.StartsWith('-')) {
          [CompletionResult]::new('-l', '-l', [CompletionResultType]::ParameterName, 'Only bind the web server to the local IP (127')
          [CompletionResult]::new('--local', '--local', [CompletionResultType]::ParameterName, 'Only bind the web server to the local IP (127')
          [CompletionResult]::new('-d', '-d', [CompletionResultType]::ParameterName, 'The HTTP daemon command-line that will be executed')
          [CompletionResult]::new('--httpd', '--httpd', [CompletionResultType]::ParameterName, 'The HTTP daemon command-line that will be executed')
          [CompletionResult]::new('-m', '-m', [CompletionResultType]::ParameterName, 'The module path (only needed if httpd is Apache)')
          [CompletionResult]::new('--module-path', '--module-path', [CompletionResultType]::ParameterName, 'The module path (only needed if httpd is Apache)')
          [CompletionResult]::new('-p', '-p', [CompletionResultType]::ParameterName, 'The port number to bind the httpd to')
          [CompletionResult]::new('--port', '--port', [CompletionResultType]::ParameterName, 'The port number to bind the httpd to')
          [CompletionResult]::new('-b', '-b', [CompletionResultType]::ParameterName, 'The web browser that should be used to view the gitweb page')
          [CompletionResult]::new('--browser', '--browser', [CompletionResultType]::ParameterName, 'The web browser that should be used to view the gitweb page')
          [CompletionResult]::new('start', 'start', [CompletionResultType]::ParameterName, 'Start the httpd instance and exit')
          [CompletionResult]::new('--start', '--start', [CompletionResultType]::ParameterName, 'Start the httpd instance and exit')
          [CompletionResult]::new('stop', 'stop', [CompletionResultType]::ParameterName, 'Stop the httpd instance and exit')
          [CompletionResult]::new('--stop', '--stop', [CompletionResultType]::ParameterName, 'Stop the httpd instance and exit')
          [CompletionResult]::new('restart', 'restart', [CompletionResultType]::ParameterName, 'Restart the httpd instance and exit')
          [CompletionResult]::new('--restart', '--restart', [CompletionResultType]::ParameterName, 'Restart the httpd instance and exit')
        }
        break
      }
      'merge-tree' {
        if ($wordToComplete.StartsWith('-')) {
          [CompletionResult]::new('-z', '-z', [CompletionResultType]::ParameterName, 'Do not quote filenames in the <Conflicted file info> section, and end each filename with a NUL character rather than newline')
          [CompletionResult]::new('--name-only', '--name-only', [CompletionResultType]::ParameterName, 'In the Conflicted file info section, instead of writing a list of (mode, oid, stage, path) tuples to output for conflicted files, just provide a list of filenames with conflicts (and do not list filenames multiple times if they have multiple conflicting stages)')
          [CompletionResult]::new('--[no-]messages', '--[no-]messages', [CompletionResultType]::ParameterName, 'Write any informational messages such as "Auto-merging <path>" or CONFLICT notices to the end of stdout')
          [CompletionResult]::new('--allow-unrelated-histories', '--allow-unrelated-histories', [CompletionResultType]::ParameterName, 'merge-tree will by default error out if the two branches specified share no common history')
          [CompletionResult]::new('--merge-base=<tree-ish>', '--merge-base=<tree-ish>', [CompletionResultType]::ParameterName, 'Instead of finding the merge-bases for <branch1> and <branch2>, specify a merge-base for the merge, and specifying multiple bases is currently not supported')
          [CompletionResult]::new('-X<option>', '-X<option>', [CompletionResultType]::ParameterName, 'Pass the merge strategy-specific option through to the merge strategy')
          [CompletionResult]::new('--strategy-option=<option>', '--strategy-option=<option>', [CompletionResultType]::ParameterName, 'Pass the merge strategy-specific option through to the merge strategy')
        }
        break
      }
      'rerere' {
        if ($commandAst.CommandElements.Count -le 3) {
          [CompletionResult]::new('clear', 'clear', [CompletionResultType]::ParameterName, 'Reset the metadata used by rerere if a merge resolution is to be aborted')
          [CompletionResult]::new('forget', 'forget', [CompletionResultType]::ParameterName, 'Reset the conflict resolutions which rerere has recorded for the current conflict in <pathspec>')
          [CompletionResult]::new('diff', 'diff', [CompletionResultType]::ParameterName, 'Display diffs for the current state of the resolution')
          [CompletionResult]::new('status', 'status', [CompletionResultType]::ParameterName, 'Print paths with conflicts whose merge resolution rerere will record')
          [CompletionResult]::new('remaining', 'remaining', [CompletionResultType]::ParameterName, 'Print paths with conflicts that have not been autoresolved by rerere')
          [CompletionResult]::new('gc', 'gc', [CompletionResultType]::ParameterName, 'Prune records of conflicted merges that occurred a long time ago')
        }
        break
      }
      'show-branch' {
        if ($wordToComplete.StartsWith('-')) {
          [CompletionResult]::new('<rev>', '<rev>', [CompletionResultType]::ParameterName, 'Arbitrary extended SHA-1 expression (see gitrevisions(7)) that typically names a branch head or a tag')
          [CompletionResult]::new('<glob>', '<glob>', [CompletionResultType]::ParameterName, 'A glob pattern that matches branch or tag names under refs/')
          [CompletionResult]::new('-r', '-r', [CompletionResultType]::ParameterName, 'Show the remote-tracking branches')
          [CompletionResult]::new('--remotes', '--remotes', [CompletionResultType]::ParameterName, 'Show the remote-tracking branches')
          [CompletionResult]::new('-a', '-a', [CompletionResultType]::ParameterName, 'Show both remote-tracking branches and local branches')
          [CompletionResult]::new('--all', '--all', [CompletionResultType]::ParameterName, 'Show both remote-tracking branches and local branches')
          [CompletionResult]::new('--current', '--current', [CompletionResultType]::ParameterName, 'With this option, the command includes the current branch in the list of revs to be shown when it is not given on the command line')
          [CompletionResult]::new('--topo-order', '--topo-order', [CompletionResultType]::ParameterName, 'By default, the branches and their commits are shown in reverse chronological order')
          [CompletionResult]::new('--date-order', '--date-order', [CompletionResultType]::ParameterName, 'This option is similar to --topo-order in the sense that no parent comes before all of its children, but otherwise commits are ordered according to their commit date')
          [CompletionResult]::new('--sparse', '--sparse', [CompletionResultType]::ParameterName, 'By default, the output omits merges that are reachable from only one tip being shown')
          [CompletionResult]::new('--more=<n>', '--more=<n>', [CompletionResultType]::ParameterName, 'Usually the command stops output upon showing the commit that is the common ancestor of all the branches')
          [CompletionResult]::new('--list', '--list', [CompletionResultType]::ParameterName, 'Synonym to --more=-1')
          [CompletionResult]::new('--merge-base', '--merge-base', [CompletionResultType]::ParameterName, 'Instead of showing the commit list, determine possible merge bases for the specified commits')
          [CompletionResult]::new('--independent', '--independent', [CompletionResultType]::ParameterName, 'Among the <ref>s given, display only the ones that cannot be reached from any other <ref>')
          [CompletionResult]::new('--no-name', '--no-name', [CompletionResultType]::ParameterName, 'Do not show naming strings for each commit')
          [CompletionResult]::new('--sha1-name', '--sha1-name', [CompletionResultType]::ParameterName, 'Instead of naming the commits using the path to reach them from heads (e')
          [CompletionResult]::new('--topics', '--topics', [CompletionResultType]::ParameterName, 'Shows only commits that are NOT on the first branch given')
          [CompletionResult]::new('-g', '-g', [CompletionResultType]::ParameterName, 'Shows <n> most recent ref-log entries for the given ref')
          [CompletionResult]::new('--reflog[=<n>[,<base>]]', '--reflog[=<n>[,<base>]]', [CompletionResultType]::ParameterName, 'Shows <n> most recent ref-log entries for the given ref')
          [CompletionResult]::new('--color[=<when>]', '--color[=<when>]', [CompletionResultType]::ParameterName, "Color the status sign (one of these: * ! + -) of each commit corresponding to the branch it's in")
          [CompletionResult]::new('--no-color', '--no-color', [CompletionResultType]::ParameterName, 'Turn off colored output, even when the configuration file gives the default to color output')
        }
        break
      }
      'verify-commit' {
        if ($wordToComplete.StartsWith('-')) {
          [CompletionResult]::new('--raw', '--raw', [CompletionResultType]::ParameterName, 'Print the raw gpg status output to standard error instead of the normal human-readable output')
          [CompletionResult]::new('-v', '-v', [CompletionResultType]::ParameterName, 'Print the contents of the commit object before validating it')
          [CompletionResult]::new('--verbose', '--verbose', [CompletionResultType]::ParameterName, 'Print the contents of the commit object before validating it')
          [CompletionResult]::new('<commit>…​', '<commit>…​', [CompletionResultType]::ParameterName, 'SHA-1 identifiers of Git commit objects')
        }
        break
      }
      'verify-tag' {
        if ($wordToComplete.StartsWith('-')) {
          [CompletionResult]::new('--raw', '--raw', [CompletionResultType]::ParameterName, 'Print the raw gpg status output to standard error instead of the normal human-readable output')
          [CompletionResult]::new('-v', '-v', [CompletionResultType]::ParameterName, 'Print the contents of the tag object before validating it')
          [CompletionResult]::new('--verbose', '--verbose', [CompletionResultType]::ParameterName, 'Print the contents of the tag object before validating it')
          [CompletionResult]::new('<tag>…​', '<tag>…​', [CompletionResultType]::ParameterName, 'SHA-1 identifiers of Git tag objects')
        }
        break
      }
      'version' {
        if ($wordToComplete.StartsWith('-')) {
          [CompletionResult]::new('--build-options', '--build-options', [CompletionResultType]::ParameterName, 'Include additional information about how git was built for diagnostic purposes')
        }
        break
      }
      'whatchanged' { break }
      'archimport' { break }
      'cvsexportcommit' { break }
      'cvsimport' { break }
      'cvsserver' { break }
      'imap-send' {
        if ($wordToComplete.StartsWith('-')) {
          [CompletionResult]::new('-v', '-v', [CompletionResultType]::ParameterName, 'Be verbose')
          [CompletionResult]::new('--verbose', '--verbose', [CompletionResultType]::ParameterName, 'Be verbose')
          [CompletionResult]::new('-q', '-q', [CompletionResultType]::ParameterName, 'Be quiet')
          [CompletionResult]::new('--quiet', '--quiet', [CompletionResultType]::ParameterName, 'Be quiet')
          [CompletionResult]::new('--curl', '--curl', [CompletionResultType]::ParameterName, 'Use libcurl to communicate with the IMAP server, unless tunneling into it')
          [CompletionResult]::new('--no-curl', '--no-curl', [CompletionResultType]::ParameterName, "Talk to the IMAP server using git's own IMAP routines instead of using libcurl")
        }
        break
      }
      'p4' {
        if ($wordToComplete.StartsWith('-')) {
          [CompletionResult]::new('--git-dir', '--git-dir', [CompletionResultType]::ParameterName, 'Set the GIT_DIR environment variable')
          [CompletionResult]::new('-v', '-v', [CompletionResultType]::ParameterName, 'Provide more progress information')
          [CompletionResult]::new('--verbose', '--verbose', [CompletionResultType]::ParameterName, 'Provide more progress information')
        }
        elseif ($commandAst.CommandElements.Count -le 3) {
        }
        break
      }
      'quiltimport' {
        if ($wordToComplete.StartsWith('-')) {
          [CompletionResult]::new('-n', '-n', [CompletionResultType]::ParameterName, 'Walk through the patches in the series and warn if we cannot find all of the necessary information to commit a patch')
          [CompletionResult]::new('--dry-run', '--dry-run', [CompletionResultType]::ParameterName, 'Walk through the patches in the series and warn if we cannot find all of the necessary information to commit a patch')
          [CompletionResult]::new('--author', '--author', [CompletionResultType]::ParameterName, 'The author name and email address to use when no author information can be found in the patch description')
          [CompletionResult]::new('--patches', '--patches', [CompletionResultType]::ParameterName, 'The directory to find the quilt patches')
          [CompletionResult]::new('--series', '--series', [CompletionResultType]::ParameterName, 'The quilt series file')
          [CompletionResult]::new('--keep-non-patch', '--keep-non-patch', [CompletionResultType]::ParameterName, 'Pass -b flag to git mailinfo (see git-mailinfo(1))')
        }
        break
      }
      'request-pull' {
        if ($wordToComplete.StartsWith('-')) {
          [CompletionResult]::new('-p', '-p', [CompletionResultType]::ParameterName, 'Include patch text in the output')
          [CompletionResult]::new('<start>', '<start>', [CompletionResultType]::ParameterName, 'Commit to start at')
          [CompletionResult]::new('<URL>', '<URL>', [CompletionResultType]::ParameterName, 'The repository URL to be pulled from')
          [CompletionResult]::new('<end>', '<end>', [CompletionResultType]::ParameterName, 'Commit to end at (defaults to HEAD)')
        }
        break
      }
      'send-email' {
        if ($wordToComplete.StartsWith('-')) {
          [CompletionResult]::new('--annotate', '--annotate', [CompletionResultType]::ParameterName, "Review and edit each patch you're about to send")
          [CompletionResult]::new('--bcc=<address>,…​', '--bcc=<address>,…​', [CompletionResultType]::ParameterName, 'Specify a "Bcc:" value for each email')
          [CompletionResult]::new('--cc=<address>,…​', '--cc=<address>,…​', [CompletionResultType]::ParameterName, 'Specify a starting "Cc:" value for each email')
          [CompletionResult]::new('--compose', '--compose', [CompletionResultType]::ParameterName, 'Invoke a text editor (see GIT_EDITOR in git-var(1)) to edit an introductory message for the patch series')
          [CompletionResult]::new('--from=<address>', '--from=<address>', [CompletionResultType]::ParameterName, 'Specify the sender of the emails')
          [CompletionResult]::new('--reply-to=<address>', '--reply-to=<address>', [CompletionResultType]::ParameterName, 'Specify the address where replies from recipients should go to')
          [CompletionResult]::new('--in-reply-to=<identifier>', '--in-reply-to=<identifier>', [CompletionResultType]::ParameterName, 'Make the first mail (or all the mails with --no-thread) appear as a reply to the given Message-ID, which avoids breaking threads to provide a new patch series')
          [CompletionResult]::new('--subject=<string>', '--subject=<string>', [CompletionResultType]::ParameterName, 'Specify the initial subject of the email thread')
          [CompletionResult]::new('--to=<address>,…​', '--to=<address>,…​', [CompletionResultType]::ParameterName, 'Specify the primary recipient of the emails generated')
          [CompletionResult]::new('--8bit-encoding=<encoding>', '--8bit-encoding=<encoding>', [CompletionResultType]::ParameterName, 'When encountering a non-ASCII message or subject that does not declare its encoding, add headers/quoting to indicate it is encoded in <encoding>')
          [CompletionResult]::new('--compose-encoding=<encoding>', '--compose-encoding=<encoding>', [CompletionResultType]::ParameterName, 'Specify encoding of compose message')
          [CompletionResult]::new('--transfer-encoding=(7bit|8bit|quoted-printable|base64|auto)', '--transfer-encoding=(7bit|8bit|quoted-printable|base64|auto)', [CompletionResultType]::ParameterName, 'Specify the transfer encoding to be used to send the message over SMTP')
          [CompletionResult]::new('--xmailer', '--xmailer', [CompletionResultType]::ParameterName, 'Add (or prevent adding) the "X-Mailer:" header')
          [CompletionResult]::new('--no-xmailer', '--no-xmailer', [CompletionResultType]::ParameterName, 'Add (or prevent adding) the "X-Mailer:" header')
        }
        break
      }
      'svn' {
        if ($wordToComplete.StartsWith('-')) {
          [CompletionResult]::new('--shared[=(false|true|umask|group|all|world|everybody)]', '--shared[=(false|true|umask|group|all|world|everybody)]', [CompletionResultType]::ParameterName, 'Only used with the init command')
          [CompletionResult]::new('--template=<template-directory>', '--template=<template-directory>', [CompletionResultType]::ParameterName, 'Only used with the init command')
          [CompletionResult]::new('-r', '-r', [CompletionResultType]::ParameterName, 'Used with the fetch command')
          [CompletionResult]::new('--revision', '--revision', [CompletionResultType]::ParameterName, 'Used with the fetch command')
          [CompletionResult]::new('-', '-', [CompletionResultType]::ParameterName, 'Only used with the set-tree command')
          [CompletionResult]::new('--stdin', '--stdin', [CompletionResultType]::ParameterName, 'Only used with the set-tree command')
          [CompletionResult]::new('--rmdir', '--rmdir', [CompletionResultType]::ParameterName, 'Only used with the dcommit, set-tree and commit-diff commands')
          [CompletionResult]::new('-e', '-e', [CompletionResultType]::ParameterName, 'Only used with the dcommit, set-tree and commit-diff commands')
          [CompletionResult]::new('--edit', '--edit', [CompletionResultType]::ParameterName, 'Only used with the dcommit, set-tree and commit-diff commands')
          [CompletionResult]::new('-l<num>', '-l<num>', [CompletionResultType]::ParameterName, 'Only used with the dcommit, set-tree and commit-diff commands')
          [CompletionResult]::new('--find-copies-harder', '--find-copies-harder', [CompletionResultType]::ParameterName, 'Only used with the dcommit, set-tree and commit-diff commands')
          [CompletionResult]::new('-A<filename>', '-A<filename>', [CompletionResultType]::ParameterName, 'Syntax is compatible with the file used by git cvsimport but an empty email address can be supplied with <>:           loginname = Joe User <user@example')
          [CompletionResult]::new('--authors-file=<filename>', '--authors-file=<filename>', [CompletionResultType]::ParameterName, 'Syntax is compatible with the file used by git cvsimport but an empty email address can be supplied with <>:           loginname = Joe User <user@example')
          [CompletionResult]::new('--authors-prog=<filename>', '--authors-prog=<filename>', [CompletionResultType]::ParameterName, 'If this option is specified, for each SVN committer name that does not exist in the authors file, the given file is executed with the committer name as the first argument')
          [CompletionResult]::new('-q', '-q', [CompletionResultType]::ParameterName, 'Make git svn less verbose')
          [CompletionResult]::new('--quiet', '--quiet', [CompletionResultType]::ParameterName, 'Make git svn less verbose')
          [CompletionResult]::new('-m', '-m', [CompletionResultType]::ParameterName, 'These are only used with the dcommit and rebase commands')
          [CompletionResult]::new('--merge', '--merge', [CompletionResultType]::ParameterName, 'These are only used with the dcommit and rebase commands')
          [CompletionResult]::new('-s<strategy>', '-s<strategy>', [CompletionResultType]::ParameterName, 'These are only used with the dcommit and rebase commands')
          [CompletionResult]::new('--strategy=<strategy>', '--strategy=<strategy>', [CompletionResultType]::ParameterName, 'These are only used with the dcommit and rebase commands')
          [CompletionResult]::new('-p', '-p', [CompletionResultType]::ParameterName, 'These are only used with the dcommit and rebase commands')
          [CompletionResult]::new('--rebase-merges', '--rebase-merges', [CompletionResultType]::ParameterName, 'These are only used with the dcommit and rebase commands')
          [CompletionResult]::new('-n', '-n', [CompletionResultType]::ParameterName, 'This can be used with the dcommit, rebase, branch and tag commands')
          [CompletionResult]::new('--dry-run', '--dry-run', [CompletionResultType]::ParameterName, 'This can be used with the dcommit, rebase, branch and tag commands')
          [CompletionResult]::new('--use-log-author', '--use-log-author', [CompletionResultType]::ParameterName, 'When retrieving svn commits into Git (as part of fetch, rebase, or dcommit operations), look for the first From: line or Signed-off-by trailer in the log message and use that as the author string')
          [CompletionResult]::new('--add-author-from', '--add-author-from', [CompletionResultType]::ParameterName, "When committing to svn from Git (as part of set-tree or dcommit operations), if the existing log message doesn't already have a From: or Signed-off-by trailer, append a From: line based on the Git commit's author string")
        }
        elseif ($commandAst.CommandElements.Count -le 3) {
          [CompletionResult]::new('init', 'init', [CompletionResultType]::ParameterName, 'Initializes an empty Git repository with additional metadata directories for git svn')
          [CompletionResult]::new('fetch', 'fetch', [CompletionResultType]::ParameterName, 'Fetch unfetched revisions from the Subversion remote we are tracking')
          [CompletionResult]::new('clone', 'clone', [CompletionResultType]::ParameterName, 'Runs init and fetch')
          [CompletionResult]::new('rebase', 'rebase', [CompletionResultType]::ParameterName, 'This fetches revisions from the SVN parent of the current HEAD and rebases the current (uncommitted to SVN) work against it')
          [CompletionResult]::new('dcommit', 'dcommit', [CompletionResultType]::ParameterName, 'Commit each diff from the current branch directly to the SVN repository, and then rebase or reset (depending on whether or not there is a diff between SVN and head)')
          [CompletionResult]::new('branch', 'branch', [CompletionResultType]::ParameterName, 'Create a branch in the SVN repository')
          [CompletionResult]::new('tag', 'tag', [CompletionResultType]::ParameterName, 'Create a tag in the SVN repository')
          [CompletionResult]::new('log', 'log', [CompletionResultType]::ParameterName, 'This should make it easy to look up svn log messages when svn users refer to -r/--revision numbers')
          [CompletionResult]::new('blame', 'blame', [CompletionResultType]::ParameterName, 'Show what revision and author last modified each line of a file')
          [CompletionResult]::new('find-rev', 'find-rev', [CompletionResultType]::ParameterName, 'When given an SVN revision number of the form rN, returns the corresponding Git commit hash (this can optionally be followed by a tree-ish to specify which branch should be searched)')
          [CompletionResult]::new('set-tree', 'set-tree', [CompletionResultType]::ParameterName, 'You should consider using dcommit instead of this command')
          [CompletionResult]::new('create-ignore', 'create-ignore', [CompletionResultType]::ParameterName, 'Recursively finds the svn:ignore and svn:global-ignores properties on directories and creates matching')
          [CompletionResult]::new('show-ignore', 'show-ignore', [CompletionResultType]::ParameterName, 'Recursively finds and lists the svn:ignore and svn:global-ignores properties on directories')
          [CompletionResult]::new('mkdirs', 'mkdirs', [CompletionResultType]::ParameterName, 'Attempts to recreate empty directories that core Git cannot track based on information in $GIT_DIR/svn/<refname>/unhandled')
          [CompletionResult]::new('commit-diff', 'commit-diff', [CompletionResultType]::ParameterName, 'Commits the diff of two tree-ish arguments from the command-line')
          [CompletionResult]::new('info', 'info', [CompletionResultType]::ParameterName, "Shows information about a file or directory similar to what 'svn info' provides")
          [CompletionResult]::new('proplist', 'proplist', [CompletionResultType]::ParameterName, 'Lists the properties stored in the Subversion repository about a given file or directory')
          [CompletionResult]::new('propget', 'propget', [CompletionResultType]::ParameterName, 'Gets the Subversion property given as the first argument, for a file')
          [CompletionResult]::new('propset', 'propset', [CompletionResultType]::ParameterName, 'Sets the Subversion property given as the first argument, to the value given as the second argument for the file given as the third argument')
          [CompletionResult]::new('show-externals', 'show-externals', [CompletionResultType]::ParameterName, 'Shows the Subversion externals')
          [CompletionResult]::new('gc', 'gc', [CompletionResultType]::ParameterName, 'Compress $GIT_DIR/svn/<refname>/unhandled')
          [CompletionResult]::new('reset', 'reset', [CompletionResultType]::ParameterName, 'Undoes the effects of fetch back to the specified revision')
        }
        break
      }
      'apply' {
        if ($wordToComplete.StartsWith('-')) {
          [CompletionResult]::new('<patch>…​', '<patch>…​', [CompletionResultType]::ParameterName, 'The files to read the patch from')
          [CompletionResult]::new('--stat', '--stat', [CompletionResultType]::ParameterName, 'Instead of applying the patch, output diffstat for the input')
          [CompletionResult]::new('--numstat', '--numstat', [CompletionResultType]::ParameterName, 'Similar to --stat, but shows the number of added and deleted lines in decimal notation and the pathname without abbreviation, to make it more machine friendly')
          [CompletionResult]::new('--summary', '--summary', [CompletionResultType]::ParameterName, 'Instead of applying the patch, output a condensed summary of information obtained from git diff extended headers, such as creations, renames, and mode changes')
          [CompletionResult]::new('--check', '--check', [CompletionResultType]::ParameterName, 'Instead of applying the patch, see if the patch is applicable to the current working tree and/or the index file and detects errors')
          [CompletionResult]::new('--index', '--index', [CompletionResultType]::ParameterName, 'Apply the patch to both the index and the working tree (or merely check that it would apply cleanly to both if --check is in effect)')
          [CompletionResult]::new('--cached', '--cached', [CompletionResultType]::ParameterName, 'Apply the patch to just the index, without touching the working tree')
          [CompletionResult]::new('--intent-to-add', '--intent-to-add', [CompletionResultType]::ParameterName, 'When applying the patch only to the working tree, mark new files to be added to the index later (see --intent-to-add option in git-add(1))')
          [CompletionResult]::new('-3', '-3', [CompletionResultType]::ParameterName, 'Attempt 3-way merge if the patch records the identity of blobs it is supposed to apply to and we have those blobs available locally, possibly leaving the conflict markers in the files in the working tree for the user to resolve')
          [CompletionResult]::new('--3way', '--3way', [CompletionResultType]::ParameterName, 'Attempt 3-way merge if the patch records the identity of blobs it is supposed to apply to and we have those blobs available locally, possibly leaving the conflict markers in the files in the working tree for the user to resolve')
          [CompletionResult]::new('--ours', '--ours', [CompletionResultType]::ParameterName, 'Instead of leaving conflicts in the file, resolve conflicts favouring our (or their or both) side of the lines')
          [CompletionResult]::new('--theirs', '--theirs', [CompletionResultType]::ParameterName, 'Instead of leaving conflicts in the file, resolve conflicts favouring our (or their or both) side of the lines')
          [CompletionResult]::new('--union', '--union', [CompletionResultType]::ParameterName, 'Instead of leaving conflicts in the file, resolve conflicts favouring our (or their or both) side of the lines')
          [CompletionResult]::new('--build-fake-ancestor=<file>', '--build-fake-ancestor=<file>', [CompletionResultType]::ParameterName, 'Newer git diff output has embedded index information for each blob to help identify the original version that the patch applies to')
          [CompletionResult]::new('-R', '-R', [CompletionResultType]::ParameterName, 'Apply the patch in reverse')
          [CompletionResult]::new('--reverse', '--reverse', [CompletionResultType]::ParameterName, 'Apply the patch in reverse')
          [CompletionResult]::new('--reject', '--reject', [CompletionResultType]::ParameterName, 'For atomicity, git apply by default fails the whole patch and does not touch the working tree when some of the hunks do not apply')
          [CompletionResult]::new('-z', '-z', [CompletionResultType]::ParameterName, 'When --numstat has been given, do not munge pathnames, but use a NUL-terminated machine-readable format')
          [CompletionResult]::new('-p<n>', '-p<n>', [CompletionResultType]::ParameterName, 'Remove <n> leading path components (separated by slashes) from traditional diff paths')
          [CompletionResult]::new('-C<n>', '-C<n>', [CompletionResultType]::ParameterName, 'Ensure at least <n> lines of surrounding context match before and after each change')
          [CompletionResult]::new('--unidiff-zero', '--unidiff-zero', [CompletionResultType]::ParameterName, 'By default, git apply expects that the patch being applied is a unified diff with at least one line of context')
          [CompletionResult]::new('--apply', '--apply', [CompletionResultType]::ParameterName, 'If you use any of the options marked "Turns off apply" above, git apply reads and outputs the requested information without actually applying the patch')
          [CompletionResult]::new('--no-add', '--no-add', [CompletionResultType]::ParameterName, 'When applying a patch, ignore additions made by the patch')
          [CompletionResult]::new('--allow-binary-replacement', '--allow-binary-replacement', [CompletionResultType]::ParameterName, 'Historically we did not allow binary patch application without an explicit permission from the user, and this flag was the way to do so')
          [CompletionResult]::new('--binary', '--binary', [CompletionResultType]::ParameterName, 'Historically we did not allow binary patch application without an explicit permission from the user, and this flag was the way to do so')
          [CompletionResult]::new('--exclude=<path-pattern>', '--exclude=<path-pattern>', [CompletionResultType]::ParameterName, "Don't apply changes to files matching the given path pattern")
          [CompletionResult]::new('--include=<path-pattern>', '--include=<path-pattern>', [CompletionResultType]::ParameterName, 'Apply changes to files matching the given path pattern')
          [CompletionResult]::new('--ignore-space-change', '--ignore-space-change', [CompletionResultType]::ParameterName, 'When applying a patch, ignore changes in whitespace in context lines if necessary')
          [CompletionResult]::new('--ignore-whitespace', '--ignore-whitespace', [CompletionResultType]::ParameterName, 'When applying a patch, ignore changes in whitespace in context lines if necessary')
          [CompletionResult]::new('--whitespace=<action>', '--whitespace=<action>', [CompletionResultType]::ParameterName, 'When applying a patch, detect a new or modified line that has whitespace errors')
          [CompletionResult]::new('--inaccurate-eof', '--inaccurate-eof', [CompletionResultType]::ParameterName, 'Under certain circumstances, some versions of diff do not correctly detect a missing new-line at the end of the file')
          [CompletionResult]::new('-v', '-v', [CompletionResultType]::ParameterName, 'Report progress to stderr')
          [CompletionResult]::new('--verbose', '--verbose', [CompletionResultType]::ParameterName, 'Report progress to stderr')
          [CompletionResult]::new('-q', '-q', [CompletionResultType]::ParameterName, 'Suppress stderr output')
          [CompletionResult]::new('--quiet', '--quiet', [CompletionResultType]::ParameterName, 'Suppress stderr output')
          [CompletionResult]::new('--recount', '--recount', [CompletionResultType]::ParameterName, 'Do not trust the line counts in the hunk headers, but infer them by inspecting the patch (e')
          [CompletionResult]::new('--directory=<root>', '--directory=<root>', [CompletionResultType]::ParameterName, 'Prepend <root> to all filenames')
          [CompletionResult]::new('--unsafe-paths', '--unsafe-paths', [CompletionResultType]::ParameterName, 'By default, a patch that affects outside the working area (either a Git controlled working tree, or the current working directory when "git apply" is used as a replacement of GNU patch) is rejected as a mistake (or a mischief)')
          [CompletionResult]::new('--allow-empty', '--allow-empty', [CompletionResultType]::ParameterName, "Don't return an error for patches containing no diff")
        }
        break
      }
      'checkout-index' {
        if ($wordToComplete.StartsWith('-')) {
          [CompletionResult]::new('-u', '-u', [CompletionResultType]::ParameterName, 'update stat information for the checked out entries in the index file')
          [CompletionResult]::new('--index', '--index', [CompletionResultType]::ParameterName, 'update stat information for the checked out entries in the index file')
          [CompletionResult]::new('-q', '-q', [CompletionResultType]::ParameterName, 'be quiet if files exist or are not in the index')
          [CompletionResult]::new('--quiet', '--quiet', [CompletionResultType]::ParameterName, 'be quiet if files exist or are not in the index')
          [CompletionResult]::new('-f', '-f', [CompletionResultType]::ParameterName, 'forces overwrite of existing files')
          [CompletionResult]::new('--force', '--force', [CompletionResultType]::ParameterName, 'forces overwrite of existing files')
          [CompletionResult]::new('-a', '-a', [CompletionResultType]::ParameterName, 'checks out all files in the index except for those with the skip-worktree bit set (see --ignore-skip-worktree-bits)')
          [CompletionResult]::new('--all', '--all', [CompletionResultType]::ParameterName, 'checks out all files in the index except for those with the skip-worktree bit set (see --ignore-skip-worktree-bits)')
          [CompletionResult]::new('-n', '-n', [CompletionResultType]::ParameterName, "Don't checkout new files, only refresh files already checked out")
          [CompletionResult]::new('--no-create', '--no-create', [CompletionResultType]::ParameterName, "Don't checkout new files, only refresh files already checked out")
          [CompletionResult]::new('--prefix=<string>', '--prefix=<string>', [CompletionResultType]::ParameterName, 'When creating files, prepend <string> (usually a directory including a trailing /)')
          [CompletionResult]::new('--stage=<number>|all', '--stage=<number>|all', [CompletionResultType]::ParameterName, 'Instead of checking out unmerged entries, copy out the files from the named stage')
          [CompletionResult]::new('--temp', '--temp', [CompletionResultType]::ParameterName, 'Instead of copying the files to the working directory, write the content to temporary files')
          [CompletionResult]::new('--ignore-skip-worktree-bits', '--ignore-skip-worktree-bits', [CompletionResultType]::ParameterName, 'Check out all files, including those with the skip-worktree bit set')
          [CompletionResult]::new('--stdin', '--stdin', [CompletionResultType]::ParameterName, 'Instead of taking a list of paths from the command line, read the list of paths from the standard input')
          [CompletionResult]::new('-z', '-z', [CompletionResultType]::ParameterName, 'Only meaningful with --stdin; paths are separated with NUL character instead of LF')
          [CompletionResult]::new('--', '--', [CompletionResultType]::ParameterName, 'Do not interpret any more arguments as options')
        }
        break
      }
      'commit-graph' {
        if ($wordToComplete.StartsWith('-')) {
          [CompletionResult]::new('--object-dir', '--object-dir', [CompletionResultType]::ParameterName, 'Use given directory for the location of packfiles and commit-graph file')
          [CompletionResult]::new('--[no-]progress', '--[no-]progress', [CompletionResultType]::ParameterName, 'Turn progress on/off explicitly')
        }
        break
      }
      'commit-tree' {
        if ($wordToComplete.StartsWith('-')) {
          [CompletionResult]::new('<tree>', '<tree>', [CompletionResultType]::ParameterName, 'An existing tree object')
          [CompletionResult]::new('-p', '-p', [CompletionResultType]::ParameterName, 'Each -p indicates the id of a parent commit object')
          [CompletionResult]::new('-m', '-m', [CompletionResultType]::ParameterName, 'A paragraph in the commit log message')
          [CompletionResult]::new('-F', '-F', [CompletionResultType]::ParameterName, 'Read the commit log message from the given file')
          [CompletionResult]::new('-S[<keyid>]', '-S[<keyid>]', [CompletionResultType]::ParameterName, 'GPG-sign commits')
          [CompletionResult]::new('--gpg-sign[=<keyid>]', '--gpg-sign[=<keyid>]', [CompletionResultType]::ParameterName, 'GPG-sign commits')
          [CompletionResult]::new('--no-gpg-sign', '--no-gpg-sign', [CompletionResultType]::ParameterName, 'GPG-sign commits')
        }
        break
      }
      'hash-object' {
        if ($wordToComplete.StartsWith('-')) {
          [CompletionResult]::new('-t', '-t', [CompletionResultType]::ParameterName, 'Specify the type of object to be created (default: "blob")')
          [CompletionResult]::new('-w', '-w', [CompletionResultType]::ParameterName, 'Actually write the object into the object database')
          [CompletionResult]::new('--stdin', '--stdin', [CompletionResultType]::ParameterName, 'Read the object from standard input instead of from a file')
          [CompletionResult]::new('--stdin-paths', '--stdin-paths', [CompletionResultType]::ParameterName, 'Read file names from the standard input, one per line, instead of from the command-line')
          [CompletionResult]::new('--path', '--path', [CompletionResultType]::ParameterName, 'Hash object as if it were located at the given path')
          [CompletionResult]::new('--no-filters', '--no-filters', [CompletionResultType]::ParameterName, 'Hash the contents as is, ignoring any input filter that would have been chosen by the attributes mechanism, including the end-of-line conversion')
          [CompletionResult]::new('--literally', '--literally', [CompletionResultType]::ParameterName, 'Allow --stdin to hash any garbage into a loose object which might not otherwise pass standard object parsing or git-fsck checks')
        }
        break
      }
      'index-pack' {
        if ($wordToComplete.StartsWith('-')) {
          [CompletionResult]::new('-v', '-v', [CompletionResultType]::ParameterName, 'Be verbose about what is going on, including progress status')
          [CompletionResult]::new('-o', '-o', [CompletionResultType]::ParameterName, 'Write the generated pack index into the specified file')
          [CompletionResult]::new('--[no-]rev-index', '--[no-]rev-index', [CompletionResultType]::ParameterName, 'When this flag is provided, generate a reverse index (a')
          [CompletionResult]::new('--stdin', '--stdin', [CompletionResultType]::ParameterName, 'When this flag is provided, the pack is read from stdin instead and a copy is then written to <pack-file>')
          [CompletionResult]::new('--fix-thin', '--fix-thin', [CompletionResultType]::ParameterName, 'Fix a "thin" pack produced by git pack-objects --thin (see git-pack-objects(1) for details) by adding the excluded objects the deltified objects are based on to the pack')
          [CompletionResult]::new('--keep', '--keep', [CompletionResultType]::ParameterName, 'Before moving the index into its final destination create an empty')
          [CompletionResult]::new('--keep=<msg>', '--keep=<msg>', [CompletionResultType]::ParameterName, 'Like --keep, create a')
          [CompletionResult]::new('--index-version=<version>[,<offset>]', '--index-version=<version>[,<offset>]', [CompletionResultType]::ParameterName, 'This is intended to be used by the test suite only')
          [CompletionResult]::new('--strict[=<msg-id>=<severity>…​]', '--strict[=<msg-id>=<severity>…​]', [CompletionResultType]::ParameterName, 'Die, if the pack contains broken objects or links')
          [CompletionResult]::new('--progress-title', '--progress-title', [CompletionResultType]::ParameterName, 'For internal use only')
          [CompletionResult]::new('--check-self-contained-and-connected', '--check-self-contained-and-connected', [CompletionResultType]::ParameterName, 'Die if the pack contains broken links')
          [CompletionResult]::new('--fsck-objects[=<msg-id>=<severity>…​]', '--fsck-objects[=<msg-id>=<severity>…​]', [CompletionResultType]::ParameterName, "Die if the pack contains broken objects, but unlike --strict, don't choke on broken links")
          [CompletionResult]::new('--threads=<n>', '--threads=<n>', [CompletionResultType]::ParameterName, 'Specifies the number of threads to spawn when resolving deltas')
          [CompletionResult]::new('--max-input-size=<size>', '--max-input-size=<size>', [CompletionResultType]::ParameterName, 'Die, if the pack is larger than <size>')
          [CompletionResult]::new('--object-format=<hash-algorithm>', '--object-format=<hash-algorithm>', [CompletionResultType]::ParameterName, 'Specify the given object format (hash algorithm) for the pack')
        }
        break
      }
      'merge-file' {
        if ($wordToComplete.StartsWith('-')) {
          [CompletionResult]::new('--object-id', '--object-id', [CompletionResultType]::ParameterName, 'Specify the contents to merge as blobs in the current repository instead of files')
          [CompletionResult]::new('-L', '-L', [CompletionResultType]::ParameterName, 'This option may be given up to three times, and specifies labels to be used in place of the corresponding file names in conflict reports')
          [CompletionResult]::new('-p', '-p', [CompletionResultType]::ParameterName, 'Send results to standard output instead of overwriting <current>')
          [CompletionResult]::new('-q', '-q', [CompletionResultType]::ParameterName, 'Quiet; do not warn about conflicts')
          [CompletionResult]::new('--diff3', '--diff3', [CompletionResultType]::ParameterName, 'Show conflicts in "diff3" style')
          [CompletionResult]::new('--zdiff3', '--zdiff3', [CompletionResultType]::ParameterName, 'Show conflicts in "zdiff3" style')
          [CompletionResult]::new('--ours', '--ours', [CompletionResultType]::ParameterName, 'Instead of leaving conflicts in the file, resolve conflicts favouring our (or their or both) side of the lines')
          [CompletionResult]::new('--theirs', '--theirs', [CompletionResultType]::ParameterName, 'Instead of leaving conflicts in the file, resolve conflicts favouring our (or their or both) side of the lines')
          [CompletionResult]::new('--union', '--union', [CompletionResultType]::ParameterName, 'Instead of leaving conflicts in the file, resolve conflicts favouring our (or their or both) side of the lines')
          [CompletionResult]::new('--diff-algorithm={patience|minimal|histogram|myers}', '--diff-algorithm={patience|minimal|histogram|myers}', [CompletionResultType]::ParameterName, 'Use a different diff algorithm while merging')
        }
        break
      }
      'merge-index' {
        if ($wordToComplete.StartsWith('-')) {
          [CompletionResult]::new('--', '--', [CompletionResultType]::ParameterName, 'Do not interpret any more arguments as options')
          [CompletionResult]::new('-a', '-a', [CompletionResultType]::ParameterName, 'Run merge against all files in the index that need merging')
          [CompletionResult]::new('-o', '-o', [CompletionResultType]::ParameterName, 'Instead of stopping at the first failed merge, do all of them in one shot - continue with merging even when previous merges returned errors, and only return the error code after all the merges')
          [CompletionResult]::new('-q', '-q', [CompletionResultType]::ParameterName, 'Do not complain about a failed merge program (a merge program failure usually indicates conflicts during the merge)')
        }
        break
      }
      'mktag' {
        if ($wordToComplete.StartsWith('-')) {
          [CompletionResult]::new('--strict', '--strict', [CompletionResultType]::ParameterName, 'By default mktag turns on the equivalent of git-fsck(1) --strict mode')
        }
        break
      }
      'mktree' {
        if ($wordToComplete.StartsWith('-')) {
          [CompletionResult]::new('-z', '-z', [CompletionResultType]::ParameterName, 'Read the NUL-terminated ls-tree -z output instead')
          [CompletionResult]::new('--missing', '--missing', [CompletionResultType]::ParameterName, 'Allow missing objects')
          [CompletionResult]::new('--batch', '--batch', [CompletionResultType]::ParameterName, 'Allow building of more than one tree object before exiting')
        }
        break
      }
      'multi-pack-index' {
        if ($wordToComplete.StartsWith('-')) {
          [CompletionResult]::new('--object-dir=<dir>', '--object-dir=<dir>', [CompletionResultType]::ParameterName, 'Use given directory for the location of Git objects')
          [CompletionResult]::new('--[no-]progress', '--[no-]progress', [CompletionResultType]::ParameterName, 'Turn progress on/off explicitly')
        }
        break
      }
      'pack-objects' {
        if ($wordToComplete.StartsWith('-')) {
          [CompletionResult]::new('base-name', 'base-name', [CompletionResultType]::ParameterName, 'Write into pairs of files (')
          [CompletionResult]::new('--stdout', '--stdout', [CompletionResultType]::ParameterName, 'Write the pack contents (what would have been written to')
          [CompletionResult]::new('--revs', '--revs', [CompletionResultType]::ParameterName, 'Read the revision arguments from the standard input, instead of individual object names')
          [CompletionResult]::new('--unpacked', '--unpacked', [CompletionResultType]::ParameterName, 'This implies --revs')
          [CompletionResult]::new('--all', '--all', [CompletionResultType]::ParameterName, 'This implies --revs')
          [CompletionResult]::new('--include-tag', '--include-tag', [CompletionResultType]::ParameterName, 'Include unasked-for annotated tags if the object they reference was included in the resulting packfile')
          [CompletionResult]::new('--stdin-packs', '--stdin-packs', [CompletionResultType]::ParameterName, 'Read the basenames of packfiles (e')
          [CompletionResult]::new('--cruft', '--cruft', [CompletionResultType]::ParameterName, 'Packs unreachable objects into a separate "cruft" pack, denoted by the existence of a')
          [CompletionResult]::new('--cruft-expiration=<approxidate>', '--cruft-expiration=<approxidate>', [CompletionResultType]::ParameterName, 'If specified, objects are eliminated from the cruft pack if they have an mtime older than <approxidate>')
          [CompletionResult]::new('--window=<n>', '--window=<n>', [CompletionResultType]::ParameterName, 'These two options affect how the objects contained in the pack are stored using delta compression')
          [CompletionResult]::new('--depth=<n>', '--depth=<n>', [CompletionResultType]::ParameterName, 'These two options affect how the objects contained in the pack are stored using delta compression')
          [CompletionResult]::new('--window-memory=<n>', '--window-memory=<n>', [CompletionResultType]::ParameterName, 'This option provides an additional limit on top of --window; the window size will dynamically scale down so as to not take up more than <n> bytes in memory')
          [CompletionResult]::new('--max-pack-size=<n>', '--max-pack-size=<n>', [CompletionResultType]::ParameterName, 'In unusual scenarios, you may not be able to create files larger than a certain size on your filesystem, and this option can be used to tell the command to split the output packfile into multiple independent packfiles, each not larger than the given size')
          [CompletionResult]::new('--honor-pack-keep', '--honor-pack-keep', [CompletionResultType]::ParameterName, 'This flag causes an object already in a local pack that has a')
          [CompletionResult]::new('--keep-pack=<pack-name>', '--keep-pack=<pack-name>', [CompletionResultType]::ParameterName, 'This flag causes an object already in the given pack to be ignored, even if it would have otherwise been packed')
          [CompletionResult]::new('--incremental', '--incremental', [CompletionResultType]::ParameterName, 'This flag causes an object already in a pack to be ignored even if it would have otherwise been packed')
          [CompletionResult]::new('--local', '--local', [CompletionResultType]::ParameterName, 'This flag causes an object that is borrowed from an alternate object store to be ignored even if it would have otherwise been packed')
          [CompletionResult]::new('--non-empty', '--non-empty', [CompletionResultType]::ParameterName, 'Only create a packed archive if it would contain at least one object')
          [CompletionResult]::new('--progress', '--progress', [CompletionResultType]::ParameterName, 'Progress status is reported on the standard error stream by default when it is attached to a terminal, unless -q is specified')
          [CompletionResult]::new('--all-progress', '--all-progress', [CompletionResultType]::ParameterName, 'When --stdout is specified then progress report is displayed during the object count and compression phases but inhibited during the write-out phase')
          [CompletionResult]::new('--all-progress-implied', '--all-progress-implied', [CompletionResultType]::ParameterName, 'This is used to imply --all-progress whenever progress display is activated')
          [CompletionResult]::new('-q', '-q', [CompletionResultType]::ParameterName, 'This flag makes the command not to report its progress on the standard error stream')
          [CompletionResult]::new('--no-reuse-delta', '--no-reuse-delta', [CompletionResultType]::ParameterName, 'When creating a packed archive in a repository that has existing packs, the command reuses existing deltas')
          [CompletionResult]::new('--no-reuse-object', '--no-reuse-object', [CompletionResultType]::ParameterName, 'This flag tells the command not to reuse existing object data at all, including non deltified object, forcing recompression of everything')
          [CompletionResult]::new('--compression=<n>', '--compression=<n>', [CompletionResultType]::ParameterName, 'Specifies compression level for newly-compressed data in the generated pack')
          [CompletionResult]::new('--[no-]sparse', '--[no-]sparse', [CompletionResultType]::ParameterName, 'Toggle the "sparse" algorithm to determine which objects to include in the pack, when combined with the "--revs" option')
          [CompletionResult]::new('--thin', '--thin', [CompletionResultType]::ParameterName, 'Create a "thin" pack by omitting the common objects between a sender and a receiver in order to reduce network transfer')
          [CompletionResult]::new('--shallow', '--shallow', [CompletionResultType]::ParameterName, 'Optimize a pack that will be provided to a client with a shallow repository')
          [CompletionResult]::new('--delta-base-offset', '--delta-base-offset', [CompletionResultType]::ParameterName, "A packed archive can express the base object of a delta as either a 20-byte object name or as an offset in the stream, but ancient versions of Git don't understand the latter")
          [CompletionResult]::new('--threads=<n>', '--threads=<n>', [CompletionResultType]::ParameterName, 'Specifies the number of threads to spawn when searching for best delta matches')
          [CompletionResult]::new('--index-version=<version>[,<offset>]', '--index-version=<version>[,<offset>]', [CompletionResultType]::ParameterName, 'This is intended to be used by the test suite only')
          [CompletionResult]::new('--keep-true-parents', '--keep-true-parents', [CompletionResultType]::ParameterName, 'With this option, parents that are hidden by grafts are packed nevertheless')
          [CompletionResult]::new('--filter=<filter-spec>', '--filter=<filter-spec>', [CompletionResultType]::ParameterName, 'Omits certain objects (usually blobs) from the resulting packfile')
          [CompletionResult]::new('--no-filter', '--no-filter', [CompletionResultType]::ParameterName, 'Turns off any previous --filter= argument')
          [CompletionResult]::new('--missing=<missing-action>', '--missing=<missing-action>', [CompletionResultType]::ParameterName, 'A debug option to help with future "partial clone" development')
          [CompletionResult]::new('--exclude-promisor-objects', '--exclude-promisor-objects', [CompletionResultType]::ParameterName, 'Omit objects that are known to be in the promisor remote')
          [CompletionResult]::new('--keep-unreachable', '--keep-unreachable', [CompletionResultType]::ParameterName, 'Objects unreachable from the refs in packs named with --unpacked= option are added to the resulting pack, in addition to the reachable objects that are not in packs marked with *')
          [CompletionResult]::new('--pack-loose-unreachable', '--pack-loose-unreachable', [CompletionResultType]::ParameterName, 'Pack unreachable loose objects (and their loose counterparts removed)')
          [CompletionResult]::new('--unpack-unreachable', '--unpack-unreachable', [CompletionResultType]::ParameterName, 'Keep unreachable objects in loose form')
          [CompletionResult]::new('--delta-islands', '--delta-islands', [CompletionResultType]::ParameterName, 'Restrict delta matches based on "islands"')
          [CompletionResult]::new('--path-walk', '--path-walk', [CompletionResultType]::ParameterName, "By default, git pack-objects walks objects in an order that presents trees and blobs in an order unrelated to the path they appear relative to a commit's root tree")
        }
        break
      }
      'prune-packed' {
        if ($wordToComplete.StartsWith('-')) {
          [CompletionResult]::new('-n', '-n', [CompletionResultType]::ParameterName, "Don't actually remove any objects, only show those that would have been removed")
          [CompletionResult]::new('--dry-run', '--dry-run', [CompletionResultType]::ParameterName, "Don't actually remove any objects, only show those that would have been removed")
          [CompletionResult]::new('-q', '-q', [CompletionResultType]::ParameterName, 'Squelch the progress indicator')
          [CompletionResult]::new('--quiet', '--quiet', [CompletionResultType]::ParameterName, 'Squelch the progress indicator')
        }
        break
      }
      'read-tree' {
        if ($wordToComplete.StartsWith('-')) {
          [CompletionResult]::new('-m', '-m', [CompletionResultType]::ParameterName, 'Perform a merge, not just a read')
          [CompletionResult]::new('--reset', '--reset', [CompletionResultType]::ParameterName, 'Same as -m, except that unmerged entries are discarded instead of failing')
          [CompletionResult]::new('-u', '-u', [CompletionResultType]::ParameterName, 'After a successful merge, update the files in the work tree with the result of the merge')
          [CompletionResult]::new('-i', '-i', [CompletionResultType]::ParameterName, 'Usually a merge requires the index file as well as the files in the working tree to be up to date with the current head commit, in order not to lose local changes')
          [CompletionResult]::new('-n', '-n', [CompletionResultType]::ParameterName, 'Check if the command would error out, without updating the index or the files in the working tree for real')
          [CompletionResult]::new('--dry-run', '--dry-run', [CompletionResultType]::ParameterName, 'Check if the command would error out, without updating the index or the files in the working tree for real')
          [CompletionResult]::new('-v', '-v', [CompletionResultType]::ParameterName, 'Show the progress of checking files out')
          [CompletionResult]::new('--trivial', '--trivial', [CompletionResultType]::ParameterName, 'Restrict three-way merge by git read-tree to happen only if there is no file-level merging required, instead of resolving merge for trivial cases and leaving conflicting files unresolved in the index')
          [CompletionResult]::new('--aggressive', '--aggressive', [CompletionResultType]::ParameterName, 'Usually a three-way merge by git read-tree resolves the merge for really trivial cases and leaves other cases unresolved in the index, so that porcelains can implement different merge policies')
          [CompletionResult]::new('--prefix=<prefix>', '--prefix=<prefix>', [CompletionResultType]::ParameterName, 'Keep the current index contents, and read the contents of the named tree-ish under the directory at <prefix>')
          [CompletionResult]::new('--index-output=<file>', '--index-output=<file>', [CompletionResultType]::ParameterName, 'Instead of writing the results out to $GIT_INDEX_FILE, write the resulting index in the named file')
          [CompletionResult]::new('--[no-]recurse-submodules', '--[no-]recurse-submodules', [CompletionResultType]::ParameterName, "Using --recurse-submodules will update the content of all active submodules according to the commit recorded in the superproject by calling read-tree recursively, also setting the submodules' HEAD to be detached at that commit")
          [CompletionResult]::new('--no-sparse-checkout', '--no-sparse-checkout', [CompletionResultType]::ParameterName, 'Disable sparse checkout support even if core')
          [CompletionResult]::new('--empty', '--empty', [CompletionResultType]::ParameterName, 'Instead of reading tree object(s) into the index, just empty it')
          [CompletionResult]::new('-q', '-q', [CompletionResultType]::ParameterName, 'Quiet, suppress feedback messages')
          [CompletionResult]::new('--quiet', '--quiet', [CompletionResultType]::ParameterName, 'Quiet, suppress feedback messages')
          [CompletionResult]::new('<tree-ish#>', '<tree-ish#>', [CompletionResultType]::ParameterName, 'The id of the tree object(s) to be read/merged')
        }
        break
      }
      'replay' {
        if ($wordToComplete.StartsWith('-')) {
          [CompletionResult]::new('--onto', '--onto', [CompletionResultType]::ParameterName, 'Starting point at which to create the new commits')
          [CompletionResult]::new('--advance', '--advance', [CompletionResultType]::ParameterName, 'Starting point at which to create the new commits; must be a branch name')
          [CompletionResult]::new('<revision-range>', '<revision-range>', [CompletionResultType]::ParameterName, 'Range of commits to replay')
        }
        break
      }
      'symbolic-ref' {
        if ($wordToComplete.StartsWith('-')) {
          [CompletionResult]::new('-d', '-d', [CompletionResultType]::ParameterName, 'Delete the symbolic ref <name>')
          [CompletionResult]::new('--delete', '--delete', [CompletionResultType]::ParameterName, 'Delete the symbolic ref <name>')
          [CompletionResult]::new('-q', '-q', [CompletionResultType]::ParameterName, 'Do not issue an error message if the <name> is not a symbolic ref but a detached HEAD; instead exit with non-zero status silently')
          [CompletionResult]::new('--quiet', '--quiet', [CompletionResultType]::ParameterName, 'Do not issue an error message if the <name> is not a symbolic ref but a detached HEAD; instead exit with non-zero status silently')
          [CompletionResult]::new('--short', '--short', [CompletionResultType]::ParameterName, 'When showing the value of <name> as a symbolic ref, try to shorten the value, e')
          [CompletionResult]::new('--recurse', '--recurse', [CompletionResultType]::ParameterName, 'When showing the value of <name> as a symbolic ref, if <name> refers to another symbolic ref, follow such a chain of symbolic refs until the result no longer points at a symbolic ref (--recurse, which is the default)')
          [CompletionResult]::new('--no-recurse', '--no-recurse', [CompletionResultType]::ParameterName, 'When showing the value of <name> as a symbolic ref, if <name> refers to another symbolic ref, follow such a chain of symbolic refs until the result no longer points at a symbolic ref (--recurse, which is the default)')
          [CompletionResult]::new('-m', '-m', [CompletionResultType]::ParameterName, 'Update the reflog for <name> with <reason>')
        }
        break
      }
      'unpack-objects' {
        if ($wordToComplete.StartsWith('-')) {
          [CompletionResult]::new('-n', '-n', [CompletionResultType]::ParameterName, 'Dry run')
          [CompletionResult]::new('-q', '-q', [CompletionResultType]::ParameterName, 'The command usually shows percentage progress')
          [CompletionResult]::new('-r', '-r', [CompletionResultType]::ParameterName, 'When unpacking a corrupt packfile, the command dies at the first corruption')
          [CompletionResult]::new('--strict', '--strict', [CompletionResultType]::ParameterName, "Don't write objects with broken content or links")
          [CompletionResult]::new('--max-input-size=<size>', '--max-input-size=<size>', [CompletionResultType]::ParameterName, 'Die, if the pack is larger than <size>')
        }
        break
      }
      'update-index' {
        if ($wordToComplete.StartsWith('-')) {
          [CompletionResult]::new('--add', '--add', [CompletionResultType]::ParameterName, "If a specified file isn't in the index already then it's added")
          [CompletionResult]::new('--remove', '--remove', [CompletionResultType]::ParameterName, "If a specified file is in the index but is missing then it's removed")
          [CompletionResult]::new('--refresh', '--refresh', [CompletionResultType]::ParameterName, 'Looks at the current index and checks to see if merges or updates are needed by checking stat() information')
          [CompletionResult]::new('-q', '-q', [CompletionResultType]::ParameterName, 'Quiet')
          [CompletionResult]::new('--ignore-submodules', '--ignore-submodules', [CompletionResultType]::ParameterName, 'Do not try to update submodules')
          [CompletionResult]::new('--unmerged', '--unmerged', [CompletionResultType]::ParameterName, 'If --refresh finds unmerged changes in the index, the default behavior is to error out')
          [CompletionResult]::new('--ignore-missing', '--ignore-missing', [CompletionResultType]::ParameterName, 'Ignores missing files during a --refresh')
          [CompletionResult]::new('--cacheinfo', '--cacheinfo', [CompletionResultType]::ParameterName, 'Directly insert the specified info into the index')
          [CompletionResult]::new('--cacheinfo', '--cacheinfo', [CompletionResultType]::ParameterName, 'Directly insert the specified info into the index')
          [CompletionResult]::new('--index-info', '--index-info', [CompletionResultType]::ParameterName, 'Read index information from stdin')
          [CompletionResult]::new('--chmod=(+|-)x', '--chmod=(+|-)x', [CompletionResultType]::ParameterName, 'Set the execute permissions on the updated files')
          [CompletionResult]::new('--[no-]assume-unchanged', '--[no-]assume-unchanged', [CompletionResultType]::ParameterName, 'When this flag is specified, the object names recorded for the paths are not updated')
          [CompletionResult]::new('--really-refresh', '--really-refresh', [CompletionResultType]::ParameterName, 'Like --refresh, but checks stat information unconditionally, without regard to the "assume unchanged" setting')
          [CompletionResult]::new('--[no-]skip-worktree', '--[no-]skip-worktree', [CompletionResultType]::ParameterName, 'When one of these flags is specified, the object names recorded for the paths are not updated')
          [CompletionResult]::new('--[no-]ignore-skip-worktree-entries', '--[no-]ignore-skip-worktree-entries', [CompletionResultType]::ParameterName, 'Do not remove skip-worktree (AKA "index-only") entries even when the --remove option was specified')
          [CompletionResult]::new('--[no-]fsmonitor-valid', '--[no-]fsmonitor-valid', [CompletionResultType]::ParameterName, 'When one of these flags is specified, the object names recorded for the paths are not updated')
          [CompletionResult]::new('-g', '-g', [CompletionResultType]::ParameterName, 'Runs git update-index itself on the paths whose index entries are different from those of the HEAD commit')
          [CompletionResult]::new('--again', '--again', [CompletionResultType]::ParameterName, 'Runs git update-index itself on the paths whose index entries are different from those of the HEAD commit')
          [CompletionResult]::new('--unresolve', '--unresolve', [CompletionResultType]::ParameterName, 'Restores the unmerged or needs updating state of a file during a merge if it was cleared by accident')
          [CompletionResult]::new('--info-only', '--info-only', [CompletionResultType]::ParameterName, 'Do not create objects in the object database for all <file> arguments that follow this flag; just insert their object IDs into the index')
          [CompletionResult]::new('--force-remove', '--force-remove', [CompletionResultType]::ParameterName, 'Remove the file from the index even when the working directory still has such a file')
          [CompletionResult]::new('--replace', '--replace', [CompletionResultType]::ParameterName, 'By default, when a file path exists in the index, git update-index refuses an attempt to add path/file')
          [CompletionResult]::new('--stdin', '--stdin', [CompletionResultType]::ParameterName, 'Instead of taking a list of paths from the command line, read a list of paths from the standard input')
          [CompletionResult]::new('--verbose', '--verbose', [CompletionResultType]::ParameterName, 'Report what is being added and removed from the index')
          [CompletionResult]::new('--index-version', '--index-version', [CompletionResultType]::ParameterName, 'Write the resulting index out in the named on-disk format version')
          [CompletionResult]::new('--show-index-version', '--show-index-version', [CompletionResultType]::ParameterName, 'Report the index format version used by the on-disk index file')
          [CompletionResult]::new('-z', '-z', [CompletionResultType]::ParameterName, 'Only meaningful with --stdin or --index-info; paths are separated with NUL character instead of LF')
          [CompletionResult]::new('--split-index', '--split-index', [CompletionResultType]::ParameterName, 'Enable or disable split index mode')
          [CompletionResult]::new('--no-split-index', '--no-split-index', [CompletionResultType]::ParameterName, 'Enable or disable split index mode')
          [CompletionResult]::new('--untracked-cache', '--untracked-cache', [CompletionResultType]::ParameterName, 'Enable or disable untracked cache feature')
          [CompletionResult]::new('--no-untracked-cache', '--no-untracked-cache', [CompletionResultType]::ParameterName, 'Enable or disable untracked cache feature')
          [CompletionResult]::new('--test-untracked-cache', '--test-untracked-cache', [CompletionResultType]::ParameterName, 'Only perform tests on the working directory to make sure untracked cache can be used')
          [CompletionResult]::new('--force-untracked-cache', '--force-untracked-cache', [CompletionResultType]::ParameterName, 'Same as --untracked-cache')
          [CompletionResult]::new('--fsmonitor', '--fsmonitor', [CompletionResultType]::ParameterName, 'Enable or disable files system monitor feature')
          [CompletionResult]::new('--no-fsmonitor', '--no-fsmonitor', [CompletionResultType]::ParameterName, 'Enable or disable files system monitor feature')
          [CompletionResult]::new('--', '--', [CompletionResultType]::ParameterName, 'Do not interpret any more arguments as options')
          [CompletionResult]::new('<file>', '<file>', [CompletionResultType]::ParameterName, 'Files to act on')
        }
        break
      }
      'update-ref' {
        if ($wordToComplete.StartsWith('-')) {
        }
        elseif ($commandAst.CommandElements.Count -le 3) {
          [CompletionResult]::new('update', 'update', [CompletionResultType]::ParameterName, 'Set <ref> to <new-oid> after verifying <old-oid>, if given')
          [CompletionResult]::new('create', 'create', [CompletionResultType]::ParameterName, 'Create <ref> with <new-oid> after verifying it does not exist')
          [CompletionResult]::new('delete', 'delete', [CompletionResultType]::ParameterName, 'Delete <ref> after verifying it exists with <old-oid>, if given')
          [CompletionResult]::new('symref-update', 'symref-update', [CompletionResultType]::ParameterName, 'Set <ref> to <new-target> after verifying <old-target> or <old-oid>, if given')
          [CompletionResult]::new('verify', 'verify', [CompletionResultType]::ParameterName, 'Verify <ref> against <old-oid> but do not change it')
        }
        break
      }
      'write-tree' {
        if ($wordToComplete.StartsWith('-')) {
          [CompletionResult]::new('--missing-ok', '--missing-ok', [CompletionResultType]::ParameterName, 'Normally git write-tree ensures that the objects referenced by the directory exist in the object database')
          [CompletionResult]::new('--prefix=<prefix>/', '--prefix=<prefix>/', [CompletionResultType]::ParameterName, 'Writes a tree object that represents a subdirectory <prefix>')
        }
        break
      }
      'cat-file' {
        if ($wordToComplete.StartsWith('-')) {
          [CompletionResult]::new('<object>', '<object>', [CompletionResultType]::ParameterName, 'The name of the object to show')
          [CompletionResult]::new('-t', '-t', [CompletionResultType]::ParameterName, 'Instead of the content, show the object type identified by <object>')
          [CompletionResult]::new('-s', '-s', [CompletionResultType]::ParameterName, 'Instead of the content, show the object size identified by <object>')
          [CompletionResult]::new('-e', '-e', [CompletionResultType]::ParameterName, 'Exit with zero status if <object> exists and is a valid object')
          [CompletionResult]::new('-p', '-p', [CompletionResultType]::ParameterName, 'Pretty-print the contents of <object> based on its type')
          [CompletionResult]::new('<type>', '<type>', [CompletionResultType]::ParameterName, 'Typically this matches the real type of <object> but asking for a type that can trivially be dereferenced from the given <object> is also permitted')
          [CompletionResult]::new('--[no-]mailmap', '--[no-]mailmap', [CompletionResultType]::ParameterName, 'Use mailmap file to map author, committer and tagger names and email addresses to canonical real names and email addresses')
          [CompletionResult]::new('--[no-]use-mailmap', '--[no-]use-mailmap', [CompletionResultType]::ParameterName, 'Use mailmap file to map author, committer and tagger names and email addresses to canonical real names and email addresses')
          [CompletionResult]::new('--textconv', '--textconv', [CompletionResultType]::ParameterName, 'Show the content as transformed by a textconv filter')
          [CompletionResult]::new('--filters', '--filters', [CompletionResultType]::ParameterName, 'Show the content as converted by the filters configured in the current working tree for the given <path> (i')
          [CompletionResult]::new('--path=<path>', '--path=<path>', [CompletionResultType]::ParameterName, 'For use with --textconv or --filters, to allow specifying an object name and a path separately, e')
          [CompletionResult]::new('--batch', '--batch', [CompletionResultType]::ParameterName, 'Print object information and contents for each object provided on stdin')
          [CompletionResult]::new('--batch=<format>', '--batch=<format>', [CompletionResultType]::ParameterName, 'Print object information and contents for each object provided on stdin')
          [CompletionResult]::new('--batch-check', '--batch-check', [CompletionResultType]::ParameterName, 'Print object information for each object provided on stdin')
          [CompletionResult]::new('--batch-check=<format>', '--batch-check=<format>', [CompletionResultType]::ParameterName, 'Print object information for each object provided on stdin')
          [CompletionResult]::new('--batch-command', '--batch-command', [CompletionResultType]::ParameterName, 'Enter a command mode that reads commands and arguments from stdin')
          [CompletionResult]::new('--batch-command=<format>', '--batch-command=<format>', [CompletionResultType]::ParameterName, 'Enter a command mode that reads commands and arguments from stdin')
          [CompletionResult]::new('--batch-all-objects', '--batch-all-objects', [CompletionResultType]::ParameterName, 'Instead of reading a list of objects on stdin, perform the requested batch operation on all objects in the repository and any alternate object stores (not just reachable objects)')
          [CompletionResult]::new('--buffer', '--buffer', [CompletionResultType]::ParameterName, 'Normally batch output is flushed after each object is output, so that a process can interactively read and write from cat-file')
          [CompletionResult]::new('--unordered', '--unordered', [CompletionResultType]::ParameterName, 'When --batch-all-objects is in use, visit objects in an order which may be more efficient for accessing the object contents than hash order')
          [CompletionResult]::new('--allow-unknown-type', '--allow-unknown-type', [CompletionResultType]::ParameterName, 'Allow -s or -t to query broken/corrupt objects of unknown type')
          [CompletionResult]::new('--follow-symlinks', '--follow-symlinks', [CompletionResultType]::ParameterName, 'With --batch or --batch-check, follow symlinks inside the repository when requesting objects with extended SHA-1 expressions of the form tree-ish:path-in-tree')
          [CompletionResult]::new('-Z', '-Z', [CompletionResultType]::ParameterName, 'Only meaningful with --batch, --batch-check, or --batch-command; input and output is NUL-delimited instead of newline-delimited')
          [CompletionResult]::new('-z', '-z', [CompletionResultType]::ParameterName, 'Only meaningful with --batch, --batch-check, or --batch-command; input is NUL-delimited instead of newline-delimited')
        }
        break
      }
      'cherry' {
        if ($wordToComplete.StartsWith('-')) {
          [CompletionResult]::new('-v', '-v', [CompletionResultType]::ParameterName, 'Show the commit subjects next to the SHA1s')
          [CompletionResult]::new('<upstream>', '<upstream>', [CompletionResultType]::ParameterName, 'Upstream branch to search for equivalent commits')
          [CompletionResult]::new('<head>', '<head>', [CompletionResultType]::ParameterName, 'Working branch; defaults to HEAD')
          [CompletionResult]::new('<limit>', '<limit>', [CompletionResultType]::ParameterName, 'Do not report commits up to (and including) limit')
        }
        break
      }
      'diff-files' {
        if ($wordToComplete.StartsWith('-')) {
          [CompletionResult]::new('-p', '-p', [CompletionResultType]::ParameterName, 'Generate patch (see Generating patch text with -p)')
          [CompletionResult]::new('-u', '-u', [CompletionResultType]::ParameterName, 'Generate patch (see Generating patch text with -p)')
          [CompletionResult]::new('--patch', '--patch', [CompletionResultType]::ParameterName, 'Generate patch (see Generating patch text with -p)')
          [CompletionResult]::new('-s', '-s', [CompletionResultType]::ParameterName, 'Suppress all output from the diff machinery')
          [CompletionResult]::new('--no-patch', '--no-patch', [CompletionResultType]::ParameterName, 'Suppress all output from the diff machinery')
          [CompletionResult]::new('-U<n>', '-U<n>', [CompletionResultType]::ParameterName, 'Generate diffs with <n> lines of context instead of the usual three')
          [CompletionResult]::new('--unified=<n>', '--unified=<n>', [CompletionResultType]::ParameterName, 'Generate diffs with <n> lines of context instead of the usual three')
          [CompletionResult]::new('--output=<file>', '--output=<file>', [CompletionResultType]::ParameterName, 'Output to a specific file instead of stdout')
          [CompletionResult]::new('--output-indicator-new=<char>', '--output-indicator-new=<char>', [CompletionResultType]::ParameterName, 'Specify the character used to indicate new, old or context lines in the generated patch')
          [CompletionResult]::new('--output-indicator-old=<char>', '--output-indicator-old=<char>', [CompletionResultType]::ParameterName, 'Specify the character used to indicate new, old or context lines in the generated patch')
          [CompletionResult]::new('--output-indicator-context=<char>', '--output-indicator-context=<char>', [CompletionResultType]::ParameterName, 'Specify the character used to indicate new, old or context lines in the generated patch')
          [CompletionResult]::new('--raw', '--raw', [CompletionResultType]::ParameterName, 'Generate the diff in raw format')
          [CompletionResult]::new('--patch-with-raw', '--patch-with-raw', [CompletionResultType]::ParameterName, 'Synonym for -p --raw')
          [CompletionResult]::new('--indent-heuristic', '--indent-heuristic', [CompletionResultType]::ParameterName, 'Enable the heuristic that shifts diff hunk boundaries to make patches easier to read')
          [CompletionResult]::new('--no-indent-heuristic', '--no-indent-heuristic', [CompletionResultType]::ParameterName, 'Disable the indent heuristic')
          [CompletionResult]::new('--minimal', '--minimal', [CompletionResultType]::ParameterName, 'Spend extra time to make sure the smallest possible diff is produced')
          [CompletionResult]::new('--patience', '--patience', [CompletionResultType]::ParameterName, 'Generate a diff using the "patience diff" algorithm')
          [CompletionResult]::new('--histogram', '--histogram', [CompletionResultType]::ParameterName, 'Generate a diff using the "histogram diff" algorithm')
          [CompletionResult]::new('--anchored=<text>', '--anchored=<text>', [CompletionResultType]::ParameterName, 'Generate a diff using the "anchored diff" algorithm')
          [CompletionResult]::new('--diff-algorithm={patience|minimal|histogram|myers}', '--diff-algorithm={patience|minimal|histogram|myers}', [CompletionResultType]::ParameterName, 'Choose a diff algorithm')
          [CompletionResult]::new('--stat[=<width>[,<name-width>[,<count>]]]', '--stat[=<width>[,<name-width>[,<count>]]]', [CompletionResultType]::ParameterName, 'Generate a diffstat')
          [CompletionResult]::new('--compact-summary', '--compact-summary', [CompletionResultType]::ParameterName, 'Output a condensed summary of extended header information such as file creations or deletions ("new" or "gone", optionally "+l" if it' + "'" + 's a symlink) and mode changes ("+x" or "-x" for adding or removing executable bit respectively) in diffstat')
          [CompletionResult]::new('--numstat', '--numstat', [CompletionResultType]::ParameterName, 'Similar to --stat, but shows number of added and deleted lines in decimal notation and pathname without abbreviation, to make it more machine friendly')
          [CompletionResult]::new('--shortstat', '--shortstat', [CompletionResultType]::ParameterName, 'Output only the last line of the --stat format containing total number of modified files, as well as number of added and deleted lines')
          [CompletionResult]::new('-X[<param1,param2,…​>]', '-X[<param1,param2,…​>]', [CompletionResultType]::ParameterName, 'Output the distribution of relative amount of changes for each sub-directory')
          [CompletionResult]::new('--dirstat[=<param1,param2,…​>]', '--dirstat[=<param1,param2,…​>]', [CompletionResultType]::ParameterName, 'Output the distribution of relative amount of changes for each sub-directory')
          [CompletionResult]::new('--cumulative', '--cumulative', [CompletionResultType]::ParameterName, 'Synonym for --dirstat=cumulative')
          [CompletionResult]::new('--dirstat-by-file[=<param1,param2>…​]', '--dirstat-by-file[=<param1,param2>…​]', [CompletionResultType]::ParameterName, 'Synonym for --dirstat=files,<param1>,<param2>…​')
          [CompletionResult]::new('--summary', '--summary', [CompletionResultType]::ParameterName, 'Output a condensed summary of extended header information such as creations, renames and mode changes')
          [CompletionResult]::new('--patch-with-stat', '--patch-with-stat', [CompletionResultType]::ParameterName, 'Synonym for -p --stat')
          [CompletionResult]::new('-z', '-z', [CompletionResultType]::ParameterName, 'When --raw, --numstat, --name-only or --name-status has been given, do not munge pathnames and use NULs as output field terminators')
          [CompletionResult]::new('--name-only', '--name-only', [CompletionResultType]::ParameterName, 'Show only the name of each changed file in the post-image tree')
          [CompletionResult]::new('--name-status', '--name-status', [CompletionResultType]::ParameterName, 'Show only the name(s) and status of each changed file')
          [CompletionResult]::new('--submodule[=<format>]', '--submodule[=<format>]', [CompletionResultType]::ParameterName, 'Specify how differences in submodules are shown')
          [CompletionResult]::new('--color[=<when>]', '--color[=<when>]', [CompletionResultType]::ParameterName, 'Show colored diff')
          [CompletionResult]::new('--no-color', '--no-color', [CompletionResultType]::ParameterName, 'Turn off colored diff')
          [CompletionResult]::new('--color-moved[=<mode>]', '--color-moved[=<mode>]', [CompletionResultType]::ParameterName, 'Moved lines of code are colored differently')
          [CompletionResult]::new('--no-color-moved', '--no-color-moved', [CompletionResultType]::ParameterName, 'Turn off move detection')
          [CompletionResult]::new('--color-moved-ws=<modes>', '--color-moved-ws=<modes>', [CompletionResultType]::ParameterName, 'This configures how whitespace is ignored when performing the move detection for --color-moved')
          [CompletionResult]::new('--no-color-moved-ws', '--no-color-moved-ws', [CompletionResultType]::ParameterName, 'Do not ignore whitespace when performing move detection')
          [CompletionResult]::new('--word-diff[=<mode>]', '--word-diff[=<mode>]', [CompletionResultType]::ParameterName, 'Show a word diff, using the <mode> to delimit changed words')
          [CompletionResult]::new('--word-diff-regex=<regex>', '--word-diff-regex=<regex>', [CompletionResultType]::ParameterName, 'Use <regex> to decide what a word is, instead of considering runs of non-whitespace to be a word')
          [CompletionResult]::new('--color-words[=<regex>]', '--color-words[=<regex>]', [CompletionResultType]::ParameterName, 'Equivalent to --word-diff=color plus (if a regex was specified) --word-diff-regex=<regex>')
          [CompletionResult]::new('--no-renames', '--no-renames', [CompletionResultType]::ParameterName, 'Turn off rename detection, even when the configuration file gives the default to do so')
          [CompletionResult]::new('--[no-]rename-empty', '--[no-]rename-empty', [CompletionResultType]::ParameterName, 'Whether to use empty blobs as rename source')
          [CompletionResult]::new('--check', '--check', [CompletionResultType]::ParameterName, 'Warn if changes introduce conflict markers or whitespace errors')
          [CompletionResult]::new('--ws-error-highlight=<kind>', '--ws-error-highlight=<kind>', [CompletionResultType]::ParameterName, 'Highlight whitespace errors in the context, old or new lines of the diff')
          [CompletionResult]::new('--full-index', '--full-index', [CompletionResultType]::ParameterName, 'Instead of the first handful of characters, show the full pre- and post-image blob object names on the "index" line when generating patch format output')
          [CompletionResult]::new('--binary', '--binary', [CompletionResultType]::ParameterName, 'In addition to --full-index, output a binary diff that can be applied with git-apply')
          [CompletionResult]::new('--abbrev[=<n>]', '--abbrev[=<n>]', [CompletionResultType]::ParameterName, 'Instead of showing the full 40-byte hexadecimal object name in diff-raw format output and diff-tree header lines, show the shortest prefix that is at least <n> hexdigits long that uniquely refers the object')
          [CompletionResult]::new('-B[<n>][/<m>]', '-B[<n>][/<m>]', [CompletionResultType]::ParameterName, 'Break complete rewrite changes into pairs of delete and create')
          [CompletionResult]::new('--break-rewrites[=[<n>][/<m>]]', '--break-rewrites[=[<n>][/<m>]]', [CompletionResultType]::ParameterName, 'Break complete rewrite changes into pairs of delete and create')
          [CompletionResult]::new('-M[<n>]', '-M[<n>]', [CompletionResultType]::ParameterName, 'Detect renames')
          [CompletionResult]::new('--find-renames[=<n>]', '--find-renames[=<n>]', [CompletionResultType]::ParameterName, 'Detect renames')
          [CompletionResult]::new('-C[<n>]', '-C[<n>]', [CompletionResultType]::ParameterName, 'Detect copies as well as renames')
          [CompletionResult]::new('--find-copies[=<n>]', '--find-copies[=<n>]', [CompletionResultType]::ParameterName, 'Detect copies as well as renames')
          [CompletionResult]::new('--find-copies-harder', '--find-copies-harder', [CompletionResultType]::ParameterName, 'For performance reasons, by default, -C option finds copies only if the original file of the copy was modified in the same changeset')
          [CompletionResult]::new('-D', '-D', [CompletionResultType]::ParameterName, 'Omit the preimage for deletes, i')
          [CompletionResult]::new('--irreversible-delete', '--irreversible-delete', [CompletionResultType]::ParameterName, 'Omit the preimage for deletes, i')
          [CompletionResult]::new('-l<num>', '-l<num>', [CompletionResultType]::ParameterName, 'The -M and -C options involve some preliminary steps that can detect subsets of renames/copies cheaply, followed by an exhaustive fallback portion that compares all remaining unpaired destinations to all relevant sources')
          [CompletionResult]::new('--diff-filter=[(A|C|D|M|R|T|U|X|B)…​[*]]', '--diff-filter=[(A|C|D|M|R|T|U|X|B)…​[*]]', [CompletionResultType]::ParameterName, 'Select only files that are Added (A), Copied (C), Deleted (D), Modified (M), Renamed (R), have their type (i')
          [CompletionResult]::new('-S<string>', '-S<string>', [CompletionResultType]::ParameterName, 'Look for differences that change the number of occurrences of the specified string (i')
          [CompletionResult]::new('-G<regex>', '-G<regex>', [CompletionResultType]::ParameterName, 'Look for differences whose patch text contains added/removed lines that match <regex>')
          [CompletionResult]::new('--find-object=<object-id>', '--find-object=<object-id>', [CompletionResultType]::ParameterName, 'Look for differences that change the number of occurrences of the specified object')
          [CompletionResult]::new('--pickaxe-all', '--pickaxe-all', [CompletionResultType]::ParameterName, 'When -S or -G finds a change, show all the changes in that changeset, not just the files that contain the change in <string>')
          [CompletionResult]::new('--pickaxe-regex', '--pickaxe-regex', [CompletionResultType]::ParameterName, 'Treat the <string> given to -S as an extended POSIX regular expression to match')
          [CompletionResult]::new('-O<orderfile>', '-O<orderfile>', [CompletionResultType]::ParameterName, 'Control the order in which files appear in the output')
          [CompletionResult]::new('--skip-to=<file>', '--skip-to=<file>', [CompletionResultType]::ParameterName, 'Discard the files before the named <file> from the output (i')
          [CompletionResult]::new('--rotate-to=<file>', '--rotate-to=<file>', [CompletionResultType]::ParameterName, 'Discard the files before the named <file> from the output (i')
          [CompletionResult]::new('-R', '-R', [CompletionResultType]::ParameterName, 'Swap two inputs; that is, show differences from index or on-disk file to tree contents')
          [CompletionResult]::new('--relative[=<path>]', '--relative[=<path>]', [CompletionResultType]::ParameterName, 'When run from a subdirectory of the project, it can be told to exclude changes outside the directory and show pathnames relative to it with this option')
          [CompletionResult]::new('--no-relative', '--no-relative', [CompletionResultType]::ParameterName, 'When run from a subdirectory of the project, it can be told to exclude changes outside the directory and show pathnames relative to it with this option')
          [CompletionResult]::new('-a', '-a', [CompletionResultType]::ParameterName, 'Treat all files as text')
          [CompletionResult]::new('--text', '--text', [CompletionResultType]::ParameterName, 'Treat all files as text')
          [CompletionResult]::new('--ignore-cr-at-eol', '--ignore-cr-at-eol', [CompletionResultType]::ParameterName, 'Ignore carriage-return at the end of line when doing a comparison')
          [CompletionResult]::new('--ignore-space-at-eol', '--ignore-space-at-eol', [CompletionResultType]::ParameterName, 'Ignore changes in whitespace at EOL')
          [CompletionResult]::new('-b', '-b', [CompletionResultType]::ParameterName, 'Ignore changes in amount of whitespace')
          [CompletionResult]::new('--ignore-space-change', '--ignore-space-change', [CompletionResultType]::ParameterName, 'Ignore changes in amount of whitespace')
          [CompletionResult]::new('-w', '-w', [CompletionResultType]::ParameterName, 'Ignore whitespace when comparing lines')
          [CompletionResult]::new('--ignore-all-space', '--ignore-all-space', [CompletionResultType]::ParameterName, 'Ignore whitespace when comparing lines')
          [CompletionResult]::new('--ignore-blank-lines', '--ignore-blank-lines', [CompletionResultType]::ParameterName, 'Ignore changes whose lines are all blank')
          [CompletionResult]::new('-I<regex>', '-I<regex>', [CompletionResultType]::ParameterName, 'Ignore changes whose all lines match <regex>')
          [CompletionResult]::new('--ignore-matching-lines=<regex>', '--ignore-matching-lines=<regex>', [CompletionResultType]::ParameterName, 'Ignore changes whose all lines match <regex>')
          [CompletionResult]::new('--inter-hunk-context=<lines>', '--inter-hunk-context=<lines>', [CompletionResultType]::ParameterName, 'Show the context between diff hunks, up to the specified number of lines, thereby fusing hunks that are close to each other')
          [CompletionResult]::new('-W', '-W', [CompletionResultType]::ParameterName, 'Show whole function as context lines for each change')
          [CompletionResult]::new('--function-context', '--function-context', [CompletionResultType]::ParameterName, 'Show whole function as context lines for each change')
          [CompletionResult]::new('--exit-code', '--exit-code', [CompletionResultType]::ParameterName, 'Make the program exit with codes similar to diff(1)')
          [CompletionResult]::new('--quiet', '--quiet', [CompletionResultType]::ParameterName, 'Disable all output of the program')
          [CompletionResult]::new('--ext-diff', '--ext-diff', [CompletionResultType]::ParameterName, 'Allow an external diff helper to be executed')
          [CompletionResult]::new('--no-ext-diff', '--no-ext-diff', [CompletionResultType]::ParameterName, 'Disallow external diff drivers')
          [CompletionResult]::new('--textconv', '--textconv', [CompletionResultType]::ParameterName, 'Allow (or disallow) external text conversion filters to be run when comparing binary files')
          [CompletionResult]::new('--no-textconv', '--no-textconv', [CompletionResultType]::ParameterName, 'Allow (or disallow) external text conversion filters to be run when comparing binary files')
          [CompletionResult]::new('--ignore-submodules[=<when>]', '--ignore-submodules[=<when>]', [CompletionResultType]::ParameterName, 'Ignore changes to submodules in the diff generation')
          [CompletionResult]::new('--src-prefix=<prefix>', '--src-prefix=<prefix>', [CompletionResultType]::ParameterName, 'Show the given source prefix instead of "a/"')
          [CompletionResult]::new('--dst-prefix=<prefix>', '--dst-prefix=<prefix>', [CompletionResultType]::ParameterName, 'Show the given destination prefix instead of "b/"')
          [CompletionResult]::new('--no-prefix', '--no-prefix', [CompletionResultType]::ParameterName, 'Do not show any source or destination prefix')
          [CompletionResult]::new('--default-prefix', '--default-prefix', [CompletionResultType]::ParameterName, 'Use the default source and destination prefixes ("a/" and "b/")')
          [CompletionResult]::new('--line-prefix=<prefix>', '--line-prefix=<prefix>', [CompletionResultType]::ParameterName, 'Prepend an additional prefix to every line of output')
          [CompletionResult]::new('--ita-invisible-in-index', '--ita-invisible-in-index', [CompletionResultType]::ParameterName, 'By default entries added by "git add -N" appear as an existing empty file in "git diff" and a new file in "git diff --cached"')
        }
        break
      }
      'diff-index' {
        if ($wordToComplete.StartsWith('-')) {
          [CompletionResult]::new('-p', '-p', [CompletionResultType]::ParameterName, 'Generate patch (see Generating patch text with -p)')
          [CompletionResult]::new('-u', '-u', [CompletionResultType]::ParameterName, 'Generate patch (see Generating patch text with -p)')
          [CompletionResult]::new('--patch', '--patch', [CompletionResultType]::ParameterName, 'Generate patch (see Generating patch text with -p)')
          [CompletionResult]::new('-s', '-s', [CompletionResultType]::ParameterName, 'Suppress all output from the diff machinery')
          [CompletionResult]::new('--no-patch', '--no-patch', [CompletionResultType]::ParameterName, 'Suppress all output from the diff machinery')
          [CompletionResult]::new('-U<n>', '-U<n>', [CompletionResultType]::ParameterName, 'Generate diffs with <n> lines of context instead of the usual three')
          [CompletionResult]::new('--unified=<n>', '--unified=<n>', [CompletionResultType]::ParameterName, 'Generate diffs with <n> lines of context instead of the usual three')
          [CompletionResult]::new('--output=<file>', '--output=<file>', [CompletionResultType]::ParameterName, 'Output to a specific file instead of stdout')
          [CompletionResult]::new('--output-indicator-new=<char>', '--output-indicator-new=<char>', [CompletionResultType]::ParameterName, 'Specify the character used to indicate new, old or context lines in the generated patch')
          [CompletionResult]::new('--output-indicator-old=<char>', '--output-indicator-old=<char>', [CompletionResultType]::ParameterName, 'Specify the character used to indicate new, old or context lines in the generated patch')
          [CompletionResult]::new('--output-indicator-context=<char>', '--output-indicator-context=<char>', [CompletionResultType]::ParameterName, 'Specify the character used to indicate new, old or context lines in the generated patch')
          [CompletionResult]::new('--raw', '--raw', [CompletionResultType]::ParameterName, 'Generate the diff in raw format')
          [CompletionResult]::new('--patch-with-raw', '--patch-with-raw', [CompletionResultType]::ParameterName, 'Synonym for -p --raw')
          [CompletionResult]::new('--indent-heuristic', '--indent-heuristic', [CompletionResultType]::ParameterName, 'Enable the heuristic that shifts diff hunk boundaries to make patches easier to read')
          [CompletionResult]::new('--no-indent-heuristic', '--no-indent-heuristic', [CompletionResultType]::ParameterName, 'Disable the indent heuristic')
          [CompletionResult]::new('--minimal', '--minimal', [CompletionResultType]::ParameterName, 'Spend extra time to make sure the smallest possible diff is produced')
          [CompletionResult]::new('--patience', '--patience', [CompletionResultType]::ParameterName, 'Generate a diff using the "patience diff" algorithm')
          [CompletionResult]::new('--histogram', '--histogram', [CompletionResultType]::ParameterName, 'Generate a diff using the "histogram diff" algorithm')
          [CompletionResult]::new('--anchored=<text>', '--anchored=<text>', [CompletionResultType]::ParameterName, 'Generate a diff using the "anchored diff" algorithm')
          [CompletionResult]::new('--diff-algorithm={patience|minimal|histogram|myers}', '--diff-algorithm={patience|minimal|histogram|myers}', [CompletionResultType]::ParameterName, 'Choose a diff algorithm')
          [CompletionResult]::new('--stat[=<width>[,<name-width>[,<count>]]]', '--stat[=<width>[,<name-width>[,<count>]]]', [CompletionResultType]::ParameterName, 'Generate a diffstat')
          [CompletionResult]::new('--compact-summary', '--compact-summary', [CompletionResultType]::ParameterName, 'Output a condensed summary of extended header information such as file creations or deletions ("new" or "gone", optionally "+l" if it' + "'" + 's a symlink) and mode changes ("+x" or "-x" for adding or removing executable bit respectively) in diffstat')
          [CompletionResult]::new('--numstat', '--numstat', [CompletionResultType]::ParameterName, 'Similar to --stat, but shows number of added and deleted lines in decimal notation and pathname without abbreviation, to make it more machine friendly')
          [CompletionResult]::new('--shortstat', '--shortstat', [CompletionResultType]::ParameterName, 'Output only the last line of the --stat format containing total number of modified files, as well as number of added and deleted lines')
          [CompletionResult]::new('-X[<param1,param2,…​>]', '-X[<param1,param2,…​>]', [CompletionResultType]::ParameterName, 'Output the distribution of relative amount of changes for each sub-directory')
          [CompletionResult]::new('--dirstat[=<param1,param2,…​>]', '--dirstat[=<param1,param2,…​>]', [CompletionResultType]::ParameterName, 'Output the distribution of relative amount of changes for each sub-directory')
          [CompletionResult]::new('--cumulative', '--cumulative', [CompletionResultType]::ParameterName, 'Synonym for --dirstat=cumulative')
          [CompletionResult]::new('--dirstat-by-file[=<param1,param2>…​]', '--dirstat-by-file[=<param1,param2>…​]', [CompletionResultType]::ParameterName, 'Synonym for --dirstat=files,<param1>,<param2>…​')
          [CompletionResult]::new('--summary', '--summary', [CompletionResultType]::ParameterName, 'Output a condensed summary of extended header information such as creations, renames and mode changes')
          [CompletionResult]::new('--patch-with-stat', '--patch-with-stat', [CompletionResultType]::ParameterName, 'Synonym for -p --stat')
          [CompletionResult]::new('-z', '-z', [CompletionResultType]::ParameterName, 'When --raw, --numstat, --name-only or --name-status has been given, do not munge pathnames and use NULs as output field terminators')
          [CompletionResult]::new('--name-only', '--name-only', [CompletionResultType]::ParameterName, 'Show only the name of each changed file in the post-image tree')
          [CompletionResult]::new('--name-status', '--name-status', [CompletionResultType]::ParameterName, 'Show only the name(s) and status of each changed file')
          [CompletionResult]::new('--submodule[=<format>]', '--submodule[=<format>]', [CompletionResultType]::ParameterName, 'Specify how differences in submodules are shown')
          [CompletionResult]::new('--color[=<when>]', '--color[=<when>]', [CompletionResultType]::ParameterName, 'Show colored diff')
          [CompletionResult]::new('--no-color', '--no-color', [CompletionResultType]::ParameterName, 'Turn off colored diff')
          [CompletionResult]::new('--color-moved[=<mode>]', '--color-moved[=<mode>]', [CompletionResultType]::ParameterName, 'Moved lines of code are colored differently')
          [CompletionResult]::new('--no-color-moved', '--no-color-moved', [CompletionResultType]::ParameterName, 'Turn off move detection')
          [CompletionResult]::new('--color-moved-ws=<modes>', '--color-moved-ws=<modes>', [CompletionResultType]::ParameterName, 'This configures how whitespace is ignored when performing the move detection for --color-moved')
          [CompletionResult]::new('--no-color-moved-ws', '--no-color-moved-ws', [CompletionResultType]::ParameterName, 'Do not ignore whitespace when performing move detection')
          [CompletionResult]::new('--word-diff[=<mode>]', '--word-diff[=<mode>]', [CompletionResultType]::ParameterName, 'Show a word diff, using the <mode> to delimit changed words')
          [CompletionResult]::new('--word-diff-regex=<regex>', '--word-diff-regex=<regex>', [CompletionResultType]::ParameterName, 'Use <regex> to decide what a word is, instead of considering runs of non-whitespace to be a word')
          [CompletionResult]::new('--color-words[=<regex>]', '--color-words[=<regex>]', [CompletionResultType]::ParameterName, 'Equivalent to --word-diff=color plus (if a regex was specified) --word-diff-regex=<regex>')
          [CompletionResult]::new('--no-renames', '--no-renames', [CompletionResultType]::ParameterName, 'Turn off rename detection, even when the configuration file gives the default to do so')
          [CompletionResult]::new('--[no-]rename-empty', '--[no-]rename-empty', [CompletionResultType]::ParameterName, 'Whether to use empty blobs as rename source')
          [CompletionResult]::new('--check', '--check', [CompletionResultType]::ParameterName, 'Warn if changes introduce conflict markers or whitespace errors')
          [CompletionResult]::new('--ws-error-highlight=<kind>', '--ws-error-highlight=<kind>', [CompletionResultType]::ParameterName, 'Highlight whitespace errors in the context, old or new lines of the diff')
          [CompletionResult]::new('--full-index', '--full-index', [CompletionResultType]::ParameterName, 'Instead of the first handful of characters, show the full pre- and post-image blob object names on the "index" line when generating patch format output')
          [CompletionResult]::new('--binary', '--binary', [CompletionResultType]::ParameterName, 'In addition to --full-index, output a binary diff that can be applied with git-apply')
          [CompletionResult]::new('--abbrev[=<n>]', '--abbrev[=<n>]', [CompletionResultType]::ParameterName, 'Instead of showing the full 40-byte hexadecimal object name in diff-raw format output and diff-tree header lines, show the shortest prefix that is at least <n> hexdigits long that uniquely refers the object')
          [CompletionResult]::new('-B[<n>][/<m>]', '-B[<n>][/<m>]', [CompletionResultType]::ParameterName, 'Break complete rewrite changes into pairs of delete and create')
          [CompletionResult]::new('--break-rewrites[=[<n>][/<m>]]', '--break-rewrites[=[<n>][/<m>]]', [CompletionResultType]::ParameterName, 'Break complete rewrite changes into pairs of delete and create')
          [CompletionResult]::new('-M[<n>]', '-M[<n>]', [CompletionResultType]::ParameterName, 'Detect renames')
          [CompletionResult]::new('--find-renames[=<n>]', '--find-renames[=<n>]', [CompletionResultType]::ParameterName, 'Detect renames')
          [CompletionResult]::new('-C[<n>]', '-C[<n>]', [CompletionResultType]::ParameterName, 'Detect copies as well as renames')
          [CompletionResult]::new('--find-copies[=<n>]', '--find-copies[=<n>]', [CompletionResultType]::ParameterName, 'Detect copies as well as renames')
          [CompletionResult]::new('--find-copies-harder', '--find-copies-harder', [CompletionResultType]::ParameterName, 'For performance reasons, by default, -C option finds copies only if the original file of the copy was modified in the same changeset')
          [CompletionResult]::new('-D', '-D', [CompletionResultType]::ParameterName, 'Omit the preimage for deletes, i')
          [CompletionResult]::new('--irreversible-delete', '--irreversible-delete', [CompletionResultType]::ParameterName, 'Omit the preimage for deletes, i')
          [CompletionResult]::new('-l<num>', '-l<num>', [CompletionResultType]::ParameterName, 'The -M and -C options involve some preliminary steps that can detect subsets of renames/copies cheaply, followed by an exhaustive fallback portion that compares all remaining unpaired destinations to all relevant sources')
          [CompletionResult]::new('--diff-filter=[(A|C|D|M|R|T|U|X|B)…​[*]]', '--diff-filter=[(A|C|D|M|R|T|U|X|B)…​[*]]', [CompletionResultType]::ParameterName, 'Select only files that are Added (A), Copied (C), Deleted (D), Modified (M), Renamed (R), have their type (i')
          [CompletionResult]::new('-S<string>', '-S<string>', [CompletionResultType]::ParameterName, 'Look for differences that change the number of occurrences of the specified string (i')
          [CompletionResult]::new('-G<regex>', '-G<regex>', [CompletionResultType]::ParameterName, 'Look for differences whose patch text contains added/removed lines that match <regex>')
          [CompletionResult]::new('--find-object=<object-id>', '--find-object=<object-id>', [CompletionResultType]::ParameterName, 'Look for differences that change the number of occurrences of the specified object')
          [CompletionResult]::new('--pickaxe-all', '--pickaxe-all', [CompletionResultType]::ParameterName, 'When -S or -G finds a change, show all the changes in that changeset, not just the files that contain the change in <string>')
          [CompletionResult]::new('--pickaxe-regex', '--pickaxe-regex', [CompletionResultType]::ParameterName, 'Treat the <string> given to -S as an extended POSIX regular expression to match')
          [CompletionResult]::new('-O<orderfile>', '-O<orderfile>', [CompletionResultType]::ParameterName, 'Control the order in which files appear in the output')
          [CompletionResult]::new('--skip-to=<file>', '--skip-to=<file>', [CompletionResultType]::ParameterName, 'Discard the files before the named <file> from the output (i')
          [CompletionResult]::new('--rotate-to=<file>', '--rotate-to=<file>', [CompletionResultType]::ParameterName, 'Discard the files before the named <file> from the output (i')
          [CompletionResult]::new('-R', '-R', [CompletionResultType]::ParameterName, 'Swap two inputs; that is, show differences from index or on-disk file to tree contents')
          [CompletionResult]::new('--relative[=<path>]', '--relative[=<path>]', [CompletionResultType]::ParameterName, 'When run from a subdirectory of the project, it can be told to exclude changes outside the directory and show pathnames relative to it with this option')
          [CompletionResult]::new('--no-relative', '--no-relative', [CompletionResultType]::ParameterName, 'When run from a subdirectory of the project, it can be told to exclude changes outside the directory and show pathnames relative to it with this option')
          [CompletionResult]::new('-a', '-a', [CompletionResultType]::ParameterName, 'Treat all files as text')
          [CompletionResult]::new('--text', '--text', [CompletionResultType]::ParameterName, 'Treat all files as text')
          [CompletionResult]::new('--ignore-cr-at-eol', '--ignore-cr-at-eol', [CompletionResultType]::ParameterName, 'Ignore carriage-return at the end of line when doing a comparison')
          [CompletionResult]::new('--ignore-space-at-eol', '--ignore-space-at-eol', [CompletionResultType]::ParameterName, 'Ignore changes in whitespace at EOL')
          [CompletionResult]::new('-b', '-b', [CompletionResultType]::ParameterName, 'Ignore changes in amount of whitespace')
          [CompletionResult]::new('--ignore-space-change', '--ignore-space-change', [CompletionResultType]::ParameterName, 'Ignore changes in amount of whitespace')
          [CompletionResult]::new('-w', '-w', [CompletionResultType]::ParameterName, 'Ignore whitespace when comparing lines')
          [CompletionResult]::new('--ignore-all-space', '--ignore-all-space', [CompletionResultType]::ParameterName, 'Ignore whitespace when comparing lines')
          [CompletionResult]::new('--ignore-blank-lines', '--ignore-blank-lines', [CompletionResultType]::ParameterName, 'Ignore changes whose lines are all blank')
          [CompletionResult]::new('-I<regex>', '-I<regex>', [CompletionResultType]::ParameterName, 'Ignore changes whose all lines match <regex>')
          [CompletionResult]::new('--ignore-matching-lines=<regex>', '--ignore-matching-lines=<regex>', [CompletionResultType]::ParameterName, 'Ignore changes whose all lines match <regex>')
          [CompletionResult]::new('--inter-hunk-context=<lines>', '--inter-hunk-context=<lines>', [CompletionResultType]::ParameterName, 'Show the context between diff hunks, up to the specified number of lines, thereby fusing hunks that are close to each other')
          [CompletionResult]::new('-W', '-W', [CompletionResultType]::ParameterName, 'Show whole function as context lines for each change')
          [CompletionResult]::new('--function-context', '--function-context', [CompletionResultType]::ParameterName, 'Show whole function as context lines for each change')
          [CompletionResult]::new('--exit-code', '--exit-code', [CompletionResultType]::ParameterName, 'Make the program exit with codes similar to diff(1)')
          [CompletionResult]::new('--quiet', '--quiet', [CompletionResultType]::ParameterName, 'Disable all output of the program')
          [CompletionResult]::new('--ext-diff', '--ext-diff', [CompletionResultType]::ParameterName, 'Allow an external diff helper to be executed')
          [CompletionResult]::new('--no-ext-diff', '--no-ext-diff', [CompletionResultType]::ParameterName, 'Disallow external diff drivers')
          [CompletionResult]::new('--textconv', '--textconv', [CompletionResultType]::ParameterName, 'Allow (or disallow) external text conversion filters to be run when comparing binary files')
          [CompletionResult]::new('--no-textconv', '--no-textconv', [CompletionResultType]::ParameterName, 'Allow (or disallow) external text conversion filters to be run when comparing binary files')
          [CompletionResult]::new('--ignore-submodules[=<when>]', '--ignore-submodules[=<when>]', [CompletionResultType]::ParameterName, 'Ignore changes to submodules in the diff generation')
          [CompletionResult]::new('--src-prefix=<prefix>', '--src-prefix=<prefix>', [CompletionResultType]::ParameterName, 'Show the given source prefix instead of "a/"')
          [CompletionResult]::new('--dst-prefix=<prefix>', '--dst-prefix=<prefix>', [CompletionResultType]::ParameterName, 'Show the given destination prefix instead of "b/"')
          [CompletionResult]::new('--no-prefix', '--no-prefix', [CompletionResultType]::ParameterName, 'Do not show any source or destination prefix')
          [CompletionResult]::new('--default-prefix', '--default-prefix', [CompletionResultType]::ParameterName, 'Use the default source and destination prefixes ("a/" and "b/")')
          [CompletionResult]::new('--line-prefix=<prefix>', '--line-prefix=<prefix>', [CompletionResultType]::ParameterName, 'Prepend an additional prefix to every line of output')
          [CompletionResult]::new('--ita-invisible-in-index', '--ita-invisible-in-index', [CompletionResultType]::ParameterName, 'By default entries added by "git add -N" appear as an existing empty file in "git diff" and a new file in "git diff --cached"')
        }
        break
      }
      'diff-tree' {
        if ($wordToComplete.StartsWith('-')) {
          [CompletionResult]::new('-p', '-p', [CompletionResultType]::ParameterName, 'Generate patch (see Generating patch text with -p)')
          [CompletionResult]::new('-u', '-u', [CompletionResultType]::ParameterName, 'Generate patch (see Generating patch text with -p)')
          [CompletionResult]::new('--patch', '--patch', [CompletionResultType]::ParameterName, 'Generate patch (see Generating patch text with -p)')
          [CompletionResult]::new('-s', '-s', [CompletionResultType]::ParameterName, 'Suppress all output from the diff machinery')
          [CompletionResult]::new('--no-patch', '--no-patch', [CompletionResultType]::ParameterName, 'Suppress all output from the diff machinery')
          [CompletionResult]::new('-U<n>', '-U<n>', [CompletionResultType]::ParameterName, 'Generate diffs with <n> lines of context instead of the usual three')
          [CompletionResult]::new('--unified=<n>', '--unified=<n>', [CompletionResultType]::ParameterName, 'Generate diffs with <n> lines of context instead of the usual three')
          [CompletionResult]::new('--output=<file>', '--output=<file>', [CompletionResultType]::ParameterName, 'Output to a specific file instead of stdout')
          [CompletionResult]::new('--output-indicator-new=<char>', '--output-indicator-new=<char>', [CompletionResultType]::ParameterName, 'Specify the character used to indicate new, old or context lines in the generated patch')
          [CompletionResult]::new('--output-indicator-old=<char>', '--output-indicator-old=<char>', [CompletionResultType]::ParameterName, 'Specify the character used to indicate new, old or context lines in the generated patch')
          [CompletionResult]::new('--output-indicator-context=<char>', '--output-indicator-context=<char>', [CompletionResultType]::ParameterName, 'Specify the character used to indicate new, old or context lines in the generated patch')
          [CompletionResult]::new('--raw', '--raw', [CompletionResultType]::ParameterName, 'Generate the diff in raw format')
          [CompletionResult]::new('--patch-with-raw', '--patch-with-raw', [CompletionResultType]::ParameterName, 'Synonym for -p --raw')
          [CompletionResult]::new('--indent-heuristic', '--indent-heuristic', [CompletionResultType]::ParameterName, 'Enable the heuristic that shifts diff hunk boundaries to make patches easier to read')
          [CompletionResult]::new('--no-indent-heuristic', '--no-indent-heuristic', [CompletionResultType]::ParameterName, 'Disable the indent heuristic')
          [CompletionResult]::new('--minimal', '--minimal', [CompletionResultType]::ParameterName, 'Spend extra time to make sure the smallest possible diff is produced')
          [CompletionResult]::new('--patience', '--patience', [CompletionResultType]::ParameterName, 'Generate a diff using the "patience diff" algorithm')
          [CompletionResult]::new('--histogram', '--histogram', [CompletionResultType]::ParameterName, 'Generate a diff using the "histogram diff" algorithm')
          [CompletionResult]::new('--anchored=<text>', '--anchored=<text>', [CompletionResultType]::ParameterName, 'Generate a diff using the "anchored diff" algorithm')
          [CompletionResult]::new('--diff-algorithm={patience|minimal|histogram|myers}', '--diff-algorithm={patience|minimal|histogram|myers}', [CompletionResultType]::ParameterName, 'Choose a diff algorithm')
          [CompletionResult]::new('--stat[=<width>[,<name-width>[,<count>]]]', '--stat[=<width>[,<name-width>[,<count>]]]', [CompletionResultType]::ParameterName, 'Generate a diffstat')
          [CompletionResult]::new('--compact-summary', '--compact-summary', [CompletionResultType]::ParameterName, 'Output a condensed summary of extended header information such as file creations or deletions ("new" or "gone", optionally "+l" if it' + "'" + 's a symlink) and mode changes ("+x" or "-x" for adding or removing executable bit respectively) in diffstat')
          [CompletionResult]::new('--numstat', '--numstat', [CompletionResultType]::ParameterName, 'Similar to --stat, but shows number of added and deleted lines in decimal notation and pathname without abbreviation, to make it more machine friendly')
          [CompletionResult]::new('--shortstat', '--shortstat', [CompletionResultType]::ParameterName, 'Output only the last line of the --stat format containing total number of modified files, as well as number of added and deleted lines')
          [CompletionResult]::new('-X[<param1,param2,…​>]', '-X[<param1,param2,…​>]', [CompletionResultType]::ParameterName, 'Output the distribution of relative amount of changes for each sub-directory')
          [CompletionResult]::new('--dirstat[=<param1,param2,…​>]', '--dirstat[=<param1,param2,…​>]', [CompletionResultType]::ParameterName, 'Output the distribution of relative amount of changes for each sub-directory')
          [CompletionResult]::new('--cumulative', '--cumulative', [CompletionResultType]::ParameterName, 'Synonym for --dirstat=cumulative')
          [CompletionResult]::new('--dirstat-by-file[=<param1,param2>…​]', '--dirstat-by-file[=<param1,param2>…​]', [CompletionResultType]::ParameterName, 'Synonym for --dirstat=files,<param1>,<param2>…​')
          [CompletionResult]::new('--summary', '--summary', [CompletionResultType]::ParameterName, 'Output a condensed summary of extended header information such as creations, renames and mode changes')
          [CompletionResult]::new('--patch-with-stat', '--patch-with-stat', [CompletionResultType]::ParameterName, 'Synonym for -p --stat')
          [CompletionResult]::new('-z', '-z', [CompletionResultType]::ParameterName, 'When --raw, --numstat, --name-only or --name-status has been given, do not munge pathnames and use NULs as output field terminators')
          [CompletionResult]::new('--name-only', '--name-only', [CompletionResultType]::ParameterName, 'Show only the name of each changed file in the post-image tree')
          [CompletionResult]::new('--name-status', '--name-status', [CompletionResultType]::ParameterName, 'Show only the name(s) and status of each changed file')
          [CompletionResult]::new('--submodule[=<format>]', '--submodule[=<format>]', [CompletionResultType]::ParameterName, 'Specify how differences in submodules are shown')
          [CompletionResult]::new('--color[=<when>]', '--color[=<when>]', [CompletionResultType]::ParameterName, 'Show colored diff')
          [CompletionResult]::new('--no-color', '--no-color', [CompletionResultType]::ParameterName, 'Turn off colored diff')
          [CompletionResult]::new('--color-moved[=<mode>]', '--color-moved[=<mode>]', [CompletionResultType]::ParameterName, 'Moved lines of code are colored differently')
          [CompletionResult]::new('--no-color-moved', '--no-color-moved', [CompletionResultType]::ParameterName, 'Turn off move detection')
          [CompletionResult]::new('--color-moved-ws=<modes>', '--color-moved-ws=<modes>', [CompletionResultType]::ParameterName, 'This configures how whitespace is ignored when performing the move detection for --color-moved')
          [CompletionResult]::new('--no-color-moved-ws', '--no-color-moved-ws', [CompletionResultType]::ParameterName, 'Do not ignore whitespace when performing move detection')
          [CompletionResult]::new('--word-diff[=<mode>]', '--word-diff[=<mode>]', [CompletionResultType]::ParameterName, 'Show a word diff, using the <mode> to delimit changed words')
          [CompletionResult]::new('--word-diff-regex=<regex>', '--word-diff-regex=<regex>', [CompletionResultType]::ParameterName, 'Use <regex> to decide what a word is, instead of considering runs of non-whitespace to be a word')
          [CompletionResult]::new('--color-words[=<regex>]', '--color-words[=<regex>]', [CompletionResultType]::ParameterName, 'Equivalent to --word-diff=color plus (if a regex was specified) --word-diff-regex=<regex>')
          [CompletionResult]::new('--no-renames', '--no-renames', [CompletionResultType]::ParameterName, 'Turn off rename detection, even when the configuration file gives the default to do so')
          [CompletionResult]::new('--[no-]rename-empty', '--[no-]rename-empty', [CompletionResultType]::ParameterName, 'Whether to use empty blobs as rename source')
          [CompletionResult]::new('--check', '--check', [CompletionResultType]::ParameterName, 'Warn if changes introduce conflict markers or whitespace errors')
          [CompletionResult]::new('--ws-error-highlight=<kind>', '--ws-error-highlight=<kind>', [CompletionResultType]::ParameterName, 'Highlight whitespace errors in the context, old or new lines of the diff')
          [CompletionResult]::new('--full-index', '--full-index', [CompletionResultType]::ParameterName, 'Instead of the first handful of characters, show the full pre- and post-image blob object names on the "index" line when generating patch format output')
          [CompletionResult]::new('--binary', '--binary', [CompletionResultType]::ParameterName, 'In addition to --full-index, output a binary diff that can be applied with git-apply')
          [CompletionResult]::new('--abbrev[=<n>]', '--abbrev[=<n>]', [CompletionResultType]::ParameterName, 'Instead of showing the full 40-byte hexadecimal object name in diff-raw format output and diff-tree header lines, show the shortest prefix that is at least <n> hexdigits long that uniquely refers the object')
          [CompletionResult]::new('-B[<n>][/<m>]', '-B[<n>][/<m>]', [CompletionResultType]::ParameterName, 'Break complete rewrite changes into pairs of delete and create')
          [CompletionResult]::new('--break-rewrites[=[<n>][/<m>]]', '--break-rewrites[=[<n>][/<m>]]', [CompletionResultType]::ParameterName, 'Break complete rewrite changes into pairs of delete and create')
          [CompletionResult]::new('-M[<n>]', '-M[<n>]', [CompletionResultType]::ParameterName, 'Detect renames')
          [CompletionResult]::new('--find-renames[=<n>]', '--find-renames[=<n>]', [CompletionResultType]::ParameterName, 'Detect renames')
          [CompletionResult]::new('-C[<n>]', '-C[<n>]', [CompletionResultType]::ParameterName, 'Detect copies as well as renames')
          [CompletionResult]::new('--find-copies[=<n>]', '--find-copies[=<n>]', [CompletionResultType]::ParameterName, 'Detect copies as well as renames')
          [CompletionResult]::new('--find-copies-harder', '--find-copies-harder', [CompletionResultType]::ParameterName, 'For performance reasons, by default, -C option finds copies only if the original file of the copy was modified in the same changeset')
          [CompletionResult]::new('-D', '-D', [CompletionResultType]::ParameterName, 'Omit the preimage for deletes, i')
          [CompletionResult]::new('--irreversible-delete', '--irreversible-delete', [CompletionResultType]::ParameterName, 'Omit the preimage for deletes, i')
          [CompletionResult]::new('-l<num>', '-l<num>', [CompletionResultType]::ParameterName, 'The -M and -C options involve some preliminary steps that can detect subsets of renames/copies cheaply, followed by an exhaustive fallback portion that compares all remaining unpaired destinations to all relevant sources')
          [CompletionResult]::new('--diff-filter=[(A|C|D|M|R|T|U|X|B)…​[*]]', '--diff-filter=[(A|C|D|M|R|T|U|X|B)…​[*]]', [CompletionResultType]::ParameterName, 'Select only files that are Added (A), Copied (C), Deleted (D), Modified (M), Renamed (R), have their type (i')
          [CompletionResult]::new('-S<string>', '-S<string>', [CompletionResultType]::ParameterName, 'Look for differences that change the number of occurrences of the specified string (i')
          [CompletionResult]::new('-G<regex>', '-G<regex>', [CompletionResultType]::ParameterName, 'Look for differences whose patch text contains added/removed lines that match <regex>')
          [CompletionResult]::new('--find-object=<object-id>', '--find-object=<object-id>', [CompletionResultType]::ParameterName, 'Look for differences that change the number of occurrences of the specified object')
          [CompletionResult]::new('--pickaxe-all', '--pickaxe-all', [CompletionResultType]::ParameterName, 'When -S or -G finds a change, show all the changes in that changeset, not just the files that contain the change in <string>')
          [CompletionResult]::new('--pickaxe-regex', '--pickaxe-regex', [CompletionResultType]::ParameterName, 'Treat the <string> given to -S as an extended POSIX regular expression to match')
          [CompletionResult]::new('-O<orderfile>', '-O<orderfile>', [CompletionResultType]::ParameterName, 'Control the order in which files appear in the output')
          [CompletionResult]::new('--skip-to=<file>', '--skip-to=<file>', [CompletionResultType]::ParameterName, 'Discard the files before the named <file> from the output (i')
          [CompletionResult]::new('--rotate-to=<file>', '--rotate-to=<file>', [CompletionResultType]::ParameterName, 'Discard the files before the named <file> from the output (i')
          [CompletionResult]::new('-R', '-R', [CompletionResultType]::ParameterName, 'Swap two inputs; that is, show differences from index or on-disk file to tree contents')
          [CompletionResult]::new('--relative[=<path>]', '--relative[=<path>]', [CompletionResultType]::ParameterName, 'When run from a subdirectory of the project, it can be told to exclude changes outside the directory and show pathnames relative to it with this option')
          [CompletionResult]::new('--no-relative', '--no-relative', [CompletionResultType]::ParameterName, 'When run from a subdirectory of the project, it can be told to exclude changes outside the directory and show pathnames relative to it with this option')
          [CompletionResult]::new('-a', '-a', [CompletionResultType]::ParameterName, 'Treat all files as text')
          [CompletionResult]::new('--text', '--text', [CompletionResultType]::ParameterName, 'Treat all files as text')
          [CompletionResult]::new('--ignore-cr-at-eol', '--ignore-cr-at-eol', [CompletionResultType]::ParameterName, 'Ignore carriage-return at the end of line when doing a comparison')
          [CompletionResult]::new('--ignore-space-at-eol', '--ignore-space-at-eol', [CompletionResultType]::ParameterName, 'Ignore changes in whitespace at EOL')
          [CompletionResult]::new('-b', '-b', [CompletionResultType]::ParameterName, 'Ignore changes in amount of whitespace')
          [CompletionResult]::new('--ignore-space-change', '--ignore-space-change', [CompletionResultType]::ParameterName, 'Ignore changes in amount of whitespace')
          [CompletionResult]::new('-w', '-w', [CompletionResultType]::ParameterName, 'Ignore whitespace when comparing lines')
          [CompletionResult]::new('--ignore-all-space', '--ignore-all-space', [CompletionResultType]::ParameterName, 'Ignore whitespace when comparing lines')
          [CompletionResult]::new('--ignore-blank-lines', '--ignore-blank-lines', [CompletionResultType]::ParameterName, 'Ignore changes whose lines are all blank')
          [CompletionResult]::new('-I<regex>', '-I<regex>', [CompletionResultType]::ParameterName, 'Ignore changes whose all lines match <regex>')
          [CompletionResult]::new('--ignore-matching-lines=<regex>', '--ignore-matching-lines=<regex>', [CompletionResultType]::ParameterName, 'Ignore changes whose all lines match <regex>')
          [CompletionResult]::new('--inter-hunk-context=<lines>', '--inter-hunk-context=<lines>', [CompletionResultType]::ParameterName, 'Show the context between diff hunks, up to the specified number of lines, thereby fusing hunks that are close to each other')
          [CompletionResult]::new('-W', '-W', [CompletionResultType]::ParameterName, 'Show whole function as context lines for each change')
          [CompletionResult]::new('--function-context', '--function-context', [CompletionResultType]::ParameterName, 'Show whole function as context lines for each change')
          [CompletionResult]::new('--exit-code', '--exit-code', [CompletionResultType]::ParameterName, 'Make the program exit with codes similar to diff(1)')
          [CompletionResult]::new('--quiet', '--quiet', [CompletionResultType]::ParameterName, 'Disable all output of the program')
          [CompletionResult]::new('--ext-diff', '--ext-diff', [CompletionResultType]::ParameterName, 'Allow an external diff helper to be executed')
          [CompletionResult]::new('--no-ext-diff', '--no-ext-diff', [CompletionResultType]::ParameterName, 'Disallow external diff drivers')
          [CompletionResult]::new('--textconv', '--textconv', [CompletionResultType]::ParameterName, 'Allow (or disallow) external text conversion filters to be run when comparing binary files')
          [CompletionResult]::new('--no-textconv', '--no-textconv', [CompletionResultType]::ParameterName, 'Allow (or disallow) external text conversion filters to be run when comparing binary files')
          [CompletionResult]::new('--ignore-submodules[=<when>]', '--ignore-submodules[=<when>]', [CompletionResultType]::ParameterName, 'Ignore changes to submodules in the diff generation')
          [CompletionResult]::new('--src-prefix=<prefix>', '--src-prefix=<prefix>', [CompletionResultType]::ParameterName, 'Show the given source prefix instead of "a/"')
          [CompletionResult]::new('--dst-prefix=<prefix>', '--dst-prefix=<prefix>', [CompletionResultType]::ParameterName, 'Show the given destination prefix instead of "b/"')
          [CompletionResult]::new('--no-prefix', '--no-prefix', [CompletionResultType]::ParameterName, 'Do not show any source or destination prefix')
          [CompletionResult]::new('--default-prefix', '--default-prefix', [CompletionResultType]::ParameterName, 'Use the default source and destination prefixes ("a/" and "b/")')
          [CompletionResult]::new('--line-prefix=<prefix>', '--line-prefix=<prefix>', [CompletionResultType]::ParameterName, 'Prepend an additional prefix to every line of output')
          [CompletionResult]::new('--ita-invisible-in-index', '--ita-invisible-in-index', [CompletionResultType]::ParameterName, 'By default entries added by "git add -N" appear as an existing empty file in "git diff" and a new file in "git diff --cached"')
        }
        break
      }
      'for-each-ref' {
        if ($wordToComplete.StartsWith('-')) {
          [CompletionResult]::new('<pattern>…​', '<pattern>…​', [CompletionResultType]::ParameterName, 'If one or more patterns are given, only refs are shown that match against at least one pattern, either using fnmatch(3) or literally, in the latter case matching completely or from the beginning up to a slash')
          [CompletionResult]::new('--stdin', '--stdin', [CompletionResultType]::ParameterName, 'If --stdin is supplied, then the list of patterns is read from standard input instead of from the argument list')
          [CompletionResult]::new('--count=<count>', '--count=<count>', [CompletionResultType]::ParameterName, 'By default the command shows all refs that match <pattern>')
          [CompletionResult]::new('--sort=<key>', '--sort=<key>', [CompletionResultType]::ParameterName, 'A field name to sort on')
          [CompletionResult]::new('--format=<format>', '--format=<format>', [CompletionResultType]::ParameterName, 'A string that interpolates %(fieldname) from a ref being shown and the object it points at')
          [CompletionResult]::new('--color[=<when>]', '--color[=<when>]', [CompletionResultType]::ParameterName, 'Respect any colors specified in the --format option')
          [CompletionResult]::new('--shell', '--shell', [CompletionResultType]::ParameterName, 'If given, strings that substitute %(fieldname) placeholders are quoted as string literals suitable for the specified host language')
          [CompletionResult]::new('--perl', '--perl', [CompletionResultType]::ParameterName, 'If given, strings that substitute %(fieldname) placeholders are quoted as string literals suitable for the specified host language')
          [CompletionResult]::new('--python', '--python', [CompletionResultType]::ParameterName, 'If given, strings that substitute %(fieldname) placeholders are quoted as string literals suitable for the specified host language')
          [CompletionResult]::new('--tcl', '--tcl', [CompletionResultType]::ParameterName, 'If given, strings that substitute %(fieldname) placeholders are quoted as string literals suitable for the specified host language')
          [CompletionResult]::new('--points-at=<object>', '--points-at=<object>', [CompletionResultType]::ParameterName, 'Only list refs which points at the given object')
          [CompletionResult]::new('--merged[=<object>]', '--merged[=<object>]', [CompletionResultType]::ParameterName, 'Only list refs whose tips are reachable from the specified commit (HEAD if not specified)')
          [CompletionResult]::new('--no-merged[=<object>]', '--no-merged[=<object>]', [CompletionResultType]::ParameterName, 'Only list refs whose tips are not reachable from the specified commit (HEAD if not specified)')
          [CompletionResult]::new('--contains[=<object>]', '--contains[=<object>]', [CompletionResultType]::ParameterName, 'Only list refs which contain the specified commit (HEAD if not specified)')
          [CompletionResult]::new('--no-contains[=<object>]', '--no-contains[=<object>]', [CompletionResultType]::ParameterName, "Only list refs which don't contain the specified commit (HEAD if not specified)")
          [CompletionResult]::new('--ignore-case', '--ignore-case', [CompletionResultType]::ParameterName, 'Sorting and filtering refs are case insensitive')
          [CompletionResult]::new('--omit-empty', '--omit-empty', [CompletionResultType]::ParameterName, 'Do not print a newline after formatted refs where the format expands to the empty string')
          [CompletionResult]::new('--exclude=<pattern>', '--exclude=<pattern>', [CompletionResultType]::ParameterName, 'If one or more patterns are given, only refs which do not match any excluded pattern(s) are shown')
          [CompletionResult]::new('--include-root-refs', '--include-root-refs', [CompletionResultType]::ParameterName, 'List root refs (HEAD and pseudorefs) apart from regular refs')
        }
        break
      }
      'for-each-repo' {
        if ($wordToComplete.StartsWith('-')) {
          [CompletionResult]::new('--config=<config>', '--config=<config>', [CompletionResultType]::ParameterName, 'Use the given config variable as a multi-valued list storing absolute path names')
          [CompletionResult]::new('--keep-going', '--keep-going', [CompletionResultType]::ParameterName, 'Continue with the remaining repositories if the command failed on a repository')
        }
        break
      }
      'get-tar-commit-id' { break }
      'ls-files' {
        if ($wordToComplete.StartsWith('-')) {
          [CompletionResult]::new('-c', '-c', [CompletionResultType]::ParameterName, "Show all files cached in Git's index, i")
          [CompletionResult]::new('--cached', '--cached', [CompletionResultType]::ParameterName, "Show all files cached in Git's index, i")
          [CompletionResult]::new('-d', '-d', [CompletionResultType]::ParameterName, 'Show files with an unstaged deletion')
          [CompletionResult]::new('--deleted', '--deleted', [CompletionResultType]::ParameterName, 'Show files with an unstaged deletion')
          [CompletionResult]::new('-m', '-m', [CompletionResultType]::ParameterName, 'Show files with an unstaged modification (note that an unstaged deletion also counts as an unstaged modification)')
          [CompletionResult]::new('--modified', '--modified', [CompletionResultType]::ParameterName, 'Show files with an unstaged modification (note that an unstaged deletion also counts as an unstaged modification)')
          [CompletionResult]::new('-o', '-o', [CompletionResultType]::ParameterName, 'Show other (i')
          [CompletionResult]::new('--others', '--others', [CompletionResultType]::ParameterName, 'Show other (i')
          [CompletionResult]::new('-i', '-i', [CompletionResultType]::ParameterName, 'Show only ignored files in the output')
          [CompletionResult]::new('--ignored', '--ignored', [CompletionResultType]::ParameterName, 'Show only ignored files in the output')
          [CompletionResult]::new('-s', '-s', [CompletionResultType]::ParameterName, "Show staged contents' mode bits, object name and stage number in the output")
          [CompletionResult]::new('--stage', '--stage', [CompletionResultType]::ParameterName, "Show staged contents' mode bits, object name and stage number in the output")
          [CompletionResult]::new('--directory', '--directory', [CompletionResultType]::ParameterName, 'If a whole directory is classified as "other", show just its name (with a trailing slash) and not its whole contents')
          [CompletionResult]::new('--no-empty-directory', '--no-empty-directory', [CompletionResultType]::ParameterName, 'Do not list empty directories')
          [CompletionResult]::new('-u', '-u', [CompletionResultType]::ParameterName, 'Show information about unmerged files in the output, but do not show any other tracked files (forces --stage, overrides --cached)')
          [CompletionResult]::new('--unmerged', '--unmerged', [CompletionResultType]::ParameterName, 'Show information about unmerged files in the output, but do not show any other tracked files (forces --stage, overrides --cached)')
          [CompletionResult]::new('-k', '-k', [CompletionResultType]::ParameterName, 'Show untracked files on the filesystem that need to be removed due to file/directory conflicts for tracked files to be able to be written to the filesystem')
          [CompletionResult]::new('--killed', '--killed', [CompletionResultType]::ParameterName, 'Show untracked files on the filesystem that need to be removed due to file/directory conflicts for tracked files to be able to be written to the filesystem')
          [CompletionResult]::new('--resolve-undo', '--resolve-undo', [CompletionResultType]::ParameterName, 'Show files having resolve-undo information in the index together with their resolve-undo information')
          [CompletionResult]::new('-z', '-z', [CompletionResultType]::ParameterName, '\0 line termination on output and do not quote filenames')
          [CompletionResult]::new('--deduplicate', '--deduplicate', [CompletionResultType]::ParameterName, 'When only filenames are shown, suppress duplicates that may come from having multiple stages during a merge, or giving --deleted and --modified option at the same time')
          [CompletionResult]::new('-x', '-x', [CompletionResultType]::ParameterName, 'Skip untracked files matching pattern')
          [CompletionResult]::new('--exclude=<pattern>', '--exclude=<pattern>', [CompletionResultType]::ParameterName, 'Skip untracked files matching pattern')
          [CompletionResult]::new('-X', '-X', [CompletionResultType]::ParameterName, 'Read exclude patterns from <file>; 1 per line')
          [CompletionResult]::new('--exclude-from=<file>', '--exclude-from=<file>', [CompletionResultType]::ParameterName, 'Read exclude patterns from <file>; 1 per line')
          [CompletionResult]::new('--exclude-per-directory=<file>', '--exclude-per-directory=<file>', [CompletionResultType]::ParameterName, 'Read additional exclude patterns that apply only to the directory and its subdirectories in <file>')
          [CompletionResult]::new('--exclude-standard', '--exclude-standard', [CompletionResultType]::ParameterName, 'Add the standard Git exclusions:')
          [CompletionResult]::new('--error-unmatch', '--error-unmatch', [CompletionResultType]::ParameterName, 'If any <file> does not appear in the index, treat this as an error (return 1)')
          [CompletionResult]::new('--with-tree=<tree-ish>', '--with-tree=<tree-ish>', [CompletionResultType]::ParameterName, 'When using --error-unmatch to expand the user supplied <file> (i')
          [CompletionResult]::new('-t', '-t', [CompletionResultType]::ParameterName, 'Show status tags together with filenames')
          [CompletionResult]::new('-v', '-v', [CompletionResultType]::ParameterName, 'Similar to -t, but use lowercase letters for files that are marked as assume unchanged (see git-update-index(1))')
          [CompletionResult]::new('-f', '-f', [CompletionResultType]::ParameterName, 'Similar to -t, but use lowercase letters for files that are marked as fsmonitor valid (see git-update-index(1))')
          [CompletionResult]::new('--full-name', '--full-name', [CompletionResultType]::ParameterName, 'When run from a subdirectory, the command usually outputs paths relative to the current directory')
          [CompletionResult]::new('--recurse-submodules', '--recurse-submodules', [CompletionResultType]::ParameterName, 'Recursively calls ls-files on each active submodule in the repository')
          [CompletionResult]::new('--abbrev[=<n>]', '--abbrev[=<n>]', [CompletionResultType]::ParameterName, 'Instead of showing the full 40-byte hexadecimal object lines, show the shortest prefix that is at least <n> hexdigits long that uniquely refers the object')
          [CompletionResult]::new('--debug', '--debug', [CompletionResultType]::ParameterName, 'After each line that describes a file, add more data about its cache entry')
          [CompletionResult]::new('--eol', '--eol', [CompletionResultType]::ParameterName, 'Show <eolinfo> and <eolattr> of files')
          [CompletionResult]::new('--sparse', '--sparse', [CompletionResultType]::ParameterName, 'If the index is sparse, show the sparse directories without expanding to the contained files')
          [CompletionResult]::new('--format=<format>', '--format=<format>', [CompletionResultType]::ParameterName, 'A string that interpolates %(fieldname) from the result being shown')
          [CompletionResult]::new('--', '--', [CompletionResultType]::ParameterName, 'Do not interpret any more arguments as options')
          [CompletionResult]::new('<file>', '<file>', [CompletionResultType]::ParameterName, 'Files to show')
        }
        break
      }
      'ls-remote' {
        if ($wordToComplete.StartsWith('-')) {
          [CompletionResult]::new('-b', '-b', [CompletionResultType]::ParameterName, 'Limit to only local branches and local tags, respectively')
          [CompletionResult]::new('--branches', '--branches', [CompletionResultType]::ParameterName, 'Limit to only local branches and local tags, respectively')
          [CompletionResult]::new('-t', '-t', [CompletionResultType]::ParameterName, 'Limit to only local branches and local tags, respectively')
          [CompletionResult]::new('--tags', '--tags', [CompletionResultType]::ParameterName, 'Limit to only local branches and local tags, respectively')
          [CompletionResult]::new('--refs', '--refs', [CompletionResultType]::ParameterName, 'Do not show peeled tags or pseudorefs like HEAD in the output')
          [CompletionResult]::new('-q', '-q', [CompletionResultType]::ParameterName, 'Do not print remote URL to stderr')
          [CompletionResult]::new('--quiet', '--quiet', [CompletionResultType]::ParameterName, 'Do not print remote URL to stderr')
          [CompletionResult]::new('--upload-pack=<exec>', '--upload-pack=<exec>', [CompletionResultType]::ParameterName, 'Specify the full path of git-upload-pack on the remote host')
          [CompletionResult]::new('--exit-code', '--exit-code', [CompletionResultType]::ParameterName, 'Exit with status "2" when no matching refs are found in the remote repository')
          [CompletionResult]::new('--get-url', '--get-url', [CompletionResultType]::ParameterName, 'Expand the URL of the given remote repository taking into account any "url')
          [CompletionResult]::new('--symref', '--symref', [CompletionResultType]::ParameterName, 'In addition to the object pointed by it, show the underlying ref pointed by it when showing a symbolic ref')
          [CompletionResult]::new('--sort=<key>', '--sort=<key>', [CompletionResultType]::ParameterName, 'Sort based on the key given')
          [CompletionResult]::new('-o', '-o', [CompletionResultType]::ParameterName, 'Transmit the given string to the server when communicating using protocol version 2')
          [CompletionResult]::new('--server-option=<option>', '--server-option=<option>', [CompletionResultType]::ParameterName, 'Transmit the given string to the server when communicating using protocol version 2')
          [CompletionResult]::new('<repository>', '<repository>', [CompletionResultType]::ParameterName, 'The "remote" repository to query')
          [CompletionResult]::new('<patterns>…​', '<patterns>…​', [CompletionResultType]::ParameterName, 'When unspecified, all references, after filtering done with --heads and --tags, are shown')
        }
        break
      }
      'ls-tree' {
        if ($wordToComplete.StartsWith('-')) {
          [CompletionResult]::new('<tree-ish>', '<tree-ish>', [CompletionResultType]::ParameterName, 'Id of a tree-ish')
          [CompletionResult]::new('-d', '-d', [CompletionResultType]::ParameterName, 'Show only the named tree entry itself, not its children')
          [CompletionResult]::new('-r', '-r', [CompletionResultType]::ParameterName, 'Recurse into sub-trees')
          [CompletionResult]::new('-t', '-t', [CompletionResultType]::ParameterName, 'Show tree entries even when going to recurse them')
          [CompletionResult]::new('-l', '-l', [CompletionResultType]::ParameterName, 'Show object size of blob (file) entries')
          [CompletionResult]::new('--long', '--long', [CompletionResultType]::ParameterName, 'Show object size of blob (file) entries')
          [CompletionResult]::new('-z', '-z', [CompletionResultType]::ParameterName, '\0 line termination on output and do not quote filenames')
          [CompletionResult]::new('--name-only', '--name-only', [CompletionResultType]::ParameterName, 'List only filenames (instead of the "long" output), one per line')
          [CompletionResult]::new('--name-status', '--name-status', [CompletionResultType]::ParameterName, 'List only filenames (instead of the "long" output), one per line')
          [CompletionResult]::new('--object-only', '--object-only', [CompletionResultType]::ParameterName, 'List only names of the objects, one per line')
          [CompletionResult]::new('--abbrev[=<n>]', '--abbrev[=<n>]', [CompletionResultType]::ParameterName, 'Instead of showing the full 40-byte hexadecimal object lines, show the shortest prefix that is at least <n> hexdigits long that uniquely refers the object')
          [CompletionResult]::new('--full-name', '--full-name', [CompletionResultType]::ParameterName, 'Instead of showing the path names relative to the current working directory, show the full path names')
          [CompletionResult]::new('--full-tree', '--full-tree', [CompletionResultType]::ParameterName, 'Do not limit the listing to the current working directory')
          [CompletionResult]::new('--format=<format>', '--format=<format>', [CompletionResultType]::ParameterName, 'A string that interpolates %(fieldname) from the result being shown')
          [CompletionResult]::new('[<path>…​]', '[<path>…​]', [CompletionResultType]::ParameterName, "When paths are given, show them (note that this isn't really raw pathnames, but rather a list of patterns to match)")
        }
        break
      }
      'merge-base' {
        if ($wordToComplete.StartsWith('-')) {
          [CompletionResult]::new('--octopus', '--octopus', [CompletionResultType]::ParameterName, 'Compute the best common ancestors of all supplied commits, in preparation for an n-way merge')
          [CompletionResult]::new('--independent', '--independent', [CompletionResultType]::ParameterName, 'Instead of printing merge bases, print a minimal subset of the supplied commits with the same ancestors')
          [CompletionResult]::new('--is-ancestor', '--is-ancestor', [CompletionResultType]::ParameterName, 'Check if the first <commit> is an ancestor of the second <commit>, and exit with status 0 if true, or with status 1 if not')
          [CompletionResult]::new('--fork-point', '--fork-point', [CompletionResultType]::ParameterName, 'Find the point at which a branch (or any history that leads to <commit>) forked from another branch (or any reference) <ref>')
        }
        break
      }
      'name-rev' {
        if ($wordToComplete.StartsWith('-')) {
          [CompletionResult]::new('--tags', '--tags', [CompletionResultType]::ParameterName, 'Do not use branch names, but only tags to name the commits')
          [CompletionResult]::new('--refs=<pattern>', '--refs=<pattern>', [CompletionResultType]::ParameterName, 'Only use refs whose names match a given shell pattern')
          [CompletionResult]::new('--exclude=<pattern>', '--exclude=<pattern>', [CompletionResultType]::ParameterName, 'Do not use any ref whose name matches a given shell pattern')
          [CompletionResult]::new('--all', '--all', [CompletionResultType]::ParameterName, 'List all commits reachable from all refs')
          [CompletionResult]::new('--annotate-stdin', '--annotate-stdin', [CompletionResultType]::ParameterName, 'Transform stdin by substituting all the 40-character SHA-1 hexes (say $hex) with "$hex ($rev_name)"')
          [CompletionResult]::new('--name-only', '--name-only', [CompletionResultType]::ParameterName, 'Instead of printing both the SHA-1 and the name, print only the name')
          [CompletionResult]::new('--no-undefined', '--no-undefined', [CompletionResultType]::ParameterName, 'Die with error code != 0 when a reference is undefined, instead of printing undefined')
          [CompletionResult]::new('--always', '--always', [CompletionResultType]::ParameterName, 'Show uniquely abbreviated commit object as fallback')
        }
        break
      }
      'pack-redundant' {
        if ($wordToComplete.StartsWith('-')) {
        }
        break
      }
      'rev-list' {
        if ($wordToComplete.StartsWith('-')) {
        }
        break
      }
      'rev-parse' {
        if ($wordToComplete.StartsWith('-')) {
          [CompletionResult]::new('--parseopt', '--parseopt', [CompletionResultType]::ParameterName, 'Use git rev-parse in option parsing mode (see PARSEOPT section below)')
          [CompletionResult]::new('--sq-quote', '--sq-quote', [CompletionResultType]::ParameterName, 'Use git rev-parse in shell quoting mode (see SQ-QUOTE section below)')
          [CompletionResult]::new('--keep-dashdash', '--keep-dashdash', [CompletionResultType]::ParameterName, 'Only meaningful in --parseopt mode')
          [CompletionResult]::new('--stop-at-non-option', '--stop-at-non-option', [CompletionResultType]::ParameterName, 'Only meaningful in --parseopt mode')
          [CompletionResult]::new('--stuck-long', '--stuck-long', [CompletionResultType]::ParameterName, 'Only meaningful in --parseopt mode')
          [CompletionResult]::new('--revs-only', '--revs-only', [CompletionResultType]::ParameterName, 'Do not output flags and parameters not meant for git rev-list command')
          [CompletionResult]::new('--no-revs', '--no-revs', [CompletionResultType]::ParameterName, 'Do not output flags and parameters meant for git rev-list command')
          [CompletionResult]::new('--flags', '--flags', [CompletionResultType]::ParameterName, 'Do not output non-flag parameters')
          [CompletionResult]::new('--no-flags', '--no-flags', [CompletionResultType]::ParameterName, 'Do not output flag parameters')
          [CompletionResult]::new('--default', '--default', [CompletionResultType]::ParameterName, 'If there is no parameter given by the user, use <arg> instead')
          [CompletionResult]::new('--prefix', '--prefix', [CompletionResultType]::ParameterName, 'Behave as if git rev-parse was invoked from the <arg> subdirectory of the working tree')
          [CompletionResult]::new('--verify', '--verify', [CompletionResultType]::ParameterName, 'Verify that exactly one parameter is provided, and that it can be turned into a raw 20-byte SHA-1 that can be used to access the object database')
          [CompletionResult]::new('-q', '-q', [CompletionResultType]::ParameterName, 'Only meaningful in --verify mode')
          [CompletionResult]::new('--quiet', '--quiet', [CompletionResultType]::ParameterName, 'Only meaningful in --verify mode')
          [CompletionResult]::new('--sq', '--sq', [CompletionResultType]::ParameterName, 'Usually the output is made one line per flag and parameter')
          [CompletionResult]::new('--short[=<length>]', '--short[=<length>]', [CompletionResultType]::ParameterName, 'Same as --verify but shortens the object name to a unique prefix with at least length characters')
          [CompletionResult]::new('--not', '--not', [CompletionResultType]::ParameterName, 'When showing object names, prefix them with ^ and strip ^ prefix from the object names that already have one')
          [CompletionResult]::new('--abbrev-ref[=(strict|loose)]', '--abbrev-ref[=(strict|loose)]', [CompletionResultType]::ParameterName, 'A non-ambiguous short name of the objects name')
          [CompletionResult]::new('--symbolic', '--symbolic', [CompletionResultType]::ParameterName, 'Usually the object names are output in SHA-1 form (with possible ^ prefix); this option makes them output in a form as close to the original input as possible')
          [CompletionResult]::new('--symbolic-full-name', '--symbolic-full-name', [CompletionResultType]::ParameterName, 'This is similar to --symbolic, but it omits input that are not refs (i')
          [CompletionResult]::new('--output-object-format=(sha1|sha256|storage)', '--output-object-format=(sha1|sha256|storage)', [CompletionResultType]::ParameterName, 'Allow oids to be input from any object format that the current repository supports')
          [CompletionResult]::new('--all', '--all', [CompletionResultType]::ParameterName, 'Show all refs found in refs/')
          [CompletionResult]::new('--branches[=<pattern>]', '--branches[=<pattern>]', [CompletionResultType]::ParameterName, 'Show all branches, tags, or remote-tracking branches, respectively (i')
          [CompletionResult]::new('--tags[=<pattern>]', '--tags[=<pattern>]', [CompletionResultType]::ParameterName, 'Show all branches, tags, or remote-tracking branches, respectively (i')
          [CompletionResult]::new('--remotes[=<pattern>]', '--remotes[=<pattern>]', [CompletionResultType]::ParameterName, 'Show all branches, tags, or remote-tracking branches, respectively (i')
          [CompletionResult]::new('--glob=<pattern>', '--glob=<pattern>', [CompletionResultType]::ParameterName, 'Show all refs matching the shell glob pattern pattern')
          [CompletionResult]::new('--exclude=<glob-pattern>', '--exclude=<glob-pattern>', [CompletionResultType]::ParameterName, 'Do not include refs matching <glob-pattern> that the next --all, --branches, --tags, --remotes, or --glob would otherwise consider')
          [CompletionResult]::new('--exclude-hidden=(fetch|receive|uploadpack)', '--exclude-hidden=(fetch|receive|uploadpack)', [CompletionResultType]::ParameterName, 'Do not include refs that would be hidden by git-fetch, git-receive-pack or git-upload-pack by consulting the appropriate fetch')
          [CompletionResult]::new('--disambiguate=<prefix>', '--disambiguate=<prefix>', [CompletionResultType]::ParameterName, 'Show every object whose name begins with the given prefix')
          [CompletionResult]::new('--local-env-vars', '--local-env-vars', [CompletionResultType]::ParameterName, 'List the GIT_* environment variables that are local to the repository (e')
          [CompletionResult]::new('--path-format=(absolute|relative)', '--path-format=(absolute|relative)', [CompletionResultType]::ParameterName, 'Controls the behavior of certain other options')
          [CompletionResult]::new('--git-dir', '--git-dir', [CompletionResultType]::ParameterName, 'Show $GIT_DIR if defined')
          [CompletionResult]::new('--git-common-dir', '--git-common-dir', [CompletionResultType]::ParameterName, 'Show $GIT_COMMON_DIR if defined, else $GIT_DIR')
          [CompletionResult]::new('--resolve-git-dir', '--resolve-git-dir', [CompletionResultType]::ParameterName, 'Check if <path> is a valid repository or a gitfile that points at a valid repository, and print the location of the repository')
          [CompletionResult]::new('--git-path', '--git-path', [CompletionResultType]::ParameterName, 'Resolve "$GIT_DIR/<path>" and takes other path relocation variables such as $GIT_OBJECT_DIRECTORY, $GIT_INDEX_FILE…​ into account')
          [CompletionResult]::new('--show-toplevel', '--show-toplevel', [CompletionResultType]::ParameterName, 'Show the (by default, absolute) path of the top-level directory of the working tree')
          [CompletionResult]::new('--show-superproject-working-tree', '--show-superproject-working-tree', [CompletionResultType]::ParameterName, "Show the absolute path of the root of the superproject's working tree (if exists) that uses the current repository as its submodule")
          [CompletionResult]::new('--shared-index-path', '--shared-index-path', [CompletionResultType]::ParameterName, 'Show the path to the shared index file in split index mode, or empty if not in split-index mode')
          [CompletionResult]::new('--since=<datestring>', '--since=<datestring>', [CompletionResultType]::ParameterName, 'Parse the date string, and output the corresponding --max-age= parameter for git rev-list')
          [CompletionResult]::new('--after=<datestring>', '--after=<datestring>', [CompletionResultType]::ParameterName, 'Parse the date string, and output the corresponding --max-age= parameter for git rev-list')
          [CompletionResult]::new('--until=<datestring>', '--until=<datestring>', [CompletionResultType]::ParameterName, 'Parse the date string, and output the corresponding --min-age= parameter for git rev-list')
          [CompletionResult]::new('--before=<datestring>', '--before=<datestring>', [CompletionResultType]::ParameterName, 'Parse the date string, and output the corresponding --min-age= parameter for git rev-list')
          [CompletionResult]::new('<arg>…​', '<arg>…​', [CompletionResultType]::ParameterName, 'Flags and parameters to be parsed')
        }
        break
      }
      'show-index' {
        if ($wordToComplete.StartsWith('-')) {
        }
        break
      }
      'show-ref' {
        if ($wordToComplete.StartsWith('-')) {
          [CompletionResult]::new('--head', '--head', [CompletionResultType]::ParameterName, 'Show the HEAD reference, even if it would normally be filtered out')
          [CompletionResult]::new('--branches', '--branches', [CompletionResultType]::ParameterName, 'Limit to local branches and local tags, respectively')
          [CompletionResult]::new('--tags', '--tags', [CompletionResultType]::ParameterName, 'Limit to local branches and local tags, respectively')
          [CompletionResult]::new('-d', '-d', [CompletionResultType]::ParameterName, 'Dereference tags into object IDs as well')
          [CompletionResult]::new('--dereference', '--dereference', [CompletionResultType]::ParameterName, 'Dereference tags into object IDs as well')
          [CompletionResult]::new('-s', '-s', [CompletionResultType]::ParameterName, 'Only show the OID, not the reference name')
          [CompletionResult]::new('--hash[=<n>]', '--hash[=<n>]', [CompletionResultType]::ParameterName, 'Only show the OID, not the reference name')
          [CompletionResult]::new('--verify', '--verify', [CompletionResultType]::ParameterName, 'Enable stricter reference checking by requiring an exact ref path')
          [CompletionResult]::new('--exists', '--exists', [CompletionResultType]::ParameterName, 'Check whether the given reference exists')
          [CompletionResult]::new('--abbrev[=<n>]', '--abbrev[=<n>]', [CompletionResultType]::ParameterName, 'Abbreviate the object name')
          [CompletionResult]::new('-q', '-q', [CompletionResultType]::ParameterName, 'Do not print any results to stdout')
          [CompletionResult]::new('--quiet', '--quiet', [CompletionResultType]::ParameterName, 'Do not print any results to stdout')
          [CompletionResult]::new('--exclude-existing[=<pattern>]', '--exclude-existing[=<pattern>]', [CompletionResultType]::ParameterName, 'Make git show-ref act as a filter that reads refs from stdin of the form ^(?:<anything>\s)?<refname>(?:\^{})?$ and performs the following actions on each: (1) strip ^{} at the end of line if any; (2) ignore if pattern is provided and does not head-match refname; (3) warn if refname is not a well-formed refname and skip; (4) ignore if refname is a ref that exists in the local repository; (5) otherwise output the line')
          [CompletionResult]::new('<pattern>…​', '<pattern>…​', [CompletionResultType]::ParameterName, 'Show references matching one or more patterns')
        }
        break
      }
      'unpack-file' {
        if ($commandAst.CommandElements.Count -le 3) {
          [CompletionResult]::new('<blob>', '<blob>', [CompletionResultType]::ParameterName, 'Must be a blob id')
        }
        break
      }
      'var' {
        if ($wordToComplete.StartsWith('-')) {
          [CompletionResult]::new('-l', '-l', [CompletionResultType]::ParameterName, 'Display the logical variables')
        }
        break
      }
      'verify-pack' {
        if ($wordToComplete.StartsWith('-')) {
          [CompletionResult]::new('<pack>.idx', '<pack>.idx', [CompletionResultType]::ParameterName, 'The idx files to verify')
          [CompletionResult]::new('-v', '-v', [CompletionResultType]::ParameterName, 'After verifying the pack, show the list of objects contained in the pack and a histogram of delta chain length')
          [CompletionResult]::new('--verbose', '--verbose', [CompletionResultType]::ParameterName, 'After verifying the pack, show the list of objects contained in the pack and a histogram of delta chain length')
          [CompletionResult]::new('-s', '-s', [CompletionResultType]::ParameterName, 'Do not verify the pack contents; only show the histogram of delta chain length')
          [CompletionResult]::new('--stat-only', '--stat-only', [CompletionResultType]::ParameterName, 'Do not verify the pack contents; only show the histogram of delta chain length')
          [CompletionResult]::new('--', '--', [CompletionResultType]::ParameterName, 'Do not interpret any more arguments as options')
        }
        break
      }
      'daemon' {
        if ($wordToComplete.StartsWith('-')) {
          [CompletionResult]::new('--strict-paths', '--strict-paths', [CompletionResultType]::ParameterName, 'Match paths exactly (i')
          [CompletionResult]::new('--base-path=<path>', '--base-path=<path>', [CompletionResultType]::ParameterName, 'Remap all the path requests as relative to the given path')
          [CompletionResult]::new('--base-path-relaxed', '--base-path-relaxed', [CompletionResultType]::ParameterName, 'If --base-path is enabled and repo lookup fails, with this option git daemon will attempt to lookup without prefixing the base path')
          [CompletionResult]::new('--interpolated-path=<pathtemplate>', '--interpolated-path=<pathtemplate>', [CompletionResultType]::ParameterName, 'To support virtual hosting, an interpolated path template can be used to dynamically construct alternate paths')
          [CompletionResult]::new('--export-all', '--export-all', [CompletionResultType]::ParameterName, 'Allow pulling from all directories that look like Git repositories (have the objects and refs subdirectories), even if they do not have the git-daemon-export-ok file')
          [CompletionResult]::new('--inetd', '--inetd', [CompletionResultType]::ParameterName, 'Have the server run as an inetd service')
          [CompletionResult]::new('--listen=<host-or-ipaddr>', '--listen=<host-or-ipaddr>', [CompletionResultType]::ParameterName, 'Listen on a specific IP address or hostname')
          [CompletionResult]::new('--port=<n>', '--port=<n>', [CompletionResultType]::ParameterName, 'Listen on an alternative port')
          [CompletionResult]::new('--init-timeout=<n>', '--init-timeout=<n>', [CompletionResultType]::ParameterName, 'Timeout (in seconds) between the moment the connection is established and the client request is received (typically a rather low value, since that should be basically immediate)')
          [CompletionResult]::new('--timeout=<n>', '--timeout=<n>', [CompletionResultType]::ParameterName, 'Timeout (in seconds) for specific client sub-requests')
          [CompletionResult]::new('--max-connections=<n>', '--max-connections=<n>', [CompletionResultType]::ParameterName, 'Maximum number of concurrent clients, defaults to 32')
          [CompletionResult]::new('--syslog', '--syslog', [CompletionResultType]::ParameterName, 'Short for --log-destination=syslog')
          [CompletionResult]::new('--log-destination=<destination>', '--log-destination=<destination>', [CompletionResultType]::ParameterName, 'Send log messages to the specified destination')
          [CompletionResult]::new('--user-path', '--user-path', [CompletionResultType]::ParameterName, 'Allow ~user notation to be used in requests')
          [CompletionResult]::new('--user-path=<path>', '--user-path=<path>', [CompletionResultType]::ParameterName, 'Allow ~user notation to be used in requests')
          [CompletionResult]::new('--verbose', '--verbose', [CompletionResultType]::ParameterName, 'Log details about the incoming connections and requested files')
          [CompletionResult]::new('--reuseaddr', '--reuseaddr', [CompletionResultType]::ParameterName, 'Use SO_REUSEADDR when binding the listening socket')
          [CompletionResult]::new('--detach', '--detach', [CompletionResultType]::ParameterName, 'Detach from the shell')
          [CompletionResult]::new('--pid-file=<file>', '--pid-file=<file>', [CompletionResultType]::ParameterName, 'Save the process id in file')
          [CompletionResult]::new('--user=<user>', '--user=<user>', [CompletionResultType]::ParameterName, "Change daemon's uid and gid before entering the service loop")
          [CompletionResult]::new('--group=<group>', '--group=<group>', [CompletionResultType]::ParameterName, "Change daemon's uid and gid before entering the service loop")
          [CompletionResult]::new('--enable=<service>', '--enable=<service>', [CompletionResultType]::ParameterName, 'Enable/disable the service site-wide per default')
          [CompletionResult]::new('--disable=<service>', '--disable=<service>', [CompletionResultType]::ParameterName, 'Enable/disable the service site-wide per default')
          [CompletionResult]::new('--allow-override=<service>', '--allow-override=<service>', [CompletionResultType]::ParameterName, 'Allow/forbid overriding the site-wide default with per repository configuration')
          [CompletionResult]::new('--forbid-override=<service>', '--forbid-override=<service>', [CompletionResultType]::ParameterName, 'Allow/forbid overriding the site-wide default with per repository configuration')
          [CompletionResult]::new('--[no-]informative-errors', '--[no-]informative-errors', [CompletionResultType]::ParameterName, 'When informative errors are turned on, git-daemon will report more verbose errors to the client, differentiating conditions like "no such repository" from "repository not exported"')
          [CompletionResult]::new('--access-hook=<path>', '--access-hook=<path>', [CompletionResultType]::ParameterName, 'Every time a client connects, first run an external command specified by the <path> with service name (e')
          [CompletionResult]::new('<directory>', '<directory>', [CompletionResultType]::ParameterName, 'The remaining arguments provide a list of directories')
        }
        break
      }
      'fetch-pack' {
        if ($wordToComplete.StartsWith('-')) {
          [CompletionResult]::new('--all', '--all', [CompletionResultType]::ParameterName, 'Fetch all remote refs')
          [CompletionResult]::new('--stdin', '--stdin', [CompletionResultType]::ParameterName, 'Take the list of refs from stdin, one per line')
          [CompletionResult]::new('-q', '-q', [CompletionResultType]::ParameterName, 'Pass -q flag to git unpack-objects; this makes the cloning process less verbose')
          [CompletionResult]::new('--quiet', '--quiet', [CompletionResultType]::ParameterName, 'Pass -q flag to git unpack-objects; this makes the cloning process less verbose')
          [CompletionResult]::new('-k', '-k', [CompletionResultType]::ParameterName, 'Do not invoke git unpack-objects on received data, but create a single packfile out of it instead, and store it in the object database')
          [CompletionResult]::new('--keep', '--keep', [CompletionResultType]::ParameterName, 'Do not invoke git unpack-objects on received data, but create a single packfile out of it instead, and store it in the object database')
          [CompletionResult]::new('--thin', '--thin', [CompletionResultType]::ParameterName, 'Fetch a "thin" pack, which records objects in deltified form based on objects not included in the pack to reduce network traffic')
          [CompletionResult]::new('--include-tag', '--include-tag', [CompletionResultType]::ParameterName, 'If the remote side supports it, annotated tags objects will be downloaded on the same connection as the other objects if the object the tag references is downloaded')
          [CompletionResult]::new('--upload-pack=<git-upload-pack>', '--upload-pack=<git-upload-pack>', [CompletionResultType]::ParameterName, 'Use this to specify the path to git-upload-pack on the remote side, if it is not found on your $PATH')
          [CompletionResult]::new('--exec=<git-upload-pack>', '--exec=<git-upload-pack>', [CompletionResultType]::ParameterName, 'Same as --upload-pack=<git-upload-pack>')
          [CompletionResult]::new('--depth=<n>', '--depth=<n>', [CompletionResultType]::ParameterName, 'Limit fetching to ancestor-chains not longer than n')
          [CompletionResult]::new('--shallow-since=<date>', '--shallow-since=<date>', [CompletionResultType]::ParameterName, 'Deepen or shorten the history of a shallow repository to include all reachable commits after <date>')
          [CompletionResult]::new('--shallow-exclude=<revision>', '--shallow-exclude=<revision>', [CompletionResultType]::ParameterName, 'Deepen or shorten the history of a shallow repository to exclude commits reachable from a specified remote branch or tag')
          [CompletionResult]::new('--deepen-relative', '--deepen-relative', [CompletionResultType]::ParameterName, 'Argument --depth specifies the number of commits from the current shallow boundary instead of from the tip of each remote branch history')
          [CompletionResult]::new('--refetch', '--refetch', [CompletionResultType]::ParameterName, 'Skips negotiating commits with the server in order to fetch all matching objects')
          [CompletionResult]::new('--no-progress', '--no-progress', [CompletionResultType]::ParameterName, 'Do not show the progress')
          [CompletionResult]::new('--check-self-contained-and-connected', '--check-self-contained-and-connected', [CompletionResultType]::ParameterName, 'Output "connectivity-ok" if the received pack is self-contained and connected')
          [CompletionResult]::new('-v', '-v', [CompletionResultType]::ParameterName, 'Run verbosely')
          [CompletionResult]::new('<repository>', '<repository>', [CompletionResultType]::ParameterName, 'The URL to the remote repository')
          [CompletionResult]::new('<refs>…​', '<refs>…​', [CompletionResultType]::ParameterName, 'The remote heads to update from')
        }
        break
      }
      'http-backend' { break }
      'send-pack' {
        if ($wordToComplete.StartsWith('-')) {
          [CompletionResult]::new('--receive-pack=<git-receive-pack>', '--receive-pack=<git-receive-pack>', [CompletionResultType]::ParameterName, 'Path to the git-receive-pack program on the remote end')
          [CompletionResult]::new('--exec=<git-receive-pack>', '--exec=<git-receive-pack>', [CompletionResultType]::ParameterName, 'Same as --receive-pack=<git-receive-pack>')
          [CompletionResult]::new('--all', '--all', [CompletionResultType]::ParameterName, 'Instead of explicitly specifying which refs to update, update all heads that locally exist')
          [CompletionResult]::new('--stdin', '--stdin', [CompletionResultType]::ParameterName, 'Take the list of refs from stdin, one per line')
          [CompletionResult]::new('--dry-run', '--dry-run', [CompletionResultType]::ParameterName, 'Do everything except actually send the updates')
          [CompletionResult]::new('--force', '--force', [CompletionResultType]::ParameterName, 'Usually, the command refuses to update a remote ref that is not an ancestor of the local ref used to overwrite it')
          [CompletionResult]::new('--verbose', '--verbose', [CompletionResultType]::ParameterName, 'Run verbosely')
          [CompletionResult]::new('--thin', '--thin', [CompletionResultType]::ParameterName, 'Send a "thin" pack, which records objects in deltified form based on objects not included in the pack to reduce network traffic')
          [CompletionResult]::new('--atomic', '--atomic', [CompletionResultType]::ParameterName, 'Use an atomic transaction for updating the refs')
          [CompletionResult]::new('--[no-]signed', '--[no-]signed', [CompletionResultType]::ParameterName, 'GPG-sign the push request to update refs on the receiving side, to allow it to be checked by the hooks and/or be logged')
          [CompletionResult]::new('--signed=(true|false|if-asked)', '--signed=(true|false|if-asked)', [CompletionResultType]::ParameterName, 'GPG-sign the push request to update refs on the receiving side, to allow it to be checked by the hooks and/or be logged')
          [CompletionResult]::new('--push-option=<string>', '--push-option=<string>', [CompletionResultType]::ParameterName, 'Pass the specified string as a push option for consumption by hooks on the server side')
          [CompletionResult]::new('<host>', '<host>', [CompletionResultType]::ParameterName, 'A remote host to house the repository')
          [CompletionResult]::new('<directory>', '<directory>', [CompletionResultType]::ParameterName, 'The repository to update')
          [CompletionResult]::new('<ref>…​', '<ref>…​', [CompletionResultType]::ParameterName, 'The remote refs to update')
        }
        break
      }
      'update-server-info' {
        if ($wordToComplete.StartsWith('-')) {
          [CompletionResult]::new('-f', '-f', [CompletionResultType]::ParameterName, 'Update the info files from scratch')
          [CompletionResult]::new('--force', '--force', [CompletionResultType]::ParameterName, 'Update the info files from scratch')
        }
        break
      }
      'check-attr' {
        if ($wordToComplete.StartsWith('-')) {
          [CompletionResult]::new('-a,', '-a,', [CompletionResultType]::ParameterName, 'List all attributes that are associated with the specified paths')
          [CompletionResult]::new('--cached', '--cached', [CompletionResultType]::ParameterName, 'Consider')
          [CompletionResult]::new('--stdin', '--stdin', [CompletionResultType]::ParameterName, 'Read pathnames from the standard input, one per line, instead of from the command line')
          [CompletionResult]::new('-z', '-z', [CompletionResultType]::ParameterName, 'The output format is modified to be machine-parsable')
          [CompletionResult]::new('--source=<tree-ish>', '--source=<tree-ish>', [CompletionResultType]::ParameterName, 'Check attributes against the specified tree-ish')
          [CompletionResult]::new('--', '--', [CompletionResultType]::ParameterName, 'Interpret all preceding arguments as attributes and all following arguments as path names')
        }
        break
      }
      'check-ignore' {
        if ($wordToComplete.StartsWith('-')) {
          [CompletionResult]::new('-q,', '-q,', [CompletionResultType]::ParameterName, "Don't output anything, just set exit status")
          [CompletionResult]::new('-v,', '-v,', [CompletionResultType]::ParameterName, 'Instead of printing the paths that are excluded, for each path that matches an exclude pattern, print the exclude pattern together with the path')
          [CompletionResult]::new('--stdin', '--stdin', [CompletionResultType]::ParameterName, 'Read pathnames from the standard input, one per line, instead of from the command-line')
          [CompletionResult]::new('-z', '-z', [CompletionResultType]::ParameterName, 'The output format is modified to be machine-parsable (see below)')
          [CompletionResult]::new('-n,', '-n,', [CompletionResultType]::ParameterName, "Show given paths which don't match any pattern")
          [CompletionResult]::new('--no-index', '--no-index', [CompletionResultType]::ParameterName, "Don't look in the index when undertaking the checks")
        }
        break
      }
      'check-mailmap' {
        if ($wordToComplete.StartsWith('-')) {
          [CompletionResult]::new('--stdin', '--stdin', [CompletionResultType]::ParameterName, 'Read contacts, one per line, from the standard input after exhausting contacts provided on the command-line')
          [CompletionResult]::new('--mailmap-file=<file>', '--mailmap-file=<file>', [CompletionResultType]::ParameterName, 'In addition to any configured mailmap files, read the specified mailmap file')
          [CompletionResult]::new('--mailmap-blob=<blob>', '--mailmap-blob=<blob>', [CompletionResultType]::ParameterName, 'Like --mailmap-file, but consider the value as a reference to a blob in the repository')
        }
        break
      }
      'check-ref-format' {
        if ($wordToComplete.StartsWith('-')) {
          [CompletionResult]::new('--[no-]allow-onelevel', '--[no-]allow-onelevel', [CompletionResultType]::ParameterName, 'Controls whether one-level refnames are accepted (i')
          [CompletionResult]::new('--refspec-pattern', '--refspec-pattern', [CompletionResultType]::ParameterName, 'Interpret <refname> as a reference name pattern for a refspec (as used with remote repositories)')
          [CompletionResult]::new('--normalize', '--normalize', [CompletionResultType]::ParameterName, 'Normalize refname by removing any leading slash (/) characters and collapsing runs of adjacent slashes between name components into a single slash')
        }
        break
      }
      'column' {
        if ($wordToComplete.StartsWith('-')) {
          [CompletionResult]::new('--command=<name>', '--command=<name>', [CompletionResultType]::ParameterName, 'Look up layout mode using configuration variable column')
          [CompletionResult]::new('--mode=<mode>', '--mode=<mode>', [CompletionResultType]::ParameterName, 'Specify layout mode')
          [CompletionResult]::new('--raw-mode=<n>', '--raw-mode=<n>', [CompletionResultType]::ParameterName, 'Same as --mode but take mode encoded as a number')
          [CompletionResult]::new('--width=<width>', '--width=<width>', [CompletionResultType]::ParameterName, 'Specify the terminal width')
          [CompletionResult]::new('--indent=<string>', '--indent=<string>', [CompletionResultType]::ParameterName, 'String to be printed at the beginning of each line')
          [CompletionResult]::new('--nl=<string>', '--nl=<string>', [CompletionResultType]::ParameterName, 'String to be printed at the end of each line, including newline character')
          [CompletionResult]::new('--padding=<N>', '--padding=<N>', [CompletionResultType]::ParameterName, 'The number of spaces between columns')
        }
        break
      }
      'credential' { break }
      'credential-cache' {
        if ($wordToComplete.StartsWith('-')) {
          [CompletionResult]::new('--timeout', '--timeout', [CompletionResultType]::ParameterName, 'Number of seconds to cache credentials (default: 900)')
          [CompletionResult]::new('--socket', '--socket', [CompletionResultType]::ParameterName, 'Use <path> to contact a running cache daemon (or start a new cache daemon if one is not started)')
        }
        break
      }
      'credential-store' {
        if ($wordToComplete.StartsWith('-')) {
          [CompletionResult]::new('--file=<path>', '--file=<path>', [CompletionResultType]::ParameterName, 'Use <path> to lookup and store credentials')
        }
        break
      }
      'fmt-merge-msg' {
        if ($wordToComplete.StartsWith('-')) {
          [CompletionResult]::new('--log[=<n>]', '--log[=<n>]', [CompletionResultType]::ParameterName, 'In addition to branch names, populate the log message with one-line descriptions from the actual commits that are being merged')
          [CompletionResult]::new('--no-log', '--no-log', [CompletionResultType]::ParameterName, 'Do not list one-line descriptions from the actual commits being merged')
          [CompletionResult]::new('--[no-]summary', '--[no-]summary', [CompletionResultType]::ParameterName, 'Synonyms to --log and --no-log; these are deprecated and will be removed in the future')
          [CompletionResult]::new('-m', '-m', [CompletionResultType]::ParameterName, 'Use <message> instead of the branch names for the first line of the log message')
          [CompletionResult]::new('--message', '--message', [CompletionResultType]::ParameterName, 'Use <message> instead of the branch names for the first line of the log message')
          [CompletionResult]::new('--into-name', '--into-name', [CompletionResultType]::ParameterName, 'Prepare the merge message as if merging to the branch <branch>, instead of the name of the real branch to which the merge is made')
          [CompletionResult]::new('-F', '-F', [CompletionResultType]::ParameterName, 'Take the list of merged objects from <file> instead of stdin')
          [CompletionResult]::new('--file', '--file', [CompletionResultType]::ParameterName, 'Take the list of merged objects from <file> instead of stdin')
        }
        break
      }
      'hook' {
        if ($wordToComplete.StartsWith('-')) {
          [CompletionResult]::new('--to-stdin', '--to-stdin', [CompletionResultType]::ParameterName, "For `"run`"; specify a file which will be streamed into the hook's stdin")
          [CompletionResult]::new('--ignore-missing', '--ignore-missing', [CompletionResultType]::ParameterName, 'Ignore any missing hook by quietly returning zero')
        }
        elseif ($commandAst.CommandElements.Count -le 3) {
          [CompletionResult]::new('run', 'run', [CompletionResultType]::ParameterName, 'Run the <hook-name> hook')
        }
        break
      }
      'hook;run' {
        break
      }
      'interpret-trailers' {
        if ($wordToComplete.StartsWith('-')) {
          [CompletionResult]::new('--in-place', '--in-place', [CompletionResultType]::ParameterName, 'Edit the files in place')
          [CompletionResult]::new('--trim-empty', '--trim-empty', [CompletionResultType]::ParameterName, 'If the <value> part of any trailer contains only whitespace, the whole trailer will be removed from the output')
          [CompletionResult]::new('--trailer', '--trailer', [CompletionResultType]::ParameterName, 'Specify a (<key>, <value>) pair that should be applied as a trailer to the inputs')
          [CompletionResult]::new('--where', '--where', [CompletionResultType]::ParameterName, 'Specify where all new trailers will be added')
          [CompletionResult]::new('--no-where', '--no-where', [CompletionResultType]::ParameterName, 'Specify where all new trailers will be added')
          [CompletionResult]::new('--if-exists', '--if-exists', [CompletionResultType]::ParameterName, 'Specify what action will be performed when there is already at least one trailer with the same <key> in the input')
          [CompletionResult]::new('--no-if-exists', '--no-if-exists', [CompletionResultType]::ParameterName, 'Specify what action will be performed when there is already at least one trailer with the same <key> in the input')
          [CompletionResult]::new('--if-missing', '--if-missing', [CompletionResultType]::ParameterName, 'Specify what action will be performed when there is no other trailer with the same <key> in the input')
          [CompletionResult]::new('--no-if-missing', '--no-if-missing', [CompletionResultType]::ParameterName, 'Specify what action will be performed when there is no other trailer with the same <key> in the input')
          [CompletionResult]::new('--only-trailers', '--only-trailers', [CompletionResultType]::ParameterName, 'Output only the trailers, not any other parts of the input')
          [CompletionResult]::new('--only-input', '--only-input', [CompletionResultType]::ParameterName, 'Output only trailers that exist in the input; do not add any from the command-line or by applying trailer')
          [CompletionResult]::new('--unfold', '--unfold', [CompletionResultType]::ParameterName, 'If a trailer has a value that runs over multiple lines (aka "folded"), reformat the value into a single line')
          [CompletionResult]::new('--parse', '--parse', [CompletionResultType]::ParameterName, 'A convenience alias for --only-trailers --only-input --unfold')
          [CompletionResult]::new('--no-divider', '--no-divider', [CompletionResultType]::ParameterName, 'Do not treat --- as the end of the commit message')
        }
        break
      }
      'mailinfo' {
        if ($wordToComplete.StartsWith('-')) {
          [CompletionResult]::new('-k', '-k', [CompletionResultType]::ParameterName, 'Usually the program removes email cruft from the Subject: header line to extract the title line for the commit log message')
          [CompletionResult]::new('-b', '-b', [CompletionResultType]::ParameterName, 'When -k is not in effect, all leading strings bracketed with [ and ] pairs are stripped')
          [CompletionResult]::new('-u', '-u', [CompletionResultType]::ParameterName, 'The commit log message, author name and author email are taken from the e-mail, and after minimally decoding MIME transfer encoding, re-coded in the charset specified by i18n')
          [CompletionResult]::new('--encoding=<encoding>', '--encoding=<encoding>', [CompletionResultType]::ParameterName, 'Similar to -u')
          [CompletionResult]::new('-n', '-n', [CompletionResultType]::ParameterName, 'Disable all charset re-coding of the metadata')
          [CompletionResult]::new('-m', '-m', [CompletionResultType]::ParameterName, 'Copy the Message-ID header at the end of the commit message')
          [CompletionResult]::new('--message-id', '--message-id', [CompletionResultType]::ParameterName, 'Copy the Message-ID header at the end of the commit message')
          [CompletionResult]::new('--scissors', '--scissors', [CompletionResultType]::ParameterName, 'Remove everything in body before a scissors line (e')
          [CompletionResult]::new('--no-scissors', '--no-scissors', [CompletionResultType]::ParameterName, 'Ignore scissors lines')
          [CompletionResult]::new('--quoted-cr=<action>', '--quoted-cr=<action>', [CompletionResultType]::ParameterName, 'Action when processes email messages sent with base64 or quoted-printable encoding, and the decoded lines end with a CRLF instead of a simple LF')
          [CompletionResult]::new('<msg>', '<msg>', [CompletionResultType]::ParameterName, 'The commit log message extracted from e-mail, usually except the title line which comes from e-mail Subject')
          [CompletionResult]::new('<patch>', '<patch>', [CompletionResultType]::ParameterName, 'The patch extracted from e-mail')
        }
        break
      }
      'mailsplit' {
        if ($wordToComplete.StartsWith('-')) {
          [CompletionResult]::new('<mbox>', '<mbox>', [CompletionResultType]::ParameterName, 'Mbox file to split')
          [CompletionResult]::new('<Maildir>', '<Maildir>', [CompletionResultType]::ParameterName, 'Root of the Maildir to split')
          [CompletionResult]::new('-o<directory>', '-o<directory>', [CompletionResultType]::ParameterName, 'Directory in which to place the individual messages')
          [CompletionResult]::new('-b', '-b', [CompletionResultType]::ParameterName, "If any file doesn't begin with a From line, assume it is a single mail message instead of signaling an error")
          [CompletionResult]::new('-d<prec>', '-d<prec>', [CompletionResultType]::ParameterName, 'Instead of the default 4 digits with leading zeros, different precision can be specified for the generated filenames')
          [CompletionResult]::new('-f<nn>', '-f<nn>', [CompletionResultType]::ParameterName, 'Skip the first <nn> numbers, for example if -f3 is specified, start the numbering with 0004')
          [CompletionResult]::new('--keep-cr', '--keep-cr', [CompletionResultType]::ParameterName, 'Do not remove \r from lines ending with \r\n')
          [CompletionResult]::new('--mboxrd', '--mboxrd', [CompletionResultType]::ParameterName, 'Input is of the "mboxrd" format and "^>+From " line escaping is reversed')
        }
        break
      }
      'merge-one-file' {
        break
      }
      'patch-id' {
        if ($wordToComplete.StartsWith('-')) {
          [CompletionResult]::new('--verbatim', '--verbatim', [CompletionResultType]::ParameterName, 'Calculate the patch-id of the input as it is given, do not strip any whitespace')
          [CompletionResult]::new('--stable', '--stable', [CompletionResultType]::ParameterName, 'Use a "stable" sum of hashes as the patch ID')
          [CompletionResult]::new('--unstable', '--unstable', [CompletionResultType]::ParameterName, 'Use an "unstable" hash as the patch ID')
        }
        break
      }
      'sh-i18n' {
        if ($commandAst.CommandElements -le 3) {
          [CompletionResult]::new('gettext', 'gettext', [CompletionResultType]::ParameterName, 'Currently a dummy fall-through function implemented as a wrapper around printf(1)')
          [CompletionResult]::new('eval_gettext', 'eval_gettext', [CompletionResultType]::ParameterName, 'Currently a dummy fall-through function implemented as a wrapper around printf(1) with variables expanded by the git-sh-i18n--envsubst(1) helper')
        }
        break
      }
      'sh-setup' {
        if ($commandAst.CommandElements -le 3) {
          [CompletionResult]::new('die', 'die', [CompletionResultType]::ParameterName, 'exit after emitting the supplied error message to the standard error stream')
          [CompletionResult]::new('usage', 'usage', [CompletionResultType]::ParameterName, 'die with the usage message')
          [CompletionResult]::new('set_reflog_action', 'set_reflog_action', [CompletionResultType]::ParameterName, 'Set GIT_REFLOG_ACTION environment to a given string (typically the name of the program) unless it is already set')
          [CompletionResult]::new('git_editor', 'git_editor', [CompletionResultType]::ParameterName, "runs an editor of user's choice (GIT_EDITOR, core")
          [CompletionResult]::new('is_bare_repository', 'is_bare_repository', [CompletionResultType]::ParameterName, 'outputs true or false to the standard output stream to indicate if the repository is a bare repository (i')
          [CompletionResult]::new('cd_to_toplevel', 'cd_to_toplevel', [CompletionResultType]::ParameterName, 'runs chdir to the toplevel of the working tree')
          [CompletionResult]::new('require_work_tree', 'require_work_tree', [CompletionResultType]::ParameterName, 'checks if the current directory is within the working tree of the repository, and otherwise dies')
          [CompletionResult]::new('require_work_tree_exists', 'require_work_tree_exists', [CompletionResultType]::ParameterName, 'checks if the working tree associated with the repository exists, and otherwise dies')
          [CompletionResult]::new('require_clean_work_tree', 'require_clean_work_tree', [CompletionResultType]::ParameterName, 'checks that the working tree and index associated with the repository have no uncommitted changes to tracked files')
          [CompletionResult]::new('get_author_ident_from_commit', 'get_author_ident_from_commit', [CompletionResultType]::ParameterName, 'outputs code for use with eval to set the GIT_AUTHOR_NAME, GIT_AUTHOR_EMAIL and GIT_AUTHOR_DATE variables for a given commit')
          [CompletionResult]::new('create_virtual_base', 'create_virtual_base', [CompletionResultType]::ParameterName, 'modifies the first file so only lines in common with the second file remain')
        }
        break
      }
      'stripspace' {
        if ($wordToComplete.StartsWith('-')) {
          [CompletionResult]::new('-s', '-s', [CompletionResultType]::ParameterName, 'Skip and remove all lines starting with a comment character (default #)')
          [CompletionResult]::new('--strip-comments', '--strip-comments', [CompletionResultType]::ParameterName, 'Skip and remove all lines starting with a comment character (default #)')
          [CompletionResult]::new('-c', '-c', [CompletionResultType]::ParameterName, 'Prepend the comment character and a blank space to each line')
          [CompletionResult]::new('--comment-lines', '--comment-lines', [CompletionResultType]::ParameterName, 'Prepend the comment character and a blank space to each line')
        }
        break
      }
      'attributes' {
        break
      }
      'cli' {
        break
      }
      'hooks' {
        break
      }
      'ignore' {
        break
      }
      'mailmap' {
        break
      }
      'modules' {

        break
      }
      'repository-layout' {
        if ($wordToComplete.StartsWith('-')) {
        }
        break
      }
      'credential-helper-selector' { break }
      'credential-manager' {
        if ($wordToComplete.StartsWith('-')) {
          [CompletionResult]::new('--no-ui', '--no-ui', [CompletionResultType]::ParameterName, 'Do not use graphical user interface prompts')
          [CompletionResult]::new('--version', '--version', [CompletionResultType]::ParameterName, 'Show version information')
          [CompletionResult]::new('-h', '-h', [CompletionResultType]::ParameterName, 'Show help and usage information')
          [CompletionResult]::new('-?', '-?', [CompletionResultType]::ParameterName, 'Show help and usage information')
          [CompletionResult]::new('--help', '--help', [CompletionResultType]::ParameterName, 'Show help and usage information')
        }
        elseif ($commandAst.CommandElements.Count -le 3) {
          [CompletionResult]::new('get', 'get', [CompletionResultType]::ParameterName, '[Git] Return a stored credential')
          [CompletionResult]::new('store', 'store', [CompletionResultType]::ParameterName, '[Git] Store a credential')
          [CompletionResult]::new('erase', 'erase', [CompletionResultType]::ParameterName, '[Git] Erase a stored credential')
          [CompletionResult]::new('configure', 'configure', [CompletionResultType]::ParameterName, 'Configure Git Credential Manager as the Git credential helper')
          [CompletionResult]::new('unconfigure', 'unconfigure', [CompletionResultType]::ParameterName, 'Unconfigure Git Credential Manager as the Git credential helper')
          [CompletionResult]::new('diagnose', 'diagnose', [CompletionResultType]::ParameterName, 'Run diagnostics and gather logs to diagnose problems with Git Credential Manager')
          [CompletionResult]::new('azure-repos', 'azure-repos', [CompletionResultType]::ParameterName, 'Commands for interacting with the Azure Repos host provider')
          [CompletionResult]::new('github', 'github', [CompletionResultType]::ParameterName, 'Commands for interacting with the GitHub host provider')
        }
        break
      }
      'flow' {
        if ($commandAst.CommandElements.Count -le 3) {
          [CompletionResult]::new('init', 'init', [CompletionResultType]::ParameterName, 'Initialize a new git repo with support for the branching model.')
          [CompletionResult]::new('feature', 'feature', [CompletionResultType]::ParameterName, 'Manage your feature branches.')
          [CompletionResult]::new('bugfix', 'bugfix', [CompletionResultType]::ParameterName, 'Manage your bugfix branches.')
          [CompletionResult]::new('release', 'release', [CompletionResultType]::ParameterName, 'Manage your release branches.')
          [CompletionResult]::new('hotfix', 'hotfix', [CompletionResultType]::ParameterName, 'Manage your hotfix branches.')
          [CompletionResult]::new('support', 'support', [CompletionResultType]::ParameterName, 'Manage your support branches.')
          [CompletionResult]::new('version', 'version', [CompletionResultType]::ParameterName, 'Shows version information.')
          [CompletionResult]::new('config', 'config', [CompletionResultType]::ParameterName, 'Manage your git-flow configuration.')
          [CompletionResult]::new('log', 'log', [CompletionResultType]::ParameterName, 'Show log deviating from base branch.')
        }
        break
      }
      'flow init' {
        if ($wordToComplete.StartsWith('-')) {
          [CompletionResult]::new('-h', '-h', [CompletionResultType]::ParameterName, 'Show this help')
          [CompletionResult]::new('--help', '--help', [CompletionResultType]::ParameterName, 'Show this help')
          [CompletionResult]::new('--showcommands', '--showcommands', [CompletionResultType]::ParameterName, 'Show git commands while executing them')
          [CompletionResult]::new('-d', '-d', [CompletionResultType]::ParameterName, 'Use default branch naming conventions')
          [CompletionResult]::new('--defaults', '--defaults', [CompletionResultType]::ParameterName, 'Use default branch naming conventions')
          [CompletionResult]::new('--nodefaults', '--nodefaults', [CompletionResultType]::ParameterName, 'Use default branch naming conventions')
          [CompletionResult]::new('-f', '-f', [CompletionResultType]::ParameterName, 'Force setting of gitflow branches, even if already configured')
          [CompletionResult]::new('--force', '--force', [CompletionResultType]::ParameterName, 'Force setting of gitflow branches, even if already configured')
          [CompletionResult]::new('--noforce', '--noforce', [CompletionResultType]::ParameterName, 'Force setting of gitflow branches, even if already configured')
          [CompletionResult]::new('-p', '-p', [CompletionResultType]::ParameterName, 'Feature branches')
          [CompletionResult]::new('--feature', '--feature', [CompletionResultType]::ParameterName, 'Feature branches')
          [CompletionResult]::new('-b', '-b', [CompletionResultType]::ParameterName, 'Bugfix branches')
          [CompletionResult]::new('--bugfix', '--bugfix', [CompletionResultType]::ParameterName, 'Bugfix branches')
          [CompletionResult]::new('-r', '-r', [CompletionResultType]::ParameterName, 'Release branches')
          [CompletionResult]::new('--release', '--release', [CompletionResultType]::ParameterName, 'Release branches')
          [CompletionResult]::new('-x', '-x', [CompletionResultType]::ParameterName, 'Hotfix branches')
          [CompletionResult]::new('--hotfix', '--hotfix', [CompletionResultType]::ParameterName, 'Hotfix branches')
          [CompletionResult]::new('-s', '-s', [CompletionResultType]::ParameterName, 'Support branches')
          [CompletionResult]::new('--support', '--support', [CompletionResultType]::ParameterName, 'Support branches')
          [CompletionResult]::new('-t', '-t', [CompletionResultType]::ParameterName, 'Version tag prefix')
          [CompletionResult]::new('--tag', '--tag', [CompletionResultType]::ParameterName, 'Version tag prefix')
          [CompletionResult]::new('--Use', '--Use', [CompletionResultType]::ParameterName, 'config file location')
          [CompletionResult]::new('--no-Use', '--no-Use', [CompletionResultType]::ParameterName, 'config file location')
          [CompletionResult]::new('--local', '--local', [CompletionResultType]::ParameterName, 'use repository config file')
          [CompletionResult]::new('--global', '--global', [CompletionResultType]::ParameterName, 'use global config file')
          [CompletionResult]::new('--system', '--system', [CompletionResultType]::ParameterName, 'use system config file')
          [CompletionResult]::new('--file', '--file', [CompletionResultType]::ParameterName, 'use given config file')
          [CompletionResult]::new('--no-file', '--no-file', [CompletionResultType]::ParameterName, 'use given config file')
        }
        break
      }
      { $_.StartsWith('flow ') } {
        if ($wordToComplete.StartsWith('-')) {
          [CompletionResult]::new('-h', '-h', [CompletionResultType]::ParameterName, 'Show this help')
          [CompletionResult]::new('--help', '--help', [CompletionResultType]::ParameterName, 'Show this help')
          [CompletionResult]::new('-v', '-v', [CompletionResultType]::ParameterName, 'Verbose (more) output')
          [CompletionResult]::new('--verbose', '--verbose', [CompletionResultType]::ParameterName, 'Verbose (more) output')
          [CompletionResult]::new('--no-verbose', '--no-verbose', [CompletionResultType]::ParameterName, 'Verbose (more) output')
        }
        elseif ($commandAst.CommandElements.Count -le 4) {
          [CompletionResult]::new('list', 'list', [CompletionResultType]::ParameterName, "Lists all the existing $_ branches in the local repository.")
          [CompletionResult]::new('start', 'start', [CompletionResultType]::ParameterName, "Start a new $_")
        }
        break
      }
      'lfs' {
        if ($commandAst.CommandElements.Count -le 3) {
          [CompletionResult]::new('checkout', 'checkout', [CompletionResultType]::ParameterName, 'Populate working copy with real content from Git LFS files')
          [CompletionResult]::new('completion', 'completion', [CompletionResultType]::ParameterName, 'Generate shell scripts for command-line tab-completion of Git LFS commands')
          [CompletionResult]::new('dedup', 'dedup', [CompletionResultType]::ParameterName, 'De-duplicate Git LFS files')
          [CompletionResult]::new('env', 'env', [CompletionResultType]::ParameterName, 'Display the Git LFS environment')
          [CompletionResult]::new('ext', 'ext', [CompletionResultType]::ParameterName, 'Display Git LFS extension details')
          [CompletionResult]::new('fetch', 'fetch', [CompletionResultType]::ParameterName, 'Download Git LFS files from a remote')
          [CompletionResult]::new('fsck', 'fsck', [CompletionResultType]::ParameterName, 'Check Git LFS files for consistency')
          [CompletionResult]::new('install', 'install', [CompletionResultType]::ParameterName, 'Install Git LFS configuration')
          [CompletionResult]::new('lock', 'lock', [CompletionResultType]::ParameterName, 'Set a file as "locked" on the Git LFS server')
          [CompletionResult]::new('locks', 'locks', [CompletionResultType]::ParameterName, 'List currently "locked" files from the Git LFS server')
          [CompletionResult]::new('logs', 'logs', [CompletionResultType]::ParameterName, 'Show errors from the Git LFS command')
          [CompletionResult]::new('ls-files', 'ls-files', [CompletionResultType]::ParameterName, 'Show information about Git LFS files in the index and working tree')
          [CompletionResult]::new('migrate', 'migrate', [CompletionResultType]::ParameterName, 'Migrate history to or from Git LFS')
          [CompletionResult]::new('prune', 'prune', [CompletionResultType]::ParameterName, 'Delete old Git LFS files from local storage')
          [CompletionResult]::new('pull', 'pull', [CompletionResultType]::ParameterName, 'Fetch Git LFS changes from the remote & checkout any required working tree files')
          [CompletionResult]::new('push', 'push', [CompletionResultType]::ParameterName, 'Push queued large files to the Git LFS endpoint')
          [CompletionResult]::new('status', 'status', [CompletionResultType]::ParameterName, 'Show the status of Git LFS files in the working tree')
          [CompletionResult]::new('track', 'track', [CompletionResultType]::ParameterName, 'View or add Git LFS paths to Git attributes')
          [CompletionResult]::new('uninstall', 'uninstall', [CompletionResultType]::ParameterName, 'Uninstall Git LFS by removing hooks and smudge/clean filter configuration')
          [CompletionResult]::new('unlock', 'unlock', [CompletionResultType]::ParameterName, 'Remove "locked" setting for a file on the Git LFS server')
          [CompletionResult]::new('untrack', 'untrack', [CompletionResultType]::ParameterName, 'Remove Git LFS paths from Git Attributes')
          [CompletionResult]::new('update', 'update', [CompletionResultType]::ParameterName, 'Update Git hooks for the current Git repository')
          [CompletionResult]::new('version', 'version', [CompletionResultType]::ParameterName, 'Report the version number')
        }
        break
      }
      'update-git-for-windows' { break }
    }) | Where-Object CompletionText -Like "$wordToComplete*"
}
