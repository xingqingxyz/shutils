# procps-ng [omit(pwdx)]
Register-ArgumentCompleter -Native -CommandName free, pgrep, pidof, pidwait, pkill, pmap, ps, skill, slabtop, snice, sysctl, tload, top, uptime, vmstat, w, watch -ScriptBlock {
  param ([string]$wordToComplete, [System.Management.Automation.Language.CommandAst]$commandAst, [int]$cursorPosition)
  @(if ($wordToComplete.StartsWith('-')) {
      switch -CaseSensitive (Split-Path -LeafBase $commandAst.GetCommandName()) {
        free {
          '-b', '--bytes', '--kilo', '--mega', '--giga', '--tera', '--peta', '-k', '--kibi', '-m', '--mebi', '-g', '--gibi', '--tebi', '--pebi', '-h', '--human', '--si', '-l', '--lohi', '-L', '--line', '-t', '--total', '-v', '--committed', '-s', '--seconds', '-c', '--count', '-w', '--wide', '--help', '-V', '--version'
          break
        }
        pgrep {
          '-d', '--delimiter', '-l', '--list-name', '-a', '--list-full', '-v', '--inverse', '-w', '--lightweight', '-c', '--count', '-f', '--full', '-g', '--pgroup', '-G', '--group', '-i', '--ignore-case', '-n', '--newest', '-o', '--oldest', '-O', '--older', '-P', '--parent', '-s', '--session', '--signal', '-t', '--terminal', '-u', '--euid', '-U', '--uid', '-x', '--exact', '-F', '--pidfile', '-L', '--logpidfile', '-r', '--runstates=D', '--runstates=S', '--runstates=Z', '-A', '--ignore-ancestors', '--cgroup', '--ns', '--nslist=ipc', '--nslist=mnt', '--nslist=net', '--nslist=pid', '--nslist=user', '--nslist=uts', '-h', '--help', '-V', '--version'
          break
        }
        pidof {
          '-s', '--single-shot', '-c', '--check-root', '-q', '-w', '--with-workers', '-x', '-o', '--omit-pid', '-t', '--lightweight', '-S', '--separator', '-h', '--help', '-V', '--version'
          break
        }
        pidwait {
          '-e', '--echo', '-c', '--count', '-f', '--full', '-g', '--pgroup', '-G', '--group', '-i', '--ignore-case', '-n', '--newest', '-o', '--oldest', '-O', '--older', '-P', '--parent', '-s', '--session', '--signal=HUP', '--signal=INT', '--signal=QUIT', '--signal=ILL', '--signal=TRAP', '--signal=ABRT', '--signal=BUS', '--signal=FPE', '--signal=KILL', '--signal=USR1', '--signal=SEGV', '--signal=USR2', '--signal=PIPE', '--signal=ALRM', '--signal=TERM', '--signal=STKFLT', '--signal=CHLD', '--signal=CONT', '--signal=STOP', '--signal=TSTP', '--signal=TTIN', '--signal=TTOU', '--signal=URG', '--signal=XCPU', '--signal=XFSZ', '--signal=VTALRM', '--signal=PROF', '--signal=WINCH', '--signal=IO', '--signal=PWR', '--signal=SYS', '--signal=RTMIN', '--signal=RTMIN+1', '--signal=RTMIN+2', '--signal=RTMIN+3', '--signal=RTMIN+4', '--signal=RTMIN+5', '--signal=RTMIN+6', '--signal=RTMIN+7', '--signal=RTMIN+8', '--signal=RTMIN+9', '--signal=RTMIN+10', '--signal=RTMIN+11', '--signal=RTMIN+12', '--signal=RTMIN+13', '--signal=RTMIN+14', '--signal=RTMIN+15', '--signal=RTMAX-14', '--signal=RTMAX-13', '--signal=RTMAX-12', '--signal=RTMAX-11', '--signal=RTMAX-10', '--signal=RTMAX-9', '--signal=RTMAX-8', '--signal=RTMAX-7', '--signal=RTMAX-6', '--signal=RTMAX-5', '--signal=RTMAX-4', '--signal=RTMAX-3', '--signal=RTMAX-2', '--signal=RTMAX-1', '--signal=RTMAX', '-t', '--terminal', '-u', '--euid', '-U', '--uid', '-x', '--exact', '-F', '--pidfile', '-L', '--logpidfile', '-r', '--runstates=D', '--runstates=S', '--runstates=Z', '-A', '--ignore-ancestors', '--cgroup', '--ns', '--nslist=ipc', '--nslist=mnt', '--nslist=net', '--nslist=pid', '--nslist=user', '--nslist=uts', '-h', '--help', '-V', '--version'
          break
        }
        pkill {
          '-H', '--require-handler', '-q', '--queue', '-e', '--echo', '-c', '--count', '-f', '--full', '-g', '--pgroup', '-G', '--group', '-i', '--ignore-case', '-n', '--newest', '-o', '--oldest', '-O', '--older', '-P', '--parent', '-s', '--session', '--signal=HUP', '--signal=INT', '--signal=QUIT', '--signal=ILL', '--signal=TRAP', '--signal=ABRT', '--signal=BUS', '--signal=FPE', '--signal=KILL', '--signal=USR1', '--signal=SEGV', '--signal=USR2', '--signal=PIPE', '--signal=ALRM', '--signal=TERM', '--signal=STKFLT', '--signal=CHLD', '--signal=CONT', '--signal=STOP', '--signal=TSTP', '--signal=TTIN', '--signal=TTOU', '--signal=URG', '--signal=XCPU', '--signal=XFSZ', '--signal=VTALRM', '--signal=PROF', '--signal=WINCH', '--signal=IO', '--signal=PWR', '--signal=SYS', '--signal=RTMIN', '--signal=RTMIN+1', '--signal=RTMIN+2', '--signal=RTMIN+3', '--signal=RTMIN+4', '--signal=RTMIN+5', '--signal=RTMIN+6', '--signal=RTMIN+7', '--signal=RTMIN+8', '--signal=RTMIN+9', '--signal=RTMIN+10', '--signal=RTMIN+11', '--signal=RTMIN+12', '--signal=RTMIN+13', '--signal=RTMIN+14', '--signal=RTMIN+15', '--signal=RTMAX-14', '--signal=RTMAX-13', '--signal=RTMAX-12', '--signal=RTMAX-11', '--signal=RTMAX-10', '--signal=RTMAX-9', '--signal=RTMAX-8', '--signal=RTMAX-7', '--signal=RTMAX-6', '--signal=RTMAX-5', '--signal=RTMAX-4', '--signal=RTMAX-3', '--signal=RTMAX-2', '--signal=RTMAX-1', '--signal=RTMAX', '-t', '--terminal', '-u', '--euid', '-U', '--uid', '-x', '--exact', '-F', '--pidfile', '-L', '--logpidfile', '-r', '--runstates=D', '--runstates=S', '--runstates=Z', '-A', '--ignore-ancestors', '--cgroup', '--ns', '--nslist=ipc', '--nslist=mnt', '--nslist=net', '--nslist=pid', '--nslist=user', '--nslist=uts', '-h', '--help', '-V', '--version'
          break
        }
        pmap {
          '-x', '--extended', '-X', '-XX', '-c', '--read-rc', '-C', '--read-rc-from=', '-n', '--create-rc', '-N', '--create-rc-to=', '-N', '-d', '--device', '-q', '--quiet', '-p', '--show-path', '-A', '--range=', '-h', '--help', '-V', '--version'
          break
        }
        ps {
          '--help=simple', '--help=list', '--help=output', '--help=threads', '--help=misc', '--help=all'
          break
        }
        skill {
          '-f', '--fast', '-i', '--interactive', '-l', '--list', '-L', '--table', '-n', '--no-action', '-v', '--verbose', '-w', '--warnings', '-c', '--command', '-p', '--pid', '-t', '--tty', '-u', '--user', '--ns', '--nslist=ipc', '--nslist=mnt', '--nslist=net', '--nslist=pid', '--nslist=user', '--nslist=uts', '-h', '--help', '-V', '--version'
          break
        }
        slabtop {
          '-d', '--delay', '-o', '--once', '-s', '--sort', '-h', '--help', '-V', '--version'
          break
        }
        snice {
          '-f', '--fast', '-i', '--interactive', '-l', '--list', '-L', '--table', '-n', '--no-action', '-v', '--verbose', '-w', '--warnings', '-c', '--command', '-p', '--pid', '-t', '--tty', '-u', '--user', '--ns', '--nslist=ipc', '--nslist=mnt', '--nslist=net', '--nslist=pid', '--nslist=user', '--nslist=uts', '-h', '--help', '-V', '--version'
          break
        }
        sysctl {
          '-a', '--all', '-A', '-X', '--deprecated', '--dry-run', '-b', '--binary', '-e', '--ignore', '-N', '--names', '-n', '--values', '-p', '--load=', '-f', '--system', '-r', '--pattern', '-q', '--quiet', '-w', '--write', '-o', '-x', '-d', '-h', '--help', '-V', '--version'
          break
        }
        tload {
          '-d', '--delay', '-s', '--scale', '-h', '--help', '-V', '--version'
          break
        }
        top {
          '-b', '--batch-mode', '-c', '--cmdline-toggle', '-d', '--delay=', '-E', '--scale-summary-mem=', '-e', '--scale-task-mem=', '-H', '--threads-show', '-i', '--idle-toggle', '-n', '--iterations=', '-O', '--list-fields', '-o', '--sort-override=', '-p', '--pid=', '-S', '--accum-time-toggle', '-s', '--secure-mode', '-U', '--filter-any-user=', '-u', '--filter-only-euser=', '-w', '--width=', '-1', '--single-cpu-toggle', '-h', '--help', '-V', '--version'
          break
        }
        uptime {
          '-p', '--pretty', '-h', '--help', '-s', '--since', '-V', '--version'
          break
        }
        vmstat {
          '-a', '--active', '-f', '--forks', '-m', '--slabs', '-n', '--one-header', '-s', '--stats', '-d', '--disk', '-D', '--disk-sum', '-p', '--partition', '-S', '--unit', '-w', '--wide', '-t', '--timestamp', '-y', '--no-first', '-h', '--help', '-V', '--version'
          break
        }
        w {
          '-h', '--no-header', '-u', '--no-current', '-s', '--short', '-f', '--from', '-o', '--old-style', '-i', '--ip-addr', '-p', '--pids', '--help', '-V', '--version'
          break
        }
        watch {
          '-b', '--beep', '-c', '--color', '-C', '--no-color', '-d', '--differences', '-e', '--errexit', '-g', '--chgexit', '-q', '--equexit', '-n', '--interval', '-p', '--precise', '-r', '--no-rerun', '-t', '--no-title', '-w', '--no-wrap', '-x', '--exec', '-h', '--help', '-v', '--version'
          break
        }
      }
    }).Where{ $_ -like "$wordToComplete*" }
}
