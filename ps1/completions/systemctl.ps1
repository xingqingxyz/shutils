using namespace System.Management.Automation
using namespace System.Management.Automation.Language

Register-ArgumentCompleter -Native -CommandName systemctl -ScriptBlock {
  param ([string]$wordToComplete, [CommandAst]$commandAst, [int]$cursorPosition)
  $commands = @(foreach ($i in $commandAst.CommandElements) {
      if ($i.Extent.StartOffset -eq 0 -or $i.Extent.EndOffset -eq $cursorPosition) {
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
      default { $_; break }
    }
  }
  @(switch ($commands -join ' ') {
      '' {
        'list-units', 'list-automounts', 'list-paths', 'list-sockets', 'list-timers', 'is-active', 'is-failed', 'status', 'show', 'cat', 'help', 'list-dependencies', 'start', 'stop', 'reload', 'restart', 'try-restart', 'reload-or-restart', 'try-reload-or-restart', 'isolate', 'kill', 'clean', 'freeze', 'thaw', 'set-property', 'bind', 'mount-image', 'service-log-level', 'service-log-target', 'reset-failed', 'whoami', 'list-unit-files', 'enable', 'disable', 'reenable', 'preset', 'preset-all', 'is-enabled', 'mask', 'unmask', 'link', 'revert', 'add-wants', 'add-requires', 'edit', 'get-default', 'set-default', 'list-machines', 'list-jobs', 'cancel', 'show-environment', 'set-environment', 'unset-environment', 'import-environment', 'daemon-reload', 'daemon-reexec', 'log-level', 'log-target', 'service-watchdogs', 'is-system-running', 'default', 'rescue', 'emergency', 'halt', 'poweroff', 'reboot', 'kexec', 'soft-reboot', 'exit', 'switch-root', 'sleep', 'suspend', 'hibernate', 'hybrid-sleep', 'suspend-then-hibernate'
        break
      }
      default {
        if ($wordToComplete.StartsWith('-')) {
          '--help', '--version', '--system', '--user', '--capsule=', '--host=', '--machine=', '--type=', '--state=', '--failed', '--property=', '-P', '--all', '--full', '--recursive', '--reverse', '--before', '--after', '--with-dependencies', '--job-mode=', '--show-transaction', '--show-types', '--value', '--check-inhibitors=', '-i', '--kill-whom=', '--kill-value=', '--signal=', '--what=', '--now', '--dry-run', '--quiet', '--no-warn', '--wait', '--no-block', '--no-wall', '--message=', '--no-reload', '--legend=', '--no-pager', '--no-ask-password', '--global', '--runtime', '--force', '--preset-mode=', '--root=', '--image=', '--image-policy=', '--lines=', '--output=', '--firmware-setup', '--boot-loader-menu=', '--boot-loader-entry=', '--reboot-argument=', '--plain', '--timestamp=', '--read-only', '--mkdir', '--marked', '--drop-in=', '--when=', '--stdin',
          '--timestamp=pretty', '--timestamp=unix', '--timestamp=us', '--timestamp=utc', '--timestamp=us+utc'
          '--output=short', '--output=short-precise', '--output=short-iso', '--output=short-iso-precise', '--output=short-full', '--output=short-monotonic', '--output=short-unix', '--output=short-delta', '--output=verbose', '--output=export', '--output=json', '--output=json-pretty', '--output=json-sse', '--output=cat',
          '--legend=true', '--legend=false'
        }
        break
      }
    }
  ).Where{ $_ -like "$wordToComplete*" }
}
