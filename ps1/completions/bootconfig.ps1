# kernel tools: bootconfig, centrino-decode, cpupower, gpio-event-mon, gpio-hammer, gpio-watch, iio_event_monitor, iio_generic_buffer, intel-speed-select, intel_sdsi, kvm_stat, lsgpio, lsiio, page_owner_sort, powernow-k8-decode, slabinfo, tmon, turbostat, x86_energy_perf_policy, ynl, ynl-ethtool
Register-ArgumentCompleter -Native -CommandName bootconfig, gpio-event-mon, gpio-hammer, iio_event_monitor, iio_generic_buffer, intel_sdsi, lsgpio, page_owner_sort, slabinfo, tmon, turbostat, x86_energy_perf_policy, ynl, ynl-ethtool -ScriptBlock {
  param ([string]$wordToComplete, [System.Management.Automation.Language.CommandAst]$commandAst, [int]$cursorPosition)
  @(if ($wordToComplete.StartsWith('-')) {
      switch -CaseSensitive (Split-Path -LeafBase $commandAst.GetCommandName()) {
        bootconfig {
          '-a', '-d', '-l'
          break
        }
        gpio-event-mon {
          '-n', '-o', '-d', '-s', '-r', '-f', '-w', '-t', '-b', '-c', '-?'
          break
        }
        gpio-hammer {
          '-n', '-o', '-c', '-?'
          break
        }
        iio_event_monitor {
          '-a'
          break
        }
        iio_generic_buffer {
          '-a', '-A', '-b', '-c', '-e', '-g', '-l', '--device-name', '-n', '--device-num', '-N', '--trigger-name', '-t', '--trigger-num', '-T', '-w'
          break
        }
        intel_sdsi {
          '-l', '--list', '-d', '--devno=', '-i', '--info', '-s', '--state', '-m', '--meter', '-C', '--meter_current', '-a', '--akc=', '-c', '--cap='
          break
        }
        lsgpio {
          '-n', '-?'
          break
        }
        lsiio {
          '-v'
          break
        }
        page_owner_sort {
          '-a', '-m', '-n', '-p', '-P', '-s', '-t', '--pid=', '--tgid=', '--name=', '--cull=', '--sort='
          break
        }
        slabinfo {
          '-a', '--aliases', '-A', '--activity', '-B', '--Bytes', '-D', '--display-active', '-e', '--empty', '-f', '--first-alias', '-h', '--help', '-i', '--inverted', '-l', '--slabs', '-L', '--Loss', '-n', '--numa', '-N', '--lines=K', '-o', '--ops', '-P', '--partial', '-r', '--report', '-s', '--shrink', '-S', '--Size', '-t', '--tracking', '-T', '--Totals', '-U', '--Unreclaim', '-v', '--validate', '-X', '--Xtotals', '-z', '--zero', '-1', '--1ref', '-d', '--debug', '-da', '--debug=a', '--debug=f', '--debug=z', '--debug=p', '--debug=u', '--debug=t'
          break
        }
        tmon {
          '-c', '--control', '-d', '--daemon', '-g', '--debug', '-h', '--help', '-l', '--log', '-t', '--time-interval', '-T', '--target-temp', '-v', '--version', '-z', '--zone'
          break
        }
        turbostat {
          '-a', '--add=', '-c', '--cpu=', '-d', '--debug', '-D', '--Dump', '-e', '--enable=all', '--enable=', '-f', '--force', '-H', '--hide=', '-i', '--interval=', '-J', '--Joules', '-l', '--list', '-M', '--no-msr', '-P', '--no-perf', '-n', '--num_iterations=', '-N', '--header_iterations=', '-o', '--out=', '-q', '--quiet', '-s', '--show=', '-S', '--Summary', '-T', '--TCC=', '-h', '--help', '-v', '--version'
          break
        }
        x86_energy_perf_policy {
          '--cpu=', '--hwp-use-pkg', '--pkg=', '--all', '--epb', '--hwp-epp', '--hwp-min', '--hwp-max', '--hwp-desired', '--hwp-enable', '--turbo-enable=0', '--turbo-enable=1', '--help', '--force', '--hwp-window=', '-c', '-v', '-r'
          break
        }
        ynl {
          '-h', '--help', '--family=', '--list-families', '--spec=', '--schema=', '--no-schema', '--json=', '--do=', '--multi=', '--dump=', '--list-ops', '--list-msgs', '--duration=', '--sleep=', '--subscribe=', '--replace', '--excl', '--create', '--append', '--process-unknown', '--no-process-unknown', '--output-json', '--dbg-small-recv='
          break
        }
        ynl-ethtool {
          '-h', '--help', '--json', '--no-json', '--show-priv-flags', '--no-show-priv-flags', '--set-priv-flags', '--no-set-priv-flags', '--show-eee', '--no-show-eee', '--set-eee', '--no-set-eee', '-a', '--show-pause', '--no-show-pause', '-A', '--set-pause', '--no-set-pause', '-c', '--show-coalesce', '--no-show-coalesce', '-C', '--set-coalesce', '--no-set-coalesce', '-g', '--show-ring', '--no-show-ring', '-G', '--set-ring', '--no-set-ring', '-k', '--show-features', '--no-show-features', '-K', '--set-features', '--no-set-features', '-l', '--show-channels', '--no-show-channels', '-L', '--set-channels', '--no-set-channels', '-T', '--show-time-stamping', '--no-show-time-stamping', '-S', '--statistics', '--no-statistics'
          break
        }
      }
      '--help', '--version'
    }
    else {
      switch -CaseSensitive (Split-Path -LeafBase $commandAst.GetCommandName()) {
        x86_energy_perf_policy {
          'normal', 'performance', 'balance-performance', 'balance-power', 'power'
          break
        }
      }
    }).Where{ $_ -like "$wordToComplete*" }
}
