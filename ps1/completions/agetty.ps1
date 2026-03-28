# util-linux-core (#setsid)
Register-ArgumentCompleter -Native -CommandName agetty, blkid, blockdev, chrt, dmesg, findmnt, flock, fsck, hardlink, ionice, ipcmk, ipcrm, ipcs, kill, logger, losetup, mkswap, more, mount, mountpoint, nsenter, partx, renice, sulogin, swapoff, swapon, switch_root, taskset, umount, unshare -ScriptBlock {
  param ([string]$wordToComplete, [System.Management.Automation.Language.CommandAst]$commandAst, [int]$cursorPosition)
  @(if ($wordToComplete.StartsWith('-')) {
      switch -CaseSensitive (Split-Path -LeafBase $commandAst.GetCommandName()) {
        agetty {
          '-8', '--8bits', '-a', '--autologin', '-c', '--noreset', '-E', '--remote', '-f', '--issue-file=', '--show-issue', '-h', '--flow-control', '-H', '--host', '-i', '--noissue', '-I', '--init-string=', '-J', '--noclear', '-l', '--login-program=', '-L', '--local-line', '--local-line=', '-m', '--extract-baud', '-n', '--skip-login', '-N', '--nonewline', '-o', '--login-options=', '-p', '--login-pause', '-r', '--chroot=', '-R', '--hangup', '-s', '--keep-baud', '-t', '--timeout=', '-U', '--detect-case', '-w', '--wait-cr', '--nohints', '--nohostname', '--long-hostname', '--erase-chars=', '--kill-chars=', '--chdir=', '--delay=', '--nice=', '--reload', '--list-speeds', '--help', '--version'
          break
        }
        blkid {
          '-c', '--cache-file=', '-d', '--no-encoding', '-g', '--garbage-collect', '-o', '--output=value', '--output=device', '--output=export', '--output=json', '--output=full', '-k', '--list-filesystems', '-s', '--match-tag=', '-t', '--match-token=', '-l', '--list-one', '-L', '--label=', '-U', '--uuid=', '-p', '--probe', '-i', '--info', '-H', '--hint=', '-S', '--size=', '-O', '--offset=', '-u', '--usages=', '-n', '--match-types=btrfs', '--match-types=ext4', '--match-types=vfat', '--match-types=xfs', '-D', '--no-part-details', '-h', '--help', '-V', '--version'
          break
        }
        blockdev {
          '-q', '-v', '--report', '-h', '--help', '-V', '--version', '--getsz', '--setro', '--setrw', '--getro', '--getdiscardzeroes', '--getss', '--getpbsz', '--getiomin', '--getioopt', '--getalignoff', '--getmaxsect', '--getbsz', '--setbsz=', '--getsize', '--getsize64', '--setra=', '--getra', '--setfra=', '--getfra', '--getdiskseq', '--getzonesz', '--flushbufs', '--rereadpt'
          break
        }
        chrt {
          '-b', '--batch', '-d', '--deadline', '-f', '--fifo', '-i', '--idle', '-o', '--other', '-r', '--rr', '-R', '--reset-on-fork', '-T', '--sched-runtime', '-P', '--sched-period', '-D', '--sched-deadline', '-a', '--all-tasks', '-m', '--max', '-p', '--pid', '-v', '--verbose', '-h', '--help', '-V', '--version'
          break
        }
        dmesg {
          '-C', '--clear', '-c', '--read-clear', '-D', '--console-off', '-E', '--console-on', '-F', '--file=', '-K', '--kmsg-file=', '-f', '--facility=kern', '--facility=user', '--facility=mail', '--facility=daemon', '--facility=auth', '--facility=syslog', '--facility=lpr', '--facility=news', '--facility=uucp', '--facility=cron', '--facility=authpriv', '--facility=ftp', '--facility=res0', '--facility=res1', '--facility=res2', '--facility=res3', '--facility=local0', '--facility=local1', '--facility=local2', '--facility=local3', '--facility=local4', '--facility=local5', '--facility=local6', '--facility=local7', '-H', '--human', '-J', '--json', '-k', '--kernel', '-L', '--color', '--color=auto', '--color=always', '--color=never', '-l', '--level=emerg', '--level=alert', '--level=crit', '--level=err', '--level=warn', '--level=notice', '--level=info', '--level=debug', '-n', '--console-level=emerg', '--console-level=alert', '--console-level=crit', '--console-level=err', '--console-level=warn', '--console-level=notice', '--console-level=info', '--console-level=debug', '-P', '--nopager', '-p', '--force-prefix', '-r', '--raw', '--noescape', '-S', '--syslog', '-s', '--buffer-size=', '-u', '--userspace', '-w', '--follow', '-W', '--follow-new', '-x', '--decode', '-d', '--show-delta', '-e', '--reltime', '-T', '--ctime', '-t', '--notime', '--since=', '--until=', '-h', '--help', '-V', '--version'
          break
        }
        findmnt {
          '-F', '-m', '--mtab', '-k', '--kernel', '-N', '--task=', '-p', '--poll', '--poll=', '-s', '--fstab', '-A', '--all', '-d', '--direction=forward', '--direction=backward', '-f', '--first-only', '-i', '--invert', '--id=', '--uniq-id=', '--pseudo', '-Q', '--filter=', '-M', '--mountpoint=', '--shadowed', '-R', '--submounts', '--real', '-S', '--source=', '-T', '--target=', '-t', '--types=', '-U', '--uniq', '-a', '--ascii', '-b', '--bytes', '-C', '--nocanonicalize', '-c', '--canonicalize', '-D', '--df', '-e', '--evaluate', '-I', '--dfi', '-J', '--json', '-l', '--list', '-n', '--noheadings', '-O', '--options=', '-o', '--output=', '--output-all', '-P', '--pairs', '-r', '--raw', '--tree', '-u', '--notruncate', '-v', '--nofsroot', '-w', '--timeout=', '-y', '--shell', '-x', '--verify', '--verbose', '--vfs-all', '-H', '--list-columns', '-h', '--help', '-V', '--version'
          break
        }
        flock {
          '-s', '--shared', '-x', '--exclusive', '-u', '--unlock', '-n', '--nonblock', '-w', '--timeout=', '-E', '--conflict-exit-code=', '-o', '--close', '-c', '--command=', '-F', '--no-fork', '--fcntl', '--verbose', '-h', '--help', '-V', '--version'
          break
        }
        fsck {
          '-A', '-C', '-l', '-M', '-N', '-P', '-R', '-r', '-s', '-T', '-t', '-V', '-?', '--help', '--version'
          break
        }
        hardlink {
          '-c', '--content', '-b', '--io-size=', '-d', '--respect-dir', '-f', '--respect-name', '-i', '--include=', '-m', '--maximize', '-M', '--minimize', '-n', '--dry-run', '-l', '--list-duplicates', '-z', '--zero', '-o', '--ignore-owner', '-F', '--prioritize-trees', '-O', '--keep-oldest', '-p', '--ignore-mode', '-q', '--quiet', '-r', '--cache-size=', '-s', '--minimum-size=', '-S', '--maximum-size=', '-t', '--ignore-time', '-v', '--verbose', '-x', '--exclude=', '--exclude-subtree=', '--mount', '-X', '--respect-xattrs', '-y', '--method=', '--reflink', '--reflink=auto', '--reflink=always', '--reflink=never', '--skip-reflinks', '-h', '--help', '-V', '--version'
          break
        }
        ionice {
          '-c', '--class=none', '--class=realtime', '--class=best-effort', '--class=idle', '-n', '--classdata=', '-p', '--pid=', '-P', '--pgid=', '-t', '--ignore', '-u', '--uid=', '-h', '--help', '-V', '--version'
          break
        }
        ipcmk {
          '-M', '--shmem=', '-m', '--posix-shmem=', '-S', '--semaphore=', '-s', '--posix-semaphore', '-Q', '--queue', '-q', '--posix-mqueue', '-p', '--mode=0644', '--mode=0755', '-n', '--name=', '-h', '--help', '-V', '--version'
          break
        }
        ipcrm {
          '-m', '--shmem-id=', '-M', '--shmem-key=', '--posix-shmem=', '-q', '--queue-id=', '-Q', '--queue-key=', '--posix-mqueue=', '-s', '--semaphore-id=', '-S', '--semaphore-key=', '--posix-semaphore=', '-a', '--all', '--all=shm', '--all=pshm', '--all=msg', '--all=pmsg', '--all=sem', '--all=psem', '-v', '--verbose', '-h', '--help', '-V', '--version'
          break
        }
        ipcs {
          '-i', '--id=', '-h', '--help', '-V', '--version', '-m', '--shmems', '-q', '--queues', '-s', '--semaphores', '-a', '--all', '-t', '--time', '-p', '--pid', '-c', '--creator', '-l', '--limits', '-u', '--summary', '--human', '-b', '--bytes'
          break
        }
        kill {
          '-a', '--all', '-s', '--signal=HUP', '--signal=INT', '--signal=QUIT', '--signal=ILL', '--signal=TRAP', '--signal=ABRT', '--signal=BUS', '--signal=FPE', '--signal=KILL', '--signal=USR1', '--signal=SEGV', '--signal=USR2', '--signal=PIPE', '--signal=ALRM', '--signal=TERM', '--signal=STKFLT', '--signal=CHLD', '--signal=CONT', '--signal=STOP', '--signal=TSTP', '--signal=TTIN', '--signal=TTOU', '--signal=URG', '--signal=XCPU', '--signal=XFSZ', '--signal=VTALRM', '--signal=PROF', '--signal=WINCH', '--signal=IO', '--signal=PWR', '--signal=SYS', '--signal=RTMIN', '--signal=RTMIN+1', '--signal=RTMIN+2', '--signal=RTMIN+3', '--signal=RTMIN+4', '--signal=RTMIN+5', '--signal=RTMIN+6', '--signal=RTMIN+7', '--signal=RTMIN+8', '--signal=RTMIN+9', '--signal=RTMIN+10', '--signal=RTMIN+11', '--signal=RTMIN+12', '--signal=RTMIN+13', '--signal=RTMIN+14', '--signal=RTMIN+15', '--signal=RTMAX-14', '--signal=RTMAX-13', '--signal=RTMAX-12', '--signal=RTMAX-11', '--signal=RTMAX-10', '--signal=RTMAX-9', '--signal=RTMAX-8', '--signal=RTMAX-7', '--signal=RTMAX-6', '--signal=RTMAX-5', '--signal=RTMAX-4', '--signal=RTMAX-3', '--signal=RTMAX-2', '--signal=RTMAX-1', '--signal=RTMAX', '-q', '--queue=', '--timeout=', '-p', '--pid', '-l', '--list', '--list=HUP', '--list=INT', '--list=QUIT', '--list=ILL', '--list=TRAP', '--list=ABRT', '--list=BUS', '--list=FPE', '--list=KILL', '--list=USR1', '--list=SEGV', '--list=USR2', '--list=PIPE', '--list=ALRM', '--list=TERM', '--list=STKFLT', '--list=CHLD', '--list=CONT', '--list=STOP', '--list=TSTP', '--list=TTIN', '--list=TTOU', '--list=URG', '--list=XCPU', '--list=XFSZ', '--list=VTALRM', '--list=PROF', '--list=WINCH', '--list=IO', '--list=PWR', '--list=SYS', '--list=RTMIN', '--list=RTMIN+1', '--list=RTMIN+2', '--list=RTMIN+3', '--list=RTMIN+4', '--list=RTMIN+5', '--list=RTMIN+6', '--list=RTMIN+7', '--list=RTMIN+8', '--list=RTMIN+9', '--list=RTMIN+10', '--list=RTMIN+11', '--list=RTMIN+12', '--list=RTMIN+13', '--list=RTMIN+14', '--list=RTMIN+15', '--list=RTMAX-14', '--list=RTMAX-13', '--list=RTMAX-12', '--list=RTMAX-11', '--list=RTMAX-10', '--list=RTMAX-9', '--list=RTMAX-8', '--list=RTMAX-7', '--list=RTMAX-6', '--list=RTMAX-5', '--list=RTMAX-4', '--list=RTMAX-3', '--list=RTMAX-2', '--list=RTMAX-1', '--list=RTMAX', '-L', '--table', '-r', '--require-handler', '-d', '--show-process-state=', '--verbose', '-h', '--help', '-V', '--version'
          break
        }
        logger {
          '-i', '--id', '--id=', '-f', '--file=', '-e', '--skip-empty', '--no-act', '-p', '--priority=', '--octet-count', '--prio-prefix', '-s', '--stderr', '-S', '--size=', '-t', '--tag=', '-n', '--server=', '-P', '--port=', '-T', '--tcp', '-d', '--udp', '--rfc3164', '--rfc5424', '--rfc5424=', '--sd-id=', '--sd-param=', '--msgid=', '-u', '--socket=', '--socket-errors', '--journald', '--journald=', '-h', '--help', '-V', '--version'
          break
        }
        losetup {
          '-a', '--all', '-d', '--detach=', '-D', '--detach-all', '-f', '--find', '-c', '--set-capacity=', '-j', '--associated=', '-L', '--nooverlap', '-o', '--offset=', '--sizelimit=', '-b', '--sector-size=', '-P', '--partscan', '-r', '--read-only', '--direct-io', '--direct-io=on', '--direct-io=off', '--loop-ref=', '--show', '-v', '--verbose', '-J', '--json', '-l', '--list', '-n', '--noheadings', '-O', '--output=', '--output-all', '--raw', '-h', '--help', '-V', '--version'
          break
        }
        mkswap {
          '-c', '--check', '-f', '--force', '-q', '--quiet', '-p', '--pagesize=', '-L', '--label=', '-v', '--swapversion=', '-U', '--uuid=', '-e', '--endianness=native', '--endianness=little', '--endianness=big', '-o', '--offset=', '-s', '--size=', '-F', '--file', '--verbose', '--lock', '--lock=yes', '--lock=no', '--lock=nonblock', '-h', '--help', '-V', '--version'
          break
        }
        more {
          '-d', '--silent', '-f', '--logical', '-l', '--no-pause', '-c', '--print-over', '-p', '--clean-print', '-e', '--exit-on-eof', '-s', '--squeeze', '-u', '--plain', '-n', '--lines=', '-h', '--help', '-V', '--version'
          break
        }
        mount {
          '-a', '--all', '-c', '--no-canonicalize', '-f', '--fake', '-F', '--fork', '-T', '--fstab=', '-i', '--internal-only', '-l', '--show-labels', '--map-groups=', '--map-users=', '-m', '--mkdir', '--mkdir=0751', '-n', '--no-mtab', '--options-mode=', '--options-source=', '--options-source-force', '--onlyonce', '-o', '--options=', '-O', '--test-opts=', '-r', '--read-only', '-t', '--types=', '--source=', '--target=', '--target-prefix=', '-v', '--verbose', '-w', '--rw', '--read-write', '-N', '--namespace=', '-h', '--help', '-V', '--version', '-L', '--label=', '-U', '--uuid=', '-B', '--bind', '-M', '--move', '-R', '--rbind', '--make-shared', '--make-slave', '--make-private', '--make-unbindable', '--make-rshared', '--make-rslave', '--make-rprivate', '--make-runbindable'
          break
        }
        mountpoint {
          '-q', '--quiet', '--nofollow', '-d', '--fs-devno', '-x', '--devno', '-h', '--help', '-V', '--version'
          break
        }
        nsenter {
          '-a', '--all', '-t', '--target=', '-m', '--mount', '--mount=', '-u', '--uts', '--uts=', '-i', '--ipc', '--ipc=', '-n', '--net', '--net=', '-N', '--net-socket=', '-p', '--pid', '--pid=', '-C', '--cgroup', '--cgroup=', '-U', '--user', '--user=', '--user-parent', '-T', '--time', '--time=', '-S', '--setuid', '--setuid=', '-G', '--setgid', '--setgid=', '--preserve-credentials', '--keep-caps', '-r', '--root', '--root=', '-w', '--wd', '--wd=', '-W', '--wdns=', '-e', '--env', '-F', '--no-fork', '-c', '--join-cgroup', '-Z', '--follow-context', '-h', '--help', '-V', '--version'
          break
        }
        partx {
          '-a', '--add', '-d', '--delete', '-u', '--update', '-s', '--show', '-b', '--bytes', '-g', '--noheadings', '-n', '--nr=', '-o', '--output=', '--output-all', '-P', '--pairs', '-r', '--raw', '-S', '--sector-size=', '-t', '--type=aix', '--type=sgi', '--type=sun', '--type=dos', '--type=gpt', '--type=PMBR', '--type=mac', '--type=ultrix', '--type=bsd', '--type=unixware', '--type=solaris', '--type=minix', '--type=atari', '--list-types', '-v', '--verbose', '-h', '--help', '-V', '--version'
          break
        }
        renice {
          '-n=', '--priority=', '--relative=', '-p', '--pid', '-g', '--pgrp', '-u', '--user', '-h', '--help', '-V', '--version'
          break
        }
        sulogin {
          '-p', '--login-shell', '-t', '--timeout=', '-e', '--force', '-h', '--help', '-V', '--version'
          break
        }
        swapoff {
          '-a', '--all', '-v', '--verbose', '-h', '--help', '-V', '--version', '-L', '-U'
          break
        }
        swapon {
          '-a', '--all', '-d', '--discard', '--discard=once', '--discard=pages', '-e', '--ifexists', '-f', '--fixpgsz', '-o', '--options=', '-p', '--priority=', '-s', '--summary', '-T', '--fstab=', '--show', '--show=', '--noheadings', '--raw', '--bytes', '-v', '--verbose', '-h', '--help', '-V', '--version', '-L=', '-U='
          break
        }
        switch_root {
          '-h', '--help', '-V', '--version'
          break
        }
        taskset {
          '-a', '--all-tasks', '-p', '--pid', '-c', '--cpu-list', '-h', '--help', '-V', '--version'
          break
        }
        umount {
          '-a', '--all', '-A', '--all-targets', '-c', '--no-canonicalize', '-d', '--detach-loop', '--fake', '-f', '--force', '-i', '--internal-only', '-n', '--no-mtab', '-l', '--lazy', '-O', '--test-opts=btrfs', '--test-opts=ext4', '--test-opts=vfat', '--test-opts=xfs', '-R', '--recursive', '-r', '--read-only', '-t', '--types=btrfs', '--types=ext4', '--types=vfat', '--types=xfs', '-v', '--verbose', '-q', '--quiet', '-N', '--namespace=', '-h', '--help', '-V', '--version'
          break
        }
        unshare {
          '-m', '--mount', '--mount=', '-u', '--uts', '--uts=', '-i', '--ipc', '--ipc=', '-n', '--net', '--net=', '-p', '--pid', '--pid=', '-U', '--user', '--user=', '-C', '--cgroup', '--cgroup=', '-T', '--time', '--time=', '--mount-proc', '--mount-proc=', '--mount-binfmt', '--mount-binfmt=', '-l', '--load-interp=', '--propagation', '-R', '--root=', '-w', '--wd=', '-S', '--setuid=', '-G', '--setgid=', '--map-user=', '--map-group=', '-r', '--map-root-user', '-c', '--map-current-user', '--map-auto', '--map-users=', '--map-groups=', '-f', '--fork', '--kill-child', '--kill-child=', '--setgroups=allow', '--setgroups=deny', '--keep-caps', '--monotonic=', '--boottime=', '-h', '--help', '-V', '--version'
          break
        }
      }
    }
    else {
      switch -CaseSensitive (Split-Path -LeafBase $commandAst.GetCommandName()) {
        agetty {
          switch ($prev) {
            '--autologin' { loginctl list-users --no-legend | ForEach-Object { $_.Split(' ', 2)[0] }; break }
            '--host' { bash -c 'compgen -A hostname'; break }
          }
          break
        }
      }
    }).Where{ $_ -like "$wordToComplete*" }
}
