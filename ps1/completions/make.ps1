Register-ArgumentCompleter -Native -CommandName make -ScriptBlock {
  param ([string]$wordToComplete, [System.Management.Automation.Language.CommandAst]$commandAst, [int]$cursorPosition)
  @(if ($commandAst.CommandElements.Count -le 2 -and !$wordToComplete.StartsWith('-')) {
      $step = 0
      # 0,1,2: none, target, not a target
      $blockType = 0
      $target = ''
      env LC_ALL=C make -npq | ForEach-Object {
        if (
          ($step -eq 0 -and $_.StartsWith('# Make data base')) -or
          ($step -eq 1 -and $_.StartsWith('# Variables')) -or
          ($step -eq 2 -and $_.StartsWith('# Files'))
        ) {
          $step++
          return
        }
        if ($step -ne 3) {
          return
        }
        if ($blockType -eq 0 -and $_.StartsWith('# Not a target')) {
          $blockType = 2
        }
        elseif ($blockType -eq 0 -and $_ -like "$wordToComplete*" -and $_ -cmatch '^[^#\t:%]+(?=:)') {
          $blockType = 1
          $target = $Matches[0]
          if (
            # special targets
            $target -cmatch '^\.(PHONY|SUFFIXES|DEFAULT|PRECIOUS|INTERMEDIATE|SECONDARY|SECONDEXPANSION|DELETE_ON_ERROR|IGNORE|LOW_RESOLUTION_TIME|SILENT|EXPORT_ALL_VARIABLES|NOTPARALLEL|ONESHELL|POSIX|NOEXPORT|MAKE)$' -or
            # dont complete with hidden targets unless we are doing a partial completion
            (($wordToComplete -ceq '' -or $wordToComplete.EndsWith('/')) -and
            $target[$wordToComplete.Length] -cnotmatch '[a-zA-Z0-9]')
          ) {
            $target = ''
          }
        }
        elseif ($blockType -eq 1 -and $_ -ceq '') {
          if ($target -ne '') {
            $target
          }
          $blockType = 0
        }
        elseif ($blockType -eq 1 -and $_.StartsWith('# File is an intermediate prerequisite')) {
          $target = ''
        }
        elseif ($blockType -eq 2 -and $_ -ceq '') {
          $blockType = 0
        }
      }
    }
    elseif ($wordToComplete.StartsWith('-')) {
      '-b', '-m', '-B', '--always-make', '-C', '--directory=', '-d', '--debug', '--debug=', '-e', '--environment-overrides', '-E', '--eval=', '-f', '--file=', '--makefile=', '-h', '--help', '-i', '--ignore-errors', '-I', '--include-dir=', '-j', '-j32', '-j8', '--jobs', '--jobs=32', '--jobs=8', '--jobserver-style=', '-k', '--keep-going', '-l', '-l8', '--load-average', '--load-average=8', '--max-load', '--max-load=8', '-L', '--check-symlink-times', '-n', '--just-print', '--dry-run', '--recon', '-o', '--old-file=', '--assume-old=', '-O', '--output-sync', '--output-sync=', '-p', '--print-data-base', '-q', '--question', '-r', '--no-builtin-rules', '-R', '--no-builtin-variables', '--shuffle', '--shuffle=42', '--shuffle=random', '--shuffle=reverse', '--shuffle=none', '-s', '--silent', '--quiet', '--no-silent', '-S', '--no-keep-going', '--stop', '-t', '--touch', '--trace', '-v', '--version', '-w', '--print-directory', '--no-print-directory', '-W', '--what-if=', '--new-file=', '--assume-new=', '--warn-undefined-variables'
    }).Where{ $_ -like "$wordToComplete*" }
}
