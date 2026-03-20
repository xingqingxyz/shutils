# pipewire [spa-inspect, spa-json-dump, spa-monitor]
Register-ArgumentCompleter -Native -CommandName pw-cat, pw-cli, pw-config, pw-container, pw-dot, pw-dsdplay, pw-dump, pw-encplay, pw-jack, pw-link, pw-loopback, pw-metadata, pw-mididump, pw-midiplay, pw-midirecord, pw-mon, pw-play, pw-profiler, pw-record, pw-reserve, pw-top, spa-acp-tool, spa-resample -ScriptBlock {
  param ([string]$wordToComplete, [System.Management.Automation.Language.CommandAst]$commandAst, [int]$cursorPosition)
  @(if ($wordToComplete.StartsWith('-')) {
      switch -CaseSensitive (Split-Path -LeafBase $commandAst.GetCommandName()) {
        pw-cat {
          '-h', '--help', '--version', '-v', '--verbose', '-R', '--remote=', '--media-type=Audio', '--media-category=Playback', '--media-role=Music', '--target=auto', '--target=0', '--latency=100ms', '--latency=1s', '--latency=1us', '--latency=1ns', '--latency=256', '-P', '--properties=', '--rate=48000', '--channels=2', '--channel-map=', '--format=s16', '--format=ulaw', '--format=alaw', '--format=u8', '--format=s8', '--format=s32', '--format=f32', '--format=f64', '--volume=0.0', '--volume=1.0', '-q', '--quality=4', '--quality=0', '--quality=15', '-a', '--raw', '-p', '--playback', '-r', '--record', '-m', '--midi', '-d', '--dsd'
          break
        }
        pw-cli {
          '-h', '--help', '--version', '-d', '--daemon', '-m', '--monitor'
          break
        }
        pw-config {
          '-h', '--help', '--version', '-n', '--name=', '-p', '--prefix=', '-L', '--no-newline', '-r', '--recurse', '-N', '--no-colors', '-C', '--color=auto', '--color=always', '--color=never'
          break
        }
        pw-container {
          '-h', '--help', '--version', '-r', '--remote', '-P', '--properties'
          break
        }
        pw-dot {
          '-h', '--help', '--version', '-a', '--all', '-s', '--smart', '-d', '--detail', '-r', '--remote', '-o', '--output', '-L', '--lr', '-9', '--90', '-j', '--json'
          break
        }
        pw-dump {
          '-h', '--help', '--version', '-r', '--remote', '-m', '--monitor', '-N', '--no-colors', '-C', '--color=auto', '--color=always', '--color=never'
          break
        }
        pw-jack {
          '-h', '-r', '-v', '-s', '-p'
          break
        }
        pw-link {
          '-h', '--help', '--version', '-r', '--remote=', '-o', '--output', '-i', '--input', '-l', '--links', '-m', '--monitor', '-I', '--id', '-v', '--verbose', '-L', '--linger', '-P', '--passive', '-p', '--props=', '-w', '--wait', '-d', '--disconnect'
          break
        }
        pw-loopback {
          '-h', '--help', '--version', '-r', '--remote=', '-n', '--name=', '-g', '--group=', '-c', '--channels=2', '-m', '--channel-map=', '-l', '--latency=100', '-d', '--delay=0.1', '-C', '--capture', '-i', '--capture-props', '-P', '--playback', '-o', '--playback-props'
          break
        }
        pw-metadata {
          '-h', '--help', '--version', '-r', '--remote=', '-n', '--name=', '-g', '--group=', '-c', '--channels=2', '-m', '--channel-map=', '-l', '--latency=100', '-d', '--delay=0.1', '-C', '--capture', '-i', '--capture-props', '-P', '--playback', '-o', '--playback-props'
          break
        }
        pw-mididump {
          '-h', '--help', '--version', '-r', '--remote='
          break
        }
        pw-mon {
          '-h', '--help', '--version', '-r', '--remote=', '-N', '--no-colors', '-C', '--color=auto', '--color=always', '--color=never', '-o', '--hide-props', '-a', '--hide-params', '-p', '--print-separator'
          break
        }
        pw-profiler {
          '-h', '--help', '--version', '-r', '--remote=', '-o', '--output', '-J', '--json', '-n', '--iterations'
          break
        }
        pw-reserve {
          '-h', '--help', '--version', '-n', '--name=Audio0', '--name=Midi0', '--name=Video0', '-a', '--appname=', '--appname=pw-reserve', '-p', '--priority=0', '-m', '--monitor', '-r', '--release'
          break
        }
        pw-top {
          '-b', '--batch-mode', '-n', '--iterations=', '-r', '--remote=', '-h', '--help', '-V', '--version'
          break
        }
        spa-acp-tool {
          '-h', '--help', '-v', '--verbose', '-c', '--card=', '-p', '--properties='
          break
        }
        spa-resample {
          '-h', '--help', '-v', '--verbose', '-r', '--rate=', '-f', '--format=s8', '--format=s16', '--format=s32', '--format=f32', '--format=f64', '-q', '--quality=4', '-c', '--cpuflags=0'
          break
        }
        {
          $_ -ceq 'pw-dsdplay' -or
          $_ -ceq 'pw-encplay' -or
          $_ -ceq 'pw-midiplay' -or
          $_ -ceq 'pw-midirecord' -or
          $_ -ceq 'pw-play' -or
          $_ -ceq 'pw-record'
        } {
          '-h', '--help', '--version', '-v', '--verbose', '-R', '--remote=', '--media-type=Audio', '--media-category=Playback', '--media-role=Music', '--target=auto', '--target=0', '--latency=100ms', '--latency=1s', '--latency=1us', '--latency=1ns', '--latency=256', '-P', '--properties=', '--rate=48000', '--channels=2', '--channel-map=', '--format=s16', '--format=ulaw', '--format=alaw', '--format=u8', '--format=s8', '--format=s32', '--format=f32', '--format=f64', '--volume=0.0', '--volume=1.0', '-q', '--quality=4', '--quality=0', '--quality=15', '-a', '--raw'
          break
        }
      }
    }
    else {
      switch -CaseSensitive (Split-Path -LeafBase $commandAst.GetCommandName()) {
        pw-cli {
          'help', 'h', 'load-module', 'lm', 'unload-module', 'um', 'connect', 'con', 'disconnect', 'dis', 'list-remotes', 'lr', 'switch-remote', 'sr', 'list-objects', 'ls', 'info', 'info all', 'i', 'create-device', 'cd', 'create-node', 'cn', 'destroy', 'd', 'create-link', 'cl', 'export-node', 'en', 'enum-params', 'e', 'set-param', 's', 'permissions', 'sp', 'get-permissions', 'gp', 'send-command', 'c', 'quit', 'q'

          break
        }
        pw-config {
          'paths', 'list', 'merge'
          break
        }
        spa-acp-tool {
          'help', 'h', 'quit', 'q', 'card', 'c', 'info', 'i', 'list', 'l', 'list-verbose', 'lv', 'list-profiles', 'lpr', 'set-profile', 'spr', 'list-ports', 'lp', 'set-port', 'sp', 'list-devices', 'ld', 'get-volume', 'gv', 'set-volume', 'v', 'inc-volume', 'v+', 'dec-volume', 'v-', 'get-mute', 'gm', 'set-mute', 'sm', 'toggle-mute', 'm'
          break
        }
      }
    }).Where{ $_ -like "$wordToComplete*" }
}
