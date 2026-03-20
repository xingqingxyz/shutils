function prompt {
  '{0} ({1}:{2}) {3}{4} ' -f @(
    # status
    switch ([int]!$? -shl 1 -bor [int][bool]$LASTEXITCODE) {
      0 { "`e[32mPS`e[0m"; break }
      1 { "`e[33m$LASTEXITCODE`e[0m"; break }
      2 { "`e[31mPS`e[0m"; break }
      3 { "`e[31m$LASTEXITCODE`e[0m"; break }
      # no default
    }
    # historyId
    $MyInvocation.HistoryId
    # duration
    Format-Duration ($MyInvocation.HistoryId -eq 1 ? 0 : (Get-History -Count 1).Duration)
    # pwd
    if ($PWD.Provider.Name -ceq 'FileSystem') {
      $PSStyle.FormatHyperlink(
        (($PWD.ProviderPath + [System.IO.Path]::DirectorySeparatorChar).StartsWith($HOME + [System.IO.Path]::DirectorySeparatorChar) ? '~' + $PWD.ProviderPath.Substring($HOME.Length) : $PWD.ProviderPath),
        [uri]::new($env:WSL_DISTRO_NAME ? (wslpath -w $PWD.ProviderPath) : $PWD.ProviderPath))
    }
    else {
      $PWD
    }
    # endMark
    ($PWD.Path.Length / [System.Console]::WindowWidth -gt .42 ? "`n" : '') + ('>' * ($NestedPromptLevel + 1))
  )
}
