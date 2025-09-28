using namespace System.Management.Automation
using namespace System.Management.Automation.Language

Register-ArgumentCompleter -Native -CommandName ctr -ScriptBlock {
  param ([string]$wordToComplete, [CommandAst]$commandAst, [int]$cursorPosition)
  $commands = @(foreach ($i in $commandAst.CommandElements) {
      if ($i.Extent.StartOffset -eq $commandAst.Extent.StartOffset -or $i.Extent.EndOffset -eq $cursorPosition) {
        continue
      }
      if ($i -isnot [StringConstantExpressionAst] -or
        $i.StringConstantType -ne [StringConstantType]::BareWord -or
        $i.Value.StartsWith('-')) {
        break
      }
      $i.Value
    })

  if ($commands.Length) {
    $commands[0] = switch ($commands[0]) {
      'plugin' { 'plugins'; break }
      'c' { 'containers'; break }
      'container' { 'containers'; break }
      'event' { 'events'; break }
      'i' { 'images'; break }
      'image' { 'images'; break }
      'namespace' { 'namespaces'; break }
      'ns' { 'namespaces'; break }
      'snapshot' { 'snapshots'; break }
      'task' { 'tasks'; break }
      't' { 'tasks'; break }
      'sandbox' { 'sandboxes'; break }
      'sb' { 'sandboxes'; break }
      's' { 'sandboxes'; break }
      'h' { 'help'; break }
      default { $_; break }
    }
  }
  elseif ($commands.Length -gt 1) {
    $commands[1] = switch ($commands[1]) {
      'c' { 'create'; break }
      'r' { 'run'; break }
      'ls' { 'list'; break }
      'delete' { 'remove'; break }
      'rm' { 'remove'; break }
      'del' { 'remove'; break }
      'i' { 'inspect'; break }
      'm' { 'mounts'; break }
      'mount' { 'mounts'; break }
      'metric' { 'metrics'; break }
      'del' { 'remove'; break }
      default { $_; break }
    }
  }

  @(switch ($commands -join ' ') {
      '' {
        'plugins', 'plugin', 'version', 'containers', 'c', 'container', 'content', 'events', 'event', 'images', 'image', 'i', 'leases', 'namespaces', 'namespace', 'ns', 'pprof', 'run', 'snapshots', 'snapshot', 'tasks', 't', 'task', 'install', 'oci', 'sandboxes', 'sandbox', 'sb', 's', 'info', 'deprecations', 'shim', 'help', 'h',
        '--debug', '--address', '-a', '--timeout', '--connect-timeout', '--namespace', '-n', '--version', '-v'
        break
      }
      'plugins' {
        'list', 'ls', 'inspect-runtime', 'help', 'h'
        break
      }
      'containers' {
        'create', 'delete', 'del', 'remove', 'rm', 'info', 'list', 'ls', 'label', 'checkpoint', 'restore', 'help', 'h'
        break
      }
      'content' {
        'active', 'delete', 'del', 'remove', 'rm', 'edit', 'fetch', 'fetch-object', 'fetch-blob', 'get', 'ingest', 'list', 'ls', 'push-object', 'label', 'prune', 'help', 'h'
        break
      }
      'images' {
        'check', 'export', 'import', 'inspect', 'i', 'list', 'ls', 'mount', 'unmount', 'pull', 'push', 'prune', 'delete', 'del', 'remove', 'rm', 'tag', 'label', 'convert', 'usage', 'help', 'h'
        break
      }
      'leases' {
        'list', 'ls', 'create', 'delete', 'del', 'remove', 'rm', 'help', 'h'
        break
      }
      'namespaces' {
        'create', 'c', 'list', 'ls', 'remove', 'rm', 'label', 'help', 'h'
        break
      }
      'pprof' {
        'block', 'goroutines', 'heap', 'profile', 'threadcreate', 'trace', 'help', 'h',
        '--debug-socket', '-d'
        break
      }
      'run' {
        '--rm', '--null-io', '--log-uri', '--detach', '-d', '--fifo-dir', '--cgroup', '--platform', '--cni', '--uidmap container-uid:host-uid:length', '--gidmap container-gid:host-gid:length', '--remap-labels', '--privileged-without-host-devices', '--cpus', '--cpu-shares', '--cpuset-cpus', '--cpuset-mems', '--runtime', '--runtime-config-path', '--runc-binary', '--runc-root', '--runc-systemd-cgroup', '--snapshotter', '--snapshotter-label', '--config', '-c', '--cwd', '--env', '--env-file', '--label', '--annotation', '--mount', '--net-host', '--privileged', '--read-only', '--sandbox', '--tty', '-t', '--with-ns', '--pid-file', '--gpus', '--allow-new-privs', '--memory-limit', '--cap-add', '--cap-drop', '--seccomp', '--seccomp-profile', '--apparmor-default-profile', '--apparmor-profile', '--blockio-config-file', '--blockio-class', '--rdt-class', '--hostname', '--user', '-u', '--rootfs', '--no-pivot', '--cpu-quota', '--cpu-period', '--rootfs-propagation', '--device'
        break
      }
      'snapshots' {
        'commit', 'diff', 'info', 'list', 'ls', 'mounts', 'm', 'mount', 'prepare', 'delete', 'del', 'remove', 'rm', 'label', 'tree', 'unpack', 'usage', 'view', 'help', 'h',
        '--snapshotter'
        break
      }
      'tasks' {
        'attach', 'checkpoint', 'delete', 'del', 'remove', 'rm', 'exec', 'list', 'ls', 'kill', 'metrics', 'metric', 'pause', 'ps', 'resume', 'start', 'help', 'h'
        break
      }
      'install' {
        '--libs', '-l', '--replace', '-r', '--path'
        break
      }
      'oci' {
        'spec', 'help', 'h'
        break
      }
      'sandboxes' {
        'run', 'create', 'c', 'r', 'list', 'ls', 'remove', 'rm', 'help', 'h'
        break
      }
      'deprecations' {
        'list', 'help', 'h'
        break
      }
      'shim' {
        'delete', 'exec', 'start', 'state', 'pprof', 'help', 'h',
        '--id'
        break
      }
      'help' {
        'plugins', 'plugin', 'version', 'containers', 'c', 'container', 'content', 'events', 'event', 'images', 'image', 'i', 'leases', 'namespaces', 'namespace', 'ns', 'pprof', 'run', 'snapshots', 'snapshot', 'tasks', 't', 'task', 'install', 'oci', 'sandboxes', 'sandbox', 'sb', 's', 'info', 'deprecations', 'shim', 'help', 'h'
        break
      }
      'plugins list' {
        '--quiet', '-q', '--detailed', '-d'
        break
      }
      'plugins inspect-runtime' {
        '--runtime', '--runtime-config-path', '--runc-binary', '--runc-root', '--runc-systemd-cgroup'
        break
      }
      'containers create' {
        '--runtime', '--runtime-config-path', '--runc-binary', '--runc-root', '--runc-systemd-cgroup', '--snapshotter', '--snapshotter-label', '--config', '-c', '--cwd', '--env', '--env-file', '--label', '--annotation', '--mount', '--net-host', '--privileged', '--read-only', '--sandbox', '--tty', '-t', '--with-ns', '--pid-file', '--gpus', '--allow-new-privs', '--memory-limit', '--cap-add', '--cap-drop', '--seccomp', '--seccomp-profile', '--apparmor-default-profile', '--apparmor-profile', '--blockio-config-file', '--blockio-class', '--rdt-class', '--hostname', '--user', '-u', '--rootfs', '--no-pivot', '--cpu-quota', '--cpu-period', '--rootfs-propagation', '--device'
        break
      }
      'containers delete' {
        '--keep-snapshot'
        break
      }
      'containers info' {
        '--spec'
        break
      }
      'containers list' {
        '--quiet', '-q'
        break
      }
      'containers checkpoint' {
        '--rw', '--image', '--task'
        break
      }
      'containers restore' {
        '--rw', '--live'
        break
      }
      'content active' {
        '--timeout', '-t', '--root'
        break
      }
      'content edit' {
        '--validate', '--editor'
        break
      }
      'content fetch' {
        '--skip-verify', '-k', '--plain-http', '--user', '-u', '--refresh', '--hosts-dir', '--tlscacert', '--tlscert', '--tlskey', '--http-dump', '--http-trace', '--label', '--platform', '--all-platforms', '--skip-metadata', '--metadata-only'
        break
      }
      'content fetch-object' {
        '--skip-verify', '-k', '--plain-http', '--user', '-u', '--refresh', '--hosts-dir', '--tlscacert', '--tlscert', '--tlskey', '--http-dump', '--http-trace'
        break
      }
      'content fetch-blob' {
        '--skip-verify', '-k', '--plain-http', '--user', '-u', '--refresh', '--hosts-dir', '--tlscacert', '--tlscert', '--tlskey', '--http-dump', '--http-trace', '--media-type'
        break
      }
      'content ingest' {
        '--expected-size', '--expected-digest'
        break
      }
      'content list' {
        '--quiet', '-q'
        break
      }
      'content push-object' {
        '--skip-verify', '-k', '--plain-http', '--user', '-u', '--refresh', '--hosts-dir', '--tlscacert', '--tlscert', '--tlskey', '--http-dump', '--http-trace'
        break
      }
      'content prune' {
        'references', 'help', 'h'
        break
      }
      'images check' {
        '--quiet', '-q', '--snapshotter'
        break
      }
      'images export' {
        '--skip-manifest-json', '--skip-non-distributable', '--platform', '--all-platforms', '--local'
        break
      }
      'images import' {
        '--base-name', '--digests', '--skip-digest-for-named', '--index-name', '--all-platforms', '--platform', '--no-unpack', '--local', '--compress-blobs', '--discard-unpacked-layers', '--snapshotter', '--label'
        break
      }
      'images inspect' {
        '--content'
        break
      }
      'images list' {
        '--quiet', '-q'
        break
      }
      'images mount' {
        '--skip-verify', '-k', '--plain-http', '--user', '-u', '--refresh', '--hosts-dir', '--tlscacert', '--tlscert', '--tlskey', '--http-dump', '--http-trace', '--snapshotter', '--label', '--rw', '--platform'
        break
      }
      'images unmount' {
        '--skip-verify', '-k', '--plain-http', '--user', '-u', '--refresh', '--hosts-dir', '--tlscacert', '--tlscert', '--tlskey', '--http-dump', '--http-trace', '--snapshotter', '--label', '--rm'
        break
      }
      'images pull' {
        '--skip-verify', '-k', '--plain-http', '--user', '-u', '--refresh', '--hosts-dir', '--tlscacert', '--tlscert', '--tlskey', '--http-dump', '--http-trace', '--snapshotter', '--label', '--platform', '--all-platforms', '--skip-metadata', '--print-chainid', '--max-concurrent-downloads', '--local'
        break
      }
      'images push' {
        '--skip-verify', '-k', '--plain-http', '--user', '-u', '--refresh', '--hosts-dir', '--tlscacert', '--tlscert', '--tlskey', '--http-dump', '--http-trace', '--manifest', '--manifest-type', '--platform', '--max-concurrent-uploaded-layers', '--local', '--allow-non-distributable-blobs'
        break
      }
      'images prune' {
        '--all'
        break
      }
      'images delete' {
        '--sync'
        break
      }
      'images tag' {
        '--force', '--local', '--skip-reference-check'
        break
      }
      'images label' {
        '--replace-all', '-r'
        break
      }
      'images convert' {
        '--uncompress', '--oci', '--platform', '--all-platforms'
        break
      }
      'images usage' {
        '--snapshotter'
        break
      }
      'leases list' {
        '--quiet', '-q'
        break
      }
      'leases create' {
        '--id', '--expires', '-x'
        break
      }
      'leases delete' {
        '--sync'
        break
      }
      'namespaces list' {
        '--quiet', '-q'
        break
      }
      'namespaces remove' {
        '--cgroup', '-c'
        break
      }
      'pprof block' {
        '--debug'
        break
      }
      'pprof goroutines' {
        '--debug'
        break
      }
      'pprof heap' {
        '--debug'
        break
      }
      'pprof profile' {
        '--seconds', '-s', '--debug'
        break
      }
      'pprof threadcreate' {
        '--debug'
        break
      }
      'pprof trace' {
        '--seconds', '-s', '--debug'
        break
      }
      'snapshots diff' {
        '--media-type', '--ref', '--keep', '--label'
        break
      }
      'snapshots prepare' {
        '--target', '-t', '--mounts'
        break
      }
      'snapshots unpack' {
        '--snapshotter'
        break
      }
      'snapshots usage' {
        '-b'
        break
      }
      'snapshots view' {
        '--target', '-t', '--mounts'
        break
      }
      'tasks checkpoint' {
        '--exit', '--image-path', '--work-path'
        break
      }
      'tasks delete' {
        '--force', '-f', '--exec-id'
        break
      }
      'tasks exec' {
        '--cwd', '--tty', '-t', '--detach', '-d', '--exec-id', '--fifo-dir', '--log-uri', '--user'
        break
      }
      'tasks list' {
        '--quiet', '-q'
        break
      }
      'tasks kill' {
        '--signal', '-s', '--exec-id', '--all', '-a'
        break
      }
      'tasks metrics' {
        '--format table'
        break
      }
      'tasks start' {
        '--no-pivot', '--null-io', '--log-uri', '--fifo-dir', '--pid-file', '--detach', '-d'
        break
      }
      'oci spec' {
        '--platform'
        break
      }
      'sandboxes run' {
        '--runtime'
        break
      }
      'sandboxes list' {
        '--filters'
        break
      }
      'sandboxes remove' {
        '--force', '-f'
        break
      }
      'deprecations list' {
        '--format'
        break
      }
      'shim exec' {
        '--stdin', '--stdout', '--stderr', '--tty', '-t', '--attach', '-a', '--env', '-e', '--cwd', '--spec'
        break
      }
      'shim state' {
        '--task-id', '-t', '--api-version'
        break
      }
      'shim pprof' {
        'block', 'goroutines', 'heap', 'profile', 'threadcreate', 'trace', 'help', 'h'
        break
      }
      'shim pprof block' {
        '--debug'
        break
      }
      'shim pprof goroutines' {
        '--debug'
        break
      }
      'shim pprof heap' {
        '--debug'
        break
      }
      'shim pprof profile' {
        '--seconds', '-s', '--debug'
        break
      }
      'shim pprof threadcreate' {
        '--debug'
        break
      }
      'shim pprof trace' {
        '--seconds', '-s', '--debug'
        break
      }
    }
    '--debug', '--address', '-a', '--timeout', '--connect-timeout', '--namespace', '-n', '--version', '-v', '-h', '--help'
  ).Where{ $_ -like "$wordToComplete*" }
}
